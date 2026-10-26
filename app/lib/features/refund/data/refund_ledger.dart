import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../payment/domain/payment.dart';
import '../domain/refund.dart';

part 'refund_ledger.g.dart';

/// Возвраты, оформленные на этом телефоне в концепт-режиме.
///
/// Живут только в памяти: после перезапуска приложения пропадают.
/// Бэк о них не знает, поэтому история и сводка накладывают их поверх
/// ответов сервера (см. [apply]).
@Riverpod(keepAlive: true)
class RefundLedger extends _$RefundLedger {
  @override
  Map<String, List<Refund>> build() => const {};

  void add(Refund refund) => state = {
    ...state,
    refund.paymentKey: [...?state[refund.paymentKey], refund],
  };

  /// Возвраты платежа, от старых к новым.
  List<Refund> of(Payment payment) => state[payment.key] ?? const [];

  /// Платёж с учётом возвратов из журнала.
  Payment apply(Payment payment) => applyRefunds(payment, of(payment));
}

Payment applyRefunds(Payment payment, List<Refund> refunds) {
  var cents = 0;
  for (final r in refunds) {
    cents += r.amountCents;
  }
  return payment.withRefund(cents);
}
