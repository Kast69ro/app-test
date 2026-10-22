import 'dart:typed_data';
import 'dart:ui';

import 'package:activbank_qr/features/history/presentation/widgets/history_row.dart';
import 'package:activbank_qr/features/payment/presentation/payment_screen.dart';
import 'package:activbank_qr/features/receipt/data/receipt_sharer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';
import '../history/history_widget_test.dart' show openHistory, payment;

/// Вместо системного окна запоминает, какой чек отдали.
class FakeSharer implements ReceiptSharer {
  final shared = <({Uint8List pdf, String fileName})>[];
  bool fails = false;

  @override
  Future<void> share(Uint8List pdf, {required String fileName, Rect? origin}) {
    if (fails) return Future.error(Exception('нет приложения'));
    shared.add((pdf: pdf, fileName: fileName));
    return Future.value();
  }
}

void main() {
  final at = DateTime(2026, 9, 8, 14, 12);

  Future<FakeSharer> openPayment(
    WidgetTester tester,
    Map<String, Object?> json, {
    Size size = const Size(320, 568),
  }) async {
    final sharer = FakeSharer();
    final backend = FakeBackend()..history = [json];
    await pumpTestApp(
      tester,
      backend,
      size: size,
      overrides: [receiptSharerProvider.overrideWithValue(sharer)],
    );
    await signIn(tester);
    await openHistory(tester);
    await tester.tap(find.byType(HistoryRow));
    await tester.pumpAndSettle();
    return sharer;
  }

  testWidgets('карточка оплаченной операции: реквизиты и кнопки', (
    tester,
  ) async {
    await openPayment(tester, payment(1234.5, at), size: const Size(390, 844));

    expect(find.byType(PaymentScreen), findsOneWidget);
    expect(find.text('История'), findsNothing); // без нижней панели
    expect(find.text('1 234,50').hitTestable(), findsOneWidget);
    expect(find.text('08.09').hitTestable(), findsOneWidget);
    expect(find.text('Душанбе Сити Банк').hitTestable(), findsOneWidget);
    expect(find.text('12345').hitTestable(), findsOneWidget); // ID терминала
    expect(find.text('ООО Ромашка').hitTestable(), findsOneWidget);
    expect(find.text('Возврат платежа'), findsOneWidget);
    expect(find.text('Поделиться чеком'), findsOneWidget);

    await tester.tap(find.text('← Назад'));
    await tester.pumpAndSettle();
    expect(find.byType(PaymentScreen), findsNothing);
    expect(find.byType(HistoryRow), findsOneWidget);
  });

  testWidgets('маленький экран и крупный шрифт — без переполнений', (
    tester,
  ) async {
    await openPayment(tester, payment(1234567.89, at));
    await tester.scrollUntilVisible(find.text('Клиент отсканировал'), 100);
    expect(find.text('Поделиться чеком'), findsOneWidget);
  });

  testWidgets('отклонённый платёж — чеком не делимся', (tester) async {
    await openPayment(tester, payment(20, at, status: 'cancel'));

    await tester.scrollUntilVisible(find.text('Ход операции'), 100);
    expect(find.text('Отклонён'), findsNWidgets(2)); // чип и «Ход операции»
    expect(find.text('Поделиться чеком'), findsNothing);
  });

  testWidgets('незнакомый статус — чеком не делимся', (tester) async {
    await openPayment(tester, payment(20, at, status: 'weird'));

    await tester.scrollUntilVisible(find.text('Ход операции'), 100);
    expect(find.text('Неизвестно'), findsNWidgets(2));
    expect(find.text('Поделиться чеком'), findsNothing);
  });

  testWidgets('«Поделиться чеком» отдаёт PDF', (tester) async {
    final sharer = await openPayment(
      tester,
      payment(150, at),
      size: const Size(390, 844),
    );

    await tester.tap(find.text('Поделиться чеком'));
    // Шрифты и PDF собираются вне тестовых часов — даём настоящее время.
    await tester.runAsync(() async {
      for (var i = 0; i < 50 && sharer.shared.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    await tester.pumpAndSettle();

    final shot = sharer.shared.single;
    expect(shot.fileName, 'receipt_2026-09-08_1412');
    expect(String.fromCharCodes(shot.pdf.sublist(0, 5)), '%PDF-');
    expect(find.text('Поделиться чеком'), findsOneWidget);
  });

  testWidgets('ошибка отправки — кнопка предлагает повторить', (tester) async {
    final sharer = await openPayment(
      tester,
      payment(150, at),
      size: const Size(390, 844),
    );
    sharer.fails = true;

    await tester.tap(find.text('Поделиться чеком'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Не удалось — повторить'), findsOneWidget);
  });
}
