import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';

// A simple data model to make passing employee data easier and cleaner.
// In a real app, this would be in the 'data/models' folder.
class Employee {
  final String name;
  final String id;
  final String email;
  final String status;

  Employee({required this.name, required this.id, required this.email, required this.status});
}

/// A screen to display detailed information about a single employee.
class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Helper widget for a detail row
    Widget detailRow(String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.bodyRegular.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
            Text(value, style: AppTextStyles.bodyBold),
          ],
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(employee.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: theme.colorScheme.background,
                    child: Icon(Icons.person, size: 56, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 16),
                  Text(employee.name, style: AppTextStyles.heading2),
                  Text("ID: ${employee.id}", style: AppTextStyles.subtitle),
                  const SizedBox(height: 24),
                  const Divider(),
                  detailRow("Email", employee.email),
                  detailRow("Current Status", employee.status),
                  detailRow("Department", "Engineering"), // Mock data
                  detailRow("Joined On", "Oct 1, 2024"), // Mock data
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}