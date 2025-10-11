import 'package:attendence_monitoring_system/data/models/correction_request_model.dart';
import 'package:attendence_monitoring_system/data/models/leave_request_model.dart';

// The contract for what our request repository can do.
abstract class RequestRepository {
  Future<List<LeaveRequest>> getLeaveRequestsForEmployee(String employeeId);
  Future<List<CorrectionRequest>> getCorrectionRequestsForEmployee(String employeeId);
  
  // These will be used later when connecting to a real backend.
  // Future<void> submitLeaveRequest(LeaveRequest request);
  // Future<void> submitCorrectionRequest(CorrectionRequest request);
}