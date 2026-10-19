import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/history_repository.dart';
import '../domain/history_feed.dart';

part 'history_controller.g.dart';

@immutable
class HistoryState {
  const HistoryState(this.feed, {this.loadingMore = false, this.moreError});

  final HistoryFeed feed;
  final bool loadingMore;

  /// Ошибка подгрузки следующей страницы. Список при этом остаётся.
  final Object? moreError;
}

/// История операций: первая страница + «Показать ещё».
///
/// Ошибка обновления не стирает список: Riverpod хранит прошлое значение
/// в `AsyncError`, экран показывает его вместе с плашкой «Повторить».
@riverpod
class HistoryController extends _$HistoryController {
  @override
  Future<HistoryState> build() async {
    final page = await ref.watch(historyRepositoryProvider).getPage(offset: 0);
    return HistoryState(HistoryFeed.first(page));
  }

  /// Следующая страница. Обновление с начала — `ref.invalidate` с экрана.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.feed.hasMore) {
      return;
    }
    // Пока идёт refresh, подгрузку не начинаем: страницы перемешаются.
    if (state.isLoading) return;

    final feed = current.feed;
    state = AsyncData(HistoryState(feed, loadingMore: true));
    try {
      final page = await ref
          .read(historyRepositoryProvider)
          .getPage(offset: feed.nextOffset);
      // За время запроса список могли обновить — тогда ответ устарел.
      if (!ref.mounted || state.value?.feed != feed) return;
      state = AsyncData(HistoryState(feed.append(page)));
    } catch (e) {
      if (!ref.mounted || state.value?.feed != feed) return;
      state = AsyncData(HistoryState(feed, moreError: e));
    }
  }
}
