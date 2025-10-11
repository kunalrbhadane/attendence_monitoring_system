import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';


class RequestCorrectionScreen extends StatefulWidget {
  const RequestCorrectionScreen({super.key});

  @override
  State<RequestCorrectionScreen> createState() => _RequestCorrectionScreenState();
}

class _RequestCorrectionScreenState extends State<RequestCorrectionScreen> {
  int _selectedMissedPunch = -1; // -1 for none selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Correction", style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _buildDatePicker(context, "Date of Incident"),
            const SizedBox(height: 24),
            Text("Clock In Time", style: AppTextStyles.subtitle),
            const SizedBox(height: 8),

            // Missed Punch Options
            _buildRadioTile("Clock In Time", 0),
            _buildRadioTile("Clock Out Time", 1),
            _buildRadioTile("Missed Punch", 2),
            const SizedBox(height: 24),

            // Reason Text Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Reason for Correction',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
             const SizedBox(height: 8),
             Text("Required", style: AppTextStyles.caption.copyWith(color: Colors.blueAccent)),
             const SizedBox(height: 32),
             PrimaryButton(text: "Submit Request", onPressed: () {
                 Navigator.of(context).pop();
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Correction request submitted!'))
                );
             })
          ],
        ),
      ),
    );
  }
   
  Widget _buildDatePicker(BuildContext context, String label) {
    return InkWell(
      onTap: () { /* TODO: Implement actual date picker logic */ },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.calendar_month_outlined),
        ),
        child: Text("Select Date", style: AppTextStyles.bodyRegular.copyWith(fontSize: 16, color: Theme.of(context).hintColor)),
      ),
    );
  }

  Widget _buildRadioTile(String title, int value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: RadioListTile<int>(
        title: Text(title, style: AppTextStyles.bodyRegular),
        subtitle: const Text("Missed Punch"),
        value: value,
        groupValue: _selectedMissedPunch,
        onChanged: (newValue) {
          setState(() => _selectedMissedPunch = newValue!);
        },
      ),
    );
  }
}