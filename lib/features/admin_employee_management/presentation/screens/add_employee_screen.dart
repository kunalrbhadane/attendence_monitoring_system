import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';

class AddEmployeeScreen extends StatefulWidget {
  // MODIFIED: Removed const
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  String? _selectedRole = 'Employee';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Employee"),
        // The back arrow is automatically added and themed
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Form Fields (now inherit style from theme) ---
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Employee ID (Auto-generated)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  // Use a theme-aware color
                  fillColor: theme.scaffoldBackgroundColor.withAlpha(180),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: <String>['Admin', 'Employee']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
              ),
              const SizedBox(height: 32),
              // --- Action Button ---
              PrimaryButton(
                text: 'Generate Invite Code & Add', 
                onPressed: () {
                   Navigator.of(context).pop();
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                        content: Text('Employee added successfully! (Mock)'),
                        backgroundColor: AppColors.statusGreen,
                      )
                   );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}