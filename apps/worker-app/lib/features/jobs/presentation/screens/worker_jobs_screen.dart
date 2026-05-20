import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class WorkerJobsScreen extends StatelessWidget {
  const WorkerJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'DISPATCH QUEUE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.primaryGold,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.accentCyan),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final isHighPriority = index == 0;
          return GlassCard(
            onTap: () => context.push('/job/JOB-${1024 + index}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHighPriority ? AppColors.primaryGold.withOpacity(0.2) : AppColors.surface,
                        border: Border.all(
                          color: isHighPriority ? AppColors.primaryGold : AppColors.borders,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isHighPriority ? 'PRIORITY TARGET' : 'STANDARD OP',
                        style: TextStyle(
                          color: isHighPriority ? AppColors.primaryGold : AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    Text(
                      '#JOB-${1024 + index}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isHighPriority ? 'Emergency System Repair' : 'Routine Maintenance',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.accentCyan),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sector 7G, Industrial District',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.borders),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PAYOUT', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10)),
                        Text('\$${(250 + index * 50).toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primaryGold, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentCyan.withOpacity(0.2),
                            foregroundColor: AppColors.accentCyan,
                            side: const BorderSide(color: AppColors.accentCyan),
                            elevation: 0,
                          ),
                          child: const Text('ACCEPT OP'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
