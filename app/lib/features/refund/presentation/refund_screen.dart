import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/api_error_text.dart';
import '../../../core/widgets/text_link.dart';
import '../../../l10n/app_localizations.dart';
import '../../payment/domain/payment.dart';
import '../../pin/presentation/pin_screen.dart';
import '../../pin/presentation/widgets/pin_entry_view.dart';
import '../domain/refund.dart';
import '../domain/refund_amount.dart';
import 'refund_controller.dart';
import 'refund_providers.dart';
import 'widgets/refund_form.dart';
import 'widgets/refund_status_views.dart';

/// Возврат платежа — полный или частичный (в прототипе экрана нет).
/// Открывается из карточки операции поверх неё.
class RefundScreen extends ConsumerStatefulWidget {
  const RefundScreen({super.key, required this.payment});

  /// Как пришёл с бэка; возвраты с телефона накладываются здесь.
  final Payment payment;

  @override
  ConsumerState<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends ConsumerState<RefundScreen> {
  late final TextEditingController _amount;
  final _reason = TextEditingController();

  @override
  void initState() {
    super.initState();
    // По умолчанию — всё, что ещё можно вернуть: частичный возврат —
    // это исправить сумму.
    final p = ref.read(effectivePaymentProvider(widget.payment));
    _amount = TextEditingController(text: formatMoneyInput(p.refundableCents));
  }

  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final provider = refundControllerProvider(widget.payment);
    final s = ref.watch(provider);
    final c = ref.read(provider.notifier);
    final p = ref.watch(effectivePaymentProvider(widget.payment));
    final concept = ref.watch(envProvider).refunds == RefundMode.concept;

    void close() => Navigator.of(context).maybePop();

    final Widget page = switch (s.stage) {
      RefundStage.form => _form(l, p, s, c, concept, close),
      RefundStage.pin => PinEntryView(
        header: BackLink(label: l.back, onTap: c.backToForm),
        title: l.refundPinTitle,
        subtitle: l.refundPinSubtitle(formatMoney(s.amountCents / 100)),
        value: s.pin,
        error: pinErrorText(s.pinError, l),
        onKey: c.key,
      ),
      RefundStage.sending => RefundSendingView(text: l.refundSending),
      RefundStage.done => RefundDoneView(
        title: l.refundDoneTitle,
        text: s.result?.status == RefundStatus.pending
            ? l.refundDonePending
            : l.refundDoneText(
                formatMoney((s.result?.amountCents ?? s.amountCents) / 100),
                p.sender,
              ),
        pending: s.result?.status == RefundStatus.pending,
        buttonLabel: l.refundDone,
        onDone: close,
      ),
    };

    return PopScope(
      // Пока запрос в пути — не уходим. С экрана кода «Назад» — к форме.
      canPop: s.stage == RefundStage.form || s.stage == RefundStage.done,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && s.stage == RefundStage.pin) c.backToForm();
      },
      child: page,
    );
  }

  Widget _form(
    AppLocalizations l,
    Payment p,
    RefundState s,
    RefundController c,
    bool concept,
    VoidCallback close,
  ) {
    final text = _amount.text.trim();
    final cents = parseMoney(text);
    final check = checkRefundAmount(cents, p.refundableCents);
    final valid = check == null && p.canRefund;

    return RefundForm(
      payment: p,
      amount: _amount,
      reason: _reason,
      // Пустое поле — без подсказки, просто неактивная кнопка.
      amountError: text.isEmpty
          ? null
          : switch (check) {
              RefundAmountError.tooMuch => l.refundAmountTooMuch(
                formatMoney(p.refundableCents / 100),
              ),
              RefundAmountError.invalid ||
              RefundAmountError.zero => l.refundAmountInvalid,
              null => null,
            },
      submitLabel: valid
          ? l.refundSubmit(formatMoney(cents! / 100))
          : l.refundTitle,
      onAll: () =>
          setState(() => _amount.text = formatMoneyInput(p.refundableCents)),
      onChanged: () => setState(() {}),
      onSubmit: valid
          ? () {
              FocusScope.of(context).unfocus();
              c.submit(cents!, _reason.text);
            }
          : null,
      onBack: close,
      error: s.error == null ? null : apiErrorText(s.error!, l),
      conceptNote: concept ? l.refundConceptNote : null,
    );
  }
}
