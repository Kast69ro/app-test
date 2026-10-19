import 'package:flutter/painting.dart';

/// Цвета из прототипа `POS Terminal.dc.html`. В экранах — только отсюда.
abstract final class AppColors {
  static const background = Color(0xFFF4F4F2);
  static const surface = Color(0xFFFFFFFF);
  static const surfacePressed = Color(0xFFFAFAF8);
  static const border = Color(0xFFE7E7E2);

  /// Бордер строк истории и карточки операции.
  static const borderList = Color(0xFFE2E2DE);

  static const textPrimary = Color(0xFF16181A);
  static const textSecondary = Color(0xFF6B7075);
  static const textTertiary = Color(0xFF9AA0A6);

  static const accent = Color(0xFF0E8F6F);
  static const accentPressed = Color(0xFF0B7259);

  static const error = Color(0xFFB3352F);
  static const errorBg = Color(0xFFFDECEA);
  static const errorBorder = Color(0xFFE3A9A5);

  static const key = Color(0xFFEAEAE5);
  static const keyPressed = Color(0xFFE4E4DF);
  static const cellIdle = Color(0xFFD7D7D2);

  static const buttonDark = Color(0xFF16181A);
  static const buttonLoading = Color(0xFF2E3237);
  static const buttonDisabled = Color(0xFFE2E2DE);
  static const disabledBg = Color(0xFFF0F0EC);
  static const disabledText = Color(0xFFA6ABB0);

  static const tabActiveBg = Color(0xFFFDECEC);
  static const tabActive = Color(0xFFD6202A);

  /// Блок «TJ QR | QR рамзи ягона».
  static const tjqrText = Color(0xFF4F4F4F);
  static const qrBackdrop = Color(0x29898383);

  // Статусы операций: фон чипа / текст / точка и полоса слева.
  static const successBg = Color(0xFFE8F5F0);
  static const successFg = Color(0xFF0B7259);
  static const successDot = Color(0xFF0E8F6F);
  static const cancelBg = Color(0xFFFDECEA);
  static const cancelFg = Color(0xFFB3352F);
  static const cancelDot = Color(0xFFC9403A);
  static const pendingBg = Color(0xFFFFF6E5);
  static const pendingFg = Color(0xFF8A5A00);
  static const pendingDot = Color(0xFFD89A1F);
  static const refundBg = Color(0xFFEEF1FB);
  static const refundFg = Color(0xFF3B4E8F);
  static const refundDot = Color(0xFF5A6FB5);
  static const unknownBg = Color(0xFFF0F0EC);
  static const unknownFg = Color(0xFF6B7075);
  static const unknownDot = Color(0xFF9AA0A6);
}
