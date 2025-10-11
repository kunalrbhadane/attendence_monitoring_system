import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/data/models/attendance_record_model.dart';
import 'package:attendence_monitoring_system/data/providers/attendance_provider.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';
import 'package:attendence_monitoring_system/shared_widgets/secondary_button.dart';
// MODIFIED: Added imports for navigation
import 'package:attendence_monitoring_system/features/employee_attendance_calendar/presentation/screens/attendance_calendar_screen.dart';
import 'package:attendence_monitoring_system/features/employee_requests/presentation/screens/request_correction_screen.dart';


class EmployeeHomeScreen extends ConsumerWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(employeeStatusProvider);
    final activityAsync = ref.watch(todayActivityProvider);
    final String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome, Alex!", style: AppTextStyles.heading1.copyWith(fontSize: 32)),
              const SizedBox(height: 4),
              Text(formattedDate, style: AppTextStyles.subtitle.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
              const SizedBox(height: 32),

              statusAsync.when(
                data: (statusText) => StatusBanner(statusText: statusText),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
              
              const SizedBox(height: 32),
              
              Text("Today's Activity", style: AppTextStyles.heading2),
              const SizedBox(height: 16),
              
              activityAsync.when(
                data: (activities) => Expanded(child: ActivityTimeline(activities: activities)),
                loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),

              const SizedBox(height: 24),

              // MODIFIED: Button navigation implemented
              PrimaryButton(
                text: "View My Attendance Calendar", 
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AttendanceCalendarScreen())
                  );
                }
              ),
              const SizedBox(height: 12),
              // MODIFIED: Button navigation implemented
              SecondaryButton(
                text: "Request Correction", 
                onPressed: () {
                   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RequestCorrectionScreen())
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- HELPER WIDGETS ---
// (No changes needed for StatusBanner or ActivityTimeline, they are included for completeness)

/// The green banner showing the current check-in status.
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
      ),
      child: Text(
        statusText,
        textAlign: TextAlign.center,
        style: AppTextStyles.heading2.copyWith(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

/// The timeline widget that displays IN and OUT events.
class ActivityTimeline extends StatelessWidget {
  final List<AttendanceRecord> activities;
  const ActivityTimeline({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final hasCheckedIn = activities.any((a) => a.eventType == AttendanceEventType.inn);
    
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (hasCheckedIn)
          _buildTimelineTile(
            context: context,
            icon: Icons.check_circle,
            iconColor: AppColors.statusGreen,
            time: DateFormat('hh:mm a').format(activities.first.timestamp),
            subtitle: "IN at Main Entrance",
            isLast: false,
          ),

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
          Column(
            children: [
              Icon(icon, color: iconColor, size: 28),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: AppTextStyles.bodyBold.copyWith(fontSize: 16)),
                Text(subtitle, style: AppTextStyles.bodyRegular.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                const SizedBox(height: 24),
              ],
            ),
          )
        ],
      ),
    );
  }
}