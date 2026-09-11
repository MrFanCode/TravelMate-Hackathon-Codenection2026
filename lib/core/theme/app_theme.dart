import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Global ThemeData. Screens should pull colors/text styles from
/// AppColors / AppTextStyles rather than Theme.of(context) directly,
/// so the passport/airmail identity stays consistent everywhere.
class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.rust,
      surface: AppColors.paper,
      primary: AppColors.rust,
      secondary: AppColors.pine,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      bodyMedium: AppTextStyles.body,
      labelLarge: AppTextStyles.label,
    ),
  );
}
