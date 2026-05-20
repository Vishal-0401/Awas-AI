import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color primaryGold = Color(0xFFFFB800);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color borders = Color(0xFF30363D);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8B949E);

  static const Color glassBackground = Color(0x1A161B22); // 10% surface
  static const Color glassBorder = Color(0x3330363D);

  // Common app colors
  static Color get primary => primaryGold;
  static Color get primaryDark => const Color(0xFF121820);

  static Color get surfaceHighlight => const Color(0xFF21262D);

  static Color get success => const Color(0xFF2ECC71);
  static Color get warning => const Color(0xFFFFB800);

  // Backward-compat aliases (some screens use different names)
  static Color get succs => success;


  static Color get online => const Color(0xFF00E5FF);

  static Color get error => const Color(0xFFFF4D4D); // 20% border
}
