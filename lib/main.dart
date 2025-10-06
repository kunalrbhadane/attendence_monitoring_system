import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
// REMOVE or COMMENT OUT the LoginScreen import for now
// import 'package/attendence_monitoring_system/features/admin_auth/presentation/screens/login_screen.dart';
// ADD the import for your Admin App Shell
import 'package:attendence_monitoring_system/features/shared_app_shell/presentation/screens/admin_app_shell.dart';

void main() {
  runApp(
    // ProviderScope is required for Riverpod to work.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartAttend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
        useMaterial3: true,
      ),
      // --- THIS IS THE CRUCIAL CHANGE ---
      // We are temporarily setting the AdminAppShell as the home screen for direct testing.
      home: const AdminAppShell(), 

      // This was the original line, which we will restore later
      // home: const LoginScreen(), 
    );
  }
}