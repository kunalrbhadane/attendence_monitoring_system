import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';

/// A fully functional form for employees to request time off (leave).
class RequestLeaveScreen extends StatefulWidget {
  const RequestLeaveScreen({super.key});

  @override
  State<RequestLeaveScreen> createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeaveScreen> {
  // --- STATE MANAGEMENT ---
  final _formKey = GlobalKey<FormState>();
  String _selectedLeaveType = 'Casual Leave';
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _formatter = DateFormat('MMM dd, yyyy');
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  /// Shows a date picker dialog and updates the corresponding state variable.
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final now = DateTime.now();
    // The first selectable date should be today for start dates,
    // or the chosen start date for end dates.
    final firstDate = isStartDate ? now : (_startDate ?? now);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1), // Allow selection up to one year in the future.
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // If the type is "Short Leave", the end date must match the start date.
          if (_selectedLeaveType == 'Short Leave') {
            _endDate = picked;
          }
          // If the user changes the start date to be after the current end date,
          // reset the end date to force re-selection.
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }
  
  /// Validates the form and performs the mock submission.
  void _submitRequest() {
    // Also check if dates are selected, as FormField validation doesn't cover this.
    if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Please select a start and end date.'), backgroundColor: Colors.redAccent)
       );
       return;
    }
    
    if (_formKey.currentState!.validate()) {
       Navigator.of(context).pop();
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Leave request submitted successfully! (Mock)'))
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the end date field should be disabled.
    final bool isEndDateDisabled = _selectedLeaveType == 'Short Leave';

    return Scaffold(
      appBar: AppBar(
        title: Text("Request Leave", style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Leave Type Dropdown ---
              DropdownButtonFormField<String>(
                value: _selectedLeaveType,
                decoration: InputDecoration(
                  labelText: 'Leave Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                // "Short Leave" is now an option.
                items: ['Casual Leave', 'Paid Leave', 'Short Leave', 'Unpaid Leave'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLeaveType = newValue;
                       // If the user selects "Short Leave" and a start date is already picked,
                       // automatically set the end date to match.
                       if (newValue == 'Short Leave' && _startDate != null) {
                        _endDate = _startDate;
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              
              // --- Fully Functional Date Pickers ---
              _buildDatePicker(context, "Start Date", _startDate, () => _selectDate(context, true)),
              const SizedBox(height: 20),
              // The End Date picker is visually and functionally disabled for Short Leave.
              _buildDatePicker(context, "End Date", _endDate, () => _selectDate(context, false),
                  isDisabled: isEndDateDisabled),

              const SizedBox(height: 20),
              
              // --- Reason Text Field with Validation ---
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason for Leave',
                  hintText: 'Explain your reason here...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please provide a reason' : null,
              ),
              const SizedBox(height: 32),
              PrimaryButton(text: 'Submit Request', onPressed: _submitRequest),
            ],
          ),
        ),
      ),
    );
  }

  /// A rebuilt helper widget for rendering date picker fields, now with a disabled state.
  Widget _buildDatePicker(BuildContext context, String label, DateTime? date, VoidCallback onTap, {bool isDisabled = false}) {
    String displayText = date != null ? _formatter.format(date) : "Select Date";
    
    // Use InkWell to make the whole field tappable.
    return InkWell(
      onTap: isDisabled ? null : onTap, // If disabled, onTap is null.
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.calendar_month_outlined),
          // Visually indicate the disabled state.
          filled: isDisabled,
          fillColor: isDisabled ? Colors.grey.shade200 : Colors.transparent,
        ),
        child: Text(
          displayText, 
          style: AppTextStyles.bodyRegular.copyWith(
            fontSize: 16,
            color: isDisabled ? Colors.grey.shade700 : Theme.of(context).colorScheme.onSurface,
          )
        ),
      ),
    );
  }
}