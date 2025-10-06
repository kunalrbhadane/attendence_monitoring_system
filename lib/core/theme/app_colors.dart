import 'package:flutter/material.dart';

// Defines all the colors used in the SmartAttend app design.
class AppColors {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF1E88E5); // Example blue from buttons
  static const Color primaryDarkBlue = Color(0xFF1565C0); // Darker blue for interactions
  static const Color secondaryOrange = Color(0xFFFFA726); // Accent color for 'Request Correction'

  // Status Colors
  static const Color statusGreen = Color(0xFF66BB6A);
  static const Color statusRed = Color(0xFFEF5350);
  static const Color statusYellow = Color(0xFFFFCA28);
  static const Color statusOnLeave = Color(0xFF42A5F5); // For calendar, etc.

  // Text Colors
  static const Color textPrimary = Color(0xFF333333); // Dark primary text
  static const Color textSecondary = Color(0xFF757575); // Lighter grey text
  static const Color textOnPrimary = Colors.white; // Text on top of blue buttons

  // Background & Surface Colors
  static const Color background = Color(0xFFF5F7FA); // Light grey background
  static const Color surface = Colors.white; // Color for cards, sheets

  // Neutral Colors for Borders, Dividers, etc.
  static const Color border = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFBDBDBD);
}