import 'dart:convert';

import 'package:activbank_qr/core/api/api_exception.dart';
import 'package:activbank_qr/features/payment/data/payment_dto.dart';
import 'package:activbank_qr/features/payment/domain/payment.dart';
import 'package:activbank_qr/features/refund/data/refund_ledger.dart';
import 'package:activbank_qr/features/refund/data/refund_repository.dart';
import 'package:activbank_qr/features/refund/domain/refund.dart';
import 'package:activbank_qr/features/refund/domain/refund_amount.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http.dart';

final paid = Payment(
  sender: 'Алиф',
  amount: 150,
  status: PaymentStatus.success,
  createdAt: DateTime(2026, 9, 8, 14, 12),
);

void main() {
  group('Payment и возврат', () {
    test('частичный, потом остаток — статус и доступная сумма', () {
      expect(paid.refundableCents, 15000);
      expect(paid.canRefund, isTrue);

      final part = paid.withRefund(3050);
      expect(part.status, PaymentStatus.partiallyRefunded);
      expect(part.refundedAmount, 30.5);
      expect(part.refundableCents, 11950);
      expect(part.canRefund, isTrue);

      final all = part.withRefund(11950);
      expect(all.status, PaymentStatus.refunded);
      expect(all.refundableCents, 0);
      expect(all.canRefund, isFalse);
    });

    test('отклонённый и ожидающий вернуть нельзя', () {
      for (final s in [PaymentStatus.cancel, PaymentStatus.pending]) {
        final p = Payment(sender: 'Б', amount: 10, status: s, createdAt: null);
        expect(p.canRefund, isFalse, reason: '$s');
      }
    });

    test('ключ: ID, а без него — время, сумма и банк', () {
      expect(paid.key, '2026-09-08T14:12:00.000|150.0|null|Алиф');
      final withId = PaymentDto.fromJson({
        'id': 42,
        'amount': 150,
        'status': 'success',
      }).toDomain();
      expect(withId.id, '42');
      expect(withId.key, '42');
    });

    test('DTO: refunded_amount и частичный статус', () {
      final p = PaymentDto.fromJson({
        'amount': 150,
        'status': 'partially_refunded',
        'refunded_amount': 30.5,
      }).toDomain();
      expect(p.status, PaymentStatus.partiallyRefunded);
      expect(p.refundableCents, 11950);

      // Возвращён целиком без суммы — значит, вся сумма.
      final full = PaymentDto.fromJson({'amount': 150, 'status': 'refunded'})
          .toDomain();
      expect(full.refundedAmount, 150);
      expect(full.canRefund, isFalse);
    });
  });

  test('checkRefundAmount', () {
    expect(checkRefundAmount(null, 15000), RefundAmountError.invalid);
    expect(checkRefundAmount(0, 15000), RefundAmountError.zero);
    expect(checkRefundAmount(15001, 15000), RefundAmountError.tooMuch);
    expect(checkRefundAmount(15000, 15000), isNull);
    expect(checkRefundAmount(1, 15000), isNull);
  });

  group('ConceptRefundRepository', () {
    late ProviderContainer container;
    late ConceptRefundRepository repo;

    setUp(() {
      container = ProviderContainer();
      repo = ConceptRefundRepository(
        container.read(refundLedgerProvider.notifier),
        delay: Duration.zero,
      );
    });
    tearDown(() => container.dispose());

    test('возвраты копятся в журнале и меняют платёж', () async {
      final r = await repo.refund(paid, amountCents: 5000, reason: 'товар');
      expect(r.amountCents, 5000);
      expect(r.reason, 'товар');
      expect(r.status, RefundStatus.done);
      await repo.refund(paid, amountCents: 2000);

      final ledger = container.read(refundLedgerProvider.notifier);
      expect(ledger.of(paid).map((r) => r.amountCents), [5000, 2000]);
      final now = ledger.apply(paid);
      expect(now.status, PaymentStatus.partiallyRefunded);
      expect(now.refundableCents, 8000);
    });

    test('больше остатка — ошибка как от бэка, журнал не меняется', () async {
      await repo.refund(paid, amountCents: 10000);
      await expectLater(
        repo.refund(paid, amountCents: 5001),
        throwsA(
          isA<ApiException>().having(
            (e) => e.detail,
            'detail',
            'Сумма больше доступной к возврату.',
          ),
        ),
      );
      expect(
        container.read(refundLedgerProvider.notifier).of(paid),
        hasLength(1),
      );
    });

    test('возвращённый целиком — повторить нельзя', () async {
      await repo.refund(paid, amountCents: 15000);
      await expectLater(
        repo.refund(paid, amountCents: 1),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'код', 409)),
      );
    });
  });

  group('ApiRefundRepository', () {
    final withId = Payment(
      id: 'p/1',
      sender: 'Алиф',
      amount: 150,
      status: PaymentStatus.success,
      createdAt: DateTime(2026, 9, 8, 14, 12),
    );

    test('без ID платежа не поддерживается', () {
      final t = fakeApi((_) async => jsonBody(200, {}));
      final repo = ApiRefundRepository(t.client);
      expect(repo.supports(paid), isFalse);
      expect(repo.supports(withId), isTrue);
    });

    test('POST с суммой в TJS и причиной, ответ → Refund', () async {
      final t = fakeApi(
        (_) async => jsonBody(200, {
          'status': 'refunded',
          'refund_id': 77,
          'refunded_at': '2026-09-08T15:00:00',
          'amount': 30.5,
        }),
      );
      final r = await ApiRefundRepository(t.client)
          .refund(withId, amountCents: 3050, reason: 'товар');

      final req = t.adapter.last!;
      expect(req.method, 'POST');
      expect(req.path, '/pos/payments/p%2F1/refund');
      expect(jsonDecode(jsonEncode(req.data)), {
        'amount': 30.5,
        'reason': 'товар',
      });
      expect(r.id, '77');
      expect(r.amountCents, 3050);
      expect(r.paymentKey, 'p/1');
      expect(r.createdAt, DateTime(2026, 9, 8, 15));
    });

    test('pending — возврат в обработке', () async {
      final t = fakeApi((_) async => jsonBody(200, {'status': 'pending'}));
      final r = await ApiRefundRepository(t.client)
          .refund(withId, amountCents: 100);
      expect(r.status, RefundStatus.pending);
      expect(r.amountCents, 100);
    });

    test('ошибка бэка приходит с detail', () async {
      final t = fakeApi(
        (_) async => jsonBody(400, {'detail': 'Истёк срок возврата'}),
      );
      await expectLater(
        ApiRefundRepository(t.client).refund(withId, amountCents: 100),
        throwsA(
          isA<ApiException>().having(
            (e) => e.detail,
            'detail',
            'Истёк срок возврата',
          ),
        ),
      );
    });

    test('rejected в успешном ответе — не считаем возвратом', () async {
      final t = fakeApi((_) async => jsonBody(200, {'status': 'rejected'}));
      await expectLater(
        ApiRefundRepository(t.client).refund(withId, amountCents: 100),
        throwsA(
          isA<ApiException>().having(
            (e) => e.kind,
            'kind',
            ApiErrorKind.badResponse,
          ),
        ),
      );
    });
  });
}
