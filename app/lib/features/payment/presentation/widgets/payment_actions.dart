import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

/// «Возврат платежа» — пока всегда неактивна (возвраты ещё не готовы на бэке).
class RefundButton extends StatelessWidget {
  const RefundButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: false,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.disabledBg,
          border: Border.all(color: AppColors.borderList),
          borderRadius: BorderRadius.circular(AppDimens.radiusRow),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.disabledText,
          ),
        ),
      ),
    );
  }
}

/// Белая кнопка 52 px на месте «Печать чека» из прототипа.
class ShareReceiptButton extends StatelessWidget {
  const ShareReceiptButton({
    super.key,
    required this.label,
    required this.onTap,
    this.busy = false,
    this.failed = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool busy;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusRow),
      side: const BorderSide(color: AppColors.borderList),
    );
    return Semantics(
      button: true,
      enabled: !busy,
      child: Material(
        color: busy ? AppColors.disabledBg : AppColors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: busy ? null : onTap,
          highlightColor: AppColors.disabledBg,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: failed ? AppColors.error : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
