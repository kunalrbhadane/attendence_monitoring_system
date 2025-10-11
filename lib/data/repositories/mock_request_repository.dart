import 'package:attendence_monitoring_system/data/models/leave_request_model.dart';
import 'package:attendence_monitoring_system/data/repositories/request_repository.dart';

/// The mock implementation of the [RequestRepository].
/// This class returns hardcoded data to allow for UI development and testing
/// without needing a live backend connection.
class MockRequestRepository implements RequestRepository {
  
  /// Overrides the method from the abstract class to provide mock leave request data.
  @override
  Future<List<LeaveRequest>> getLeaveRequestsForEmployee(String employeeId) async {
    // Simulate a network delay of 400 milliseconds.
    await Future.delayed(const Duration(milliseconds: 400));
    // Return a list of various leave requests to test all UI states.
    return [
      LeaveRequest(
        id: 'LR003',
        leaveType: 'Casual Leave',
        startDate: DateTime.now().add(const Duration(days: 20)),
        endDate: DateTime.now().add(const Duration(days: 21)),
        reason: 'Personal Appointment',
        status: RequestStatus.pending, // A pending request
      ),
       LeaveRequest(
        id: 'LR001',
        leaveType: 'Paid Leave',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().subtract(const Duration(days: 8)),
        reason: 'Family Vacation',
        status: RequestStatus.approved, // An approved request
      ),
      LeaveRequest(
        id: 'LR002',
        leaveType: 'Unpaid Leave',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().subtract(const Duration(days: 30)),
        reason: 'Medical Emergency',
        status: RequestStatus.denied, // A denied request
      ),
    ];
  }
}