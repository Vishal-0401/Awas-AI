import 'package:flutter/material.dart';

class AppColors {
  // Premium Dark Theme
  static const Color background = Color(0xFF0A0F14);
  static const Color surface = Color(0xFF121820);
  static const Color surfaceHighlight = Color(0xFF1E293B);
  static const Color primaryGold = Color(0xFFFFB800);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color primaryDark = Color(0xFF121820);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textTertiary = Color(0xFF6E7681);

  // Status Colors
  static const Color online = Color(0xFF00E5FF);
  static const Color offline = Color(0xFF8B949E);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF4D4D);

  // Glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x333A4455);

  // Borders (backward compatibility)
  static const Color borders = Color(0xFF30363D);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFB800), Color(0xFFFF9500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0F14), Color(0xFF0D141A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Backward-compatible getters
  static Color get primary => primaryGold;
}