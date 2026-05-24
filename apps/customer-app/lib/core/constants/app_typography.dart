import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTypography {
  // Display
  static TextStyle get displayLarge => TextStyle(
        fontSize: 48.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -2,
        height: 1.1,
      );

  static TextStyle get displayMedium => TextStyle(
        fontSize: 36.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.2,
      );

  static TextStyle get displaySmall => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.3,
      );

  // Headings
  static TextStyle get h1 => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.3,
      );

  static TextStyle get h2 => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.35,
      );

  static TextStyle get h3 => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.4,
      );

  static TextStyle get h4 => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.4,
      );

  // Body
  static TextStyle get bodyLarge => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.45,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.4,
      );

  // Caption & Labels
  static TextStyle get caption => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
        height: 1.3,
      );

  static TextStyle get labelLarge => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.4,
      );

  static TextStyle get labelMedium => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.3,
      );

  static TextStyle get labelSmall => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.2,
      );

  // Monospace for data/stats
  static TextStyle get mono => TextStyle(
        fontFamily: 'Courier',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );
}