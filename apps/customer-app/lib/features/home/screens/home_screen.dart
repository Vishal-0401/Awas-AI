import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:awas_customer_app/core/constants/app_typography.dart';
import 'package:awas_customer_app/core/constants/spacing.dart';
import 'package:awas_customer_app/core/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                SizedBox(height: AppSpacing.lg.h),
                _buildHomeHealthScore(),
                SizedBox(height: AppSpacing.lg.h),
                _buildApplianceGrid(),
                SizedBox(height: AppSpacing.lg.h),
                _buildLiveWorkers(),
                SizedBox(height: AppSpacing.lg.h),
                _buildQuickActions(),
                SizedBox(height: AppSpacing.xxl.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AWAS HOME',
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(duration: 300.ms),
            SizedBox(height: 4.h),
            Text(
              'Good Evening, User',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(duration: 400.ms),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_none, color: AppColors.textPrimary, size: 24.r),
              onPressed: () {},
            ),
            Positioned(
              right: 10.w,
              top: 10.h,
              child: Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
                duration: 800.ms,
                begin: const Offset(0.8, 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHomeHealthScore() {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HOME HEALTH',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'AI DIAGNOSTICS',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140.r,
                height: 140.r,
                child: CircularProgressIndicator(
                  value: 0.78,
                  strokeWidth: 12.r,
                  backgroundColor: AppColors.surfaceHighlight.withOpacity(0.3),
                  color: AppColors.success,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '78',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'GOOD',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ).animate().scale(duration: 500.ms),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHealthMetric('APPLIANCES', '8/10'),
              _buildHealthMetric('LAST SCAN', '2d ago'),
              _buildHealthMetric('ALERTS', '2'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildHealthMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.h4.copyWith(
            color: AppColors.textPrimary,
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

  Widget _buildApplianceGrid() {
    final appliances = [
      {'name': 'AC Unit', 'type': 'Split', 'health': 92, 'icon': Icons.ac_unit},
      {'name': 'Water Purifier', 'type': 'RO', 'health': 65, 'icon': Icons.water_drop},
      {'name': 'Washing Machine', 'type': 'Front Load', 'health': 45, 'icon': Icons.local_laundry_service},
      {'name': 'Refrigerator', 'type': 'Double Door', 'health': 88, 'icon': Icons.kitchen},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'APPLIANCES',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md.w,
            mainAxisSpacing: AppSpacing.md.h,
            childAspectRatio: 1,
          ),
          itemCount: appliances.length,
          itemBuilder: (context, index) {
            final appliance = appliances[index];
            return GlassCard(
              padding: EdgeInsets.all(AppSpacing.md.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    appliance['icon'] as IconData,
                    color: _getHealthColor(appliance['health'] as int),
                    size: 32.r,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    appliance['name'] as String,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${appliance['health']}% • ${appliance['type']}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (200 + index * 100).ms);
          },
        ),
      ],
    );
  }

  Color _getHealthColor(int health) {
    if (health >= 80) return AppColors.success;
    if (health >= 50) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildLiveWorkers() {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NEARBY WORKERS',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '5 ONLINE',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: AppSpacing.md.w),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 50.r,
                            height: 50.r,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceHighlight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person, color: AppColors.primary, size: 24.r),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12.r,
                              height: 12.r,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.background, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Worker ${index + 1}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ).animate().scale(delay: (index * 50).ms);
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.qr_code_scanner, 'label': 'AI Scan', 'color': AppColors.primary},
      {'icon': Icons.emergency, 'label': 'Emergency', 'color': AppColors.error},
      {'icon': Icons.schedule, 'label': 'Schedule', 'color': AppColors.warning},
      {'icon': Icons.history, 'label': 'History', 'color': AppColors.accentCyan},
    ];

    return Row(
      children: actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;
        return Expanded(
          child: GlassCard(
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs.r),
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
            child: Column(
              children: [
                Icon(
                  action['icon'] as IconData,
                  color: action['color'] as Color,
                  size: 24.r,
                ),
                SizedBox(height: 4.h),
                Text(
                  action['label'] as String,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ).animate().scale(delay: (500 + index * 100).ms),
        );
      }).toList(),
    );
  }
}