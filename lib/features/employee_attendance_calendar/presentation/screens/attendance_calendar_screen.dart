import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:table_calendar/table_calendar.dart';

// ======================= THE FIX IS HERE =======================
// This line explicitly tells this file where to find `monthlyAttendanceProvider`.
// Without it, the compiler does not know what `monthlyAttendanceProvider` is.
import 'package:attendence_monitoring_system/data/providers/attendance_provider.dart';
// ================================================================

class AttendanceCalendarScreen extends ConsumerStatefulWidget {
  const AttendanceCalendarScreen({super.key});

  @override
  ConsumerState<AttendanceCalendarScreen> createState() =>
      _AttendanceCalendarScreenState();
}

class _AttendanceCalendarScreenState extends ConsumerState<AttendanceCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Present': return AppColors.statusGreen;
      case 'Absent': return AppColors.statusRed;
      case 'OnLeave': return AppColors.statusOnLeave;
      default: return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // This line will now work correctly because of the import statement above.
    final attendanceDataAsync = ref.watch(monthlyAttendanceProvider(_focusedDay));

    return Scaffold(
      appBar: AppBar(
        title: Text("My Attendance Calendar", style: AppTextStyles.heading2),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: attendanceDataAsync.when(
                data: (attendanceMap) {
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
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      titleTextStyle: AppTextStyles.subtitle,
                      formatButtonVisible: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final status = attendanceMap[day.day];
                        final color = _getStatusColor(status);
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
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: AppColors.primaryBlue, width: 2), shape: BoxShape.circle),
                            child: Center(child: Text('${day.day}'))
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
                            child: Center(child: Text('${day.day}', style: const TextStyle(color: Colors.white)))
                           ),
                         );
                      },
                    ),
                  );
                },
                loading: () => const Center(heightFactor: 10, child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Error: $err")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}