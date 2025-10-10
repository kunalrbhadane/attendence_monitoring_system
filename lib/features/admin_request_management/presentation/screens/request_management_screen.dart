import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';

// --- Data Model ---
// A simple model for the leave request data.
class LeaveRequest {
  final String name;
  final String date;
  final String reason;

  LeaveRequest({required this.name, required this.date, required this.reason});
}

// --- WIDGETS ---

/// A theme-aware list tile for a pending leave request, with callbacks for actions.
class LeaveRequestTile extends StatelessWidget {
  final LeaveRequest request;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  const LeaveRequestTile({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.background,
              child: Icon(Icons.person, size: 28, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(request.name, style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  Text("Date: ${request.date}", style: AppTextStyles.caption),
                  Text(
                    "Reason: ${request.reason}",
                    style: AppTextStyles.caption.copyWith(color: AppColors.primaryBlue),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            // Action buttons
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 32, // Constrain button height
                  child: TextButton(
                    onPressed: onApprove,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.statusGreen,
                      backgroundColor: AppColors.statusGreen.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 32,
                  child: TextButton(
                    onPressed: onDeny,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.statusRed,
                      backgroundColor: AppColors.statusRed.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Deny'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// The main screen for managing leave requests, now simplified and fully functional.
class RequestManagementScreen extends StatefulWidget {
  const RequestManagementScreen({super.key});

  @override
  State<RequestManagementScreen> createState() => _RequestManagementScreenState();
}

class _RequestManagementScreenState extends State<RequestManagementScreen> {
  // --- STATE MANAGEMENT ---

  // Mock database for leave requests only
  late List<LeaveRequest> _leaveRequests;

  @override
  void initState() {
    super.initState();
    // Initialize the state with our mock data
    _leaveRequests = [
      LeaveRequest(name: 'Jane Smith', date: 'Oct 20-22', reason: 'Family vacation trip...'),
      LeaveRequest(name: 'John Doe', date: 'Nov 01-02', reason: 'Personal leave'),
      LeaveRequest(name: 'Alex Chen', date: 'Oct 25', reason: 'Medical appointment'),
    ];
  }
  
  // --- FUNCTIONALITY ---

  void _handleRequest(LeaveRequest request, bool isApproved) {
    setState(() {
      // Remove the item from the list. Using a unique property like the
      // object reference itself is the most reliable way to remove it.
      _leaveRequests.remove(request);
    });

    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Request from ${request.name} has been ${isApproved ? 'approved' : 'denied'}."),
        backgroundColor: isApproved ? AppColors.statusGreen : AppColors.statusRed,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // No TabController is needed anymore.
    return Scaffold(
      appBar: AppBar(
        // The title is now more specific.
        title: const Text("Leave Requests"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        // Display the list of requests, or a message if the list is empty.
        child: _leaveRequests.isEmpty
            ? Center(
                child: Text(
                  "No pending leave requests.",
                  style: AppTextStyles.subtitle.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                ),
              )
            : ListView.builder(
                itemCount: _leaveRequests.length,
                itemBuilder: (context, index) {
                  final request = _leaveRequests[index];
                  return LeaveRequestTile(
                    request: request,
                    // Pass the handling functions down to the tile
                    onApprove: () => _handleRequest(request, true),
                    onDeny: () => _handleRequest(request, false),
                  );
                },
              ),
      ),
    );
  }
}