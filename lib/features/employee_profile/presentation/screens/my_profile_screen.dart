import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/data/models/leave_request_model.dart';
import 'package:attendence_monitoring_system/data/providers/request_provider.dart';
import 'package:attendence_monitoring_system/features/admin_auth/presentation/screens/login_screen.dart';

/// The main profile screen for the employee.
/// Displays user information, profile actions, and a list of recent leave requests.
class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the list of leave requests.
    final leaveRequestsAsync = ref.watch(leaveRequestsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile", style: AppTextStyles.heading2),
        automaticallyImplyLeading: false,
      ),
      // This main Column separates the scrollable content from the fixed logout button.
      body: Column(
        children: [
          // Expanded takes all available vertical space, pushing the logout button down.
          Expanded(
            // SingleChildScrollView ensures the content inside can scroll if needed
            // on smaller screens, without affecting the logout button's position.
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- User Info & Profile Buttons ---
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFE8E8E8),
                    child: Icon(Icons.person, size: 50, color: Color(0xFFB0B0B0)),
                  ),
                  const SizedBox(height: 12),
                  Text("Alex Smith", style: AppTextStyles.heading2, textAlign: TextAlign.center),
                  Text("#EID-001", style: AppTextStyles.subtitle.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  
                  _buildProfileButton(context, "Edit Personal Info", Icons.edit_outlined),
                  // The "Change Password" button has been re-added as requested.
                  _buildProfileButton(context, "Change Password", Icons.lock_outline_rounded),
                  
                  // --- ENHANCED: Recent Leave Requests List ---
                  const SizedBox(height: 24),
                  Text("Recent Leave Requests", style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Use .when() to handle loading, error, and data states from the provider.
                  leaveRequestsAsync.when(
                    data: (requests) {
                      if (requests.isEmpty) {
                        return const Center(heightFactor: 5, child: Text("No leave requests found."));
                      }
                      // Using a Column here is efficient as we're already in a scrollable view.
                      return Column(
                        children: requests.map((req) => LeaveRequestListTile(request: req)).toList(),
                      );
                    },
                    loading: () => const Center(heightFactor: 5, child: CircularProgressIndicator()),
                    error: (e, s) => const Center(heightFactor: 5, child: Text("Could not load requests.")),
                  ),
                ],
              ),
            ),
          ),
          
          // --- Logout Button (Positioned correctly outside the scrolling content) ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusRed, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16)
                ),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c) => const LoginScreen()), (r) => false), 
                child: Text("Logout", style: AppTextStyles.button),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper for creating styled, tappable list-like buttons for profile actions.
  Widget _buildProfileButton(BuildContext context, String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor, width: 0.8)
      ),
      child: ListTile(
        leading: Icon(icon, size: 22),
        title: Text(title, style: AppTextStyles.bodyBold.copyWith(fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, size: 22),
        onTap: () {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title feature coming soon!")));
        },
      ),
    );
  }
}

// --- HELPER WIDGET ---

/// A dedicated widget to display a single leave request in a styled list format.
class LeaveRequestListTile extends StatelessWidget {
  final LeaveRequest request;
  const LeaveRequestListTile({super.key, required this.request});
  
  /// Helper to get the correct color and display text based on the request's status.
  ({Color color, String text}) _getStatusStyle() {
    switch(request.status) {
      case RequestStatus.approved: return (color: AppColors.statusGreen, text: 'Approved');
      case RequestStatus.pending: return (color: AppColors.statusYellow, text: 'Pending');
      case RequestStatus.denied: return (color: AppColors.statusRed, text: 'Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusStyle = _getStatusStyle();
    // Format the date range for display.
    final formattedDate = "${DateFormat('MMM d, yyyy').format(request.startDate)} - ${DateFormat('MMM d, yyyy').format(request.endDate)}";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(request.leaveType, style: AppTextStyles.bodyBold),
                // The colored status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: statusStyle.color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(statusStyle.text, style: AppTextStyles.caption.copyWith(color: statusStyle.color, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(formattedDate, style: AppTextStyles.bodyRegular.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8))),
            const SizedBox(height: 4),
            // Display the reason, truncating it if it's too long.
            Text("Reason: ${request.reason}", style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}