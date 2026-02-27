import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claimflow_africa/screens/authentication/signin_screen.dart';

void main() {
  group('SignInScreen Tests', () {

    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/signup': (context) => const Scaffold(body: Text('SignupScreenPlaceholder')),
        },
        home: const SignInScreen(),
      );
    }

    testWidgets('SignInScreen renders properly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign In'), findsNWidgets(2)); // Title and Button
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('SignInScreen validates empty forms', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Attempt submit without filling fields
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Expect email error
      expect(find.text('Enter a valid email'), findsOneWidget);
      // Expect password error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('SignInScreen validates incorrect email formats', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find text fields
      final fields = find.byType(TextFormField);
      final emailField = fields.first;

      // Enter malformed email
      await tester.enterText(emailField, 'not_an_email');
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email'), findsOneWidget);
      
      // Enter correct email
      await tester.enterText(emailField, 'test@example.com');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Error should vanish
      expect(find.text('Enter a valid email'), findsNothing);
    });

    testWidgets('SignInScreen toggles password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final passwordField = find.widgetWithText(TextFormField, 'Password');

      // The field should be obscured to start
      TextField passwordWidget = tester.widget(find.descendant(of: passwordField, matching: find.byType(TextField)));
      expect(passwordWidget.obscureText, isTrue);

      // Tap visibility off icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Should now be visible
      passwordWidget = tester.widget(find.descendant(of: passwordField, matching: find.byType(TextField)));
      expect(passwordWidget.obscureText, isFalse);

      // Tap visibility icon again
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Should be hidden again
      passwordWidget = tester.widget(find.descendant(of: passwordField, matching: find.byType(TextField)));
      expect(passwordWidget.obscureText, isTrue);
    });

    testWidgets('SignInScreen navigates to sign up screen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap Sign Up link at the bottom
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('SignupScreenPlaceholder'), findsOneWidget);
    });

  });
}
