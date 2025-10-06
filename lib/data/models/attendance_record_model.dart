enum AttendanceEventType { inn, out }

class AttendanceRecord {
  final String employeeId;
  final String employeeName;
  final String? employeeProfileImageUrl;
  final DateTime timestamp;
  final AttendanceEventType eventType;

  AttendanceRecord({
    required this.employeeId,
    required this.employeeName,
    this.employeeProfileImageUrl,
    required this.timestamp,
    required this.eventType,
  });
}