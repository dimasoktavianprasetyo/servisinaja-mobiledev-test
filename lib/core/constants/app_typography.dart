import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle getHeading({
    required bool isDark,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w700,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );
  }

  static TextStyle getBody({
    required bool isDark,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    bool isSecondary = false,
  }) {
    final color = isSecondary
        ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );
  }

  static TextStyle getLabel({
    required bool isDark,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w600,
    Color? customColor,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: customColor ??
          (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }
}
