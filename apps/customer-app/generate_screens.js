const fs = require('fs');
const path = require('path');

const screens = [
  'features/auth/screens/splash_screen.dart',
  'features/auth/screens/onboarding_screen.dart',
  'features/auth/screens/login_screen.dart',
  'features/auth/screens/otp_screen.dart',
  'features/home/screens/homeowner_home_screen.dart',
  'features/home/screens/home_dashboard_screen.dart',
  'features/home/screens/appliance_detail_screen.dart',
  'features/home/screens/predictive_alert_screen.dart',
  'features/ai_scanner/screens/ai_scanner_screen.dart',
  'features/ai_scanner/screens/diagnostic_result_screen.dart',
  'features/ai_scanner/screens/ai_report_screen.dart',
  'features/jobs/screens/nearby_workers_screen.dart',
  'features/jobs/screens/booking_screen.dart',
  'features/jobs/screens/booking_confirmation_screen.dart',
  'features/jobs/screens/live_tracking_screen.dart',
  'features/jobs/screens/orders_screen.dart',
  'features/jobs/screens/order_detail_screen.dart',
  'features/wallet/screens/wallet_screen.dart',
  'features/wallet/screens/payment_methods_screen.dart',
  'features/wallet/screens/transactions_screen.dart',
  'features/profile/screens/profile_screen.dart',
  'features/profile/screens/settings_screen.dart',
  'features/profile/screens/saved_addresses_screen.dart',
  'features/notifications/screens/notifications_screen.dart'
];

screens.forEach(screen => {
  const fullPath = path.join('d:/system_design/AwasAi/apps/customer-app/lib', screen);
  const dirPath = path.dirname(fullPath);
  
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
  
  const fileName = path.basename(screen, '.dart');
  const className = fileName.split('_').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join('');
  
  if (!fs.existsSync(fullPath)) {
    const content = `import 'package:flutter/material.dart';

class ${className} extends StatelessWidget {
  const ${className}({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${className}')),
      body: const Center(child: Text('${className} Placeholder')),
    );
  }
}
`;
    fs.writeFileSync(fullPath, content);
  }
});
