import 'package:flutter/material.dart';

class AppColors {
  // Premium Dark Theme - Tesla-inspired
  static const Color background = Color(0xFF050A0F);
  static const Color surface = Color(0xFF0D1419);
  static const Color surfaceHighlight = Color(0xFF161E27);
  static const Color cardBackground = Color(0xFF121A22);
  
  // Primary Accent - Cyan for AI/futuristic feel
  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryVariant = Color(0xFF00BFA5);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color neonCyan = Color(0xFF00FFFF);
  
  // Gold for premium elements
  static const Color primaryGold = Color(0xFFFFB800);
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF7A8699);
  static const Color textTertiary = Color(0xFF5A6473);
  static const Color textDisabled = Color(0xFF3A4455);
  
  // Status Colors
  static const Color online = Color(0xFF00E5FF);
  static const Color offline = Color(0xFF8B949E);
  static const Color success = Color(0xFF00E571);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF4D4D);
  
  // Glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x333A4455);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFB800), Color(0xFFFF9500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF050A0F), Color(0xFF0A121A), Color(0xFF0D141A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF121A22), Color(0xFF0D1419)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00E571), Color(0xFF00C853)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static get secondary => null;
}