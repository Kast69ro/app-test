import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Белая карточка с бордером, которая подсвечивается при нажатии.
class PressableCard extends StatelessWidget {
  const PressableCard({
    super.key,
    required this.child,
    required this.radius,
    required this.padding,
    this.onTap,
    this.pressedColor = AppColors.surfacePressed,
    this.borderColor = AppColors.border,
    this.semanticLabel,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color pressedColor;
  final Color borderColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: borderColor),
    );
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      child: Material(
        color: AppColors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          highlightColor: pressedColor,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
