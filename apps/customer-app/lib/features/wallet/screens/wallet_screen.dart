import 'package:awas_customer_app/core/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:awas_customer_app/core/constants/app_typography.dart';
import 'package:awas_customer_app/core/constants/spacing.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'WALLET',
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBalanceCard(),
                SizedBox(height: AppSpacing.lg.h),
                _buildQuickActions(),
                SizedBox(height: AppSpacing.lg.h),
                _buildRecentTransactions(),
                SizedBox(height: AppSpacing.xxl.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BALANCE',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            '₹2,450.00',
            style: AppTypography.h1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem('Available', '₹2,000'),
              ),
              Expanded(
                child: _buildBalanceItem('In Escrow', '₹450'),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.account_balance_wallet, color: AppColors.background, size: 18.r),
              label: Text(
                'ADD MONEY',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.background,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildBalanceItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTypography.h4.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.arrow_upward, 'label': 'Withdraw', 'color': AppColors.error},
      {'icon': Icons.history, 'label': 'History', 'color': AppColors.primary},
      {'icon': Icons.card_giftcard, 'label': 'Offers', 'color': AppColors.success},
    ];

    return Row(
      children: actions.asMap().map((index, action) {
        return MapEntry(
          index,
          Expanded(
            child: GlassCard(
              margin: EdgeInsets.symmetric(horizontal: 4.r),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                children: [
                  Icon(action['icon'] as IconData, color: action['color'] as Color, size: 24.r),
                  SizedBox(height: 4.h),
                  Text(
                    action['label'] as String,
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ).animate().scale(delay: (index * 100).ms),
          ),
        );
      }).values.toList(),
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = List.generate(5, (index) => {
          'title': index % 2 == 0 ? 'AC Service Payment' : 'Wallet Top-up',
          'date': 'Today, ${2 + index}:00 PM',
          'amount': index % 2 == 0 ? '-₹599' : '+₹1000',
          'status': 'Completed',
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT TRANSACTIONS',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        GlassCard(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
          child: Column(
            children: transactions.asMap().map((index, txn) {
              final isNegative = (txn['amount'] as String).startsWith('-');
              return MapEntry(
                index,
                ListTile(
                  leading: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: isNegative
                          ? AppColors.error.withOpacity(0.2)
                          : AppColors.success.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isNegative ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isNegative ? AppColors.error : AppColors.success,
                      size: 20.r,
                    ),
                  ),
                  title: Text(
                    txn['title'] as String,
                    style: AppTypography.bodyMedium,
                  ),
                  subtitle: Text(
                    txn['date'] as String,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: Text(
                    txn['amount'] as String,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isNegative ? AppColors.error : AppColors.success,
                    ),
                  ),
                ).animate().slideX(begin: -0.1, delay: (index * 50).ms),
              );
            }).values.toList(),
          ),
        ),
      ],
    );
  }
}