import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/api/api_providers.dart';
import '../../../core/api/parse.dart';
import '../domain/history_feed.dart';
import 'history_dtos.dart';

part 'history_repository.g.dart';

class HistoryRepository {
  HistoryRepository(this._api);

  final ApiClient _api;

  /// Страница истории за всё время, от новых к старым.
  Future<HistoryPage> getPage({
    required int offset,
    int limit = ApiPaths.historyPageSize,
  }) async {
    final json = await _api.get(
      ApiPaths.history,
      query: {'limit': limit, 'offset': offset},
    );
    return parseResponse(() => HistoryPageDto.fromJson(json).toDomain());
  }
}

@riverpod
HistoryRepository historyRepository(Ref ref) =>
    HistoryRepository(ref.watch(apiClientProvider));
