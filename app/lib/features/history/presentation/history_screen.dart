import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/api_error_text.dart';
import '../../../core/widgets/pressable_card.dart';
import '../../../core/widgets/retry_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/history_feed.dart';
import 'history_controller.dart';
import 'widgets/history_row.dart';

/// История операций. Прототип: `POS Terminal.dc.html`, стр. 77–111.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(historyControllerProvider);
    try {
      await ref.read(historyControllerProvider.future);
    } catch (_) {
      // Ошибку покажет плашка.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final history = ref.watch(historyControllerProvider);
    final data = history.value;
    final error = history.hasError && !history.isLoading ? history.error : null;
    final groups = data == null
        ? const <DayGroup>[]
        : groupByDay(data.feed.payments);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.screenPadding,
                18,
                AppDimens.screenPadding,
                8,
              ),
              child: Text(l.tabHistory, style: AppTextStyles.tabTitle),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.accent,
                onRefresh: () => _refresh(ref),
                child: ListView(
                  // Тянуть вниз можно и при пустом списке.
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.screenPadding,
                    6,
                    AppDimens.screenPadding,
                    20,
                  ),
                  children: [
                    if (error != null) ...[
                      RetryBanner(
                        text: apiErrorText(error, l),
                        retryLabel: l.retry,
                        onRetry: () => _refresh(ref),
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (data == null && history.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        ),
                      )
                    else if (data != null && groups.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 40,
                        ),
                        child: Text(
                          l.historyEmpty,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    for (final g in groups)
                      _DayGroupView(
                        label: g.day == null
                            ? l.historyNoDate
                            : formatDayLabel(g.day!, now),
                        total: formatMoney(g.successAmount),
                        group: g,
                      ),
                    if (data != null && data.moreError != null) ...[
                      RetryBanner(
                        text: apiErrorText(data.moreError!, l),
                        retryLabel: l.retry,
                        onRetry: () => ref
                            .read(historyControllerProvider.notifier)
                            .loadMore(),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (data != null && data.feed.hasMore)
                      _LoadMoreButton(
                        label: data.loadingMore
                            ? l.historyLoadingMore
                            : l.historyLoadMore(data.feed.remaining),
                        onTap: data.loadingMore
                            ? null
                            : () => ref
                                  .read(historyControllerProvider.notifier)
                                  .loadMore(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayGroupView extends StatelessWidget {
  const _DayGroupView({
    required this.label,
    required this.total,
    required this.group,
  });

  final String label;
  final String total;
  final DayGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 6, 2, 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  total,
                  style: AppTextStyles.monoCaption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          for (final p in group.payments) ...[
            const SizedBox(height: 8),
            HistoryRow(
              payment: p,
              onTap: () => context.push(Routes.payment, extra: p),
            ),
          ],
        ],
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      radius: AppDimens.radiusRow,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      borderColor: AppColors.borderList,
      pressedColor: AppColors.disabledBg,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
