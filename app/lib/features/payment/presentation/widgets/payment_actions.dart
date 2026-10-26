import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

/// «Возврат платежа». Неактивна, когда [onTap] == `null`: возвраты
/// выключены в сборке или платёж уже нельзя вернуть.
class RefundButton extends StatelessWidget {
  const RefundButton({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusRow),
      side: BorderSide(color: context.colors.borderList),
    );
    return Semantics(
      button: true,
      enabled: enabled,
      child: Material(
        color: enabled ? context.colors.surface : context.colors.disabledBg,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          highlightColor: context.colors.disabledBg,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? context.colors.accent
                        : context.colors.disabledText,
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
      side: BorderSide(color: context.colors.borderList),
    );
    return Semantics(
      button: true,
      enabled: !busy,
      child: Material(
        color: busy ? context.colors.disabledBg : context.colors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: busy ? null : onTap,
          highlightColor: context.colors.disabledBg,
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
                    color: failed
                        ? context.colors.error
                        : context.colors.textPrimary,
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
