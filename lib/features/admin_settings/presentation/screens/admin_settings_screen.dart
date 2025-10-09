import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/features/admin_auth/presentation/screens/login_screen.dart';
import 'package:attendence_monitoring_system/features/admin_settings/presentation/screens/change_password_screen.dart';
import 'package:attendence_monitoring_system/features/admin_settings/presentation/screens/edit_profile_screen.dart';
// MODIFIED: Import the new company settings screen
import 'package:attendence_monitoring_system/features/admin_settings/presentation/screens/company_settings_screen.dart';


/// The settings screen for the Admin user, now with full functionality for all options.
class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // --- User Profile Section ---
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                           CircleAvatar(
                            radius: 32,
                            backgroundColor: theme.colorScheme.background,
                            child: Icon(Icons.person, size: 36, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("HT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                Text("HeuristicTechnopark@gmail.com", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // --- Settings Options ---
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.edit_outlined, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                            title: const Text("Edit Profile"),
                            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const EditProfileScreen())
                              );
                            },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: Icon(Icons.lock_outline_rounded, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                            title: const Text("Change Password"),
                            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const ChangePasswordScreen())
                              );
                            },
                          ),
                           const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: Icon(Icons.business_outlined, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                            title: const Text("Company Settings"),
                            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                            // MODIFIED: Replaced the SnackBar with actual navigation
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const CompanySettingsScreen())
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Logout Button ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 184, 7, 90),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}