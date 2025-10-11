import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_monitoring_system/data/models/leave_request_model.dart';
import 'package:attendence_monitoring_system/data/repositories/mock_request_repository.dart';
import 'package:attendence_monitoring_system/data/repositories/request_repository.dart';

/// Provides the instance of our [RequestRepository] to the rest of the app.
/// This is the single point of configuration for the data source.
final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  // Currently, it provides the mock implementation.
  // To switch to a real backend, you would change this one line to:
  // return FirebaseRequestRepository();
  return MockRequestRepository();
});

/// A FutureProvider that fetches the list of leave requests for the current employee.
/// The UI will watch this provider to get the data and automatically handle
/// loading and error states.
final leaveRequestsProvider = FutureProvider.autoDispose<List<LeaveRequest>>((ref) {
  // Watches the repository provider to get the current data source instance.
  final repo = ref.watch(requestRepositoryProvider);
  // Calls the method to fetch the data.
  return repo.getLeaveRequestsForEmployee('EID-001'); // Using a hardcoded ID for mock purposes.
});