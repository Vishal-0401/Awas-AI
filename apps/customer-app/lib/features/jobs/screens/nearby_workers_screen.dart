import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/config/app_theme.dart';

class NearbyWorkersScreen extends StatefulWidget {
  const NearbyWorkersScreen({super.key});

  @override
  State<NearbyWorkersScreen> createState() =>
      _NearbyWorkersScreenState();
}

class _NearbyWorkersScreenState
    extends State<NearbyWorkersScreen> {
  bool _isSearching = true;

  @override
  void initState() {
    super.initState();
    _simulateSearch();
  }

  void _simulateSearch() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          /// MAP BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://i.stack.imgur.com/B9B1Z.png',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.background,
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          /// MAP PINS
          if (!_isSearching) ...[
            _buildMapPin(top: 200, left: 120),
            _buildMapPin(top: 300, right: 100),
            _buildMapPin(
              top: 150,
              right: 150,
              isPrimary: true,
            ),
          ],

          /// GRADIENT OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withOpacity(0.9),
                  Colors.transparent,
                  AppColors.background,
                ],
                stops: const [0.0, 0.4, 0.7],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// TOP BAR
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => context.pop(),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white10,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  '12th Avenue, Cyber City',
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// FILTERS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      _buildFilterChip(
                        'AC Repair',
                        true,
                      ),
                      _buildFilterChip(
                        'Within 5km',
                        false,
                      ),
                      _buildFilterChip(
                        'Available Now',
                        false,
                      ),
                      _buildFilterChip(
                        'Top Rated',
                        false,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const Spacer(),

                /// BOTTOM CONTENT
                _isSearching
                    ? _buildSearchingState()
                    : _buildWorkerList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// MAP PIN
  Widget _buildMapPin({
    double? top,
    double? left,
    double? right,
    double? bottom,
    bool isPrimary = false,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(8),
              border: Border.all(
                color: isPrimary
                    ? AppColors.primary
                    : Colors.white10,
              ),
            ),
            child: Text(
              isPrimary ? '3 mins' : '8 mins',
              style: TextStyle(
                color: isPrimary
                    ? AppColors.primary
                    : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Icon(
            Icons.location_on_rounded,
            color: isPrimary
                ? AppColors.primary
                : AppColors.textSecondary,
            size: 32,
          ),
        ],
      ).animate().scale(
            curve: Curves.easeOutBack,
            duration: 600.ms,
          ),
    );
  }

  /// FILTER CHIP
  Widget _buildFilterChip(
    String label,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.surfaceGlass,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : Colors.white24,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? AppColors.primary
              : Colors.white,
          fontWeight: isSelected
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }

  /// SEARCHING STATE
  Widget _buildSearchingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary
                  .withOpacity(0.2),
            ),
            child: const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            )
                .animate(
                  onPlay: (controller) =>
                      controller.repeat(),
                )
                .rotate(duration: 2000.ms),
          ),

          const SizedBox(height: 24),

          Text(
            'Finding Best Experts...',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          )
              .animate()
              .fadeIn()
              .slideY(begin: 0.2),

          const SizedBox(height: 8),

          Text(
            'Scanning nearby verified AC technicians',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// WORKER LIST
  Widget _buildWorkerList() {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
            const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Experts',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '3 Nearby',
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              scrollDirection:
                  Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildWorkerCard(index);
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  /// WORKER CARD
  Widget _buildWorkerCard(int index) {
    return GestureDetector(
      onTap: () {
        context.push('/worker-profile');
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(
          right: 16,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.circular(24),
          border: Border.all(
            color: index == 0
                ? AppColors.primary
                : Colors.white10,
            width: index == 0 ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      AppColors.background,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        index == 0
                            ? 'Amit Kumar'
                            : 'Suresh Singh',
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color:
                                AppColors.warning,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '4.9 (120 jobs)',
                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                _buildBadge(
                  Icons.location_on_rounded,
                  '2.5 km',
                ),
                _buildBadge(
                  Icons.timer_rounded,
                  '15 min ETA',
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: AppColors.success,
                  size: 14,
                ),

                const SizedBox(width: 4),

                Text(
                  'Background Verified',
                  style: TextStyle(
                    color: AppColors.success
                        .withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/booking');
                },
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      index == 0
                          ? AppColors.primary
                          : AppColors.background,
                  foregroundColor:
                      index == 0
                          ? Colors.white
                          : AppColors.primary,
                  side: index == 0
                      ? BorderSide.none
                      : const BorderSide(
                          color:
                              AppColors.primary,
                        ),
                ),
                child: Text(
                  index == 0
                      ? 'Book Expert'
                      : 'Select',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BADGE
  Widget _buildBadge(
    IconData icon,
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
            BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 14,
          ),

          const SizedBox(width: 6),

          Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}