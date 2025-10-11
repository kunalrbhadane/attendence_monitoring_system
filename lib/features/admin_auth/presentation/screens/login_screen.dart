import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';
import 'package:attendence_monitoring_system/features/admin_auth/presentation/screens/signup_screen.dart';
import 'package:attendence_monitoring_system/features/admin_auth/presentation/screens/forgot_password_screen.dart';
// Note: This still points to EmployeeAppShell for Developer 2's testing.
// In the final app, this would be determined by the user's role after login.
import 'package:attendence_monitoring_system/features/shared_app_shell/presentation/screens/employee_app_shell.dart';

/// The main Login Screen, now with a password visibility toggle.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  // ======================= THE FIX IS HERE =======================
  // Corrected the typo from "TextEditing-Controller" to "TextEditingController".
  final _passwordController = TextEditingController();
  // ================================================================
  
  // State variable to manage password visibility.
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _login() {
    // Check if the form's validation rules pass.
    if (_formKey.currentState!.validate()) {
      // For this UI-first mock, we bypass actual authentication.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const EmployeeAppShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Text("Welcome Back!", textAlign: TextAlign.center, style: AppTextStyles.heading1),
                  const SizedBox(height: 8),
                  Text("Sign in to your account", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 40),
                  Icon(Icons.fingerprint, size: 100, color: AppColors.primaryBlue.withAlpha(128)),
                  const SizedBox(height: 40),

                  // --- Email Field (Unchanged) ---
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) return 'Please enter a valid email.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // --- Password Field with Visibility Toggle ---
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isPasswordObscured,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      // The suffixIcon is an IconButton that toggles the state.
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          // Update the state to show/hide the password.
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your password.';
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  
                  // --- "Forgot Password?" Button ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                      },
                      child: Text("Forgot Password?", style: AppTextStyles.bodyRegular.copyWith(color: AppColors.primaryBlue)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // --- Login & Sign Up Buttons (Unchanged) ---
                  PrimaryButton(text: "LOGIN", onPressed: _login),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: AppTextStyles.bodyRegular),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
                        },
                        child: Text("Sign Up", style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryMagenta)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}