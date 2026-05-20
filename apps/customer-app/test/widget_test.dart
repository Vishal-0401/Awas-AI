import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awas_customer_app/main.dart';

void main() {
  testWidgets(
    'AWAS App loads successfully',
    (WidgetTester tester) async {
      /// BUILD APP
      await tester.pumpWidget(
        const ProviderScope(
          child: AWASCustomerApp(),
        ),
      );

      /// WAIT FOR SPLASH SCREEN
      await tester.pumpAndSettle();

      /// VERIFY APP LOADS
      expect(find.byType(AWASCustomerApp), findsOneWidget);
    },
  );
}