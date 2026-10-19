import 'package:activbank_qr/features/history/presentation/history_screen.dart';
import 'package:activbank_qr/features/history/presentation/widgets/history_row.dart';
import 'package:activbank_qr/features/payment/presentation/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

String iso(DateTime d) => d.toIso8601String().substring(0, 19);

Map<String, Object?> payment(
  num amount,
  DateTime at, {
  String status = 'success',
  String sender = 'Душанбе Сити Банк',
}) => {
  'sender': sender,
  'amount': amount,
  'status': status,
  'creation_datetime': iso(at),
};

Future<void> openHistory(WidgetTester tester) async {
  await tester.tap(find.text('История'));
  await tester.pumpAndSettle();
}

Finder get historyList => find.descendant(
  of: find.byType(HistoryScreen),
  matching: find.byType(Scrollable),
);

void main() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day, 12);
  final yesterday = DateTime(now.year, now.month, now.day - 1, 10);

  testWidgets('группы по дням, статусы, сумма за день', (tester) async {
    final backend = FakeBackend()
      ..history = [
        payment(150, today.add(const Duration(minutes: 5))),
        payment(20, today, status: 'cancel', sender: 'Алиф'),
        payment(1234.5, yesterday),
      ];
    // Маленький экран и крупный шрифт — ничего не должно вылезать.
    await pumpTestApp(tester, backend);
    await signIn(tester);
    await openHistory(tester);

    expect(find.text('Сегодня'), findsOneWidget);
    expect(find.text('Вчера'), findsOneWidget);
    expect(find.byType(HistoryRow), findsNWidgets(3));
    expect(find.text('Оплачено'), findsNWidgets(2));
    expect(find.text('Отклонён'), findsOneWidget);
    // За сегодня — только оплаченный: 150, а не 170.
    expect(find.text('150,00'), findsNWidgets(2));
    expect(find.text('12:05'), findsOneWidget);
    // Всё загружено — кнопки нет.
    expect(find.textContaining('Показать ещё'), findsNothing);
  });

  testWidgets('чип статуса по ширине текста, рядом с суммой', (tester) async {
    final backend = FakeBackend()..history = [payment(150, today)];
    await pumpTestApp(
      tester,
      backend,
      size: const Size(390, 844),
      textScale: 1,
    );
    await signIn(tester);
    await openHistory(tester);

    final chip = tester.getRect(find.byType(StatusChip));
    final amount = tester.getRect(find.text('150,00').last);
    expect(chip.width, lessThan(150));
    expect((chip.center.dy - amount.center.dy).abs(), lessThan(10));
  });

  testWidgets('«Показать ещё» подгружает следующую страницу', (tester) async {
    final backend = FakeBackend()
      ..history = [
        for (var i = 0; i < 60; i++)
          payment(i + 1, today.subtract(Duration(minutes: i))),
      ];
    await pumpTestApp(tester, backend, size: const Size(390, 844));
    await signIn(tester);
    await openHistory(tester);

    final more = find.text('Показать ещё (10)');
    await tester.scrollUntilVisible(more, 500, scrollable: historyList);
    await tester.tap(more);
    await tester.pumpAndSettle();

    expect(find.textContaining('Показать ещё'), findsNothing);
    final history = backend.requests.where((r) => r == '/pos/history');
    expect(history, hasLength(2));
  });

  testWidgets('пустая история', (tester) async {
    await pumpTestApp(tester, FakeBackend());
    await signIn(tester);
    await openHistory(tester);

    expect(find.textContaining('Пока нет операций'), findsOneWidget);
  });

  testWidgets('нет сети → «Повторить» загружает список', (tester) async {
    final backend = FakeBackend()
      ..historyFails = true
      ..history = [payment(150, today)];
    await pumpTestApp(tester, backend);
    await signIn(tester);
    await openHistory(tester);

    expect(find.text('Нет связи с сервером. Проверьте интернет.'), findsOne);
    expect(find.byType(HistoryRow), findsNothing);

    backend.historyFails = false;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();

    expect(
      find.text('Нет связи с сервером. Проверьте интернет.'),
      findsNothing,
    );
    expect(find.byType(HistoryRow), findsOneWidget);
  });
}
