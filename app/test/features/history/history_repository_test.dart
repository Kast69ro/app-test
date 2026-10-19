import 'package:activbank_qr/core/api/api_exception.dart';
import 'package:activbank_qr/features/history/data/history_repository.dart';
import 'package:activbank_qr/features/payment/domain/payment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http.dart';

void main() {
  group('HistoryRepository.getPage', () {
    test('limit и offset в запросе, платежи и total', () async {
      final t = fakeApi(
        (_) async => jsonBody(200, {
          'terminal': {'terminalName': 'Т'},
          'total': 137,
          'limit': 50,
          'offset': 50,
          'count': 2,
          'payments': [
            {
              'sender': 'Душанбе Сити Банк',
              'sender_bank_id': 27,
              'amount': 150.00,
              'status': 'success',
              'creation_datetime': '2026-09-08T14:12:00',
            },
            {
              'sender': 'Алиф',
              'amount': 20,
              'status': 'cancel',
              'creation_datetime': '2026-09-08T13:00:00',
            },
          ],
        }),
        phone: '+992931234567',
      );

      final page = await HistoryRepository(t.client).getPage(offset: 50);

      expect(t.adapter.last!.path, '/pos/history');
      expect(t.adapter.last!.queryParameters, {
        'limit': 50,
        'offset': 50,
        'phone': '+992931234567',
      });
      expect(page.total, 137);
      expect(page.offset, 50);
      expect(page.payments, [
        Payment(
          sender: 'Душанбе Сити Банк',
          senderBankId: 27,
          amount: 150,
          status: PaymentStatus.success,
          createdAt: DateTime(2026, 9, 8, 14, 12),
        ),
        Payment(
          sender: 'Алиф',
          amount: 20,
          status: PaymentStatus.cancel,
          createdAt: DateTime(2026, 9, 8, 13),
        ),
      ]);
    });

    test('пустая история', () async {
      final t = fakeApi(
        (_) async => jsonBody(200, {'total': 0, 'count': 0, 'payments': []}),
      );
      final page = await HistoryRepository(t.client).getPage(offset: 0);
      expect(page.total, 0);
      expect(page.payments, isEmpty);
    });

    test('payments не список → badResponse', () async {
      final t = fakeApi(
        (_) async => jsonBody(200, {'total': 1, 'payments': 'нет'}),
      );
      await expectLater(
        HistoryRepository(t.client).getPage(offset: 0),
        throwsA(
          isA<ApiException>().having(
            (e) => e.kind,
            'kind',
            ApiErrorKind.badResponse,
          ),
        ),
      );
    });

    test('ошибка бэка с detail', () async {
      final t = fakeApi(
        (_) async => jsonBody(404, {'detail': 'Терминал не найден'}),
      );
      await expectLater(
        HistoryRepository(t.client).getPage(offset: 0),
        throwsA(
          isA<ApiException>().having(
            (e) => e.detail,
            'detail',
            'Терминал не найден',
          ),
        ),
      );
    });
  });
}
