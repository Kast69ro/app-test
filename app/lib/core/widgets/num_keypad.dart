import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

/// Цифровая клавиатура 3×4 из прототипа: 1–9, пусто, 0, ⌫.
///
/// [onKey] получает цифру или `null` для «стереть».
/// Высота клавиши = доля высоты экрана в пределах [minKeyHeight]–[maxKeyHeight]
/// (как `clamp(44px, 8vh, 56px)` в прототипе).
class NumKeypad extends StatelessWidget {
  const NumKeypad({
    super.key,
    required this.onKey,
    this.minKeyHeight = 44,
    this.maxKeyHeight = 56,
    this.heightFactor = 0.08,
    this.fontSize = 21,
    this.enabled = true,
  });

  final ValueChanged<String?> onKey;
  final double minKeyHeight;
  final double maxKeyHeight;
  final double heightFactor;
  final double fontSize;
  final bool enabled;

  static const _layout = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '',
    '0',
    '⌫',
  ];

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    final keyH = (screenH * heightFactor).clamp(minKeyHeight, maxKeyHeight);

    final rows = <Widget>[];
    for (var r = 0; r < 4; r++) {
      final cells = <Widget>[];
      for (var c = 0; c < 3; c++) {
        final label = _layout[r * 3 + c];
        if (c > 0) cells.add(const SizedBox(width: 10));
        cells.add(
          Expanded(
            child: label.isEmpty
                ? SizedBox(height: keyH)
                : _Key(
                    label: label,
                    height: keyH,
                    fontSize: fontSize,
                    onTap: enabled
                        ? () => onKey(label == '⌫' ? null : label)
                        : null,
                  ),
          ),
        );
      }
      if (r > 0) rows.add(const SizedBox(height: 10));
      rows.add(Row(children: cells));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.label,
    required this.height,
    required this.fontSize,
    required this.onTap,
  });

  final String label;
  final double height;
  final double fontSize;
  final VoidCallback? onTap;

  bool get _isDelete => label == '⌫';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: _isDelete ? 'Стереть' : label,
      excludeSemantics: true,
      child: Material(
        color: AppColors.key,
        borderRadius: BorderRadius.circular(AppDimens.radiusKey),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimens.radiusKey),
          highlightColor: AppColors.keyPressed,
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height < AppDimens.minTap ? AppDimens.minTap : height,
            ),
            child: Center(
              child: Text(
                label,
                // Цифры клавиатуры не растут вместе с системным шрифтом сверх 1,3×,
                // иначе не помещаются в клавишу.
                textScaler: MediaQuery.textScalerOf(context)
                    .clamp(maxScaleFactor: 1.3),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
