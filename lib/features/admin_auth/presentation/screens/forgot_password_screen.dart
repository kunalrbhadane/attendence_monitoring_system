import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';

/// A screen where users can request a password reset link.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  void _sendResetLink() {
    if (_formKey.currentState!.validate()) {
      // Simulate sending a reset link
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent to your email!'),
        ),
      );

      // Go back to the login screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Icon(Icons.mark_email_read_outlined, size: 80, color: AppColors.primaryBlue.withAlpha(128)),
                const SizedBox(height: 20),
                Text(
                  "Enter your email and we will send you a link to reset your password.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyRegular,
                ),
                const SizedBox(height: 30),

                // --- Email Field ---
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // --- Send Link Button ---
                PrimaryButton(
                  text: "SEND RESET LINK",
                  onPressed: _sendResetLink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}