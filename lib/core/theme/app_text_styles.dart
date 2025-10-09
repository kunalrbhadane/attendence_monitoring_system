import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Note: We no longer import app_colors.dart here because colors are now handled by the theme.

/// Defines all the base text styles used in the app.
/// Colors are NOT defined here; they are inherited from the active ThemeData
/// (lightTheme or darkTheme) to ensure automatic light/dark mode compatibility.
class AppTextStyles {
  // Define your app's primary font family for consistency.
  static const String fontFamily = 'Poppins';
  
  // Base TextStyle using the chosen font.
  static final TextStyle _base = GoogleFonts.poppins();

  // --- HEADING STYLES ---

  /// Font Size: 28, Weight: Bold
  static final TextStyle heading1 = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  /// Font Size: 22, Weight: Bold
  static final TextStyle heading2 = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  /// Font Size: 16, Weight: Medium (w500)
  static final TextStyle subtitle = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // --- BODY & GENERAL STYLES ---

  /// Font Size: 14, Weight: Normal
  static final TextStyle bodyRegular = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  /// Font Size: 14, Weight: Bold
  static final TextStyle bodyBold = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  /// Font Size: 12, Weight: Normal
  static final TextStyle caption = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // --- BUTTON STYLE ---

  /// Font Size: 16, Weight: Bold
  /// We keep the color here because button text color is usually an exception
  /// (e.g., white text on a blue button), which is defined in our ThemeData anyway.
  /// Keeping it provides a good default.
  static final TextStyle button = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white, // Default color for text on buttons
  );
}