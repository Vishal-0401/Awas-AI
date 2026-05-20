import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Simulated Map Background
          Positioned.fill(
            child: Image.network(
              'https://via.placeholder.com/800x1200.png?text=Live+Map+Tracking',
              fit: BoxFit.cover,
            ),
          ),
          
          // App Bar Area (Floating)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: CircleAvatar(
              backgroundColor: AppColors.surface,
              child: IconButton(
                icon:  Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
          ),

          // Bottom Info Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.background.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('15 MIN AWAY', style: AppTypography.h2.copyWith(color: AppColors.primary)),
                          Text('2.5 km • Sector 42', style: AppTypography.bodyMedium),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        radius: 25,
                        child: Icon(Icons.navigation, color: AppColors.primary),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                   Divider(color: AppColors.surfaceHighlight),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.surfaceHighlight,
                        child: Icon(Icons.person, color: AppColors.textPrimary),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amit Sharma', style: AppTypography.bodyLarge),
                            Text('Customer', style: AppTypography.caption),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.call, color: AppColors.success),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => context.push('/active-job'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    ),
                    child: const Text('ARRIVED AT LOCATION'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
