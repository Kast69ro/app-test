import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/text_link.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';
import '../../receipt/data/receipt_sharer.dart';
import '../../receipt/domain/receipt.dart';
import '../../receipt/presentation/receipt_view.dart';
import '../domain/payment.dart';
import 'payment_status_style.dart';
import 'widgets/payment_actions.dart';
import 'widgets/payment_trail.dart';
import 'widgets/status_chip.dart';

/// Карточка операции. Прототип: `POS Terminal.dc.html`, стр. 135–174.
/// Вместо «Печать чека» — «Поделиться чеком» (только для оплаченных).
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.payment});

  final Payment payment;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

enum _Share { idle, busy, failed }

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _receiptKey = GlobalKey();
  final _shareKey = GlobalKey();
  var _share = _Share.idle;

  Future<void> _shareReceipt() async {
    setState(() => _share = _Share.busy);
    try {
      final boundary =
          _receiptKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (data == null) throw StateError('PNG не собрался');

      // iPad открывает окно «Поделиться» стрелкой от кнопки.
      final button = _shareKey.currentContext?.findRenderObject() as RenderBox?;
      final origin = button == null
          ? null
          : button.localToGlobal(Offset.zero) & button.size;

      await ref
          .read(receiptSharerProvider)
          .share(
            data.buffer.asUint8List(),
            fileName: _fileName(widget.payment),
            origin: origin,
          );
      if (mounted) setState(() => _share = _Share.idle);
    } catch (_) {
      if (mounted) setState(() => _share = _Share.failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final session = ref.watch(sessionControllerProvider).value?.session;
    final p = widget.payment;
    final status = PaymentStatusStyle.of(p.status, l);
    final at = p.createdAt;
    final terminalId = session?.terminalId ?? '';
    final terminalName = session?.terminalName ?? '';
    String orDash(String v) => v.isEmpty ? '—' : v;

    final receipt = Receipt(
      payment: p,
      storeName: session?.storeName ?? '',
      terminalName: terminalName,
      terminalId: terminalId,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Чек для картинки лежит под экраном: он отрисован (иначе снимок
          // не сделать), но закрыт непрозрачной карточкой и скрыт от TalkBack.
          if (p.status == PaymentStatus.success)
            Positioned(
              left: 0,
              top: 0,
              child: ExcludeSemantics(
                child: RepaintBoundary(
                  key: _receiptKey,
                  child: ReceiptView(receipt: receipt),
                ),
              ),
            ),
          Positioned.fill(
            child: ColoredBox(
              color: AppColors.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(
                    backLabel: l.back,
                    onBack: () => context.pop(),
                    status: status,
                    amount: formatMoney(p.amount),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        InfoCard(
                          children: [
                            InfoRow(
                              l.paymentDate,
                              at == null ? '—' : formatDayMonth(at),
                            ),
                            InfoRow(
                              l.paymentTime,
                              at == null ? '—' : formatTime(at),
                            ),
                            InfoRow(l.paymentBank, p.sender),
                            // Как в прототипе: ID терминала, иначе название.
                            InfoRow(
                              l.settingsTerminal,
                              orDash(
                                terminalId.isNotEmpty
                                    ? terminalId
                                    : terminalName,
                              ),
                            ),
                            InfoRow(
                              l.settingsStore,
                              orDash(session?.storeName ?? ''),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        PaymentTrail(payment: p),
                      ],
                    ),
                  ),
                  _Actions(
                    children: [
                      RefundButton(label: l.paymentRefund),
                      if (p.status == PaymentStatus.success)
                        ShareReceiptButton(
                          key: _shareKey,
                          label: switch (_share) {
                            _Share.idle => l.paymentShare,
                            _Share.busy => l.paymentSharing,
                            _Share.failed => l.paymentShareError,
                          },
                          busy: _share == _Share.busy,
                          failed: _share == _Share.failed,
                          onTap: _shareReceipt,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `receipt_2026-09-08_1412` — имя файла без кириллицы и пробелов.
String _fileName(Payment p) {
  final at = p.createdAt;
  if (at == null) return 'receipt';
  final t = formatTime(at).replaceAll(':', '');
  return 'receipt_${formatIsoDate(at)}_$t';
}

class _Header extends StatelessWidget {
  const _Header({
    required this.backLabel,
    required this.onBack,
    required this.status,
    required this.amount,
  });

  final String backLabel;
  final VoidCallback onBack;
  final PaymentStatusStyle status;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderList)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: BackLink(label: backLabel, onTap: onBack),
                  ),
                  const SizedBox(width: 12),
                  StatusChip(style: status, large: true),
                ],
              ),
              const SizedBox(height: 12),
              // На узком экране с крупным шрифтом сумма уменьшается, а не обрезается.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(amount, style: AppTextStyles.amountLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.borderList)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
