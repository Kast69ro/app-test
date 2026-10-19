import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'env.dart';

/// Riverpod 3 по умолчанию сам повторяет упавшие запросы, и всё это время
/// экран «грузится» — ошибку и «Повторить» мерчант не видит. Отключаем:
/// ошибка показывается сразу, повтор — кнопкой или жестом «потянуть».
Duration? noRetry(int retryCount, Object error) => null;

/// Общий запуск для обоих flavors.
void bootstrap(Env env) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      retry: noRetry,
      overrides: [envProvider.overrideWithValue(env)],
      child: const ActivBankApp(),
    ),
  );
}
