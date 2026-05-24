import 'package:awas_customer_app/core/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:awas_customer_app/core/constants/app_typography.dart';
import 'package:awas_customer_app/core/constants/spacing.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final int _currentStep = 1;

  final List<Map<String, dynamic>> _trackingSteps = [
    {'status': 'CONFIRMED', 'time': '2:30 PM', 'active': true},
    {'status': 'ON THE WAY', 'time': '2:45 PM', 'active': true},
    {'status': 'ARRIVING', 'time': 'Expected 3:00 PM', 'active': false},
    {'status': 'SERVICE STARTED', 'time': '', 'active': false},
    {'status': 'COMPLETED', 'time': '', 'active': false},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'TRACK WORKER',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: AppColors.background,
                      child: Center(
                        child: Icon(
                          Icons.map,
                          size: 80.r,
                          color: AppColors.surfaceHighlight,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20.h,
                      left: 20.w,
                      right: 20.w,
                      child: _buildWorkerInfo(),
                    ),
                  ],
                ),
              ),
              _buildTrackingTimeline(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkerInfo() {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 56.r,
                height: 56.r,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceHighlight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: AppColors.primary, size: 28.r),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 14.r,
                      height: 14.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(_pulseController.value * 0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Smith',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Electrical Expert • 4.9 (1,240 jobs)',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.call, color: AppColors.primary, size: 20.r),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 20.r),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: -0.2);
  }

  Widget _buildTrackingTimeline() {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      margin: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ETA: 15 MINUTES',
            style: AppTypography.caption.copyWith(
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Stack(
            children: [
              Positioned(
                left: 20.r,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2.r,
                  color: AppColors.surfaceHighlight.withOpacity(0.3),
                ),
              ),
              Column(
                children: _trackingSteps.asMap().map((index, step) {
                  final isActive = step['active'] as bool;
                  final isCompleted = index < _currentStep;
                  return MapEntry(
                    index,
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primary.withOpacity(0.2)
                                  : AppColors.surfaceHighlight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isActive ? AppColors.primary : AppColors.surfaceHighlight,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              isCompleted ? Icons.check : Icons.circle,
                              color: isActive ? AppColors.primary : AppColors.textSecondary,
                              size: 16.r,
                            ),
                          ),
                          SizedBox(width: AppSpacing.md.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['status'] as String,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                                  ),
                                ),
                                if (step['time'] != '')
                                  Text(
                                    step['time'] as String,
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (index * 100).ms),
                  );
                }).values.toList(),
              ),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2);
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.cancel_outlined, size: 18.r),
              label: Text(
                'CANCEL',
                style: AppTypography.labelMedium,
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                foregroundColor: AppColors.error,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.payment, size: 18.r),
              label: Text(
                'PAY ESCROW',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.background,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, delay: 200.ms);
  }
}