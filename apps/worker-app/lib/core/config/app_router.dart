import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/home/screens/worker_home_screen.dart';
import '../../features/home/screens/worker_dashboard_screen.dart';
import '../../features/jobs/screens/worker_jobs_screen.dart';
import '../../features/jobs/screens/job_detail_screen.dart';
import '../../features/jobs/screens/active_job_screen.dart';
import '../../features/jobs/screens/live_tracking_screen.dart';
import '../../features/jobs/screens/complete_job_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/wallet/screens/earnings_screen.dart';
import '../../features/wallet/screens/withdrawal_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/kyc_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/ai_scanner/screens/ai_scanner_screen.dart';
import '../../features/ai_scanner/screens/diagnostic_result_screen.dart';

class AppRouter {
  static final router = GoRouter(
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
        path: '/worker-dashboard',
        builder: (context, state) => const WorkerDashboardScreen(),
      ),
      GoRoute(
        path: '/worker-jobs',
        builder: (context, state) => const WorkerJobsScreen(),
      ),
      GoRoute(
        path: '/job/:id',
        builder: (context, state) => const JobDetailScreen(),
      ),
      GoRoute(
        path: '/active-job',
        builder: (context, state) => const ActiveJobScreen(),
      ),
      GoRoute(
        path: '/live-tracking',
        builder: (context, state) => const LiveTrackingScreen(),
      ),
      GoRoute(
        path: '/complete-job',
        builder: (context, state) => const CompleteJobScreen(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/earnings',
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: '/withdrawal',
        builder: (context, state) => const WithdrawalScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/kyc',
        builder: (context, state) => const KycScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/ai-scanner',
        builder: (context, state) => const AiScannerScreen(),
      ),
      GoRoute(
        path: '/diagnostic-result',
        builder: (context, state) => const DiagnosticResultScreen(),
      ),
    ],
  );
}
