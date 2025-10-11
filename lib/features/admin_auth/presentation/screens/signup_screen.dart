import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';
import 'package:attendence_monitoring_system/features/admin_auth/presentation/screens/login_screen.dart';

/// A professional and fully functional user registration screen.
/// Includes confirm password validation and password visibility toggles.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // --- STATE MANAGEMENT ---
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // State variables to toggle password visibility
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  /// Validates the form and performs the mock signup.
  void _signUp() {
    // Validate the form. If all fields pass, proceed.
    if (_formKey.currentState!.validate()) {
      // For this UI-first mock, we just show a success message and navigate.
      // In a real app, this is where you'd call your authentication service.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please log in.'),
          backgroundColor: AppColors.statusGreen,
        ),
      );

      // Navigate to the Login screen, clearing all previous screens from the stack
      // to prevent the user from navigating back to the signup page.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar provides a clear title and a back button.
      appBar: AppBar(
        title: Text("Create Your Account", style: AppTextStyles.heading2),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // A visual icon to enhance the UI.
                Icon(Icons.person_add_alt_1_outlined, size: 80, color: AppColors.primaryMagenta.withAlpha(128)),
                const SizedBox(height: 30),

                // --- Form Fields with Validation ---
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter your full name.';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    // Password visibility toggle icon
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                    ),
                  ),
                  obscureText: _isPasswordObscured,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // "Confirm Password" field for better user experience
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    // ======================= THE FIX IS HERE =======================
                    // Replaced the non-existent 'lock_check_outline' with a valid Material icon.
                    prefixIcon: const Icon(Icons.password_rounded),
                    // ================================================================
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                     suffixIcon: IconButton(
                      icon: Icon(_isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
                    ),
                  ),
                   obscureText: _isConfirmPasswordObscured,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // --- Sign Up Button ---
                PrimaryButton(
                  text: "CREATE ACCOUNT", 
                  onPressed: _signUp,
                ),
                const SizedBox(height: 24),
                
                // --- Link to Login Screen ---
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: AppTextStyles.bodyRegular),
                      TextButton(
                        onPressed: () {
                           Navigator.of(context).pop(); // Go back to the previous screen (Login)
                        },
                        child: Text("Login", style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryBlue)),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}