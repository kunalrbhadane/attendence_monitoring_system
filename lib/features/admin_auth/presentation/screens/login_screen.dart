import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/features/shared_app_shell/presentation/screens/admin_app_shell.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  // MODIFIED: Removed const
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _login() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AdminAppShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Sign in to your account",
                textAlign: TextAlign.center,
                // Inherits subtitle styling and color from theme
                style: Theme.of(context).textTheme.titleMedium, 
              ),
              const SizedBox(height: 40),
              Icon(Icons.fingerprint, size: 120, color: AppColors.primaryBlue.withAlpha(128)),
              const SizedBox(height: 40),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("Forgot Password?", style: AppTextStyles.bodyRegular.copyWith(color: AppColors.primaryBlue)),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: "LOGIN", 
                onPressed: _login,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: AppTextStyles.bodyRegular),
                  TextButton(
                    onPressed: () {},
                    child: Text("Register Now", style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryBlue)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}