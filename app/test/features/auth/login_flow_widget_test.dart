import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('вход по номеру и создание кода', (tester) async {
    await pumpTestApp(tester, FakeBackend());

    expect(find.text('Вход для мерчантов'), findsOneWidget);
    await typeDigits(tester, '931234567');
    expect(find.text('93 123 45 67'), findsOneWidget);

    await tester.tap(find.text('Получить код'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.textContaining('Код из SMS на +992 93 ··· 67'), findsOneWidget);
    expect(find.text('Код снова через 60 с'), findsOneWidget);

    await typeDigits(tester, '123456');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Создайте код входа'), findsOneWidget);
    await typeDigits(tester, '1234');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('Повторите код'), findsOneWidget);

    await typeDigits(tester, '1234');
    await settleWithIsolate(tester);

    expect(find.text('Магазин на Рудаки'), findsOneWidget);
  });

  testWidgets('неверный SMS-код показывает detail с бэка', (tester) async {
    await pumpTestApp(tester, FakeBackend()..verifyStatus = 400);

    await typeDigits(tester, '931234567');
    await tester.tap(find.text('Получить код'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    await typeDigits(tester, '000000');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Осталось попыток: 4'), findsOneWidget);
  });

  testWidgets('«Выйти» на экране кода: отмена и выход', (tester) async {
    final backend = FakeBackend();
    final store = await pumpTestApp(tester, backend);
    await signIn(tester);

    // Перезапуск — спрашивают код, «Забыли код?» больше нет.
    await pumpTestApp(tester, backend, store: store);
    expect(find.text('Код входа'), findsOneWidget);
    expect(find.textContaining('Забыли код'), findsNothing);

    await tester.tap(find.text('Выйти'));
    await tester.pumpAndSettle();
    expect(find.text('Выйти из приложения?'), findsOneWidget);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(find.text('Код входа'), findsOneWidget);

    await tester.tap(find.text('Выйти'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Выйти').last);
    await tester.pumpAndSettle();

    expect(find.text('Вход для мерчантов'), findsOneWidget);
    expect(store.values, isEmpty);
  });

  testWidgets('несовпадение кодов — начать заново', (tester) async {
    await pumpTestApp(tester, FakeBackend());
    await typeDigits(tester, '931234567');
    await tester.tap(find.text('Получить код'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await typeDigits(tester, '123456');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    await typeDigits(tester, '1234');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    await typeDigits(tester, '9999');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(find.text('Коды не совпали. Задайте код заново.'), findsOneWidget);
    expect(find.text('Создайте код входа'), findsOneWidget);
  });
}
