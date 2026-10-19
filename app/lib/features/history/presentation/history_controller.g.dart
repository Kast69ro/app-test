// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// История операций: первая страница + «Показать ещё».
///
/// Ошибка обновления не стирает список: Riverpod хранит прошлое значение
/// в `AsyncError`, экран показывает его вместе с плашкой «Повторить».

@ProviderFor(HistoryController)
final historyControllerProvider = HistoryControllerProvider._();

/// История операций: первая страница + «Показать ещё».
///
/// Ошибка обновления не стирает список: Riverpod хранит прошлое значение
/// в `AsyncError`, экран показывает его вместе с плашкой «Повторить».
final class HistoryControllerProvider
    extends $AsyncNotifierProvider<HistoryController, HistoryState> {
  /// История операций: первая страница + «Показать ещё».
  ///
  /// Ошибка обновления не стирает список: Riverpod хранит прошлое значение
  /// в `AsyncError`, экран показывает его вместе с плашкой «Повторить».
  HistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyControllerHash();

  @$internal
  @override
  HistoryController create() => HistoryController();
}

String _$historyControllerHash() => r'8c67bbe19afcfddcfa1848847c2f4429a4602743';

/// История операций: первая страница + «Показать ещё».
///
/// Ошибка обновления не стирает список: Riverpod хранит прошлое значение
/// в `AsyncError`, экран показывает его вместе с плашкой «Повторить».

abstract class _$HistoryController extends $AsyncNotifier<HistoryState> {
  FutureOr<HistoryState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HistoryState>, HistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HistoryState>, HistoryState>,
              AsyncValue<HistoryState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
