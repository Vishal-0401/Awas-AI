import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:awas_customer_app/main.dart';

void main() {
  testWidgets(
    'AWAS App loads successfully',
    (WidgetTester tester) async {

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return const ProviderScope(
               child: AwasCustomerApp()
            );
          },
        ),
      );

      await tester.pumpAndSettle();

expect(find.byType(AwasCustomerApp), findsOneWidget);
    
    },
  );
}