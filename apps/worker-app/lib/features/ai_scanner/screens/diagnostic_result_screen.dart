import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class DiagnosticResultScreen extends StatelessWidget {
  const DiagnosticResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI ANALYSIS RESULT'),
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
              _buildConfidenceScore(),
              SizedBox(height: AppSpacing.lg),
              _buildIssueDetected(),
              SizedBox(height: AppSpacing.lg),
              _buildRequiredParts(),
              SizedBox(height: AppSpacing.lg),
              _buildEffortEstimate(),
              SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: () {
                  context.pop(); // Pop Result
                  context.pop(); // Pop Scanner
                },
                child: const Text('ATTACH REPORT TO JOB'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfidenceScore() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.primary!.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI CONFIDENCE', style: AppTypography.caption),
              Text('High Match', style: AppTypography.h3.copyWith(color: AppColors.primary)),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: 0.92,
                  color: AppColors.primary,
                  backgroundColor: AppColors.surfaceHighlight,
                  strokeWidth: 6,
                ),
              ),
              Text('92%', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildIssueDetected() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ISSUE DETECTED', style: AppTypography.h3),
        SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Broken Sink P-Trap', style: AppTypography.bodyLarge),
              SizedBox(height: AppSpacing.xs),
              Text('The image analysis indicates a fractured PVC P-Trap beneath the kitchen sink causing water leakage.', style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequiredParts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SUGGESTED PARTS', style: AppTypography.h3),
        SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            children: [
              _buildPartItem('1.5" PVC P-Trap Kit', '₹150 - ₹250'),
              Divider(color: AppColors.surfaceHighlight),
              _buildPartItem('Teflon Tape', '₹50'),
              Divider(color: AppColors.surfaceHighlight),
              _buildPartItem('PVC Solvent Cement', '₹80'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPartItem(String name, String estCost) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.build_circle_outlined, size: 16, color: AppColors.textSecondary),
              SizedBox(width: AppSpacing.sm),
              Text(name, style: AppTypography.bodyLarge),
            ],
          ),
          Text(estCost, style: AppTypography.bodyMedium.copyWith(color: AppColors.success)),
        ],
      ),
    );
  }

  Widget _buildEffortEstimate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('EFFORT ESTIMATE', style: AppTypography.h3),
        SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEffortStat('Time', '45 Mins', Icons.timer),
              _buildEffortStat('Difficulty', 'Medium', Icons.handyman),
              _buildEffortStat('Cost', '₹ 450', Icons.currency_rupee),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEffortStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTypography.bodyLarge),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
