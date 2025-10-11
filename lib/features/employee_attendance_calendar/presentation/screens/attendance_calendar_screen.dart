import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/data/providers/attendance_provider.dart';
import 'package:table_calendar/table_calendar.dart';

// A small data class to hold the calculated stats for a month.
class MonthStats {
  final int presentDays;
  final int leaveDays;
  MonthStats({this.presentDays = 0, this.leaveDays = 0});
}

/// A provider to calculate summary stats for the current and previous months.
final monthlyStatsProvider = FutureProvider.autoDispose.family<({MonthStats current, MonthStats previous}), DateTime>((ref, focusedDay) async {
  
  MonthStats calculateStats(Map<int, String> attendanceMap) {
    int present = 0;
    int leave = 0;
    for (var status in attendanceMap.values) {
      if (status == 'Present') present++;
      else if (status == 'OnLeave' || status == 'ShortLeave') leave++;
    }
    return MonthStats(presentDays: present, leaveDays: leave);
  }

  final currentMonthData = await ref.watch(monthlyAttendanceProvider(focusedDay).future);
  final currentStats = calculateStats(currentMonthData);

  final previousMonthDate = DateTime(focusedDay.year, focusedDay.month - 1, 1);
  final previousMonthData = await ref.watch(monthlyAttendanceProvider(previousMonthDate).future);
  final previousStats = calculateStats(previousMonthData);

  return (current: currentStats, previous: previousStats);
});


class AttendanceCalendarScreen extends ConsumerStatefulWidget {
  const AttendanceCalendarScreen({super.key});

  @override
  ConsumerState<AttendanceCalendarScreen> createState() =>
      _AttendanceCalendarScreenState();
}

class _AttendanceCalendarScreenState
    extends ConsumerState<AttendanceCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// Helper to get the display color for all four attendance statuses.
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Present': return AppColors.statusGreen;
      case 'Absent': return AppColors.statusRed;
      case 'OnLeave': return AppColors.statusOnLeave;
      case 'ShortLeave': return AppColors.statusYellow;
      default: return Colors.transparent;
    }
  }
  
  /// Helper to get styling for the dialog for all four statuses.
  ({Color color, IconData icon, String title}) _getDialogDetails(String status) {
    switch(status) {
      case 'Present': return (color: AppColors.statusGreen, icon: Icons.check_circle_outline, title: 'Present');
      case 'Absent': return (color: AppColors.statusRed, icon: Icons.highlight_off, title: 'Absent');
      case 'OnLeave': return (color: AppColors.statusOnLeave, icon: Icons.beach_access_outlined, title: 'On Leave');
      case 'ShortLeave': return (color: AppColors.statusYellow, icon: Icons.watch_later_outlined, title: 'Short Leave');
      default: return (color: Colors.grey, icon: Icons.help_outline, title: 'Unknown');
    }
  }

  /// The interactive dialog that shows details for a tapped day.
  void _showAttendanceDialog(DateTime day, String? status) {
     if (status == null) return;
    final details = _getDialogDetails(status);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(DateFormat('EEEE, MMMM d').format(day), style: AppTextStyles.subtitle),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(details.icon, color: details.color, size: 50),
          const SizedBox(height: 16),
          Text(details.title, style: AppTextStyles.heading2.copyWith(color: details.color)),
        ]),
        actionsAlignment: MainAxisAlignment.center,
        actions: [ TextButton(child: const Text('CLOSE'), onPressed: () => Navigator.of(context).pop()) ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendanceDataAsync = ref.watch(monthlyAttendanceProvider(_focusedDay));

    return Scaffold(
      appBar: AppBar(
        title: Text("My Attendance Calendar", style: AppTextStyles.heading2),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: attendanceDataAsync.when(
                data: (attendanceMap) {
                  // ======================= THE FIX IS HERE =======================
                  // The full implementation of the TableCalendar widget has been restored.
                  return TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.now(),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _showAttendanceDialog(selectedDay, attendanceMap[selectedDay.day]);
                    },
                    onPageChanged: (focusedDay) {
                      setState(() { _focusedDay = focusedDay; });
                    },
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      titleTextStyle: AppTextStyles.subtitle,
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(Icons.chevron_left, color: theme.iconTheme.color),
                      rightChevronIcon: Icon(Icons.chevron_right, color: theme.iconTheme.color),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final status = attendanceMap[day.day];
                        final color = _getStatusColor(status); // Correctly referenced
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          child: Center(
                            child: Text('${day.day}', style: TextStyle(color: color != Colors.transparent ? Colors.white : theme.colorScheme.onSurface)),
                          ),
                        );
                      },
                      todayBuilder: (context, day, focusedDay) {
                         final status = attendanceMap[day.day];
                         final color = _getStatusColor(status);
                         return Center(
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(color: AppColors.primaryBlue, width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('${day.day}', style: TextStyle(color: color != Colors.transparent ? Colors.white : theme.colorScheme.onSurface))),
                          ),
                        );
                      },
                       selectedBuilder: (context, day, focusedDay) {
                        final status = attendanceMap[day.day];
                        final color = _getStatusColor(status);
                         return Center(
                           child: Container(
                             margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.5), width: 3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('${day.day}', style: TextStyle(color: Colors.white)))
                           ),
                         );
                      },
                    ),
                  );
                  // ====================================================================
                },
                loading: () => const Center(heightFactor: 10, child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Error: $err")),
              ),
            ),
            
            const SizedBox(height: 24),
            MonthlySummarySection(focusedDay: _focusedDay),

          ],
        ),
      ),
    );
  }
}

/// A self-contained widget to display the monthly attendance summary.
class MonthlySummarySection extends ConsumerWidget {
  final DateTime focusedDay;
  const MonthlySummarySection({super.key, required this.focusedDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(monthlyStatsProvider(focusedDay));
    final previousMonthDate = DateTime(focusedDay.year, focusedDay.month - 1, 1);
    
    return statsAsync.when(
      data: (stats) {
        return Row(
          children: [
            Expanded(child: _buildStatCard(context, title: "${DateFormat.yMMM().format(focusedDay)} Summary", presentDays: stats.current.presentDays, leaveDays: stats.current.leaveDays)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(context, title: "${DateFormat.yMMM().format(previousMonthDate)} Summary", presentDays: stats.previous.presentDays, leaveDays: stats.previous.leaveDays)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e,s) => const Center(child: Text("Could not load summary.")),
    );
  }

  Widget _buildStatCard(BuildContext context, {required String title, required int presentDays, required int leaveDays}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.dividerColor, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodyBold.copyWith(fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Present", style: AppTextStyles.bodyRegular),
              Text(presentDays.toString(), style: AppTextStyles.bodyBold.copyWith(color: AppColors.statusGreen)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Leave", style: AppTextStyles.bodyRegular),
              Text(leaveDays.toString(), style: AppTextStyles.bodyBold.copyWith(color: AppColors.statusOnLeave)),
            ],
          ),
        ],
      ),
    );
  }
}