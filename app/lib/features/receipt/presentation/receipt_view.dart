import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/info_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../payment/presentation/payment_status_style.dart';
import '../../payment/presentation/widgets/status_chip.dart';
import '../domain/receipt.dart';

/// Картинка чека, которой делятся. Ширина фиксирована, системный размер
/// шрифта не влияет — чек выглядит одинаково на любом телефоне.
/// Состав — как у печатного чека в прототипе (стр. 619–636).
class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key, required this.receipt});

  static const width = 360.0;

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = receipt.payment;
    final at = p.createdAt;
    String orDash(String v) => v.isEmpty ? '—' : v;

    // Material — свой стиль текста: картинка не зависит от того, где лежит виджет.
    return MediaQuery.withNoTextScaling(
      child: Material(
        color: AppColors.background,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.appTitle, style: AppTextStyles.brandName),
              const SizedBox(height: 2),
              Text(l.receiptTitle, style: AppTextStyles.caption),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.borderList),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.receiptAmount, style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      formatMoney(p.amount),
                      style: AppTextStyles.amountLarge.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: 10),
                    StatusChip(style: PaymentStatusStyle.of(p.status, l)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              InfoCard(
                children: [
                  InfoRow(l.paymentDate, at == null ? '—' : formatFullDate(at)),
                  InfoRow(l.paymentTime, at == null ? '—' : formatTime(at)),
                  InfoRow(l.receiptBank, p.sender),
                  InfoRow(l.settingsStore, orDash(receipt.storeName)),
                  InfoRow(l.settingsTerminal, orDash(receipt.terminalName)),
                  InfoRow(l.settingsTerminalId, orDash(receipt.terminalId)),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                l.receiptFooter,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
