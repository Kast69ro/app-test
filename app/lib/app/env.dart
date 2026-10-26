import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env.g.dart';

enum Flavor { dev, prod }

/// Как работает «Возврат платежа».
enum RefundMode {
  /// Кнопка неактивна.
  off,

  /// Концепт для демонстрации: возврат запоминается только на телефоне,
  /// на сервер ничего не уходит и деньги не двигаются.
  concept,

  /// Настоящий возврат через бэк (`docs/refund_api_spec.md`).
  api,
}

/// Настройки сборки. Адрес сервера берётся только отсюда.
class Env {
  const Env({
    required this.flavor,
    required this.apiBaseUrl,
    this.refunds = RefundMode.off,
    this.connectTimeout = const Duration(seconds: 8),
    this.receiveTimeout = const Duration(seconds: 15),
  });

  final Flavor flavor;
  final String apiBaseUrl;
  final RefundMode refunds;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  bool get isDev => flavor == Flavor.dev;

  /// Тестовый сервер во внутренней сети банка. http — только в dev.
  static const dev = Env(
    flavor: Flavor.dev,
    apiBaseUrl: 'http://10.64.20.101:8888',
    // Ручек возврата на бэке пока нет — показываем концепт.
    refunds: RefundMode.concept,
  );

  /// TODO(prod): HTTPS-домен шлюза в DMZ — уточнить у банка.
  /// Пока пусто: ApiClient отказывает во всех запросах (fail-closed).
  static const prod = Env(flavor: Flavor.prod, apiBaseUrl: '');
}

/// Переопределяется в `main_dev.dart` / `main_prod.dart`.
@Riverpod(keepAlive: true)
Env env(Ref ref) => throw UnimplementedError('envProvider не переопределён');
