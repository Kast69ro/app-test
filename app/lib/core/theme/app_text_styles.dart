import 'package:flutter/painting.dart';

import 'app_colors.dart';

abstract final class AppFonts {
  /// Фирменный шрифт банка — весь текст приложения.
  static const brand = 'Montserrat';

  /// Цифры одной ширины, чтобы суммы и коды не «прыгали».
  static const tabular = [FontFeature.tabularFigures()];

  /// Блок TJ QR.
  static const lato = 'Lato';
}

/// Стили текста из прототипа. Шрифт по умолчанию — [AppFonts.brand] из темы.
abstract final class AppTextStyles {
  static const screenTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.52,
    height: 1.15,
    color: AppColors.textPrimary,
  );

  /// Заголовок вкладки («История»).
  static const tabTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.52,
    color: AppColors.textPrimary,
  );

  static const terminalTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.22,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 14,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const caption = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const button = TextStyle(fontSize: 17, fontWeight: FontWeight.w600);

  static const brandName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.16,
    color: AppColors.textPrimary,
  );

  static const brandSubtitle = TextStyle(
    fontFeatures: AppFonts.tabular,
    fontSize: 11,
    letterSpacing: 0.66,
    color: AppColors.textTertiary,
  );

  static const monoCaption = TextStyle(
    fontFeatures: AppFonts.tabular,
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  /// Суммы в плитках главной.
  static const amountTile = TextStyle(
    fontFeatures: AppFonts.tabular,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.48,
    color: AppColors.textPrimary,
  );

  /// Сумма в строке истории.
  static const amountRow = TextStyle(
    fontFeatures: AppFonts.tabular,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  /// Сумма в шапке карточки операции.
  static const amountLarge = TextStyle(
    fontFeatures: AppFonts.tabular,
    fontSize: 40,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
    color: AppColors.textPrimary,
  );

  static const tjqrTitle = TextStyle(
    fontFamily: AppFonts.lato,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    height: 1.12,
    color: AppColors.tjqrText,
  );

  static const tjqrMerchant = TextStyle(
    fontFamily: AppFonts.lato,
    fontSize: 14,
    color: AppColors.tjqrText,
  );
}
