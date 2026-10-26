import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/env.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/api/api_providers.dart';
import '../../../core/api/parse.dart';
import '../../payment/domain/payment.dart';
import '../domain/refund.dart';
import 'refund_dto.dart';
import 'refund_ledger.dart';

part 'refund_repository.g.dart';

abstract interface class RefundRepository {
  /// Можно ли вернуть этот платёж через этот репозиторий
  /// (настоящему бэку нужен ID платежа).
  bool supports(Payment payment);

  /// Возврат [amountCents] дирам. Ошибки — [ApiException] с `detail`.
  Future<Refund> refund(
    Payment payment, {
    required int amountCents,
    String? reason,
  });
}

/// Настоящий возврат через бэк.
class ApiRefundRepository implements RefundRepository {
  ApiRefundRepository(this._api);

  final ApiClient _api;

  @override
  bool supports(Payment payment) => payment.id != null;

  @override
  Future<Refund> refund(
    Payment payment, {
    required int amountCents,
    String? reason,
  }) async {
    final id = payment.id;
    if (id == null) throw const ApiException(ApiErrorKind.badResponse);
    final json = await _api.post(
      ApiPaths.refund(id),
      body: {
        // В TJS, как остальные суммы API (вопрос про дирамы — в спецификации).
        'amount': amountCents / 100,
        'reason': ?reason,
      },
    );
    return parseResponse(
      () => RefundDto.fromJson(json).toDomain(
        paymentKey: payment.key,
        requestedCents: amountCents,
        reason: reason,
      ),
    );
  }
}

/// Концепт для демонстрации: ведёт себя как бэк, но возврат только
/// записывается в [RefundLedger] на телефоне. На сервер ничего не уходит.
class ConceptRefundRepository implements RefundRepository {
  ConceptRefundRepository(
    this._ledger, {
    this.delay = const Duration(milliseconds: 800),
  });

  final RefundLedger _ledger;

  /// Имитация ответа сервера — чтобы было видно состояние «оформляем».
  final Duration delay;
  var _seq = 0;

  @override
  bool supports(Payment payment) => true;

  @override
  Future<Refund> refund(
    Payment payment, {
    required int amountCents,
    String? reason,
  }) async {
    await Future<void>.delayed(delay);
    // Те же проверки, что должен делать бэк. Тексты — как его `detail`.
    final actual = _ledger.apply(payment);
    if (!actual.canRefund) {
      throw const ApiException(
        ApiErrorKind.http,
        statusCode: 409,
        detail: 'Платёж уже возвращён полностью.',
      );
    }
    if (amountCents <= 0 || amountCents > actual.refundableCents) {
      throw const ApiException(
        ApiErrorKind.http,
        statusCode: 400,
        detail: 'Сумма больше доступной к возврату.',
      );
    }
    final refund = Refund(
      paymentKey: payment.key,
      id: 'concept-${++_seq}',
      amountCents: amountCents,
      createdAt: DateTime.now(),
      reason: reason,
    );
    _ledger.add(refund);
    return refund;
  }
}

/// `null` — возвраты в этой сборке выключены.
@riverpod
RefundRepository? refundRepository(Ref ref) =>
    switch (ref.watch(envProvider).refunds) {
      RefundMode.off => null,
      RefundMode.concept => ConceptRefundRepository(
        ref.watch(refundLedgerProvider.notifier),
      ),
      RefundMode.api => ApiRefundRepository(ref.watch(apiClientProvider)),
    };
