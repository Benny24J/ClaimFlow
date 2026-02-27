import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claimflow_africa/widgets/claims/claimwidgets.dart';

void main() {
  group('Claim Widgets Tests', () {
    testWidgets('FieldLabel renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: FieldLabel('Patient Name'),
        ),
      ));

      final textFinder = find.text('Patient Name');
      expect(textFinder, findsOneWidget);

      final Text textWidget = tester.widget(textFinder);
      expect(textWidget.style?.fontWeight, equals(FontWeight.w600));
      expect(textWidget.style?.letterSpacing, equals(0.8));
    });

    testWidgets('StepProgressBar shows correct step and saving state', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: StepProgressBar(
            currentStep: 1, // 0-indexed, so this means Step 2
            totalSteps: 4,
            isSaving: true,
          ),
        ),
      ));

      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(find.text('Auto-saving...'), findsOneWidget);

      // Verify the number of segments
      final containerFinder = find.byType(Container);
      // It finds the containers used for the progress bar segments
      // (The number might be slightly higher if other containers are in the tree, but here it's isolated)
      expect(tester.widgetList(containerFinder).length, equals(4));
    });

    testWidgets('StepProgressBar hides saving state when isSaving is false', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: StepProgressBar(
            currentStep: 2,
            totalSteps: 3,
            isSaving: false,
          ),
        ),
      ));

      expect(find.text('Step 3 of 3'), findsOneWidget);

      // Verify Auto-saving text is present but its opacity is 0.0
      final animatedOpacityFinder = find.byType(AnimatedOpacity);
      expect(animatedOpacityFinder, findsOneWidget);
      final AnimatedOpacity opacityWidget = tester.widget(animatedOpacityFinder);
      expect(opacityWidget.opacity, equals(0.0));
    });

    testWidgets('AppBottomNav renders and handles taps correctly', (WidgetTester tester) async {
      int pushedRouteIndex = -1;

      // Create a mocked navigation app
      await tester.pumpWidget(MaterialApp(
        onGenerateRoute: (settings) {
          final routes = [
            '/dashboard',
            '/claims',
            '/risks',
            '/ageing',
            '/settings'
          ];
          pushedRouteIndex = routes.indexOf(settings.name ?? '');

          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: AppBottomNav(currentIndex: 0),
            ),
          );
        },
        home: const Scaffold(
          body: AppBottomNav(currentIndex: 0),
        ),
      ));

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      // In tests without explicit selection, unselected items might use `icon` 
      // instead of `activeIcon`. The first index is usually active.
      // Index 0 (Dashboard) Active -> Icons.dashboard
      // Others Unselected -> *Outlined variants
      expect(find.byIcon(Icons.dashboard), findsOneWidget); // active
      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart_outlined), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

      // Tap the "Claims" tab (index 1)
      await tester.tap(find.text('Claims'));
      await tester.pumpAndSettle();

      // Expect route '/claims' to have been pushed
      expect(pushedRouteIndex, equals(1));
    });
  });
}
