import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_monitoring_system/data/models/correction_request_model.dart';
import 'package:attendence_monitoring_system/data/models/leave_request_model.dart';
import 'package:attendence_monitoring_system/data/repositories/mock_request_repository.dart';
import 'package:attendence_monitoring_system/data/repositories/request_repository.dart';


// Provides the repository instance
final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return MockRequestRepository();
});

// Provides the list of leave requests for the current user
final leaveRequestsProvider = FutureProvider.autoDispose<List<LeaveRequest>>((ref) {
  final repo = ref.watch(requestRepositoryProvider);
  return repo.getLeaveRequestsForEmployee('EID-001');
});

// Provides the list of correction requests for the current user
final correctionRequestsProvider = FutureProvider.autoDispose<List<CorrectionRequest>>((ref) {
  final repo = ref.watch(requestRepositoryProvider);
  return repo.getCorrectionRequestsForEmployee('EID-001');
});