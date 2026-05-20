import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('WORKER IDENTITY'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.primary),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileHeader(),
              SizedBox(height: AppSpacing.lg),
              _buildStatsRow(),
              SizedBox(height: AppSpacing.lg),
              _buildMenuCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceHighlight),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Icon(Icons.person, size: 40, color: AppColors.primary),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified, size: 12, color: AppColors.background),
                ),
              )
            ],
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ramesh Kumar', style: AppTypography.h2),
                Text('Expert Electrician', style: AppTypography.bodyMedium),
                SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Level 3 Worker', style: AppTypography.caption.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Jobs', '342')),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _buildStatCard('Rating', '4.8 ★')),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _buildStatCard('Experience', '3 Yrs')),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Text(value, style: AppTypography.h3),
          SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.verified_user, 'KYC Verification', '/kyc', true),
           Divider(color: AppColors.surfaceHighlight, height: 1),
          _buildMenuItem(context, Icons.schedule, 'Availability Schedule', '', false),
           Divider(color: AppColors.surfaceHighlight, height: 1),
          _buildMenuItem(context, Icons.language, 'Language Preferences', '', false),
           Divider(color: AppColors.surfaceHighlight, height: 1),
          _buildMenuItem(context, Icons.help_outline, 'Help & Support', '', false),
           Divider(color: AppColors.surfaceHighlight, height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error),
            title: Text('Sign Out', style: AppTypography.bodyLarge.copyWith(color: AppColors.error)),
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route, bool isVerified) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTypography.bodyLarge),
      trailing: isVerified 
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Verified', style: AppTypography.caption.copyWith(color: AppColors.success)),
            )
          : Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
      onTap: route.isNotEmpty ? () => context.push(route) : null,
    );
  }
}
