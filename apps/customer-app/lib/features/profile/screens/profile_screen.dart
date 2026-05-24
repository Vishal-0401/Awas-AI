import 'package:awas_customer_app/core/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:awas_customer_app/core/constants/app_typography.dart';
import 'package:awas_customer_app/core/constants/spacing.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'PROFILE',
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md.r),
            child: Column(
              children: [
                _buildProfileHeader(),
                SizedBox(height: AppSpacing.lg.h),
                _buildStats(),
                SizedBox(height: AppSpacing.lg.h),
                _buildMenu(),
                SizedBox(height: AppSpacing.xxl.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80.r,
                height: 80.r,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceHighlight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: AppColors.primary, size: 40.r),
              ),
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: Icon(Icons.edit, color: AppColors.background, size: 14.r),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'Vishal Kumar',
            style: AppTypography.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '+91 98765 43210',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'vishal@example.com',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildStats() {
    final stats = [
      {'label': 'Total Bookings', 'value': '127'},
      {'label': 'Favorites', 'value': '8'},
      {'label': 'Reviews', 'value': '4.8'},
    ];

    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.asMap().map((index, stat) {
          return MapEntry(
            index,
            Column(
              children: [
                Text(
                  stat['value']!,
                  style: AppTypography.h3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  stat['label']!,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ).animate().scale(delay: (index * 100).ms),
          );
        }).values.toList(),
      ),
    );
  }

  Widget _buildMenu() {
    final menuItems = [
      {'icon': Icons.home, 'label': 'My Home', 'route': '/dashboard'},
      {'icon': Icons.history, 'label': 'Booking History', 'route': null},
      {'icon': Icons.favorite, 'label': 'Favorite Workers', 'route': null},
      {'icon': Icons.payment, 'label': 'Payment Methods', 'route': null},
      {'icon': Icons.card_giftcard, 'label': 'Rewards', 'route': null},
      {'icon': Icons.support_agent, 'label': 'Support', 'route': null},
      {'icon': Icons.settings, 'label': 'Settings', 'route': null},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCOUNT',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        GlassCard(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
          child: Column(
            children: menuItems.asMap().map((index, item) {
              return MapEntry(
                index,
                ListTile(
                  leading: Icon(item['icon'] as IconData, color: AppColors.primary),
                  title: Text(
                    item['label'] as String,
                    style: AppTypography.bodyMedium,
                  ),
                  trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20.r),
                  onTap: () {
                    if (item['route'] != null) {
                      // Navigator.pushNamed(context, item['route'] as String);
                    }
                  },
                ).animate().slideX(begin: -0.1, delay: (index * 50).ms),
              );
            }).values.toList(),
          ),
        ),
      ],
    );
  }
}