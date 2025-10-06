import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// CORRECTED IMPORT PATH
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';

// Defines all the text styles used in the app, promoting consistency.
class AppTextStyles {
  // You might want to choose one font for the whole app, e.g., Poppins
  static final TextStyle _base = GoogleFonts.poppins();

  // Heading Styles
  static final TextStyle heading1 = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading2 = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle subtitle = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Body & General Styles
  static final TextStyle bodyRegular = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyBold = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle caption = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button Styles
  static final TextStyle button = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
  );
}