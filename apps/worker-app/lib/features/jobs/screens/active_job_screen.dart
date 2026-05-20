import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class ActiveJobScreen extends StatefulWidget {
  const ActiveJobScreen({super.key});

  @override
  State<ActiveJobScreen> createState() => _ActiveJobScreenState();
}

class _ActiveJobScreenState extends State<ActiveJobScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ACTIVE JOB'),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildJobStatus(),
              SizedBox(height: AppSpacing.lg),
              Expanded(child: _buildStepper()),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobStatus() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary!.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TIMER', style: AppTypography.caption),
              Text('00:45:12', style: AppTypography.h2.copyWith(color: AppColors.primary)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary!.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('IN PROGRESS', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Stepper(
      currentStep: _currentStep,
      onStepTapped: (index) {
        setState(() => _currentStep = index);
      },
      controlsBuilder: (context, details) => const SizedBox.shrink(),
      steps: [
        Step(
          title: Text('Arrived at Location', style: AppTypography.bodyLarge),
          content: Text('Confirm arrival and meet customer.', style: AppTypography.bodyMedium),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Pre-work Inspection', style: AppTypography.bodyLarge),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Take before photos and verify issue.', style: AppTypography.bodyMedium),
              SizedBox(height: AppSpacing.sm),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt),
                label: const Text('UPLOAD PHOTOS'),
              )
            ],
          ),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Work in Progress', style: AppTypography.bodyLarge),
          content: Text('Perform the requested service.', style: AppTypography.bodyMedium),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Completion', style: AppTypography.bodyLarge),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Take after photos and request OTP.', style: AppTypography.bodyMedium),
              SizedBox(height: AppSpacing.sm),
              ElevatedButton(
                onPressed: () => context.push('/complete-job'),
                child: const Text('FINISH JOB'),
              )
            ],
          ),
          isActive: _currentStep >= 3,
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: () {
        if (_currentStep < 3) {
          setState(() => _currentStep++);
        } else {
          context.push('/complete-job');
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      ),
      child: Text(_currentStep < 3 ? 'MARK STEP COMPLETE' : 'FINISH JOB'),
    );
  }
}
