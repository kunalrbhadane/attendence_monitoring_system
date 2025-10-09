import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';

/// A form screen for an Admin to edit their profile details.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Use controllers to pre-fill with existing user data
  final _nameController = TextEditingController(text: "HT");
  final _emailController = TextEditingController(text: "heuristictechnopark@company.com");

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Save Changes', 
                onPressed: () {
                   Navigator.of(context).pop(); // Go back to settings
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Profile updated successfully! (Mock)'))
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