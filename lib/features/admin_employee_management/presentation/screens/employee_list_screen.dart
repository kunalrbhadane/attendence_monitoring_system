import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/features/admin_employee_management/presentation/screens/add_employee_screen.dart';

// A custom widget for the status chip (IN, OUT, On Leave)
class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'in':
        chipColor = AppColors.statusGreen.withOpacity(0.1);
        textColor = AppColors.statusGreen;
        break;
      case 'out':
        chipColor = AppColors.statusRed.withOpacity(0.1);
        textColor = AppColors.statusRed;
        break;
      default:
        chipColor = AppColors.statusOnLeave.withOpacity(0.1);
        textColor = AppColors.statusOnLeave;
    }

    return Chip(
      label: Text(status),
      labelStyle: AppTextStyles.caption.copyWith(color: textColor, fontWeight: FontWeight.bold),
      backgroundColor: chipColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}


class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for the employee list
    final List<Map<String, String>> mockEmployees = [
      {'name': 'John Doe', 'id': 'S1101', 'status': 'IN'},
      {'name': 'Jane Smith', 'id': 'S1102', 'status': 'OUT'},
      {'name': 'Alex Chen', 'id': 'S1101', 'status': 'OUT'},
      {'name': 'Jane Smith', 'id': 'S1102', 'status': 'On Leave'},
      {'name': 'Alex Chen', 'id': 'S1102', 'status': 'On Leave'},
      {'name': 'Rey Tave', 'id': 'S1103', 'status': 'IN'},
    ];
    
    return Scaffold(
      backgroundColor: AppColors.surface, // Matches the design's white background
      appBar: AppBar(
        title: Text("Employee Management", style: AppTextStyles.heading2),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_list_rounded),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Employee List
            Expanded(
              child: ListView.builder(
                itemCount: mockEmployees.length,
                itemBuilder: (context, index) {
                  final employee = mockEmployees[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 1,
                    shadowColor: AppColors.background,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.border,
                        child: Icon(Icons.person, color: AppColors.textSecondary),
                      ),
                      title: Text(employee['name']!, style: AppTextStyles.bodyBold),
                      subtitle: Text("ID: ${employee['id']!}", style: AppTextStyles.caption),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatusChip(status: employee['status']!),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                        ],
                      ),
                      onTap: () {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('Viewing details for ${employee['name']}'))
                         );
                      },
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
          // Navigate to the Add Employee Screen
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
          );
        },
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}