import 'package:flutter/foundation.dart';

import '../../../core/utils/money_format.dart';
import '../../payment/domain/payment.dart';
import 'history_period.dart';

/// Количество и сумма операций одного статуса.
@immutable
class StatusTotal {
  const StatusTotal(this.count, this.amount);

  final int count;
  final double amount;
}

/// Данные для PDF-отчёта: все операции периода и точка.
@immutable
class HistoryReport {
  HistoryReport({
    required this.range,
    required this.payments,
    required this.storeName,
    required this.terminalName,
    required this.terminalId,
    required this.generatedAt,
  }) : success = _total(payments, {
         PaymentStatus.success,
         PaymentStatus.partiallyRefunded,
       }),
       cancel = _total(payments, {PaymentStatus.cancel}),
       refunded = _refunds(payments);

  final DateRange range;

  /// От новых к старым, как отдаёт бэк.
  final List<Payment> payments;
  final String storeName;
  final String terminalName;
  final String terminalId;
  final DateTime generatedAt;

  final StatusTotal success;
  final StatusTotal cancel;

  /// Возвраты, включая «в обработке» и частичные — по сумме возврата,
  /// а не платежа.
  final StatusTotal refunded;
}

StatusTotal _refunds(List<Payment> payments) {
  var count = 0;
  var cents = 0;
  for (final p in payments) {
    // Возвращён целиком или в обработке, а сумму бэк не прислал — вся.
    final whole =
        (p.status == PaymentStatus.refunded && p.refundedAmount <= 0) ||
        p.status == PaymentStatus.refundPending;
    if (whole) {
      count++;
      cents += toCents(p.amount);
    } else if (p.refundedAmount > 0) {
      count++;
      cents += toCents(p.refundedAmount);
    }
  }
  return StatusTotal(count, cents / 100);
}

StatusTotal _total(List<Payment> payments, Set<PaymentStatus> statuses) {
  var count = 0;
  // Суммируем в дирамах, чтобы не копить ошибку double.
  var cents = 0;
  for (final p in payments) {
    if (!statuses.contains(p.status)) continue;
    count++;
    cents += (p.amount * 100).round();
  }
  return StatusTotal(count, cents / 100);
}
