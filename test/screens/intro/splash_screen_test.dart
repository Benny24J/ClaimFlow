import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claimflow_africa/screens/intro/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders logo and navigates', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(MaterialApp(
      routes: {
        '/onboarding': (context) => const Scaffold(body: Text('OnboardingScreenPlaceholder')),
      },
      home: const SplashScreen(),
    ));

    // Verify logo image is present
    expect(find.byType(Image), findsOneWidget);

    // Initial state: Onboarding text should not be visible
    expect(find.text('OnboardingScreenPlaceholder'), findsNothing);

    // Fast forward time by 3 seconds for the Future.delayed
    await tester.pump(const Duration(seconds: 3));
    // Settle the navigation animation
    await tester.pumpAndSettle();

    // Verify navigation happened by checking for the placeholder string
    expect(find.text('OnboardingScreenPlaceholder'), findsOneWidget);
  });
}
