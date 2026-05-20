/// AWAS-AI Customer App
///
/// AI-powered home services platform
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive_flutter/hive_flutter.dart';

// import 'package:firebase_core/firebase_core.dart';

import 'core/config/app_theme.dart';
import 'core/config/routes.dart';

import 'core/services/storage_service.dart';

// import 'core/services/socket_service.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// LOCK PORTRAIT MODE
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// FIREBASE INIT
  /// Uncomment later
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  /// HIVE INIT
  await Hive.initFlutter();

  /// LOCAL STORAGE INIT
  await StorageService.instance.init();

  /// SOCKET INIT
  /// Uncomment when backend is ready
  // SocketService.instance.initialize();

  runApp(
    const ProviderScope(
      child: AWASCustomerApp(),
    ),
  );
}

class AWASCustomerApp extends ConsumerStatefulWidget {
  const AWASCustomerApp({super.key});

  @override
  ConsumerState<AWASCustomerApp> createState() =>
      _AWASCustomerAppState();
}

class _AWASCustomerAppState
    extends ConsumerState<AWASCustomerApp> {
  late final _router;

  @override
  void initState() {
    super.initState();

    _router = AppRouter.router;

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    /// Future App Initialization
    /// - Check auth token
    /// - Fetch user profile
    /// - Initialize analytics
    /// - Initialize notifications
    /// - Sync cache
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),

      minTextAdapt: true,

      splitScreenMode: true,

      builder: (_, child) {
        return MaterialApp.router(
          title: 'AWAS-AI',

          debugShowCheckedModeBanner: false,

          theme: AppTheme.darkTheme,

          darkTheme: AppTheme.darkTheme,

          themeMode: ThemeMode.dark,

          routerConfig: _router,

          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler:
                    const TextScaler.linear(1.0),
              ),

              /// FIXED NULL CRASH
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}