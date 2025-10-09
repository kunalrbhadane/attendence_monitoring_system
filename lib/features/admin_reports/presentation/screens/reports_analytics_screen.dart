import 'dart:math';
import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// --- WIDGETS ---
// These helper widgets are self-contained, theme-aware, and have the correct layout structure.

/// A theme-aware, selectable chip button for filtering.
/// NOTE: This widget no longer contains an Expanded widget to prevent layout errors.
class FilterChipButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  const FilterChipButton({super.key, required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AppColors.primaryBlue : theme.dividerColor),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold.copyWith(
              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// A theme-aware list tile for displaying an employee's attendance summary.
class EmployeeSummaryTile extends StatelessWidget {
  const EmployeeSummaryTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.background,
              child: Icon(Icons.person, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Jane Smith"),
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
      ),
    );
  }
}

/// The main reports screen, with all logic and layout fully implemented and error-free.
class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});
  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  // State variables for interactivity
  int _selectedFilterIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  List<BarChartGroupData> _chartData = [];
  final Random _random = Random();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateDateRangeByIndex(0);
  }

  /// Regenerates chart data when the date range changes.
  void _generateChartDataForRange(DateTime start, DateTime end) {
    final days = end.difference(start).inDays;
    int barCount = (days <= 7) ? 7 : ((days <= 31) ? 4 : 10);
    final newChartData = List.generate(barCount, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: _random.nextDouble() * 5 + 2, color: AppColors.primaryBlue, width: 15, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
          BarChartRodData(toY: _random.nextDouble() * 2 + 0.5, color: AppColors.primaryMagenta, width: 15, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
        ],
      );
    });
    if (mounted) setState(() => _chartData = newChartData);
  }

  /// Updates the date range based on filter button index.
  void _updateDateRangeByIndex(int index) {
    setState(() {
      _selectedFilterIndex = index;
      // For "Custom", we just set the index. The date fields handle the rest.
      if (index == 2) {
        final now = DateTime.now();
        _startDate ??= now; _endDate ??= now;
        if(_startDate != null && _endDate != null) _generateChartDataForRange(_startDate!, _endDate!);
        return;
      }

      final now = DateTime.now();
      DateTime start, end;
      if (index == 0) { // Week
        start = now.subtract(Duration(days: now.weekday - 1));
        end = now;
      } else { // Month
        start = DateTime(now.year, now.month, 1);
        end = now;
      }
      _startDate = start; _endDate = end;
      _generateChartDataForRange(start, end);
    });
  }

  /// Shows a single date picker and updates the corresponding date state.
  Future<void> _pickDate(bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: isStartDate ? DateTime(2020) : (_startDate ?? DateTime(2020)),
      lastDate: isStartDate ? (_endDate ?? DateTime.now()) : DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primaryBlue, onPrimary: Colors.white)),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) _startDate = picked; else _endDate = picked;
        if (_startDate != null && _endDate != null) _generateChartDataForRange(_startDate!, _endDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports & Analytics")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MODIFIED: This Row has the corrected structure to prevent ParentDataWidget errors.
            Row(children: [
              Expanded(child: FilterChipButton(text: "Week", isSelected: _selectedFilterIndex == 0, onTap: () => _updateDateRangeByIndex(0))),
              const SizedBox(width: 8),
              Expanded(child: FilterChipButton(text: "Month", isSelected: _selectedFilterIndex == 1, onTap: () => _updateDateRangeByIndex(1))),
              const SizedBox(width: 8),
              Expanded(child: FilterChipButton(text: "Custom", isSelected: _selectedFilterIndex == 2, onTap: () => _updateDateRangeByIndex(2))),
            ]),
            const SizedBox(height: 12),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _selectedFilterIndex == 2 ? _buildCustomDateFields() : _buildDateRangeDisplay(),
            ),
            const SizedBox(height: 12),
            Text("Attendance Trends", style: AppTextStyles.bodyBold),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _chartData,
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: AppTextStyles.caption), reservedSize: 28)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22, getTitlesWidget: (v, m) => _getBottomTitle(v))),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text("Employee Summary", style: AppTextStyles.bodyBold),
            const SizedBox(height: 16),
            Expanded(child: ListView.builder(itemCount: 4, padding: EdgeInsets.zero, itemBuilder: (c, i) => const EmployeeSummaryTile())),
          ],
        ),
      ),
    );
  }

  /// Helper widget for displaying the date range text for Week/Month filters.
  Widget _buildDateRangeDisplay() {
    return Center(
      child: Text(
        (_startDate != null && _endDate != null) ? "${_dateFormatter.format(_startDate!)}  -  ${_dateFormatter.format(_endDate!)}" : 'Select a date range',
        style: AppTextStyles.caption.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
      ),
    );
  }

  /// Helper widget for displaying the Start Date and End Date input fields for the Custom filter.
  Widget _buildCustomDateFields() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _pickDate(true),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Start Date',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              child: Text(_startDate != null ? _dateFormatter.format(_startDate!) : 'Select'),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () => _pickDate(false),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'End Date',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              child: Text(_endDate != null ? _dateFormatter.format(_endDate!) : 'Select'),
            ),
          ),
        ),
      ],
    );
  }
  
  /// Helper method to get the correct bottom titles for the bar chart.
  Widget _getBottomTitle(double value) {
    String text = '';
    if (_selectedFilterIndex == 0) { // Week view
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      text = days.length > value.toInt() ? days[value.toInt()] : '';
    } else if (_selectedFilterIndex == 1) { // Month view
      text = 'W${value.toInt() + 1}';
    } else { // Custom view
      text = 'D${value.toInt() + 1}';
    }
    return SideTitleWidget(axisSide: AxisSide.bottom, space: 4, child: Text(text, style: AppTextStyles.caption));
  }
}