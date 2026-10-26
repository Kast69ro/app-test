import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

/// «Оформляем возврат…» — пока ждём ответ. Назад уйти нельзя.
class RefundSendingView extends StatelessWidget {
  const RefundSendingView({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Center(
          child: Semantics(
            liveRegion: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: context.colors.accent),
                const SizedBox(height: 18),
                Text(
                  text,
                  style: AppTextStyles.body.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Итог: возврат оформлен (или в обработке у банка).
class RefundDoneView extends StatelessWidget {
  const RefundDoneView({
    super.key,
    required this.title,
    required this.text,
    required this.buttonLabel,
    required this.onDone,
    this.pending = false,
  });

  final String title;
  final String text;
  final String buttonLabel;
  final VoidCallback onDone;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.screenPadding,
            28,
            AppDimens.screenPadding,
            16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Semantics(
                      liveRegion: true,
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: pending ? c.pendingBg : c.refundBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              pending
                                  ? Icons.schedule_rounded
                                  : Icons.check_rounded,
                              size: 38,
                              color: pending ? c.pendingFg : c.refundFg,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.screenTitle,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            text,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(label: buttonLabel, onPressed: onDone),
            ],
          ),
        ),
      ),
    );
  }
}
