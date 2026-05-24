import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/telemetry_service.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/cyber_button.dart';

class WorkerHomeScreen extends ConsumerWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetryState = ref.watch(telemetryProvider);
    final isOnline = telemetryState.workerState == WorkerState.online;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TELEMETRY OPS', style: Theme.of(context).textTheme.labelLarge),
                      Text('DASHBOARD', style: Theme.of(context).textTheme.displayMedium),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.surface,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.person, color: AppColors.accentCyan),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Status Toggle Glass Card
              GlassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SYSTEM STATUS',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: isOnline ? AppColors.accentCyan : AppColors.textSecondary,
                          ),
                        ),
                        Switch(
                          value: isOnline,
                          onChanged: (_) => ref.read(telemetryProvider.notifier).toggleStatus(),
                          activeThumbColor: AppColors.accentCyan,
                          activeTrackColor: AppColors.accentCyan.withOpacity(0.3),
                          inactiveThumbColor: AppColors.textSecondary,
                          inactiveTrackColor: AppColors.borders,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isOnline ? AppColors.accentCyan.withOpacity(0.1) : AppColors.borders.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isOnline ? AppColors.accentCyan.withOpacity(0.5) : AppColors.borders,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isOnline ? Icons.sensors : Icons.sensors_off,
                            color: isOnline ? AppColors.accentCyan : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isOnline 
                                  ? 'TRANSMITTING HEARTBEAT\nLat: ${telemetryState.currentLocation?.lat.toStringAsFixed(4)} Lng: ${telemetryState.currentLocation?.lng.toStringAsFixed(4)}' 
                                  : 'SYSTEM OFFLINE\nAwaiting manual override.',
                              style: TextStyle(
                                color: isOnline ? AppColors.accentCyan : AppColors.textSecondary,
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Metrics Grid
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.account_balance_wallet, color: AppColors.primaryGold),
                          const SizedBox(height: 12),
                          Text('ESCROW', style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 4),
                          Text('\$4,250.00', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.star, color: AppColors.accentCyan),
                          const SizedBox(height: 12),
                          Text('RATING', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.accentCyan)),
                          const SizedBox(height: 4),
                          Text('4.98', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              CyberButton(
                text: 'VIEW DISPATCH QUEUE',
                glowColor: AppColors.primaryGold,
                onPressed: () => context.push('/worker-jobs'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
