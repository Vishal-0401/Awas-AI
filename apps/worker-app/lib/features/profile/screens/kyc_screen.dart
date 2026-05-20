import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class KycScreen extends StatelessWidget {
  const KycScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('KYC VERIFICATION'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatusBanner(),
              SizedBox(height: AppSpacing.xl),
              _buildDocumentUpload(
                title: 'Aadhaar Card',
                subtitle: 'Front and Back photos required',
                isUploaded: true,
              ),
              SizedBox(height: AppSpacing.lg),
              _buildDocumentUpload(
                title: 'PAN Card',
                subtitle: 'Clear front photo required',
                isUploaded: true,
              ),
              SizedBox(height: AppSpacing.lg),
              _buildDocumentUpload(
                title: 'Live Selfie',
                subtitle: 'Take a clear photo of your face',
                isUploaded: false,
              ),
              SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: () {},
                child: const Text('SUBMIT FOR VERIFICATION'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.success.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.security, color: AppColors.success),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verification Pending', style: AppTypography.bodyLarge.copyWith(color: AppColors.success)),
                Text('Complete all steps to activate account.', style: AppTypography.caption),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDocumentUpload({required String title, required String subtitle, required bool isUploaded}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isUploaded ? AppColors.success.withOpacity(0.5) : AppColors.surfaceHighlight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isUploaded ? AppColors.success.withOpacity(0.1) : AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle : Icons.upload_file,
              color: isUploaded ? AppColors.success : AppColors.textSecondary,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyLarge),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          if (!isUploaded)
            TextButton(
              onPressed: () {},
              child: const Text('UPLOAD'),
            )
        ],
      ),
    );
  }
}
