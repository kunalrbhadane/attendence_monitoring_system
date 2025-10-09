import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'package:attendence_monitoring_system/features/admin_employee_management/presentation/screens/employee_list_screen.dart';
import 'package:attendence_monitoring_system/features/admin_reports/presentation/screens/reports_analytics_screen.dart';
import 'package:attendence_monitoring_system/features/admin_settings/presentation/screens/admin_settings_screen.dart';

class AdminAppShell extends StatefulWidget {
  // Can no longer be const
  const AdminAppShell({super.key});
  @override
  State<AdminAppShell> createState() => _AdminAppShellState();
}

class _AdminAppShellState extends State<AdminAppShell> {
  int _selectedIndex = 0;

  // Pages remain const
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          // Uses the current theme's surface color
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 2)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          // BottomNavigationBar itself is already styled by the theme in main.dart
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), label: 'Employees'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Reports'),
              BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}