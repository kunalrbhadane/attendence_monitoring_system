// CORRECTED IMPORT PATH
import 'package:attendence_monitoring_system/data/models/attendance_record_model.dart';

abstract class AttendanceRepository {
  // --- For Employees ---
  Future<String> getCurrentStatusForEmployee(String employeeId);
  Future<List<AttendanceRecord>> getTodaysActivityForEmployee(String employeeId);
  // The map will contain <Day, Status> e.g., { 1: 'Present', 2: 'Absent', 3: 'OnLeave' }
  Future<Map<int, String>> getMonthlyAttendanceForEmployee(String employeeId, DateTime month);

  // --- For Admins ---
  Stream<List<AttendanceRecord>> getLiveStatusFeed();
  Future<int> getTotalPresentCount();
  Future<int> getTotalAbsentCount();
  Future<int> getTotalOnLeaveCount();
  Future<int> getTotalLateArrivalsCount();
}