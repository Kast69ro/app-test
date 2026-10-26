import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../payment/domain/payment.dart';
import '../data/refund_ledger.dart';
import '../data/refund_repository.dart';
import '../domain/refund.dart';

part 'refund_providers.g.dart';

/// Возвраты платежа, оформленные на этом телефоне (концепт).
@riverpod
List<Refund> paymentRefunds(Ref ref, Payment payment) => ref.watch(
  refundLedgerProvider.select((m) => m[payment.key] ?? const <Refund>[]),
);

/// Платёж, каким его видит мерчант: ответ бэка плюс возвраты с телефона.
@riverpod
Payment effectivePayment(Ref ref, Payment payment) =>
    applyRefunds(payment, ref.watch(paymentRefundsProvider(payment)));

/// Активна ли кнопка «Возврат платежа».
@riverpod
bool refundAvailable(Ref ref, Payment payment) {
  final repo = ref.watch(refundRepositoryProvider);
  final p = ref.watch(effectivePaymentProvider(payment));
  return repo != null && repo.supports(p) && p.canRefund;
}
