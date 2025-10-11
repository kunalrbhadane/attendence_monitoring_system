import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';

/// A reusable secondary button widget with a styled outline.
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color outlineColor;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.outlineColor = AppColors.primaryMagenta, // A default orange/magenta color
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: outlineColor,
        side: BorderSide(color: outlineColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 52), // Full width
      ),
      onPressed: onPressed,
      child: Text(text, style: AppTextStyles.button.copyWith(color: outlineColor)),
    );
  }
}