import 'package:attendence_monitoring_system/data/models/correction_request_model.dart';
import 'package:attendence_monitoring_system/data/models/leave_request_model.dart';
import 'package:attendence_monitoring_system/data/repositories/request_repository.dart';

// A mock implementation that returns hardcoded data matching the UI designs.
class MockRequestRepository implements RequestRepository {
  
  @override
  Future<List<LeaveRequest>> getLeaveRequestsForEmployee(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return [
      LeaveRequest(
        id: 'LR001',
        leaveType: 'Paid Leave',
        startDate: DateTime.now().add(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 12)),
        reason: 'Family Vacation',
        status: RequestStatus.approved,
      ),
    ];
  }

  @override
  Future<List<CorrectionRequest>> getCorrectionRequestsForEmployee(String employeeId) async {
     await Future.delayed(const Duration(milliseconds: 450));
    return [
      CorrectionRequest(
        id: 'CR001',
        dateOfIncident: DateTime.now().subtract(const Duration(days: 1)),
        reason: 'Forgot to clock out yesterday evening.',
        status: RequestStatus.pending,
      )
    ];
  }
}