import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

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
      appBar: AppBar(
        title: const Text('CONSOLE'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_none, color: AppColors.textPrimary),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: AppColors.primary),
            onPressed: () => context.push('/ai-scanner'),
          ),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatusCard(),
              SizedBox(height: AppSpacing.lg),
              _buildMetricsRow(),
              SizedBox(height: AppSpacing.lg),
              _buildActiveDispatch(),
              SizedBox(height: AppSpacing.lg),
              _buildHeatMap(),
              SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: _isOnline ? AppColors.online : AppColors.surfaceHighlight,
          width: 2,
        ),
        boxShadow: _isOnline
            ? [
                BoxShadow(
                  color: AppColors.online.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SYSTEM STATUS', style: AppTypography.caption),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    _isOnline ? 'ONLINE & READY' : 'OFFLINE',
                    style: AppTypography.h3.copyWith(
                      color: _isOnline ? AppColors.online : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isOnline,
                activeThumbColor: AppColors.online,
                inactiveThumbColor: AppColors.textSecondary,
                inactiveTrackColor: AppColors.surfaceHighlight,
                onChanged: (val) => setState(() => _isOnline = val),
              ),
            ],
          ),
          if (_isOnline) ...[
            SizedBox(height: AppSpacing.md),
            Divider(color: AppColors.surfaceHighlight),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.radar, color: AppColors.primary, size: 20),
                SizedBox(width: AppSpacing.sm),
                Text('Scanning for nearby dispatches...', style: AppTypography.bodyMedium),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: "TODAY's EARNINGS",
            value: '₹1,240',
            icon: Icons.currency_rupee,
           color: AppColors.success!,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildMetricCard(
            title: 'COMPLETED',
            value: '4 Jobs',
            icon: Icons.check_circle_outline,
            color: AppColors.primary!,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: AppSpacing.xs),
              Expanded(child: Text(title, style: AppTypography.caption, overflow: TextOverflow.ellipsis)),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.h3),
        ],
      ),
    );
  }

  Widget _buildActiveDispatch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ACTIVE DISPATCH', style: AppTypography.h3),
        SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.primary!.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary!.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('IN PROGRESS', style: AppTypography.caption.copyWith(color: AppColors.primary)),
                  ),
                  Text('2.5 km away', style: AppTypography.caption),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighlight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.person, color: AppColors.primary),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: AppTypography.bodyLarge),
                        Text('Electrical Repair', style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.navigation, color: AppColors.primary),
                    onPressed: () => context.push('/live-tracking'),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/job/123'),
                  child: const Text('VIEW DETAILS'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeatMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DEMAND HEATMAP', style: AppTypography.h3),
        SizedBox(height: AppSpacing.md),
        Container(
          height: 150.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceHighlight,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/400x150.png?text=Map+Placeholder'), // Placeholder
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_fire_department, color: AppColors.error, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  Text('High demand nearby', style: AppTypography.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
