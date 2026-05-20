import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('WALLET & ESCROW')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBalanceCard(context),
              SizedBox(height: AppSpacing.lg),
              _buildActionRow(context),
              SizedBox(height: AppSpacing.lg),
              _buildEscrowSection(),
              SizedBox(height: AppSpacing.lg),
              _buildTransactionHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text('AVAILABLE BALANCE', style: AppTypography.caption.copyWith(color: AppColors.background)),
          SizedBox(height: AppSpacing.sm),
          Text('₹ 12,450', style: AppTypography.h1.copyWith(color: AppColors.background, fontSize: 40)),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_balance, size: 16, color: AppColors.background),
                SizedBox(width: AppSpacing.xs),
                Text('Linked to UPI: ****8421', style: AppTypography.bodyMedium.copyWith(color: AppColors.background)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.push('/withdrawal'),
            icon: const Icon(Icons.arrow_upward),
            label: const Text('WITHDRAW'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceHighlight,
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.push('/earnings'),
            icon: const Icon(Icons.analytics),
            label: const Text('EARNINGS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceHighlight,
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEscrowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('IN ESCROW', style: AppTypography.h3),
        SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.warning.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Awaiting Customer Approval', style: AppTypography.bodyMedium),
                  SizedBox(height: AppSpacing.xs),
                  Text('2 Jobs Pending', style: AppTypography.caption),
                ],
              ),
              Text('₹ 850', style: AppTypography.h2.copyWith(color: AppColors.warning)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RECENT TRANSACTIONS', style: AppTypography.h3),
        SizedBox(height: AppSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          separatorBuilder: (context, index) =>  Divider(color: AppColors.surfaceHighlight),
          itemBuilder: (context, index) {
            bool isCredit = index % 2 == 0;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: (isCredit ? AppColors.success : AppColors.textSecondary).withOpacity(0.2),
                child: Icon(
                  isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isCredit ? AppColors.success : AppColors.textSecondary,
                ),
              ),
              title: Text(isCredit ? 'Job #84729${index}' : 'Withdrawal to Bank', style: AppTypography.bodyLarge),
              subtitle: Text('Today, 14:30 PM', style: AppTypography.caption),
              trailing: Text(
                '${isCredit ? '+' : '-'} ₹ ${isCredit ? '450' : '2000'}',
                style: AppTypography.h3.copyWith(
                  color: isCredit ? AppColors.success : AppColors.textSecondary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
