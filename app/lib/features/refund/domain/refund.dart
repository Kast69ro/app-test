import 'package:flutter/foundation.dart';

enum RefundStatus {
  /// Деньги ушли клиенту.
  done,

  /// Банк ещё обрабатывает возврат.
  pending,
}

/// Возврат по платежу — полный или частичный.
@immutable
class Refund {
  const Refund({
    required this.paymentKey,
    required this.amountCents,
    required this.createdAt,
    this.status = RefundStatus.done,
    this.id,
    this.reason,
  });

  /// [Payment.key] платежа, который вернули.
  final String paymentKey;
  final String? id;

  /// Сумма возврата в дирамах.
  final int amountCents;
  final DateTime createdAt;
  final RefundStatus status;
  final String? reason;
}
