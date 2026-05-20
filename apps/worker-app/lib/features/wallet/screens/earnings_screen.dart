import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('EARNINGS REPORT'),
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
              _buildSummaryCard(),
              SizedBox(height: AppSpacing.lg),
              Text('WEEKLY BREAKDOWN', style: AppTypography.h3),
              SizedBox(height: AppSpacing.md),
              _buildWeeklyChart(),
              SizedBox(height: AppSpacing.lg),
              _buildDailyList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text('THIS WEEK', style: AppTypography.caption),
          SizedBox(height: AppSpacing.sm),
          Text('₹ 4,250', style: AppTypography.h1.copyWith(color: AppColors.success)),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('JOBS', '12'),
              _buildStat('HOURS', '28h'),
              _buildStat('RATING', '4.9 ★'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.h3),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBar('Mon', 0.4),
          _buildBar('Tue', 0.7),
          _buildBar('Wed', 0.5),
          _buildBar('Thu', 0.9),
          _buildBar('Fri', 0.6),
          _buildBar('Sat', 0.8),
          _buildBar('Sun', 0.2),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double heightFactor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 150 * heightFactor,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(day, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildDailyList() {
    return Column(
      children: List.generate(5, (index) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Oct ${15 - index}', style: AppTypography.bodyLarge),
          subtitle: Text('${3 + index % 2} Jobs Completed', style: AppTypography.caption),
          trailing: Text('₹ ${800 + (index * 150)}', style: AppTypography.h3.copyWith(color: AppColors.success)),
        );
      }),
    );
  }
}
