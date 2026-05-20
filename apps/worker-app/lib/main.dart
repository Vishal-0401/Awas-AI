import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_theme.dart';
import 'core/config/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // System Initializations could go here
  
  runApp(
    const ProviderScope(
      child: AwasWorkerApp(),
    ),
  );
}

class AwasWorkerApp extends StatelessWidget {
  const AwasWorkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AWAS Worker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
