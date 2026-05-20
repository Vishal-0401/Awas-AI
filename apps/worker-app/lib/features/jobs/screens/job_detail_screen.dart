import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('DISPATCH DETAILS'),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: AppSpacing.lg),
              _buildCustomerInfo(),
              SizedBox(height: AppSpacing.lg),
              _buildJobDescription(),
              SizedBox(height: AppSpacing.lg),
              _buildLocationMap(),
              SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: () => context.push('/active-job'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
                child: const Text('PROCEED TO LOCATION'),
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('JOB #847294', style: AppTypography.caption),
              SizedBox(height: AppSpacing.xs),
              Text('Plumbing Repair', style: AppTypography.h3),
            ],
          ),
          Text('₹ 450', style: AppTypography.h2.copyWith(color: AppColors.success)),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CUSTOMER', style: AppTypography.caption),
        SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
             border: Border.all(color: AppColors.success, width: 2),
                  
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amit Sharma', style: AppTypography.bodyLarge),
                    Text('4.8 ★ Rating', style: AppTypography.bodyMedium),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.call, color: AppColors.primary),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJobDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DESCRIPTION', style: AppTypography.caption),
        SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Text(
            'The kitchen sink pipe is leaking heavily. Needs immediate repair or replacement of the joint.',
            style: AppTypography.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LOCATION', style: AppTypography.caption),
        SizedBox(height: AppSpacing.sm),
        Container(
          height: 150.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceHighlight,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/400x150.png?text=Map+Route'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text('B-402, Green Valley Apartments, Sector 42', style: AppTypography.bodyMedium),
      ],
    );
  }
}
