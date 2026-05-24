import 'package:awas_customer_app/core/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:awas_customer_app/core/constants/app_typography.dart';
import 'package:awas_customer_app/core/constants/spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white, size: 28.r),
            onPressed: () {
              context.push('/notifications');
            },
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: dashboardState.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to load dashboard\n$error', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.read(dashboardProvider.notifier).fetchDashboardData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (data) => SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildGreeting(data.userName, data.address),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildEmergencyBanner(),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildHomeHealthScore(data.healthScore, data.appliancesCount, data.lastScan, data.alertsCount),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildLiveWorkerStatus(data.nearbyWorkers),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildServiceCategories(),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildPredictiveAlerts(data.predictiveAlerts),
                  SizedBox(height: 100.h), // Padding for bottom nav
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(String name, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning, $name',
          style: AppTypography.h2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
        SizedBox(height: 4.h),
        Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Text(
              address,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
      ],
    );
  }

  Widget _buildEmergencyBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.error.withOpacity(0.8), AppColors.error.withOpacity(0.4)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.electric_bolt_rounded, color: Colors.white),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emergency Issue?', style: AppTypography.h4.copyWith(color: Colors.white)),
                Text('Get a technician in 30 mins', style: AppTypography.caption.copyWith(color: Colors.white70)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2);
  }

  Widget _buildLiveWorkerStatus(int count) {
    return GlassCard(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count Experts Nearby', style: AppTypography.h4.copyWith(color: Colors.white)),
                Text('Available for instant booking', style: AppTypography.caption.copyWith(color: Colors.white70)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildServiceCategories() {
    final categories = [
      {'icon': Icons.ac_unit, 'label': 'AC Service', 'color': Colors.blueAccent},
      {'icon': Icons.water_drop, 'label': 'Plumbing', 'color': Colors.teal},
      {'icon': Icons.electrical_services, 'label': 'Electrical', 'color': Colors.orange},
      {'icon': Icons.cleaning_services, 'label': 'Cleaning', 'color': Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SERVICES', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, letterSpacing: 1.5)),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((cat) {
            return Column(
              children: [
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: BoxDecoration(
                    color: (cat['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: (cat['color'] as Color).withOpacity(0.3)),
                  ),
                  child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 28),
                ),
                SizedBox(height: 8.h),
                Text(cat['label'] as String, style: AppTypography.caption.copyWith(color: Colors.white70)),
              ],
            ).animate().scale(delay: 500.ms);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHomeHealthScore(int score, int appliances, String lastScan, int alerts) {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HOME HEALTH SCORE',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusRound.r),
                ),
                child: Text(
                  'AI MONITORED',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.success,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120.r,
                height: 120.r,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: AppColors.surfaceHighlight,
                  color: AppColors.primary,
                ),
              ),
              Column(
                children: [
                  Text('$score', style: AppTypography.h1.copyWith(color: Colors.white, fontSize: 36.sp)),
                  Text(score > 70 ? 'Good' : 'Needs Check', style: AppTypography.caption.copyWith(color: score > 70 ? AppColors.success : AppColors.warning)),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreMetric('APPLIANCES', '$appliances/10'),
              _buildScoreMetric('LAST SCAN', lastScan),
              _buildScoreMetric('ALERTS', '$alerts', color: AppColors.warning),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildScoreMetric(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.h4.copyWith(
            color: color ?? AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictiveAlerts(List<dynamic> alerts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PREDICTIVE ALERTS',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        if (alerts.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No critical alerts right now.", style: TextStyle(color: Colors.white54)),
          )
        else
          ...alerts.asMap().map((index, alert) {
            final severity = alert['severity'] as String;
            final color = severity == 'high' ? AppColors.error : AppColors.warning;
            final icon = severity == 'high' ? Icons.water_drop : Icons.ac_unit; // Simplification mapping
            return MapEntry(
              index,
              GlassCard(
                margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
                padding: EdgeInsets.all(AppSpacing.md.r),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 20.r),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert['title'] as String,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            alert['description'] as String,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().slideX(delay: (index * 100).ms),
            );
          }).values,
      ],
    );
  }
}
