import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/features/admin_request_management/presentation/screens/request_management_screen.dart';
import 'package:attendence_monitoring_system/features/admin_reports/presentation/screens/reports_analytics_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// --- WIDGETS ---
// These helper widgets are self-contained, theme-aware, and pixel-perfect.

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;

  KpiCard({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.heading1.copyWith(fontSize: 24, height: 1.0),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 4),
              icon,
            ],
          ),
        ],
      ),
    );
  }
}

class LiveStatusTile extends StatelessWidget {
  final String name;
  final String time;
  final bool isIn;

  LiveStatusTile({super.key, required this.name, required this.time, required this.isIn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Icon(Icons.person, size: 22, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyBold),
                Text(time, style: AppTextStyles.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isIn ? AppColors.statusGreen.withAlpha(38) : AppColors.statusRed.withAlpha(38),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isIn ? 'IN' : 'OUT',
              style: AppTextStyles.caption.copyWith(
                color: isIn ? AppColors.statusGreen : AppColors.statusRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The final, perfected Admin Dashboard screen with a scrollable Live Status Feed.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text("Good Morning,", style: AppTextStyles.heading1),
              Text("Sarah!", style: AppTextStyles.heading1.copyWith(color: AppColors.primaryBlue)),
              const SizedBox(height: 4),
              Text(formattedDate, style: AppTextStyles.subtitle.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
              const SizedBox(height: 16),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: KpiCard(title: 'Total\nPresent', value: '452', icon: const Icon(Icons.arrow_upward_rounded, color: AppColors.statusGreen))),
                          const SizedBox(width: 12),
                          Expanded(child: KpiCard(title: 'Absent', value: '18', icon: const Icon(Icons.arrow_downward_rounded, color: AppColors.statusRed))),
                          const SizedBox(width: 12),
                          Expanded(child: KpiCard(title: 'On Leave', value: '35', icon: const Icon(Icons.arrow_downward_rounded, color: AppColors.statusRed))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: KpiCard(title: 'Late\nArrivals', value: '12', icon: const Icon(Icons.watch_later_outlined, color: AppColors.statusYellow))),
                          const SizedBox(width: 12),
                          Expanded(child: KpiCard(title: 'Pending\nReq.', value: '7', icon: const Icon(Icons.notifications_active_rounded, color: AppColors.notificationBell))),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Live Status Feed', style: AppTextStyles.bodyBold),
                          const SizedBox(height: 8),
                          // MODIFIED: The list of tiles is now wrapped in an Expanded
                          // widget and a ListView to make it scrollable.
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero, // Remove any default padding
                              children: [
                                LiveStatusTile(name: 'John Doe', time: '09:25 AM', isIn: true),
                                LiveStatusTile(name: 'Jane Smith', time: '09:20 AM', isIn: true),
                                LiveStatusTile(name: 'Alex Chen', time: '09:18 AM', isIn: true),
                                LiveStatusTile(name: 'Maria Garcia', time: '09:15 AM', isIn: false),
                                LiveStatusTile(name: 'David Lee', time: '09:12 AM', isIn: true),
                                LiveStatusTile(name: 'Emily Ray', time: '09:10 AM', isIn: true),
                                LiveStatusTile(name: 'Kevin Hart', time: '09:05 AM', isIn: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: _buildAttendanceOverview(context),
                    ),
                  ],
                ),
              ),
               const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attendance Overview', style: AppTextStyles.bodyBold),
          const Spacer(flex: 2),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 110,
                  width: 110,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(color: AppColors.primaryBlue, value: 88, title: '', radius: 20),
                        PieChartSectionData(color: const Color.fromARGB(255, 164, 13, 88), value: 12, title: '', radius: 20),
                      ],
                    ),
                  ),
                ),
                Text('88%', style: AppTextStyles.heading2),
              ],
            ),
          ),
          const Spacer(flex: 3),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReportsAnalyticsScreen())),
            child: Text('Generate Report', style: AppTextStyles.button.copyWith(fontSize: 14)),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDarkBlue),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RequestManagementScreen())),
            child: Text('Manage Requests', style: AppTextStyles.button.copyWith(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}