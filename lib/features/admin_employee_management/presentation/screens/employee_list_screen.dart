import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/features/admin_employee_management/presentation/screens/add_employee_screen.dart';

// --- WIDGETS ---

/// A custom styled chip to display employee status (IN, OUT, On Leave).
class StatusChip extends StatelessWidget {
  final String status;
  // MODIFIED: Removed const
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'in':
        chipColor = AppColors.statusGreen.withAlpha(38);
        textColor = AppColors.statusGreen;
        break;
      case 'out':
        chipColor = AppColors.statusRed.withAlpha(38);
        textColor = AppColors.statusRed;
        break;
      default: // 'on leave'
        chipColor = AppColors.statusOnLeave.withAlpha(38);
        textColor = AppColors.statusOnLeave;
    }

    return Chip(
      label: Text(status),
      labelStyle: AppTextStyles.caption.copyWith(color: textColor, fontWeight: FontWeight.bold),
      backgroundColor: chipColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// The main screen for listing and managing employees, now theme-aware.
class EmployeeListScreen extends StatelessWidget {
  // MODIFIED: Removed const
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Mock data for the list
    final List<Map<String, String>> mockEmployees = [
      {'name': 'John Doe', 'id': 'S1101', 'status': 'IN'},
      {'name': 'Jane Smith', 'id': 'S1102', 'status': 'OUT'},
      {'name': 'Alex Chen', 'id': 'S1101', 'status': 'OUT'},
      {'name': 'Jane Smith', 'id': 'S1102', 'status': 'On Leave'},
      {'name': 'Alex Chen', 'id': 'S1102', 'status': 'On Leave'},
      {'name': 'Rey Tave', 'id': 'S1103', 'status': 'IN'},
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Management"),
        automaticallyImplyLeading: false,
        // Properties like backgroundColor, elevation etc are now handled by theme
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            // --- Search Bar ---
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                suffixIcon: Icon(Icons.filter_list_rounded, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor, // Use theme background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // --- Employee List ---
            Expanded(
              child: ListView.builder(
                itemCount: mockEmployees.length,
                itemBuilder: (context, index) {
                  final employee = mockEmployees[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.background,
                        child: Icon(Icons.person, size: 28, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                      ),
                      title: Text(employee['name']!, style: AppTextStyles.bodyBold),
                      subtitle: Text("ID: ${employee['id']!}", style: AppTextStyles.caption),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatusChip(status: employee['status']!),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                        ],
                      ),
                      onTap: () { /* ... */ },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEmployeeScreen(),
              fullscreenDialog: true,
            ),
          );
        },
        // The FloatingActionButton colors can be set in the main theme, but styling here is fine too
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }
}