import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';

/// A form for employees to request time off.
class RequestLeaveScreen extends StatefulWidget {
  const RequestLeaveScreen({super.key});

  @override
  State<RequestLeaveScreen> createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeaveScreen> {
  String _selectedLeaveType = 'Casual Leave';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Leave", style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sign in on your account", style: AppTextStyles.subtitle.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
            const SizedBox(height: 24),
            
            // Leave Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedLeaveType,
              decoration: InputDecoration(
                labelText: 'Leave Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ['Casual Leave', 'Paid Leave', 'Unpaid Leave'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLeaveType = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            
            // Date Pickers
            _buildDatePicker(context, "Start Date", "20 M Dabre"), // Mock data
            const SizedBox(height: 20),
            _buildDatePicker(context, "End Date", "20 M Dabre"), // Mock data
            const SizedBox(height: 20),

            // Reason Text Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Reason for Leave',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Submit Request', 
              onPressed: () {
                // Mock submission logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Leave request submitted successfully!'))
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, String value) {
    return InkWell(
      onTap: () {
        // TODO: Implement actual date picker logic
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.calendar_month_outlined),
        ),
        child: Text(value, style: AppTextStyles.bodyRegular.copyWith(fontSize: 16)),
      ),
    );
  }
}