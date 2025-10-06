enum EmployeeStatus { present, absent, onLeave }

class Employee {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' or 'employee'
  final String? profileImageUrl;
  final EmployeeStatus status; // Live status

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
    required this.status,
  });
}