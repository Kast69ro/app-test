import 'package:flutter/painting.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/payment.dart';

/// Подпись и цвета статуса: фон чипа, текст, точка / полоса слева.
class PaymentStatusStyle {
  const PaymentStatusStyle(this.label, this.bg, this.fg, this.dot);

  final String label;
  final Color bg;
  final Color fg;
  final Color dot;

  factory PaymentStatusStyle.of(PaymentStatus s, AppLocalizations l) =>
      switch (s) {
        PaymentStatus.success => PaymentStatusStyle(
          l.statusSuccess,
          AppColors.successBg,
          AppColors.successFg,
          AppColors.successDot,
        ),
        PaymentStatus.cancel => PaymentStatusStyle(
          l.statusCancel,
          AppColors.cancelBg,
          AppColors.cancelFg,
          AppColors.cancelDot,
        ),
        PaymentStatus.pending => PaymentStatusStyle(
          l.statusPending,
          AppColors.pendingBg,
          AppColors.pendingFg,
          AppColors.pendingDot,
        ),
        PaymentStatus.refunded => PaymentStatusStyle(
          l.statusRefunded,
          AppColors.refundBg,
          AppColors.refundFg,
          AppColors.refundDot,
        ),
        PaymentStatus.refundPending => PaymentStatusStyle(
          l.statusRefundPending,
          AppColors.pendingBg,
          AppColors.pendingFg,
          AppColors.pendingDot,
        ),
        PaymentStatus.unknown => PaymentStatusStyle(
          l.statusUnknown,
          AppColors.unknownBg,
          AppColors.unknownFg,
          AppColors.unknownDot,
        ),
      };
}
