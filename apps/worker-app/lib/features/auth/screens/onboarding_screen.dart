import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 300.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(color: AppColors.primary!.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: AppColors.primary!.withOpacity(0.1),
                            blurRadius: 50,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.build_circle_outlined,
                          size: 100.w,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                    Text(
                      'AI-Powered\nDispatch System',
                      textAlign: TextAlign.center,
                      style: AppTypography.h2,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Get real-time jobs, smart diagnostics, and instant payouts all in one console.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('INITIALIZE WORKER PROFILE'),
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
