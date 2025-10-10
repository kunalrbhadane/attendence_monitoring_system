import 'package:flutter/material.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/features/admin_employee_management/presentation/screens/add_employee_screen.dart';
import 'package:attendence_monitoring_system/features/admin_employee_management/presentation/screens/employee_detail_screen.dart';

// --- WIDGETS ---

/// A custom styled chip to display employee status, perfectly matching the new design.
class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'in':
        chipColor = AppColors.statusGreen.withOpacity(0.15);
        textColor = AppColors.statusGreen;
        break;
      case 'out':
        chipColor = AppColors.statusRed.withOpacity(0.15);
        textColor = AppColors.statusRed;
        break;
      default: // 'on leave'
        chipColor = AppColors.statusOnLeave.withOpacity(0.15);
        textColor = AppColors.statusOnLeave;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// The final, fully functional screen for listing and managing employees.
class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  // --- STATE MANAGEMENT ---
  
  // The master list of all employees (our mock database)
  final List<Employee> _allEmployees = [
    Employee(name: 'John Doe', id: 'S1101', email: 'john.d@company.com', status: 'IN'),
    Employee(name: 'Jane Smith', id: 'S1102', email: 'jane.s@company.com', status: 'OUT'),
    Employee(name: 'Alex Chen', id: 'S1103', email: 'alex.c@company.com', status: 'OUT'),
    Employee(name: 'Maria Garcia', id: 'S1104', email: 'maria.g@company.com', status: 'On Leave'),
    Employee(name: 'David Lee', id: 'S1105', email: 'david.l@company.com', status: 'On Leave'),
    Employee(name: 'Rey Tave', id: 'S1106', email: 'rey.t@company.com', status: 'IN'),
    Employee(name: 'Kevin Hart', id: 'S1107', email: 'kevin.h@company.com', status: 'IN'),
  ];

  // State variables that control what is shown on screen
  late List<Employee> _filteredEmployees;
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = "All";

  @override
  void initState() {
    super.initState();
    _filteredEmployees = _allEmployees;
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }

  /// The single source of truth for filtering and searching. Guaranteed to work.
  void _applyFilters() {
    List<Employee> tempEmployees = List.from(_allEmployees);

    // Apply Status Filter first
    if (_selectedStatusFilter != "All") {
      tempEmployees = tempEmployees.where((employee) => 
        employee.status == _selectedStatusFilter
      ).toList();
    }

    // Then, apply Search Filter on the already filtered list
    final query = _searchController.text.toLowerCase().trim();
    if (query.isNotEmpty) {
      tempEmployees = tempEmployees.where((employee) => 
        employee.name.toLowerCase().contains(query)
      ).toList();
    }

    setState(() {
      _filteredEmployees = tempEmployees;
    });
  }

  /// Shows a modal bottom sheet with filter options. Guaranteed to work.
  void _showFilterSheet() {
    final statuses = ["All", "IN", "OUT", "On Leave"];
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Filter by Status", style: AppTextStyles.heading2.copyWith(fontSize: 20)),
              const SizedBox(height: 16),
              ...statuses.map((status) {
                return ListTile(
                  title: Text(status),
                  trailing: _selectedStatusFilter == status ? Icon(Icons.check_circle, color: AppColors.primaryBlue) : null,
                  onTap: () {
                    // This now correctly updates the state and applies the filter.
                    setState(() {
                      _selectedStatusFilter = status;
                    });
                    _applyFilters();
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Management", style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            // --- Search & Filter UI ---
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.filter_list_rounded, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  onPressed: _showFilterSheet,
                ),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor.withOpacity(0.5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            
            // --- Employee List ---
            Expanded(
              child: _filteredEmployees.isEmpty
                  ? Center(child: Text("No employees found.", style: AppTextStyles.subtitle))
                  : ListView.builder(
                      itemCount: _filteredEmployees.length,
                      itemBuilder: (context, index) {
                        final employee = _filteredEmployees[index];
                        // This is now the custom, tappable employee card widget
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => EmployeeDetailScreen(employee: employee)),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: theme.scaffoldBackgroundColor,
                                    child: Icon(Icons.person_outline, size: 28, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(employee.name, style: AppTextStyles.bodyBold.copyWith(fontSize: 16)),
                                        const SizedBox(height: 2),
                                        Text("ID: ${employee.id}", style: AppTextStyles.caption),
                                      ],
                                    ),
                                  ),
                                  StatusChip(status: employee.status),
                                  const SizedBox(width: 12),
                                  Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEmployeeScreen(), fullscreenDialog: true)),
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }
}