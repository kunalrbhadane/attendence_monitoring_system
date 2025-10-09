import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_monitoring_system/core/theme/app_theme.dart';
import 'package:attendence_monitoring_system/features/admin_auth/presentation/screens/login_screen.dart';

void main() {
  runApp(
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

      // --- MODIFIED: Applying the new Theme System ---
      theme: AppTheme.lightTheme,         // Your new light theme
      darkTheme: AppTheme.darkTheme,       // Your new dark theme
      themeMode: ThemeMode.system, // This automatically selects light/dark based on phone settings

      // The app still correctly starts at the Login Screen.
      home: const LoginScreen(),
    );
  }
}