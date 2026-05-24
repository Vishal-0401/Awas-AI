import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:awas_customer_app/core/constants/app_typography.dart';
import 'package:awas_customer_app/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';


class AiScannerScreen extends StatefulWidget {
  const AiScannerScreen({super.key});

  @override
  State<AiScannerScreen> createState() => _AiScannerScreenState();
}

class _AiScannerScreenState extends State<AiScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AI APPLIANCE SCANNER',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black87,
            child: Center(
              child: Icon(
                Icons.camera_alt,
                size: 80.r,
                color: AppColors.surfaceHighlight,
              ),
            ),
          ),
          Positioned(
            top: 120.h,
            left: 40.w,
            right: 40.w,
            child: _buildScanOverlay(),
          ),
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: _buildInstructions(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanAppliance,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.qr_code_scanner, color: AppColors.background),
        label: Text(
          'SCAN',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.background,
          ),
        ),
      ),
    );
  }

  Widget _buildScanOverlay() {
    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 240.r,
              height: 240.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 2,
                ),
              ),
            ),
            Positioned(
              top: _scanController.value * 200,
              child: Container(
                width: 200.r,
                height: 2.r,
                color: AppColors.primary.withOpacity(0.8),
              ),
            ),
            ...List.generate(4, (index) {
              final alignment = [
                Alignment.topLeft,
                Alignment.topRight,
                Alignment.bottomLeft,
                Alignment.bottomRight,
              ][index];
              return Positioned.fill(
                child: Align(
                  alignment: alignment,
                  child: Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(
                      border: Border(
                        top: index < 2
                            ? const BorderSide(color: AppColors.primary, width: 3)
                            : BorderSide.none,
                        bottom: index >= 2
                            ? const BorderSide(color: AppColors.primary, width: 3)
                            : BorderSide.none,
                        left: [0, 2].contains(index)
                            ? const BorderSide(color: AppColors.primary, width: 3)
                            : BorderSide.none,
                        right: [1, 3].contains(index)
                            ? const BorderSide(color: AppColors.primary, width: 3)
                            : BorderSide.none,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    ).animate().fadeIn();
  }

  Widget _buildInstructions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Column(
        children: [
          Text(
            'Position appliance label within frame',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 16.r),
              SizedBox(width: 8.w),
              Text(
                'AI will detect model and predict issues',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2);
  }

  void _scanAppliance() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildScanResult(),
    );
  }

  Widget _buildScanResult() {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl.r)),
      ),
      padding: EdgeInsets.all(AppSpacing.lg.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DIAGNOSTIC RESULT',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.textSecondary, size: 20.r),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighlight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                ),
                child: Icon(Icons.ac_unit, color: AppColors.primary, size: 40.r),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LG Split AC 1.5T',
                      style: AppTypography.h4,
                    ),
                    Text(
                      'Model: AS18VMC',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Container(
            padding: EdgeInsets.all(AppSpacing.md.r),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: AppColors.warning, size: 24.r),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Text(
                    'Filter efficiency dropped to 65%. Replace soon.',
                    style: AppTypography.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'RECOMMENDED ACTION',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            '• Replace AC filter (₹899)',
            style: AppTypography.bodyMedium,
          ),
          Text(
            '• Estimated service time: 15 mins',
            style: AppTypography.bodyMedium,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 48.h),
            ),
            child: Text(
              'BOOK SERVICE',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.background,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1);
  }
}