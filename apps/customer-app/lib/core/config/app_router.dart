import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'route_paths.dart';
import 'route_names.dart';
import '../widgets/app_layout.dart';
import '../../features/auth/providers/auth_provider.dart';

// Screen Imports
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/profile/screens/profile_setup_screen.dart'; 

import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/booking/screens/booking_screen.dart';
import '../../features/ai_scanner/screens/ai_scanner_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/tracking/screens/tracking_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      final isGoingToSplash = state.uri.path == RoutePaths.splash;
      final isGoingToOnboarding = state.uri.path == RoutePaths.onboarding;
      final isGoingToLoginOrOtp = state.uri.path == RoutePaths.login || state.uri.path == RoutePaths.otp;
      final isGoingToProfileSetup = state.uri.path == RoutePaths.profileSetup;

      // Logic based on AuthState
      switch (authState) {
        case AuthState.initial:
          return RoutePaths.splash;
        case AuthState.unauthenticated:
          if (!isGoingToOnboarding) return RoutePaths.onboarding;
          break;
        case AuthState.onboardingCompleted:
          if (!isGoingToLoginOrOtp) return RoutePaths.login;
          break;
        case AuthState.profileIncomplete:
          if (!isGoingToProfileSetup) return RoutePaths.profileSetup; // Need this screen
          break;
        case AuthState.authenticated:
          // If user is authenticated but trying to go to auth screens, redirect to dashboard
          if (isGoingToSplash || isGoingToOnboarding || isGoingToLoginOrOtp || isGoingToProfileSetup) {
            return RoutePaths.dashboard;
          }
          break;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.otp,
        name: RouteNames.otp,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: RoutePaths.profileSetup,
        name: RouteNames.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      
      // Bottom Navigation Shell Route
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.dashboard,
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: RoutePaths.bookings,
            name: RouteNames.bookings,
            builder: (context, state) => const BookingScreen(), // Reusing existing
          ),
          GoRoute(
            path: RoutePaths.aiScanner,
            name: RouteNames.aiScanner,
            builder: (context, state) => const AiScannerScreen(),
          ),
          GoRoute(
            path: RoutePaths.wallet,
            name: RouteNames.wallet,
            builder: (context, state) => const WalletScreen(),
          ),
          GoRoute(
            path: RoutePaths.profile,
            name: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Other routes outside of Bottom Nav
      GoRoute(
        path: RoutePaths.liveTracking,
        name: RouteNames.liveTracking,
        builder: (context, state) => const TrackingScreen(),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        name: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(), // Requires this screen
      ),
    ],
  );
});
