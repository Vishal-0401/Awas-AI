import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          final types = ['predictive', 'booking', 'payment', 'system'];
          final type = types[index % types.length];
          
          IconData icon;
          Color color;
          String title;
          String desc;
          
          switch (type) {
            case 'predictive':
              icon = Icons.online_prediction_rounded;
              color = AppColors.warning;
              title = 'Predictive Alert: AC';
              desc = 'Your AC is showing signs of cooling loss. Schedule maintenance soon.';
              break;
            case 'booking':
              icon = Icons.two_wheeler_rounded;
              color = AppColors.primary;
              title = 'Expert is Arriving';
              desc = 'Amit Kumar is 5 mins away from your location.';
              break;
            case 'payment':
              icon = Icons.account_balance_wallet_rounded;
              color = AppColors.success;
              title = 'Escrow Refunded';
              desc = '₹ 150 has been refunded to your wallet for cancelled booking.';
              break;
            default:
              icon = Icons.info_outline_rounded;
              color = AppColors.secondary;
              title = 'System Update';
              desc = 'AWAS Home v2.0 is now live with better AI diagnostics.';
              break;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: index == 0 ? color.withOpacity(0.5) : Colors.white10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (index == 0)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          desc,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '2 hours ago',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 200 * index)).slideX(begin: 0.1),
          );
        },
      ),
    );
  }
}
