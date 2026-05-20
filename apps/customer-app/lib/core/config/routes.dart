import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';

import '../../features/home/screens/homeowner_home_screen.dart';
import '../../features/home/screens/home_dashboard_screen.dart';
import '../../features/home/screens/appliance_detail_screen.dart';
import '../../features/home/screens/predictive_alert_screen.dart';
import '../../features/home/screens/smart_home_twin_screen.dart';

import '../../features/ai_scanner/screens/ai_scanner_screen.dart';
import '../../features/ai_scanner/screens/diagnostic_result_screen.dart';
import '../../features/ai_scanner/screens/ai_report_screen.dart';

import '../../features/jobs/screens/nearby_workers_screen.dart';
import '../../features/jobs/screens/booking_screen.dart';
import '../../features/jobs/screens/booking_confirmation_screen.dart';
import '../../features/jobs/screens/live_tracking_screen.dart';
import '../../features/jobs/screens/orders_screen.dart';
import '../../features/jobs/screens/order_detail_screen.dart';
import '../../features/jobs/screens/worker_profile_screen.dart';

import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/wallet/screens/payment_methods_screen.dart';
import '../../features/wallet/screens/transactions_screen.dart';

import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/profile/screens/saved_addresses_screen.dart';
import '../../features/profile/screens/live_support_screen.dart';

import '../../features/notifications/screens/notifications_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Auth Routes
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

      // Home & Main Navigation
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeownerHomeScreen(),
      ),
      GoRoute(
        path: '/home-dashboard',
        builder: (context, state) => const HomeDashboardScreen(),
      ),
      GoRoute(
        path: '/appliance/:id',
        builder: (context, state) {
          // final id = state.pathParameters['id'];
          return const ApplianceDetailScreen();
        },
      ),
      GoRoute(
        path: '/predictive-alerts',
        builder: (context, state) => const PredictiveAlertScreen(),
      ),

      // AI Scanner Routes
      GoRoute(
        path: '/ai-scanner',
        builder: (context, state) => const AiScannerScreen(),
      ),
      GoRoute(
        path: '/diagnostic-result',
        builder: (context, state) => const DiagnosticResultScreen(),
      ),
      GoRoute(
        path: '/ai-report',
        builder: (context, state) => const AiReportScreen(),
      ),

      // Booking & Jobs
      GoRoute(
        path: '/nearby-workers',
        builder: (context, state) => const NearbyWorkersScreen(),
      ),
      GoRoute(
        path: '/worker-profile',
        builder: (context, state) => const WorkerProfileScreen(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: '/booking-confirmation',
        builder: (context, state) => const BookingConfirmationScreen(),
      ),
      GoRoute(
        path: '/live-tracking',
        builder: (context, state) => const LiveTrackingScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) {
          // final id = state.pathParameters['id'];
          return const OrderDetailScreen();
        },
      ),

      // Wallet
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/payment-methods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionsScreen(),
      ),

      // Profile & Settings
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/saved-addresses',
        builder: (context, state) => const SavedAddressesScreen(),
      ),

      // Notifications
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
