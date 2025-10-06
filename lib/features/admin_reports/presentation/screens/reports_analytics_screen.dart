import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/shared_widgets/primary_button.dart';
import 'package:fl_chart/fl_chart.dart';

// Note for developers: In a larger project, helper widgets like FilterChipButton
// and EmployeeSummaryTile would be moved to a dedicated 'widgets' sub-folder
// within 'admin_reports/presentation/'.

/// A custom selectable chip button used for filtering.
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

/// A custom list tile to display a summary of an employee's attendance.
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
                Text("Last Clock-In: 09:02 AM", style: AppTextStyles.caption),
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


/// The main screen for viewing attendance reports and analytics.
class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  // State to manage which filter button is currently active
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
      // The body is a Padding widget with a Column.
      // This Column is NOT wrapped in a scroll view, making the layout fixed.
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Filter Buttons Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterChipButton(text: "This Week", isSelected: _selectedFilterIndex == 0, onTap: () => setState(() => _selectedFilterIndex = 0)),
                FilterChipButton(text: "Last Month", isSelected: _selectedFilterIndex == 1, onTap: () => setState(() => _selectedFilterIndex = 1)),
                FilterChipButton(text: "Custom Range", isSelected: _selectedFilterIndex == 2, onTap: () => setState(() => _selectedFilterIndex = 2)),
              ],
            ),
            const SizedBox(height: 24),
            
            // --- Attendance Trends Chart Section ---
            Text("Attendance Trends", style: AppTextStyles.bodyBold),
            const SizedBox(height: 16),
            // Flexible widget makes the chart container expand to take up a
            // proportional amount of the available vertical space.
            Flexible(
              flex: 3, // Adjust flex factor for desired height proportion
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
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
                          reservedSize: 32, // More space for labels
                          interval: 1,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                         sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
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
            ),
            const SizedBox(height: 24),
            
            // --- Employee Summary List Section ---
            Text("Employee Summary", style: AppTextStyles.bodyBold),
            const SizedBox(height: 16),
            // This Flexible widget takes the remaining vertical space for the list.
            Flexible(
              flex: 4, // Given more proportional space than the chart
              child: ListView( // The ListView itself can scroll if content overflows the Flexible container
                padding: EdgeInsets.zero,
                children: const [
                  EmployeeSummaryTile(),
                  EmployeeSummaryTile(),
                  EmployeeSummaryTile(),
                ],
              ),
            ),
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

  /// Generates mock data for the bar chart.
  List<BarChartGroupData> _getMockBarGroups() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index * 2 % 3 + 1).toDouble(), // Some random-looking height
            color: AppColors.primaryBlue,
            width: 15,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4)
            ),
          ),
           BarChartRodData(
            toY: (index * 2 % 3 + 1.5).toDouble(), // Some random-looking height
            color: AppColors.secondaryOrange,
            width: 15,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4)
            ),
          ),
        ],
      );
    });
  }
}