import 'package:awas_customer_app/core/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:awas_customer_app/core/constants/app_typography.dart';
import 'package:awas_customer_app/core/constants/spacing.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showMap = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'BOOK SERVICE',
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(AppSpacing.md.r),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search services...',
                          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                        ),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    ToggleButtons(
                      isSelected: [_showMap, !_showMap],
                      onPressed: (index) {
                        setState(() => _showMap = index == 0);
                      },
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                      selectedColor: AppColors.background,
                      fillColor: AppColors.primary,
                      color: AppColors.textSecondary,
                      borderColor: AppColors.surfaceHighlight,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.map, size: 20),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.list, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _showMap ? _buildMapView() : _buildListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        Container(
          color: AppColors.background,
          child: Center(
            child: Icon(
              Icons.map,
              size: 80.r,
              color: AppColors.surfaceHighlight,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildWorkerList(),
        ),
      ],
    );
  }

  Widget _buildListView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        children: [
          _buildServiceCategories(),
          SizedBox(height: AppSpacing.lg.h),
          _buildWorkerList(),
        ],
      ),
    );
  }

  Widget _buildServiceCategories() {
    final categories = [
      {'icon': Icons.plumbing, 'label': 'Plumbing', 'color': AppColors.accentCyan},
      {'icon': Icons.electrical_services, 'label': 'Electrical', 'color': AppColors.warning},
      {'icon': Icons.cleaning_services, 'label': 'Cleaning', 'color': AppColors.success},
      {'icon': Icons.ac_unit, 'label': 'AC Repair', 'color': AppColors.primary},
      {'icon': Icons.water_drop, 'label': 'Water', 'color': AppColors.accentCyan},
      {'icon': Icons.build, 'label': 'Carpentry', 'color': AppColors.warning},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SERVICE CATEGORIES',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.md.w,
            mainAxisSpacing: AppSpacing.md.h,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return GlassCard(
              padding: EdgeInsets.all(AppSpacing.sm.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: (cat['color'] as Color).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      color: cat['color'] as Color,
                      size: 20.r,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    cat['label'] as String,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().scale(delay: (index * 50).ms);
          },
        ),
      ],
    );
  }

  Widget _buildWorkerList() {
    final workers = List.generate(5, (index) => {
          'name': 'Worker ${index + 1}',
          'rating': 4.5 + (index * 0.1),
          'distance': '${2 + index}.5 km',
          'price': '₹${299 + index * 100}',
          'eta': '${10 + index * 5} min',
          'jobCount': 120 + index * 10,
        });

    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEARBY WORKERS',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          ...workers.asMap().map((index, worker) {
            return MapEntry(
              index,
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 48.r,
                          height: 48.r,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceHighlight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, color: AppColors.primary, size: 24.r),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12.r,
                            height: 12.r,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.background, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker['name'] as String,
                            style: AppTypography.bodyMedium,
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: AppColors.primary, size: 14.r),
                              SizedBox(width: 4.w),
                              Text(
                                '${worker['rating']} (${worker['jobCount']} jobs)',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          worker['price'] as String,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '${worker['distance']} • ${worker['eta']}',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    IconButton(
                      icon: Icon(Icons.arrow_forward, color: AppColors.primary, size: 20.r),
                      onPressed: () => context.push('/tracking'),
                    ),
                  ],
                ),
              ).animate().slideX(begin: -0.2, delay: (index * 100).ms),
            );
          }).values,
        ],
      ),
    );
  }
}