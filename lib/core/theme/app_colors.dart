import 'package:flutter/material.dart';

/// Defines all the colors used in the SmartAttend app design,
/// now based on the new brand logo and supporting both Light and Dark themes.
class AppColors {
  // --- Brand Colors from Logo ---
  static const Color primaryBlue = Color(0xFF007BFF); // A vibrant, primary blue
  static const Color primaryMagenta = Color(0xFFC71585); // A rich, secondary magenta

  // A slightly darker blue for button presses or accents
  static const Color primaryDarkBlue = Color(0xFF0056b3);

  // --- Light Theme Palette ---
  static const Color lightBackground = Color(0xFFF5F7FA); // Soft off-white
  static const Color lightSurface = Colors.white; // For cards, dialogs
  static const Color lightTextPrimary = Color(0xFF1a1a1a);
  static const Color lightTextSecondary = Color(0xFF6c757d);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // --- Dark Theme Palette ---
  static const Color darkBackground = Color(0xFF121212); // Standard dark background
  static const Color darkSurface = Color(0xFF1E1E1E); // Elevated dark surfaces
  static const Color darkTextPrimary = Color(0xFFEAEAEA);
  static const Color darkTextSecondary = Color(0xFFa0a0a0);
  static const Color darkBorder = Color(0xFF2c2c2c);

  // --- Semantic Colors (Remain consistent across themes) ---
  static const Color statusGreen = Color(0xFF28a745);
  static const Color statusRed = Color(0xFFdc3545);
  static const Color statusYellow = Color(0xFFffc107);
  static const Color statusOnLeave = Color(0xFF17a2b8);
  static const Color notificationBell = Color(0xFFf39c12); // Orange for pending req bell
}