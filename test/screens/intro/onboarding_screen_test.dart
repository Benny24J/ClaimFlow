import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claimflow_africa/screens/intro/onboarding_screen.dart';
import 'package:claimflow_africa/dmodels/onboarding_model.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      routes: {
        '/signup': (context) => const Scaffold(body: Text('SignupPlaceholder')),
      },
      home: const OnboardingScreen(),
    );
  }

  void configureScreenSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('OnboardingScreen renders first item correctly', (WidgetTester tester) async {
    configureScreenSize(tester);
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify the first item title is present
    expect(find.text(OnboardingData.items[0].title), findsOneWidget);
    // Verify "Next" button is present
    expect(find.text('Next'), findsOneWidget);
    // Verify "Skip" button is present
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('OnboardingScreen next button navigates to next page', (WidgetTester tester) async {
    configureScreenSize(tester);
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap "Next"
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Verify the second item title is present
    expect(find.text(OnboardingData.items[1].title), findsOneWidget);
  });

  testWidgets('OnboardingScreen skip button navigates to signup', (WidgetTester tester) async {
    configureScreenSize(tester);
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap "Skip"
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Verify navigation to signup
    expect(find.text('SignupPlaceholder'), findsOneWidget);
  });

  testWidgets('OnboardingScreen finishes and navigates to signup', (WidgetTester tester) async {
    configureScreenSize(tester);
    await tester.pumpWidget(createWidgetUnderTest());

    // Navigate to the last page
    for (int i = 0; i < OnboardingData.items.length - 1; i++) {
       await tester.tap(find.text('Next'));
       await tester.pumpAndSettle();
    }

    // Verify the last item title is present
    expect(find.text(OnboardingData.items.last.title), findsOneWidget);

    // Verify "Next" changed to "Get Started"
    expect(find.text('Get Started'), findsOneWidget);

    // Tap "Get Started"
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify navigation to signup
    expect(find.text('SignupPlaceholder'), findsOneWidget);
  });
}
