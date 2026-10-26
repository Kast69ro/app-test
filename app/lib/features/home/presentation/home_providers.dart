import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/qr_code_view.dart';
import '../../auth/presentation/session_controller.dart';
import '../../refund/data/refund_ledger.dart';
import '../data/home_repository.dart';
import '../domain/home_models.dart';

part 'home_providers.g.dart';

/// Данные точки с бэка. Заодно обновляет сессию: название, точку и QR
/// храним на устройстве, чтобы QR показывался сразу, даже без сети.
@riverpod
Future<TerminalInfo> terminalInfo(Ref ref) async {
  final info = await ref.watch(homeRepositoryProvider).getTerminal();

  final sessionCtl = ref.read(sessionControllerProvider.notifier);
  final session = ref.read(sessionControllerProvider).value?.session;
  if (session != null) {
    final updated = session.copyWith(
      terminalName: info.terminalName.isNotEmpty
          ? info.terminalName
          : session.terminalName,
      storeName: info.storeName.isNotEmpty ? info.storeName : session.storeName,
      terminalQR: info.terminalQR.isNotEmpty
          ? info.terminalQR
          : session.terminalQR,
    );
    if (updated != session) await sessionCtl.updateSession(updated);
  }
  return info;
}

/// Матрица QR, закешированная по строке: строится один раз на обоих экранах.
@riverpod
QrBuild qrBuild(Ref ref, String data) => QrBuild.from(data);

/// Сводка за сегодня.
@riverpod
Future<DaySummary> todaySummary(Ref ref) =>
    ref.watch(homeRepositoryProvider).getSummary(DateTime.now());

/// «Возврат за сегодня»: блок `refunded` сводки плюс возвраты, оформленные
/// на телефоне (концепт). `null` — ни того ни другого, плитка с прочерком.
@riverpod
Totals? todayRefunds(Ref ref) {
  final server = ref.watch(todaySummaryProvider).value?.refunded;
  final today = dayKey(DateTime.now());
  var count = 0;
  var cents = 0;
  for (final list in ref.watch(refundLedgerProvider).values) {
    for (final r in list) {
      if (dayKey(r.createdAt) != today) continue;
      count++;
      cents += r.amountCents;
    }
  }
  if (server == null && count == 0) return null;
  return Totals(
    count: (server?.count ?? 0) + count,
    amount: (toCents(server?.amount ?? 0) + cents) / 100,
  );
}
