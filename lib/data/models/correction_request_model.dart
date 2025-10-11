import 'package:attendence_monitoring_system/data/models/leave_request_model.dart'; // Re-use the enum

class CorrectionRequest {
  final String id;
  final DateTime dateOfIncident;
  final String reason;
  final RequestStatus status;

  CorrectionRequest({
    required this.id,
    required this.dateOfIncident,
    required this.reason,
    required this.status,
  });
}