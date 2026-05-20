import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class WorkerJobsScreen extends StatelessWidget {
  const WorkerJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('DISPATCH QUEUE'),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'AVAILABLE'),
              Tab(text: 'COMPLETED'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAvailableJobs(context),
            _buildCompletedJobs(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableJobs(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return _buildJobCard(context, isActive: true);
      },
    );
  }

  Widget _buildCompletedJobs(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 3,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return _buildJobCard(context, isActive: false);
      },
    );
  }

  Widget _buildJobCard(BuildContext context, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.surfaceHighlight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('JOB #847294', style: AppTypography.caption),
              Text(
                isActive ? '₹ 450' : '₹ 320',
                style: AppTypography.h3.copyWith(color: AppColors.success),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text('Plumbing Repair', style: AppTypography.bodyLarge),
          SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
              SizedBox(width: AppSpacing.xs),
              Text('Sector 42, 3.2 km away', style: AppTypography.bodyMedium),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          if (isActive)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side:  BorderSide(color: AppColors.error),
                    ),
                    child: const Text('REJECT'),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.push('/job/847294'),
                    child: const Text('ACCEPT'),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: AppColors.primary),
                SizedBox(width: AppSpacing.xs),
                Text('Completed on 12 Oct', style: AppTypography.caption.copyWith(color: AppColors.primary)),
              ],
            )
        ],
      ),
    );
  }
}
