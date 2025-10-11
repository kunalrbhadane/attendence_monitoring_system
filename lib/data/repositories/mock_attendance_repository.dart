import 'package:attendence_monitoring_system/data/models/attendance_record_model.dart';
import 'package:attendence_monitoring_system/data/repositories/attendance_repository.dart';

// This mock repository will power the employee-side UI.
class MockAttendanceRepository implements AttendanceRepository {

  // --- Employee-Specific Implementations ---

  @override
  Future<String> getCurrentStatusForEmployee(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network latency
    // This matches the "You are Checked IN" on the UI.
    return "Checked IN Since 09:02 AM";
  }

  @override
  Future<List<AttendanceRecord>> getTodaysActivityForEmployee(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // This provides the data for the timeline on the home screen.
    return [
      AttendanceRecord(
        employeeId: 'EID-001',
        employeeName: 'Alex Smith',
        timestamp: DateTime.now().copyWith(hour: 9, minute: 2),
        eventType: AttendanceEventType.inn,
      ),
      // We will represent "Pending OUT" logically in the UI
    ];
  }
  
  @override
  Future<Map<int, String>> getMonthlyAttendanceForEmployee(String employeeId, DateTime month) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Data for the calendar view. 'Present', 'Absent', 'OnLeave'
    return {
      1: 'Present', 3: 'Present', 4: 'Absent', 5: 'Present', 8: 'Present',
      9: 'OnLeave', 10: 'OnLeave', 11: 'Present', 12: 'Present', 15: 'Absent',
      // Add more mock dates as needed
    };
  }

  // --- Admin-Side Methods (Not implemented here, but must exist) ---
  // We leave these blank for now as Developer 2 doesn't need them.
  @override
  Stream<List<AttendanceRecord>> getLiveStatusFeed() => Stream.value([]);
  @override
  Future<int> getTotalPresentCount() async => 0;
  @override
  Future<int> getTotalAbsentCount() async => 0;
  @override
  Future<int> getTotalOnLeaveCount() async => 0;
  @override
  Future<int> getTotalLateArrivalsCount() async => 0;
}