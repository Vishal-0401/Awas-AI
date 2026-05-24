import 'package:awas_customer_app/features/ai_scanner/screens/ai_scanner_screen.dart';
import 'package:awas_customer_app/features/booking/screens/booking_screen.dart';
import 'package:awas_customer_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:awas_customer_app/features/home/screens/home_screen.dart';
import 'package:awas_customer_app/features/profile/screens/profile_screen.dart';
import 'package:awas_customer_app/features/profile/screens/profile_setup_screen.dart';
import 'package:awas_customer_app/features/tracking/screens/tracking_screen.dart';
import 'package:awas_customer_app/features/wallet/screens/wallet_screen.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: '/tracking',
        builder: (context, state) => const TrackingScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/ai-scanner',
        builder: (context, state) => const AiScannerScreen(),
      ),
    ],
  );
}