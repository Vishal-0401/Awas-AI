import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/config/app_theme.dart';

class HomeownerHomeScreen extends StatelessWidget {
  const HomeownerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Booking Banner
              GestureDetector(
                onTap: () => context.push('/live-tracking'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.two_wheeler_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Worker arriving in 12 mins',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ).animate().slideY(begin: -1, end: 0).fadeIn(),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header / Hero
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How can we help today?',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.surface,
                            child: Icon(Icons.person, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),

                    const SizedBox(height: 32),

                    // Live Workers Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person_pin_circle_rounded, color: AppColors.success, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              '12 Workers Available Nearby',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/nearby-workers'),
                            child: const Text('View Map', style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

                    const SizedBox(height: 32),

                    // Service Grid (Marketplace)
                    Text(
                      'Service Marketplace',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 16),
                    _buildServiceGrid(context),

                    const SizedBox(height: 32),

                    // Emergency Services
                    Text(
                      'Emergency Booking',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 16),
                    _buildEmergencyServices(context),

                    const SizedBox(height: 32),

                    // AI Health Score Dashboard (Tesla for Home)
                    Text(
                      'Home Health Dashboard',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 16),
                    _buildHomeHealthDashboard(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    final services = [
      {'icon': Icons.ac_unit_rounded, 'label': 'AC Repair'},
      {'icon': Icons.plumbing_rounded, 'label': 'Plumber'},
      {'icon': Icons.electrical_services_rounded, 'label': 'Electrician'},
      {'icon': Icons.cleaning_services_rounded, 'label': 'Cleaning'},
      {'icon': Icons.handyman_rounded, 'label': 'Carpenter'},
      {'icon': Icons.format_paint_rounded, 'label': 'Painter'},
      {'icon': Icons.water_drop_rounded, 'label': 'RO Service'},
      {'icon': Icons.local_laundry_service_rounded, 'label': 'Wash Mach'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => context.push('/nearby-workers'),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Icon(services[index]['icon'] as IconData, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                services[index]['label'] as String,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 200 + (index * 50))).slideY(begin: 0.1);
      },
    );
  }

  Widget _buildEmergencyServices(BuildContext context) {
    final emergencies = [
      {'icon': Icons.flash_on_rounded, 'label': 'Electrician', 'color': AppColors.warning},
      {'icon': Icons.water_damage_rounded, 'label': 'Water Leak', 'color': AppColors.primary},
      {'icon': Icons.ac_unit_rounded, 'label': 'AC Breakdown', 'color': Colors.blueAccent},
      {'icon': Icons.local_fire_department_rounded, 'label': 'Gas Issue', 'color': AppColors.error},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: emergencies.length,
      itemBuilder: (context, index) {
        final color = emergencies[index]['color'] as Color;
        return GestureDetector(
          onTap: () => context.push('/nearby-workers'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Icon(emergencies[index]['icon'] as IconData, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    emergencies[index]['label'] as String,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 400 + (index * 50))).slideX(begin: 0.1);
      },
    );
  }

  Widget _buildHomeHealthDashboard(BuildContext context) {
    return Column(
      children: [
        // Main Health Score
        GestureDetector(
          onTap: () => context.push('/smart-home-twin'),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.surface, AppColors.background],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('HOME HEALTH SCORE', style: TextStyle(color: AppColors.textSecondary, letterSpacing: 1.5, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('87', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                          const Text('%', style: TextStyle(color: AppColors.textSecondary, fontSize: 20)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Overall system operating normally.', style: TextStyle(color: AppColors.success, fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const CircularProgressIndicator(value: 0.87, strokeWidth: 8, backgroundColor: AppColors.surfaceGlass, valueColor: AlwaysStoppedAnimation<Color>(AppColors.success)),
                      Center(child: Icon(Icons.home_rounded, size: 32, color: AppColors.success.withOpacity(0.8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),

        const SizedBox(height: 16),

        // Maintenance Alert Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Maintenance Alert', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('AC Service Due in 5 Days', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push('/nearby-workers'),
                child: const Text('Book', style: TextStyle(color: AppColors.warning)),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
      ],
    );
  }
}
