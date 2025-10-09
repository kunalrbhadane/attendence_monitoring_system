import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';

/// A reusable primary button widget styled according to the app's brand.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Note: While there is a global ElevatedButtonTheme, defining the style here
    // makes this widget more self-contained and guarantees its appearance.
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // Uses the primary brand color which is consistent across themes.
        backgroundColor: AppColors.primaryBlue,

        // CORRECTED: Replaced the non-existent 'AppColors.textOnPrimary'
        // with the universal 'Colors.white'.
        foregroundColor: Colors.white,
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 52), // Full width
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon),
            const SizedBox(width: 8),
          ],
          Text(text, style: AppTextStyles.button), // AppTextStyles.button is already white
        ],
      ),
    );
  }
}