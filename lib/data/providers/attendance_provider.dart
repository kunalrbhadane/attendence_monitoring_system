import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_monitoring_system/data/models/attendance_record_model.dart';
import 'package:attendence_monitoring_system/data/repositories/attendance_repository.dart';
import 'package:attendence_monitoring_system/data/repositories/mock_attendance_repository.dart';

// This file defines all the data providers for the attendance feature.
// It acts as the bridge between the UI and the data layer.

// Provides the instance of our mock repository.
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return MockAttendanceRepository();
});

// Provides the current "Checked IN" status string for the home screen.
final employeeStatusProvider = FutureProvider.autoDispose<String>((ref) {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.getCurrentStatusForEmployee('EID-001'); 
});

// Provides the list of today's activities for the home screen timeline.
final todayActivityProvider = FutureProvider.autoDispose<List<AttendanceRecord>>((ref) {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.getTodaysActivityForEmployee('EID-001');
});

// --- THIS IS THE PROVIDER CAUSING THE ERROR IF NOT IMPORTED ---
// It uses .family to fetch data for a specific month passed as a parameter.
final monthlyAttendanceProvider = FutureProvider.autoDispose
    .family<Map<int, String>, DateTime>((ref, month) {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.getMonthlyAttendanceForEmployee('EID-001', month);
});