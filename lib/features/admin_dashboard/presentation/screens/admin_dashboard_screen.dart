import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/features/admin_request_management/presentation/screens/request_management_screen.dart';
import 'package:attendence_monitoring_system/features/admin_reports/presentation/screens/reports_analytics_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// A card to show Key Performance Indicators
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;
  const KpiCard({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // CORRECTED: Used a constant color for shadow
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: AppTextStyles.heading2),
              icon,
            ],
          ),
        ],
      ),
    );
  }
}

// A tile for the live status feed
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
            backgroundColor: AppColors.border,
            child: Icon(Icons.person, color: AppColors.textSecondary),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isIn ? AppColors.statusGreen.withOpacity(0.1) : AppColors.statusRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isIn ? 'IN' : 'OUT',
              style: AppTextStyles.caption.copyWith(
                color: isIn ? AppColors.statusGreen : AppColors.statusRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Text(
                "Good Morning, Sarah!",
                style: AppTextStyles.heading1.copyWith(color: AppColors.primaryBlue),
              ),
              Text(
                formattedDate,
                style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              
              // --- KPI Grid ---
              // CORRECTED: Removed the 'const' from Wrap
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: const [
                  KpiCard(title: 'Total Present', value: '452', icon: Icon(Icons.arrow_upward_rounded, color: AppColors.statusGreen)),
                  KpiCard(title: 'Absent', value: '18', icon: Icon(Icons.arrow_downward_rounded, color: AppColors.statusRed)),
                  KpiCard(title: 'On Leave', value: '35', icon: Icon(Icons.arrow_downward_rounded, color: AppColors.statusRed)),
                  // CORRECTED: Icon name changed to watch_later_outlined
                  KpiCard(title: 'Late Arrivals', value: '12', icon: Icon(Icons.watch_later_outlined, color: AppColors.statusYellow)),
                  KpiCard(title: 'Pending Requests', value: '7', icon: Icon(Icons.notifications_active_rounded, color: AppColors.secondaryOrange)),
                ],
              ),
              const SizedBox(height: 24),

              // --- Live Feed & Overview Section ---
              LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 600; // Example breakpoint for wider screens
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildLiveStatusFeed()),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: _buildAttendanceOverview(context)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildLiveStatusFeed(),
                        const SizedBox(height: 16),
                        _buildAttendanceOverview(context),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for Live Status Feed
  Widget _buildLiveStatusFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Live Status Feed', style: AppTextStyles.bodyBold),
        const SizedBox(height: 8),
        const LiveStatusTile(name: 'John Doe', time: '09:25 AM', isIn: true),
        const LiveStatusTile(name: 'Jane Smith', time: '09:20 AM', isIn: true),
        const LiveStatusTile(name: 'Alex Chen', time: '09:18 AM', isIn: true),
        const LiveStatusTile(name: 'Jane Smith', time: '09:15 AM', isIn: false),
        const LiveStatusTile(name: 'John Doe', time: '09:12 AM', isIn: true),
      ],
    );
  }
  
  // Helper method for Attendance Overview card
  Widget _buildAttendanceOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('Attendance Overview', style: AppTextStyles.bodyBold),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            width: 120,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 45,
                sections: [
                  PieChartSectionData(
                    color: AppColors.primaryBlue,
                    value: 88,
                    title: '88%',
                    radius: 20,
                    titleStyle: AppTextStyles.bodyBold.copyWith(color: AppColors.textOnPrimary),
                  ),
                  PieChartSectionData(
                    color: AppColors.statusRed,
                    value: 12,
                    title: '12%',
                    radius: 20,
                    titleStyle: AppTextStyles.caption.copyWith(color: AppColors.textOnPrimary, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Buttons as shown in the design
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReportsAnalyticsScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Generate Report'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RequestManagementScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDarkBlue,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Manage Requests'),
          )
        ],
      ),
    );
  }
}