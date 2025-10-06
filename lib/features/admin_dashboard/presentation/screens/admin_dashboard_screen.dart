import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/features/admin_request_management/presentation/screens/request_management_screen.dart';
import 'package:attendence_monitoring_system/features/admin_reports/presentation/screens/reports_analytics_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// --- WIDGETS ---
// These self-contained helper widgets are part of this file for convenience.

/// A highly flexible card to show Key Performance Indicators without overflowing.
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;

  const KpiCard({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          const Spacer(), // Pushes the bottom row down
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // MODIFIED: Reduced font size of the digit for better flexibility.
              Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 24, height: 1.0)),
              icon,
            ],
          ),
        ],
      ),
    );
  }
}

/// A tile for the live status feed, styled to match the design.
class LiveStatusTile extends StatelessWidget {
  final String name;
  final String time;
  final bool isIn;

  const LiveStatusTile({super.key, required this.name, required this.time, required this.isIn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.background,
            child: Icon(Icons.person, size: 22, color: AppColors.textSecondary),
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
              color: isIn ? AppColors.statusGreen.withOpacity(0.15) : AppColors.statusRed.withOpacity(0.15),
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


/// The main Admin Dashboard screen, re-engineered for a fully flexible, pixel-perfect layout.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Matches the format in the provided image: "Monday, October 6"
    final String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              const SizedBox(height: 16),
              Text("Good Morning,", style: AppTextStyles.heading1),
              Text("Sarah!", style: AppTextStyles.heading1.copyWith(color: AppColors.primaryBlue)),
              const SizedBox(height: 5),
              Text(formattedDate, style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 16),

              // --- KPI Section ---
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Expanded(child: KpiCard(title: 'Total\nPresent', value: '452', icon: Icon(Icons.arrow_upward_rounded, color: AppColors.statusGreen))),
                          SizedBox(width: 12),
                          Expanded(child: KpiCard(title: 'Absent', value: '18', icon: Icon(Icons.arrow_downward_rounded, color: AppColors.statusRed))),
                          SizedBox(width: 12),
                          Expanded(child: KpiCard(title: 'On Leave', value: '35', icon: Icon(Icons.arrow_downward_rounded, color: AppColors.statusRed))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(child: KpiCard(title: 'Late\nArrivals', value: '12', icon: Icon(Icons.watch_later_outlined, color: AppColors.statusYellow))),
                          const SizedBox(width: 12),
                          const Expanded(child: KpiCard(title: 'Pending\nReq.', value: '7', icon: Icon(Icons.notifications_active_rounded, color: AppColors.secondaryOrange))),
                          Expanded(child: Container()), // Empty Expanded for alignment
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Main Content Section ---
              Expanded(
                flex: 6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Live Status Feed ---
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Live Status Feed', style: AppTextStyles.bodyBold),
                          const SizedBox(height: 8),
                          const LiveStatusTile(name: 'John Doe', time: '09:25 AM', isIn: true),
                          const LiveStatusTile(name: 'Jane Smith', time: '09:20 AM', isIn: true),
                          const LiveStatusTile(name: 'Alex Chen', time: '09:18 AM', isIn: true),
                          const LiveStatusTile(name: 'Jane Smith', time: '09:15 AM', isIn: false),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // --- Attendance Overview Card ---
                    Expanded(
                      flex: 5,
                      child: _buildAttendanceOverview(context),
                    ),
                  ],
                ),
              ),
               const SizedBox(height: 16), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the right-side overview card. Uses a Stack for the chart.
  Widget _buildAttendanceOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attendance Overview', style: AppTextStyles.bodyBold),
          const Spacer(flex: 2),
          Center(
            // MODIFIED: Using a Stack to place the percentage in the center.
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 110, // Slightly larger to accommodate center text
                  width: 110,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      startDegreeOffset: -90,
                      sections: [
                        // The title property is set to '' so text does not appear on the slice.
                        PieChartSectionData(color: AppColors.primaryBlue, value: 88, title: '', radius: 20),
                        PieChartSectionData(color: AppColors.statusRed, value: 12, title: '', radius: 20),
                      ],
                    ),
                  ),
                ),
                // MODIFIED: This Text widget is placed in the center of the Stack.
                Text(
                  '88%', 
                  style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)
                ),
              ],
            ),
          ),
          const Spacer(flex: 3),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReportsAnalyticsScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text('Generate Report', style: AppTextStyles.button.copyWith(fontSize: 14)),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RequestManagementScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDarkBlue,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text('Manage Requests', style: AppTextStyles.button.copyWith(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}