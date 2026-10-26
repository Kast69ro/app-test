import 'package:activbank_qr/app/env.dart';
import 'package:activbank_qr/features/history/presentation/widgets/history_row.dart';
import 'package:activbank_qr/features/payment/presentation/payment_screen.dart';
import 'package:activbank_qr/features/refund/presentation/refund_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';
import '../history/history_widget_test.dart' show openHistory, payment;
import '../payment/payment_widget_test.dart' show inSheet;

final amountField = find.descendant(
  of: find.byType(RefundScreen),
  matching: find.byType(TextField),
);

void main() {
  final at = DateTime(2026, 9, 8, 14, 12);

  Future<void> openPayment(
    WidgetTester tester, {
    Env env = Env.dev,
    Size size = const Size(390, 844),
  }) async {
    final backend = FakeBackend()..history = [payment(150, at)];
    await pumpTestApp(tester, backend, size: size, env: env);
    await signIn(tester);
    await openHistory(tester);
    await tester.tap(find.byType(HistoryRow));
    await tester.pumpAndSettle();
  }

  /// Сумма → «Вернуть …» → код 1234 → ответ «сервера».
  Future<void> refund(WidgetTester tester, String amount, String label) async {
    await tester.enterText(amountField.first, amount);
    await tester.pump();
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
    expect(find.text('Подтвердите возврат'), findsOneWidget);
    await typeDigits(tester, '1234');
    await settleWithIsolate(tester);
  }

  testWidgets('частичный возврат, потом остаток — статусы и кнопки', (
    tester,
  ) async {
    await openPayment(tester);

    await tester.tap(find.text('Возврат платежа'));
    await tester.pumpAndSettle();
    expect(find.byType(RefundScreen), findsOneWidget);
    // По умолчанию — вся сумма.
    expect(find.text('Вернуть 150,00'), findsOneWidget);
    expect(find.textContaining('Демонстрация'), findsOneWidget);

    // Больше платежа — подсказка, кнопка неактивна.
    await tester.enterText(amountField.first, '200');
    await tester.pump();
    expect(find.text('Не больше 150,00'), findsOneWidget);
    await tester.tap(find.text('Возврат платежа').last);
    await tester.pumpAndSettle();
    expect(find.text('Подтвердите возврат'), findsNothing);

    await refund(tester, '30,5', 'Вернуть 30,50');
    expect(find.text('Возврат оформлен'), findsOneWidget);
    expect(
      find.text('30,50 вернётся клиенту на счёт в Душанбе Сити Банк.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();
    expect(find.byType(RefundScreen), findsNothing);
    expect(inSheet(find.text('Частичный возврат')), findsOneWidget);
    expect(inSheet(find.text('119,50')), findsOneWidget); // доступно
    expect(find.text('Поделиться чеком'), findsOneWidget);

    // Второй раз — остаток подставлен сам.
    await tester.tap(find.text('Вернуть ещё'));
    await tester.pumpAndSettle();
    expect(find.text('Вернуть 119,50'), findsOneWidget);
    await refund(tester, '119,50', 'Вернуть 119,50');
    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();

    expect(inSheet(find.text('Возврат')), findsOneWidget);
    expect(find.text('Вернуть ещё'), findsNothing);
    expect(find.text('Возврат платежа'), findsNothing);
    expect(find.text('Поделиться чеком'), findsNothing);

    // На главной — плитка «Возврат за сегодня» из двух возвратов.
    await tester.tap(find.text('← Назад'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Главная'));
    await tester.pumpAndSettle();
    expect(find.text('150,00'), findsOneWidget);
  });

  testWidgets('неверный код — попытка списана, назад — к форме', (
    tester,
  ) async {
    await openPayment(tester);
    await tester.tap(find.text('Возврат платежа'));
    await tester.pumpAndSettle();
    await tester.enterText(amountField.first, '10');
    await tester.pump();
    await tester.tap(find.text('Вернуть 10,00'));
    await tester.pumpAndSettle();

    await typeDigits(tester, '1111');
    await settleWithIsolate(tester);
    expect(find.text('Неверный код. Осталось попыток: 4'), findsOneWidget);

    await tester.tap(find.text('← Назад'));
    await tester.pumpAndSettle();
    expect(find.text('Вернуть 10,00'), findsOneWidget);
  });

  testWidgets('маленький экран и крупный шрифт — форма без переполнений', (
    tester,
  ) async {
    await openPayment(tester, size: const Size(320, 568));
    await tester.tap(find.text('Возврат платежа'));
    await tester.pumpAndSettle();
    expect(find.text('Вернуть 150,00'), findsOneWidget);
  });

  testWidgets('прод-сборка: кнопка неактивна', (tester) async {
    await openPayment(tester, env: Env.prod);
    expect(find.byType(PaymentScreen), findsOneWidget);
    await tester.tap(find.text('Возврат платежа'));
    await tester.pumpAndSettle();
    expect(find.byType(RefundScreen), findsNothing);
  });
}
