import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';

/// Defines the ThemeData for both Light and Dark modes of the application.
class AppTheme {
  // --- LIGHT THEME ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.lightBackground,
    // CORRECTED: fontFamily is now correctly referenced from AppTextStyles.
    fontFamily: AppTextStyles.fontFamily,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryMagenta,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      error: AppColors.statusRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
      onBackground: AppColors.lightTextPrimary,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: AppTextStyles.heading2.copyWith(color: AppColors.lightTextPrimary),
    ),

    // CORRECTED: Changed CardTheme to the proper CardThemeData constructor.
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 1.5,
      shadowColor: AppColors.lightBackground, // Using a distinct color for light theme shadows
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 52),
        textStyle: AppTextStyles.button,
      ),
    ),
    
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent, // Let the container handle color
      elevation: 0,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.lightTextSecondary.withOpacity(0.7),
      type: BottomNavigationBarType.fixed,
    ),
  );

  // --- DARK THEME ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.darkBackground,
    // CORRECTED: fontFamily is now correctly referenced from AppTextStyles.
    fontFamily: AppTextStyles.fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryMagenta,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.statusRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkTextPrimary,
      onBackground: AppColors.darkTextPrimary,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: AppTextStyles.heading2.copyWith(color: AppColors.darkTextPrimary),
    ),

    // CORRECTED: Changed CardTheme to the proper CardThemeData constructor.
     cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 1.5,
      shadowColor: AppColors.darkBackground, // Using a distinct color for dark theme shadows
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 52),
        textStyle: AppTextStyles.button,
      ),
    ),

     bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent, // Let the container handle color
      elevation: 0,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.darkTextSecondary.withOpacity(0.7),
      type: BottomNavigationBarType.fixed,
    ),
  );
}