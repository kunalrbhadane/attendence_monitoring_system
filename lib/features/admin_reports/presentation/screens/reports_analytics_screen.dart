import 'package:flutter/material.dart';
// CORRECTED IMPORTS
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';
import 'package:fl_chart/fl_chart.dart';

// Custom widget for the filter buttons
class FilterChipButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(text),
      selected: isSelected,
      onSelected: (selected) => onTap(),
      labelStyle: AppTextStyles.bodyBold.copyWith(
        color: isSelected ? AppColors.textOnPrimary : AppColors.primaryBlue,
      ),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primaryBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isSelected ? AppColors.primaryBlue : AppColors.border),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}


// Custom widget for an item in the employee summary list
class EmployeeSummaryTile extends StatelessWidget {
  const EmployeeSummaryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
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
                Text("Jane Smith", style: AppTextStyles.bodyBold),
                Text("09:02 AM", style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Present: 20", style: AppTextStyles.caption),
              Text("Absent: 2", style: AppTextStyles.caption),
              Text("Late: 3", style: AppTextStyles.caption.copyWith(color: AppColors.statusRed)),
            ],
          ),
        ],
      ),
    );
  }
}

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  int _selectedFilterIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Reports & Analytics", style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Filter Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterChipButton(text: "This Week", isSelected: _selectedFilterIndex == 0, onTap: () => setState(() => _selectedFilterIndex = 0)),
                FilterChipButton(text: "Last Month", isSelected: _selectedFilterIndex == 1, onTap: () => setState(() => _selectedFilterIndex = 1)),
                FilterChipButton(text: "Custom Range", isSelected: _selectedFilterIndex == 2, onTap: () => setState(() => _selectedFilterIndex = 2)),
              ],
            ),
            const SizedBox(height: 24),
            
            // --- Attendance Trends Chart ---
            Text("Attendance Trends", style: AppTextStyles.bodyBold),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: _getMockBarGroups(),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text('${value.toInt()}%', style: AppTextStyles.caption),
                        reservedSize: 28,
                        interval: 1,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                       sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                             String text = '';
                             switch (value.toInt()) {
                                case 0: text = 'Oct 1-3'; break;
                                case 2: text = 'Oct 1-24'; break;
                                case 4: text = 'Oct 1-21'; break;
                                case 6: text = 'Oct 1-31'; break;
                             }
                             return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: AppTextStyles.caption));
                          }
                       ),
                    )
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // --- Employee Summary List ---
            Text("Employee Summary", style: AppTextStyles.bodyBold),
            const SizedBox(height: 16),
            const EmployeeSummaryTile(),
            const EmployeeSummaryTile(),
            const EmployeeSummaryTile(),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: 'Export as PDF / CSV', 
          onPressed: () {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export functionality not implemented yet.'))
             );
          }
        ),
      ),
    );
  }

  // Mock data for the bar chart
  List<BarChartGroupData> _getMockBarGroups() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index * 2 % 3 + 1).toDouble(),
            color: AppColors.primaryBlue,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
           BarChartRodData(
            toY: (index * 2 % 3 + 1.5).toDouble(),
            color: AppColors.secondaryOrange,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}