import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ALERTS'),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: 8,
          separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            bool isNew = index < 2;
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isNew ? AppColors.surfaceHighlight : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: isNew ? AppColors.primary.withOpacity(0.5) : Colors.transparent,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Icon(
                      index % 3 == 0 ? Icons.monetization_on : Icons.campaign,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              index % 3 == 0 ? 'Payment Received' : 'New Dispatch Available',
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            if (isNew)
                              Container(
                                width: 8,
                                height: 8,
                      decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          index % 3 == 0
                              ? '₹450 has been credited to your wallet for Job #847294'
                              : 'A new plumbing repair job is available in your area.',
                          style: AppTypography.bodyMedium,
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text('10 mins ago', style: AppTypography.caption),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
