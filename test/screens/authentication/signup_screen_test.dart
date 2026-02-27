import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claimflow_africa/screens/authentication/signup_screen.dart';

void main() {
  group('SignUpScreen Tests', () {

    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/welcome': (context) => const Scaffold(body: Text('WelcomePlaceholder')),
          '/signinmethod': (context) => const Scaffold(body: Text('SignInMethodPlaceholder')),
        },
        home: const SignUpScreen(),
      );
    }

    testWidgets('SignUpScreen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4)); // Name, Email, Password, Confirm User
    });

    testWidgets('SignUpScreen validates empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Enter full name'), findsOneWidget);
      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('SignUpScreen validates mismatched passwords', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final fields = find.byType(TextFormField);
      final passwordField = fields.at(2);
      final confirmField = fields.at(3);

      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmField, 'password456');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('SignUpScreen executes valid signup and navigates to welcome', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final fields = find.byType(TextFormField);
      final nameField = fields.at(0);
      final emailField = fields.at(1);
      final passwordField = fields.at(2);
      final confirmField = fields.at(3);

      await tester.enterText(nameField, 'John Doe');
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmField, 'password123');

      // Unfocus so that tapping works cleanly if keyboard overlays are mocked
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('WelcomePlaceholder'), findsOneWidget);
    });

    testWidgets('SignUpScreen navigates to signinmethod', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap Sign In link at the bottom (scroll if needed)
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pump();

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('SignInMethodPlaceholder'), findsOneWidget);
    });
  });
}
