import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/features/employee_dashboard/presentation/screens/employee_home_screen.dart';
import 'package:attendence_monitoring_system/features/employee_attendance_calendar/presentation/screens/attendance_calendar_screen.dart';
import 'package:attendence_monitoring_system/features/employee_profile/presentation/screens/my_profile_screen.dart';


/// The main Scaffold and navigation shell for the Employee side of the app.
/// It manages the state of the selected page and the bottom navigation bar.
class EmployeeAppShell extends StatefulWidget {
  const EmployeeAppShell({super.key});

  @override
  State<EmployeeAppShell> createState() => _EmployeeAppShellState();
}

class _EmployeeAppShellState extends State<EmployeeAppShell> {
  // State variable to keep track of the currently selected tab index.
  int _selectedIndex = 0;

  // A static list of the pages that correspond to the bottom navigation bar items.
  // Using const here is a performance optimization.
  static final List<Widget> _pages = <Widget>[
    const EmployeeHomeScreen(),
    const AttendanceCalendarScreen(),
    const MyProfileScreen(),
  ];

  /// Callback function that updates the state when a bottom navigation bar item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The main scaffold that provides the app's structure.
    return Scaffold(
      // BEST PRACTICE: Using IndexedStack as the body.
      // IndexedStack keeps all pages in the widget tree and preserves their state
      // when switching tabs. This is more efficient than rebuilding the page
      // every time the user navigates.
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // The floating bottom navigation bar.
      bottomNavigationBar: Container(
        // Margin creates the floating effect above the bottom edge.
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24), 
        decoration: BoxDecoration(
          // Use the current theme's surface color for theme-awareness (light/dark mode).
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          // A subtle shadow to lift the navigation bar off the background.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            )
          ],
        ),
        // ClipRRect ensures the BottomNavigationBar itself respects the rounded corners.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            // The items to display in the navigation bar.
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Calendar'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
            // Binds the currently selected index to our state variable.
            currentIndex: _selectedIndex,
            // Links the tap action to our state-updating function.
            onTap: _onItemTapped,
            // The styling for the navigation bar itself (colors, elevation)
            // is automatically handled by the AppTheme defined in `main.dart`.
          ),
        ),
      ),
    );
  }
}