import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const horizontalMargin = 16.0;
  static const radius = 10.0;

  static final ColorScheme colorSchemes = ColorScheme(
    primary: AppColors.primaryElement,
    secondary: AppColors.primaryElement,
    surface: AppColors.surfaceWhite,
    background: Colors.white,
    error: AppColors.errorRed,
    onPrimary: Colors.white,
    onSecondary: AppColors.brown900,
    onSurface: AppColors.brown900,
    onBackground: AppColors.brown900,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static ThemeData light = ThemeData(colorScheme: colorSchemes);
}
