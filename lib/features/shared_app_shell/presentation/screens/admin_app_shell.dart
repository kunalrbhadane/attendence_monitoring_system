import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'package:attendence_monitoring_system/features/admin_employee_management/presentation/screens/employee_list_screen.dart';
// CORRECTED: Unused import removed
import 'package:attendence_monitoring_system/features/admin_reports/presentation/screens/reports_analytics_screen.dart';
import 'package:attendence_monitoring_system/features/admin_settings/presentation/screens/admin_settings_screen.dart';

class AdminAppShell extends StatefulWidget {
  const AdminAppShell({super.key});

  @override
  State<AdminAppShell> createState() => _AdminAppShellState();
}

class _AdminAppShellState extends State<AdminAppShell> {
  int _selectedIndex = 0;

  // The pages accessible directly from the bottom nav bar
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
      bottomNavigationBar: BottomNavigationBar(
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
        backgroundColor: AppColors.surface,
        elevation: 8.0,
      ),
    );
  }
}