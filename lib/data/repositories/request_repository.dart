import 'package:attendence_monitoring_system/data/models/leave_request_model.dart';

/// The abstract contract for the request repository.
/// Defines what methods must be implemented by any data source (mock or real).
///
/// By defining this interface, we can easily swap our mock data source
/// for a real Firebase data source in the future without changing the UI code.
abstract class RequestRepository {
  /// Fetches a list of leave requests for a given employee ID.
  Future<List<LeaveRequest>> getLeaveRequestsForEmployee(String employeeId);
}