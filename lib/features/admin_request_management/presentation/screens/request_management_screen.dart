import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';

// Custom widget for a request item in the list
class RequestListTile extends StatelessWidget {
  final String name;
  final String date;
  final String reason;
  const RequestListTile({super.key, required this.name, required this.date, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.5,
      shadowColor: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.border,
              child: Icon(Icons.person, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  Text("Date: $date", style: AppTextStyles.caption),
                  Text("Reason: $reason", style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                backgroundColor: AppColors.border.withOpacity(0.5)
              ),
              child: const Text('Deny'),
            )
          ],
        ),
      ),
    );
  }
}


class RequestManagementScreen extends StatelessWidget {
  const RequestManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text("Request Management", style: AppTextStyles.heading2),
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          bottom: TabBar(
            indicatorColor: AppColors.primaryBlue,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTextStyles.bodyBold,
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
              // --- Leave Requests Tab ---
              ListView(
                children: const [
                   RequestListTile(name: 'Jane Smith', date: 'Oct 20-22', reason: 'Family vacation trip...'),
                   RequestListTile(name: 'John Doe', date: 'Nov 01-02', reason: 'Personal leave'),
                   RequestListTile(name: 'Alex Chen', date: 'Oct 25', reason: 'Medical appointment'),
                ],
              ),
              // --- Correction Requests Tab ---
              ListView(
                children: const [
                  RequestListTile(name: 'Rey Tave', date: 'Oct 26', reason: 'Forgot to clock out'),
                  RequestListTile(name: 'Jane Smith', date: 'Oct 25', reason: 'Clocked in late due to traffic'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}