import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGold,
        secondary: AppColors.accentCyan,
        surface: AppColors.surface,
        background: AppColors.background,
        error: Colors.redAccent,
      ),
      fontFamily: 'Roboto', // Default fallback, but using custom styling
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimary, letterSpacing: -1.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.textPrimary, letterSpacing: -0.5, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: AppColors.textPrimary, letterSpacing: 0.1),
        bodyMedium: TextStyle(color: AppColors.textSecondary, letterSpacing: 0.1),
        labelLarge: TextStyle(color: AppColors.primaryGold, letterSpacing: 1.2, fontWeight: FontWeight.bold),
      ),
     cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.borders, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borders),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borders),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentCyan),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
