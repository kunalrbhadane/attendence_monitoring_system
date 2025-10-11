import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/data/models/attendance_record_model.dart';
import 'package:attendence_monitoring_system/data/providers/attendance_provider.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';
import 'package:attendence_monitoring_system/shared_widgets/secondary_button.dart';
import 'package:attendence_monitoring_system/features/employee_attendance_calendar/presentation/screens/attendance_calendar_screen.dart';
// MODIFIED: Replaced the profile screen import with the leave request screen import.
import 'package:attendence_monitoring_system/features/employee_requests/presentation/screens/request_leave_screen.dart';

// --- MAIN SCREEN ---

/// The main dashboard screen for the employee. It provides an at-a-glance
/// view of their current attendance status and today's activity.
class EmployeeHomeScreen extends ConsumerWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the providers to get the current state of the data (loading, error, or data).
    final statusAsync = ref.watch(employeeStatusProvider);
    final activityAsync = ref.watch(todayActivityProvider);
    // Format the current date for display.
    final String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Text("Welcome, Alex!", style: AppTextStyles.heading1.copyWith(fontSize: 32)),
              const SizedBox(height: 4),
              Text(formattedDate, style: AppTextStyles.subtitle.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
              const SizedBox(height: 32),

              // --- Status Banner ---
              // Use AsyncValue.when to gracefully handle the three possible states of the FutureProvider.
              statusAsync.when(
                data: (statusText) => StatusBanner(statusText: statusText),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error loading status: $err')),
              ),
              
              const SizedBox(height: 32),
              
              Text("Today's Activity", style: AppTextStyles.heading2),
              const SizedBox(height: 16),
              
              // --- Activity Timeline ---
              // Also use AsyncValue.when for the activity data.
              activityAsync.when(
                data: (activities) => Expanded(child: ActivityTimeline(activities: activities)),
                loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
                error: (err, stack) => Center(child: Text('Error loading activities: $err')),
              ),

              const SizedBox(height: 24),

              // --- Action Buttons with Full Navigation ---
              PrimaryButton(
                text: "View My Attendance Calendar", 
                onPressed: () {
                   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AttendanceCalendarScreen())
                  );
                }
              ),
              const SizedBox(height: 12),
              // ======================= MODIFICATION IS HERE =======================
              // The secondary button now directly navigates to the Request Leave screen.
              SecondaryButton(
                text: "Request Leave", 
                onPressed: () {
                   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RequestLeaveScreen())
                  );
                }
              ),
              // ====================================================================
            ],
          ),
        ),
      ),
    );
  }
}

// --- HELPER WIDGETS ---
// These widgets are broken out for readability and reusability. No changes needed here.

/// The green banner showing the employee's current check-in status.
class StatusBanner extends StatelessWidget {
  final String statusText;
  const StatusBanner({super.key, required this.statusText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.statusGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.statusGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5)
          )
        ]
      ),
      child: Text(
        statusText,
        textAlign: TextAlign.center,
        style: AppTextStyles.heading2.copyWith(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

/// The timeline widget that displays IN and OUT events for the day.
class ActivityTimeline extends StatelessWidget {
  final List<AttendanceRecord> activities;
  const ActivityTimeline({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    // Check if there is at least one "IN" event to display.
    final hasCheckedIn = activities.any((a) => a.eventType == AttendanceEventType.inn);
    
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Only display the check-in tile if the mock data for it exists.
        if (hasCheckedIn)
          _buildTimelineTile(
            context: context,
            icon: Icons.check_circle,
            iconColor: AppColors.statusGreen,
            time: DateFormat('hh:mm a').format(activities.first.timestamp),
            subtitle: "IN at Main Entrance",
            isLast: false,
          ),

        // Always show the "Pending OUT" entry to indicate the next expected action.
        _buildTimelineTile(
          context: context,
          icon: Icons.watch_later_outlined,
          iconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          time: "— — : — —",
          subtitle: "Pending OUT",
          isLast: true,
        ),
      ],
    );
  }

  /// A helper method to build a single row in the timeline with the icon, line, and text.
  Widget _buildTimelineTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String time,
    required String subtitle,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The left side with the icon and the connecting line
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 28),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          // The right side with the time and description text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0), // Align text better with the icon
                  child: Text(time, style: AppTextStyles.bodyBold.copyWith(fontSize: 16)),
                ),
                Text(subtitle, style: AppTextStyles.bodyRegular.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                const SizedBox(height: 24), // Vertical space between timeline items
              ],
            ),
          )
        ],
      ),
    );
  }
}