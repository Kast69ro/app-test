import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Лого TJ QR | разделитель | «QR рамзи ягона» (стандарт НБТ).
class TjQrBrandRow extends StatelessWidget {
  const TjQrBrandRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'QR рамзи ягона',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/tjqr-logo.png',
            width: 104,
            height: 46,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 14),
          Container(width: 1, height: 40, color: AppColors.tjqrText),
          const SizedBox(width: 14),
          const Text('QR рамзи\nягона', style: AppTextStyles.tjqrTitle),
        ],
      ),
    );
  }
}
