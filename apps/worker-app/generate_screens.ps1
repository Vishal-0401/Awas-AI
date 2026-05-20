$screens = @(
  "lib/features/auth/screens/splash_screen.dart",
  "lib/features/auth/screens/onboarding_screen.dart",
  "lib/features/auth/screens/login_screen.dart",
  "lib/features/auth/screens/otp_screen.dart",
  "lib/features/home/screens/worker_home_screen.dart",
  "lib/features/home/screens/worker_dashboard_screen.dart",
  "lib/features/jobs/screens/worker_jobs_screen.dart",
  "lib/features/jobs/screens/job_detail_screen.dart",
  "lib/features/jobs/screens/active_job_screen.dart",
  "lib/features/jobs/screens/live_tracking_screen.dart",
  "lib/features/jobs/screens/complete_job_screen.dart",
  "lib/features/wallet/screens/wallet_screen.dart",
  "lib/features/wallet/screens/earnings_screen.dart",
  "lib/features/wallet/screens/withdrawal_screen.dart",
  "lib/features/profile/screens/profile_screen.dart",
  "lib/features/profile/screens/kyc_screen.dart",
  "lib/features/profile/screens/settings_screen.dart",
  "lib/features/notifications/screens/notifications_screen.dart",
  "lib/features/ai_scanner/screens/ai_scanner_screen.dart",
  "lib/features/ai_scanner/screens/diagnostic_result_screen.dart"
)

foreach ($screen in $screens) {
    $dir = Split-Path $screen
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    
    $className = (Split-Path $screen -Leaf).Replace(".dart", "")
    # Convert snake_case to CamelCase
    $classNameParts = $className.Split("_")
    $classNameCamel = ""
    foreach ($part in $classNameParts) {
        $classNameCamel += $part.Substring(0,1).ToUpper() + $part.Substring(1)
    }

    $content = @"
import 'package:flutter/material.dart';

class $classNameCamel extends StatelessWidget {
  const ${classNameCamel}({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$classNameCamel')),
      body: const Center(child: Text('$classNameCamel Placeholder')),
    );
  }
}
"@
    Set-Content -Path $screen -Value $content
}
