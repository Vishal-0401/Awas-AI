import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/widgets/premium_dashboard_widgets.dart';

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'OPERATOR CONSOLE',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: AppColors.textPrimary),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                right: 12.w,
                top: 12.h,
                child: NeonStatusIndicator(
                  isActive: true,
                  activeColor: AppColors.accentCyan,
                  size: 8,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: AppColors.accentCyan),
            onPressed: () => context.push('/ai-scanner'),
          ),
          SizedBox(width: AppSpacing.sm.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.sm.h),
              _buildOnlineStatusCard(),
              SizedBox(height: AppSpacing.lg.h),
              _buildEarningsCard(),
              SizedBox(height: AppSpacing.lg.h),
              _buildMetricsRow(),
              SizedBox(height: AppSpacing.lg.h),
              SectionHeader(
                title: 'ACTIVE DISPATCH',
                actionText: 'View All',
                onActionTap: () {},
              ),
              SizedBox(height: AppSpacing.md.h),
              _buildActiveDispatchCard(),
              SizedBox(height: AppSpacing.lg.h),
              SectionHeader(title: 'PERFORMANCE METRICS'),
              SizedBox(height: AppSpacing.md.h),
              _buildPerformanceGrid(),
              SizedBox(height: AppSpacing.lg.h),
              SectionHeader(title: 'QUICK ACTIONS'),
              SizedBox(height: AppSpacing.md.h),
              QuickActionGrid(
                onScannerTap: () => context.push('/ai-scanner'),
                onEarningsTap: () {},
                onJobsTap: () {},
                onWalletTap: () => context.push('/wallet'),
              ),
              SizedBox(height: AppSpacing.xxl.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineStatusCard() {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      color: _isOnline
          ? AppColors.accentCyan.withOpacity(0.05)
          : AppColors.surface,
      boxShadow: _isOnline
          ? [
              BoxShadow(
                color: AppColors.accentCyan.withOpacity(0.1),
                blurRadius: 25,
                spreadRadius: 0,
              ),
            ]
          : null,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SYSTEM STATUS',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    _isOnline ? 'ONLINE & READY' : 'OFFLINE',
                    style: AppTypography.h3.copyWith(
                      color: _isOnline ? AppColors.accentCyan : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isOnline,
                activeThumbColor: AppColors.accentCyan,
                inactiveThumbColor: AppColors.textSecondary,
                inactiveTrackColor: AppColors.surfaceHighlight,
                onChanged: (val) => setState(() => _isOnline = val),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),
          if (_isOnline) ...[
            SizedBox(height: AppSpacing.md.h),
            Divider(color: AppColors.surfaceHighlight),
            SizedBox(height: AppSpacing.md.h),
            Row(
              children: [
                NeonStatusIndicator(isActive: true, size: 12),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  'Scanning for nearby dispatches...',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ).animate().slideX(begin: -0.2).fadeIn(),
          ],
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      color: AppColors.primaryGold.withOpacity(0.05),
      hasBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TODAY'S EARNINGS",
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              Icon(
                Icons.trending_up,
                color: AppColors.success,
                size: 20.r,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹1,240',
                style: AppTypography.h1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                '+12.5%',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          LinearProgressIndicator(
            value: 0.65,
            backgroundColor: AppColors.surfaceHighlight,
            color: AppColors.primaryGold,
            minHeight: 4.h,
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Goal: ₹2,000',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2).fadeIn();
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: MetricCard(
            title: 'COMPLETED',
            value: '4 Jobs',
            icon: Icons.check_circle_outline,
            color: AppColors.success,
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: MetricCard(
            title: 'RATING',
            value: '4.9',
            icon: Icons.star_outline,
            color: AppColors.primaryGold,
            subtitle: 'Excellent',
          ),
        ),
      ],
    ).animate().slideX(begin: -0.2).fadeIn(delay: 100.ms);
  }

  Widget _buildActiveDispatchCard() {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NeonStatusIndicator(isActive: true, size: 8),
                    SizedBox(width: AppSpacing.xs.w),
                    Text(
                      'IN PROGRESS',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '2.5 km away',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighlight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: AppColors.accentCyan, size: 24.r),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John Doe', style: AppTypography.bodyLarge),
                    Text(
                      'Electrical Repair',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.navigation, color: AppColors.accentCyan),
                onPressed: () => context.push('/live-tracking'),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/job/123'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                ),
              ),
              child: Text(
                'VIEW DETAILS',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideX(begin: 0.2).fadeIn(delay: 200.ms);
  }

  Widget _buildPerformanceGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md.w,
      mainAxisSpacing: AppSpacing.md.h,
      childAspectRatio: 1.3,
      children: [
        MetricCard(
          title: 'ON TIME',
          value: '98%',
          icon: Icons.access_time,
          color: AppColors.accentCyan,
        ),
        MetricCard(
          title: 'CANCEL RATE',
          value: '2%',
          icon: Icons.cancel_outlined,
          color: AppColors.success,
        ),
        MetricCard(
          title: 'AVG TIME',
          value: '45 min',
          icon: Icons.timer,
          color: AppColors.primaryGold,
        ),
        MetricCard(
          title: 'TODAY',
          value: '4 jobs',
          icon: Icons.work_outline,
          color: AppColors.accentCyan,
        ),
      ],
    ).animate().slideY(begin: 0.2).fadeIn(delay: 300.ms);
  }
}