import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class CompleteJobScreen extends StatefulWidget {
  const CompleteJobScreen({super.key});

  @override
  State<CompleteJobScreen> createState() => _CompleteJobScreenState();
}

class _CompleteJobScreenState extends State<CompleteJobScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _finishJob() {
    if (_otpController.text.length < 4) return;
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 80.w),
            SizedBox(height: AppSpacing.md),
            Text('JOB COMPLETED', style: AppTypography.h3),
            SizedBox(height: AppSpacing.sm),
            Text('Payment of ₹450 has been credited to your wallet.', textAlign: TextAlign.center, style: AppTypography.bodyMedium),
            SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                context.go('/worker-home'); // go to home
              },
              child: const Text('BACK TO CONSOLE'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('COMPLETION'),
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
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                   border: Border.all(color: AppColors.success ?? Colors.green, width: 2),
                    boxShadow: [
                      BoxShadow(color: (AppColors.success ?? Colors.green).withOpacity(0.2), blurRadius: 30),
                    ],
                  ),
                  child: Icon(Icons.task_alt, size: 60.w, color: AppColors.success),
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              Text(
                'Verify Completion',
                style: AppTypography.h3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Please ask the customer for the 4-digit completion PIN to close this dispatch.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  style: AppTypography.h1.copyWith(letterSpacing: 10, color: AppColors.primary),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "----",
                    hintStyle: AppTypography.h1.copyWith(letterSpacing: 10, color: AppColors.textSecondary.withOpacity(0.5)),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _finishJob,
                child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(
                          strokeWidth: 2, 
                          color: AppColors.background
                        )
                      )
                    : const Text('SUBMIT COMPLETION PIN'),
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
