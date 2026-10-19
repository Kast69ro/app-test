import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/phone_format.dart';
import '../../../core/widgets/confirm_logout.dart';
import '../../../core/widgets/text_link.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';

/// Настройки: данные точки, смена кода, выход.
/// Открываются тапом по логотипу на главной.
/// TODO: политика конфиденциальности и версия — ждут согласования пакетов.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final session = ref.watch(sessionControllerProvider).value?.session;
    String orDash(String? v) => (v == null || v.isEmpty) ? '—' : v;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.screenPadding,
            8,
            AppDimens.screenPadding,
            24,
          ),
          children: [
            BackLink(label: l.back, onTap: () => context.pop()),
            const SizedBox(height: 4),
            Text(
              l.settingsTitle,
              style: AppTextStyles.screenTitle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            _Card(
              children: [
                _Field(l.settingsTerminal, orDash(session?.terminalName)),
                _Field(l.settingsStore, orDash(session?.storeName)),
                _Field(l.settingsTerminalId, orDash(session?.terminalId)),
                _Field(
                  l.settingsPhone,
                  session == null ? '—' : formatPhoneHidden(session.phone),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ActionRow(
              label: l.settingsChangePin,
              onTap: () => context.push(Routes.changePin),
            ),
            const SizedBox(height: 12),
            _ActionRow(
              label: l.logout,
              color: AppColors.error,
              showChevron: false,
              onTap: () async {
                if (await confirmLogout(context)) {
                  await ref.read(sessionControllerProvider.notifier).signOut();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Белая карточка с полями «название — значение», как реквизиты операции.
class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) spaced.add(const SizedBox(height: 14));
      spaced.add(children[i]);
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderList),
        borderRadius: BorderRadius.circular(AppDimens.radiusRow),
      ),
      child: Column(children: spaced),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: AppFonts.mono,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.label,
    required this.onTap,
    this.color = AppColors.textPrimary,
    this.showChevron = true,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusRow),
      side: const BorderSide(color: AppColors.borderList),
    );
    return Semantics(
      button: true,
      child: Material(
        color: AppColors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          highlightColor: AppColors.disabledBg,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 16, color: color),
                    ),
                  ),
                  if (showChevron)
                    const ExcludeSemantics(
                      child: Text(
                        '›',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
