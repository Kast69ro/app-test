import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/phone_format.dart';
import '../../../core/widgets/brand_header.dart';
import '../../../core/widgets/error_box.dart';
import '../../../core/widgets/num_keypad.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../pin/data/pin_repository.dart';
import '../domain/session.dart';
import 'login_controller.dart';
import 'login_failure_text.dart';
import 'session_controller.dart';
import 'widgets/otp_cells.dart';
import 'widgets/phone_field.dart';

/// Вход: телефон → SMS-код. Прототип: `POS Terminal.dc.html`, стр. 213–267.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final s = ref.watch(loginControllerProvider);
    final c = ref.read(loginControllerProvider.notifier);
    final isPhone = s.step == LoginStep.phone;

    // Сессию стёрли после 5 неверных кодов — объясняем, пока человек не начал ввод.
    final reason = ref.watch(sessionControllerProvider).value?.reason;
    final String? error = s.failure != null
        ? loginFailureText(s.failure!, l)
        : (reason == SignOutReason.pinLockedOut && isPhone && s.phone.isEmpty)
        ? l.pinLockedOut(pinMaxAttempts)
        : null;

    final String buttonLabel;
    if (s.loading) {
      buttonLabel = isPhone ? l.loginSendingCode : l.loginVerifying;
    } else {
      buttonLabel = isPhone ? l.loginGetCode : l.loginSubmit;
    }

    return PopScope(
      // Системная «назад» на шаге кода возвращает к номеру.
      canPop: isPhone,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) c.backToPhone();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.screenPadding,
              24,
              AppDimens.screenPadding,
              26,
            ),
            // Раскладка как в прототипе: всё идёт сверху подряд. На маленьком
            // экране прокручивается только верх, кнопка и клавиатура видны всегда.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const BrandHeader(),
                        const SizedBox(height: 20),
                        if (isPhone) ...[
                          Text(l.loginTitle, style: AppTextStyles.screenTitle),
                          const SizedBox(height: 8),
                          Text(l.loginSubtitle, style: AppTextStyles.body),
                          const SizedBox(height: 20),
                          PhoneField(digits: s.phone, label: l.loginPhoneLabel),
                        ] else
                          _CodeStep(state: s, controller: c, l: l),
                        if (error != null) ...[
                          const SizedBox(height: 20),
                          ErrorBox(error),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: buttonLabel,
                  loading: s.loading,
                  onPressed: s.canSubmit ? c.submit : null,
                ),
                const SizedBox(height: 14),
                NumKeypad(onKey: c.key, enabled: !s.loading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CodeStep extends StatelessWidget {
  const _CodeStep({
    required this.state,
    required this.controller,
    required this.l,
  });

  final LoginState state;
  final LoginController controller;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final canResend = state.resendIn <= 0 && !state.loading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.loginCodeHint(
            formatPhoneHidden(state.phone),
            (state.codeExpiresIn / 60).round(),
          ),
          style: AppTextStyles.caption.copyWith(height: 1.45),
        ),
        const SizedBox(height: 10),
        OtpCells(
          code: state.code,
          length: otpLength,
          hasError: state.failure != null,
          label: l.loginCodeLabel,
        ),
        const SizedBox(height: 2),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          children: [
            _LinkButton(
              label: l.loginChangePhone,
              color: AppColors.accent,
              onTap: state.loading ? null : controller.backToPhone,
            ),
            _LinkButton(
              label: state.resendIn > 0
                  ? l.loginResendIn(state.resendIn)
                  : l.loginResend,
              color: canResend ? AppColors.accent : AppColors.textTertiary,
              mono: true,
              onTap: canResend ? controller.resend : null,
            ),
          ],
        ),
      ],
    );
  }
}

/// Текстовая ссылка с зоной нажатия 44 px.
class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.mono = false,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppDimens.minTap),
          child: Align(
            widthFactor: 1,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontFeatures: mono ? AppFonts.tabular : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
