import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';

/// Вкладки «Главная» / «История» внизу экрана. Прототип: стр. 113–120.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 18),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: Row(
              children: [
                Expanded(
                  child: _Tab(
                    label: l.tabHome,
                    iconRadius: 4,
                    active: shell.currentIndex == 0,
                    onTap: () => _go(0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Tab(
                    label: l.tabHistory,
                    iconRadius: 9,
                    active: shell.currentIndex == 1,
                    onTap: () => _go(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Повторный тап по активной вкладке возвращает её к началу.
  void _go(int index) =>
      shell.goBranch(index, initialLocation: index == shell.currentIndex);
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.iconRadius,
    required this.active,
    required this.onTap,
  });

  final String label;

  /// Иконка-фигура из прототипа: квадрат (4) у «Главной», круг (9) у «Истории».
  final double iconRadius;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = active ? AppColors.tabActive : AppColors.textTertiary;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: active ? AppColors.tabActiveBg : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 58),
            child: Column(
              // min: иначе панель растягивается на весь экран.
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 17,
                  height: 17,
                  decoration: BoxDecoration(
                    border: Border.all(color: fg, width: 2),
                    borderRadius: BorderRadius.circular(iconRadius),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  textScaler: MediaQuery.textScalerOf(context)
                      .clamp(maxScaleFactor: 1.3),
                  style: TextStyle(fontSize: 12, color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
