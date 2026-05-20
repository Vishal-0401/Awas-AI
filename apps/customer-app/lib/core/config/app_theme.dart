import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0F172A); // Deep navy/slate
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceGlass = Color(0x331E293B);
  static const Color primary = Color(0xFF06B6D4); // Neon cyan
  static const Color primaryVariant = Color(0xFF0891B2);
  static const Color secondary = Color(0xFF3B82F6); // Blue accent
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  
  // Neon glowing effect colors
  static const Color cyanGlow = Color(0x8006B6D4);
}

class AppTheme {
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.montserrat(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.montserrat(color: AppColors.textPrimary),
      bodyMedium: GoogleFonts.montserrat(color: AppColors.textSecondary),
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: AppColors.cyanGlow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      cardTheme:  CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white10, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: GoogleFonts.montserrat(color: AppColors.textSecondary),
      ),
    );
  }
}
