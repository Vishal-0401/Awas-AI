import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import 'worker_dashboard_screen.dart';
import '../../jobs/screens/worker_jobs_screen.dart';
import '../../wallet/screens/wallet_screen.dart';
import '../../profile/screens/profile_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WorkerDashboardScreen(),
    const WorkerJobsScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.9),
          border: Border(
            top: BorderSide(
              color: AppColors.primaryGold.withOpacity(0.2),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, -5.h),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primaryGold.withOpacity(0.2),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.dashboard, color: AppColors.primaryGold),
              label: 'Console',
            ),
            NavigationDestination(
              icon: Icon(Icons.work_outline, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.work, color: AppColors.primaryGold),
              label: 'Jobs',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.account_balance_wallet, color: AppColors.primaryGold),
              label: 'Wallet',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.person, color: AppColors.primaryGold),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}