import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final bool hasBorder;
  final List<BoxShadow>? boxShadow;
  final EdgeInsets? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.hasBorder = true,
    this.boxShadow,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface.withOpacity(0.7),
        borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.radiusLg.r),
        border: hasBorder
            ? Border.all(
                color: AppColors.glassBorder.withOpacity(0.5),
                width: 1,
              )
            : null,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: Offset(0, 8.h),
              ),
            ],
      ),
      child: child,
    );
  }
}

class NeonStatusIndicator extends StatefulWidget {
  final bool isActive;
  final Color activeColor;
  final double size;

  const NeonStatusIndicator({
    super.key,
    required this.isActive,
    this.activeColor = const Color(0xFF00E5FF),
    this.size = 12,
  });

  @override
  State<NeonStatusIndicator> createState() => _NeonStatusIndicatorState();
}

class _NeonStatusIndicatorState extends State<NeonStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size.r,
          height: widget.size.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isActive
                ? widget.activeColor
                : AppColors.textSecondary.withOpacity(0.3),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: widget.activeColor.withOpacity(_animation.value * 0.8),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      hasBorder: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.r, color: color),
              SizedBox(width: AppSpacing.xs.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              style: AppTypography.caption.copyWith(
                color: color,
                fontSize: 10.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class QuickActionGrid extends StatelessWidget {
  final VoidCallback onScannerTap;
  final VoidCallback onEarningsTap;
  final VoidCallback onJobsTap;
  final VoidCallback onWalletTap;

  const QuickActionGrid({
    super.key,
    required this.onScannerTap,
    required this.onEarningsTap,
    required this.onJobsTap,
    required this.onWalletTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md.w,
      mainAxisSpacing: AppSpacing.md.h,
      childAspectRatio: 1.2,
      children: [
        _ActionTile(
          icon: Icons.qr_code_scanner,
          label: 'AI Scanner',
          color: AppColors.accentCyan,
          onTap: onScannerTap,
        ),
_ActionTile(
           icon: Icons.currency_rupee,
           label: 'Earnings',
           color: AppColors.success,
           onTap: onEarningsTap,
         ),
        _ActionTile(
          icon: Icons.work_outline,
          label: 'My Jobs',
          color: AppColors.primaryGold,
          onTap: onJobsTap,
        ),
        _ActionTile(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Wallet',
          color: AppColors.accentCyan,
          onTap: onWalletTap,
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      hasBorder: false,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.r),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: const Color.fromARGB(255, 86, 22, 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionText!,
              style: AppTypography.caption.copyWith(
                color: AppColors.accentCyan,
              ),
            ),
          ),
      ],
    );
  }
}