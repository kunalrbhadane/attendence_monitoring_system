import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_monitoring_system/core/theme/app_colors.dart';
import 'package:attendence_monitoring_system/core/theme/app_text_styles.dart';
import 'package:attendence_monitoring_system/data/models/leave_request_model.dart';
import 'package:attendence_monitoring_system/data/providers/request_provider.dart';
import 'package:attendence_monitoring_system/features/admin_auth/presentation/screens/login_screen.dart';


// --- MAIN SCREEN ---
class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveRequestsAsync = ref.watch(leaveRequestsProvider);
    final correctionRequestsAsync = ref.watch(correctionRequestsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("My Profile", style: AppTextStyles.heading2)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 60)),
            const SizedBox(height: 12),
            Text("Alex Smith", style: AppTextStyles.heading2),

            // ERROR FIXED HERE: AppTextstyles -> AppTextStyles
            Text("#EID-001", style: AppTextStyles.subtitle.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
            
            const SizedBox(height: 24),
            _buildProfileButton(context, "Edit Personal Info"),
            _buildProfileButton(context, "Change Password"),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("My Requests", style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: leaveRequestsAsync.when(
                    data: (reqs) => RequestStatusCard(title: "Leave Request", status: reqs.first.status),
                    loading: () => const RequestStatusCard.loading(title: "Leave Request"),
                    error: (e,s) => const RequestStatusCard.error(title: "Leave Request"),
                  )
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: correctionRequestsAsync.when(
                    data: (reqs) => RequestStatusCard(title: "Correction Request", status: reqs.first.status),
                    loading: () => const RequestStatusCard.loading(title: "Correction Request"),
                    error: (e,s) => const RequestStatusCard.error(title: "Correction Request"),
                  )
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => const LoginScreen()), (r) => false
                  );
                }, 
                child: const Text("Logout"),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: AppTextStyles.bodyRegular),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

// (The RequestStatusCard helper widget code is unchanged)
class RequestStatusCard extends StatelessWidget {
  final String title;
  final RequestStatus? status;
  final bool isLoading;
  final bool isError;
  
  const RequestStatusCard({super.key, required this.title, this.status}) 
  : isLoading = false, isError = false;

  const RequestStatusCard.loading({super.key, required this.title}) 
  : status = null, isLoading = true, isError = false;

  const RequestStatusCard.error({super.key, required this.title}) 
  : status = null, isLoading = false, isError = true;

  Color _getBorderColor() {
    switch(status) {
      case RequestStatus.approved: return AppColors.statusGreen;
      case RequestStatus.pending: return AppColors.statusYellow;
      case RequestStatus.denied: return AppColors.statusRed;
      default: return Colors.grey.shade300;
    }
  }
  
  String _getStatusText() {
    switch(status) {
      case RequestStatus.approved: return "Approved";
      case RequestStatus.pending: return "Pending";
      case RequestStatus.denied: return "Denied";
      default: return "--";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getBorderColor(), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
          const SizedBox(height: 8),
          if (isLoading)
            const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          if(isError)
             const Text("Error"),
          if(!isLoading && !isError)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getBorderColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Text(
                _getStatusText(), 
                style: AppTextStyles.caption.copyWith(color: _getBorderColor(), fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}