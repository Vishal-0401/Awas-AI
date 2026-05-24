import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';


class SmartHomeTwinScreen extends StatelessWidget {
  const SmartHomeTwinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Smart Home Digital Twin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entire Home Condition',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(begin: -0.1),
              
              const SizedBox(height: 8),
              
              const Text(
                'AI-driven insights and lifecycle predictions for all appliances.',
                style: TextStyle(color: AppColors.textSecondary),
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),

              const SizedBox(height: 32),

              // 3D Home representation placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  gradient: LinearGradient(
                    colors: [AppColors.surface, AppColors.primary.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.view_in_ar_rounded, size: 64, color: AppColors.primary),
                      SizedBox(height: 16),
                      Text('3D Home Model Rendering...', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.easeOutBack, delay: 200.ms),

              const SizedBox(height: 32),

              // Appliance Lifecycle
              Text(
                'Appliance Lifecycle',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 16),
              
              _buildLifecycleItem('Master Bedroom AC', 0.65, 'Optimal', Icons.ac_unit_rounded, AppColors.success),
              const SizedBox(height: 12),
              _buildLifecycleItem('Kitchen Refrigerator', 0.20, 'Needs Attention', Icons.kitchen_rounded, AppColors.warning),
              const SizedBox(height: 12),
              _buildLifecycleItem('Washing Machine', 0.85, 'Excellent', Icons.local_laundry_service_rounded, AppColors.success),

              const SizedBox(height: 32),

              // AI Insights
              Text(
                'AI Insights',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 16),
              
              _buildInsightCard(
                icon: Icons.tips_and_updates_rounded,
                title: 'Energy Optimization',
                description: 'Your AC usage is 15% higher than last month. Consider cleaning the filters for better efficiency.',
                color: Colors.amber,
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 12),
              
              _buildInsightCard(
                icon: Icons.history_rounded,
                title: 'Service History Prediction',
                description: 'Based on historical data, the RO water purifier will need a filter replacement in approximately 2 weeks.',
                color: AppColors.primary,
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLifecycleItem(String name, double health, String status, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: health,
                  backgroundColor: AppColors.background,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInsightCard({required IconData icon, required String title, required String description, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: AppColors.textSecondary, height: 1.4, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
