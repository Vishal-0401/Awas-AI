import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/spacing.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final bool hasBorder;
  final List<BoxShadow>? boxShadow;
  final EdgeInsets? margin;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.hasBorder = true,
    this.boxShadow,
    this.margin,
    this.blur = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface.withOpacity(0.6),
        borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.radiusLg.r),
        border: hasBorder
            ? Border.all(
                color: AppColors.glassBorder.withOpacity(0.3),
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

class NeonGlowCard extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final EdgeInsets? padding;
  final bool isActive;

  const NeonGlowCard({
    super.key,
    required this.child,
    required this.glowColor,
    this.padding,
    this.isActive = true,
  });

  @override
  State<NeonGlowCard> createState() => _NeonGlowCardState();
}

class _NeonGlowCardState extends State<NeonGlowCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
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
          margin: EdgeInsets.all(AppSpacing.xs.r),
          padding: widget.padding ?? EdgeInsets.all(AppSpacing.md.r),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.8),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            border: Border.all(
              color: widget.glowColor.withOpacity(_animation.value * 0.5),
              width: 1,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: widget.glowColor.withOpacity(_animation.value * 0.2),
                      blurRadius: 20 * _animation.value,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class HealthScoreRing extends StatelessWidget {
  final double score;
  final double size;
  final Color? color;

  const HealthScoreRing({
    super.key,
    required this.score,
    this.size = 120,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? _getScoreColor(score);
    return SizedBox(
      width: size.r,
      height: size.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size.r,
            height: size.r,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 8.r,
              backgroundColor: AppColors.surfaceHighlight.withOpacity(0.3),
              color: progressColor,
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${score.toInt()}',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
              Text(
                'HEALTH',
                style: TextStyle(
                  fontSize: 10.sp,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }
}

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: AppColors.textPrimary,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}