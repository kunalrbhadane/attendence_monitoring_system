import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';

class RequestListTile extends StatelessWidget {
  final String name;
  final String date;
  final String reason;
  final String type;

  // MODIFIED: Removed const
  const RequestListTile({
    super.key,
    required this.name,
    required this.date,
    required this.reason,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card( // Card now uses theme defaults
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  Text(name, style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  Text("Type: $type", style: AppTextStyles.caption),
                  Text("Date: $date", style: AppTextStyles.caption),
                  Text("Reason: $reason", style: AppTextStyles.caption.copyWith(color: AppColors.primaryBlue), overflow: TextOverflow.ellipsis, maxLines: 1),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () { /* ... */ },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.statusRed,
                backgroundColor: AppColors.statusRed.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Deny'),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestManagementScreen extends StatelessWidget {
  // MODIFIED: Removed const
  const RequestManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Request Management"),
          bottom: TabBar(
            // TabBar indicator color now uses theme's primary color
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            labelStyle: AppTextStyles.bodyBold,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: "Leave Requests"),
              Tab(text: "Correction Requests"),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TabBarView(
            children: [
              ListView(
                children: const [
                   RequestListTile(name: 'Jane Smith', type: 'Casual Leave', date: 'Oct 20-22', reason: 'Family vacation trip...'),
                   RequestListTile(name: 'John Doe', type: 'Paid Leave', date: 'Nov 01-02', reason: 'Personal leave'),
                ],
              ),
              ListView(
                children: const [
                  RequestListTile(name: 'Rey Tave', type: 'Missed Punch', date: 'Oct 26', reason: 'Forgot to clock out yesterday'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}