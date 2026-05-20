import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/home/presentation/screens/worker_home_screen.dart';
import '../../features/jobs/presentation/screens/worker_jobs_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: '/worker-home',
      builder: (context, state) => const WorkerHomeScreen(),
    ),
    GoRoute(
      path: '/worker-jobs',
      builder: (context, state) => const WorkerJobsScreen(),
    ),
    GoRoute(
      path: '/job/:id',
      builder: (context, state) {
        final jobId = state.pathParameters['id'] ?? '';
        return Scaffold(body: Center(child: Text('Job $jobId Detail', style: const TextStyle(color: Colors.white))));
      },
    ),
    GoRoute(
      path: '/active-job',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Active Job', style: TextStyle(color: Colors.white)))),
    ),
    GoRoute(
      path: '/live-tracking',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Live Tracking', style: TextStyle(color: Colors.white)))),
    ),
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Wallet', style: TextStyle(color: Colors.white)))),
    ),
    GoRoute(
      path: '/earnings',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Earnings', style: TextStyle(color: Colors.white)))),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Profile', style: TextStyle(color: Colors.white)))),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Settings', style: TextStyle(color: Colors.white)))),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Notifications', style: TextStyle(color: Colors.white)))),
    ),
    GoRoute(
      path: '/ai-scanner',
      builder: (context, state) => const Scaffold(body: Center(child: Text('AI Scanner', style: TextStyle(color: Colors.white)))),
    ),
  ],
);
