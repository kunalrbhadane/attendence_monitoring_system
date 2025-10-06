import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'package:attendence_monitoring_system/features/admin_employee_management/presentation/screens/employee_list_screen.dart';
import 'package:attendence_monitoring_system/features/admin_reports/presentation/screens/reports_analytics_screen.dart';
import 'package:attendence_monitoring_system/features/admin_settings/presentation/screens/admin_settings_screen.dart';

class AdminAppShell extends StatefulWidget {
  const AdminAppShell({super.key});
  @override
  State<AdminAppShell> createState() => _AdminAppShellState();
}

class _AdminAppShellState extends State<AdminAppShell> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    AdminDashboardScreen(),
    EmployeeListScreen(),
    ReportsAnalyticsScreen(),
    AdminSettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      // This new structure creates the floating, curved navigation bar effect
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_rounded),
                label: 'Employees',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Reports',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: AppColors.textSecondary.withOpacity(0.7),
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent, // Important for the container's color to show
            elevation: 0, // Remove default elevation
          ),
        ),
      ),
    );
  }
}