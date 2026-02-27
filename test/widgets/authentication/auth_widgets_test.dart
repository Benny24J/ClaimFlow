import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claimflow_africa/widgets/authentication/social_icon.dart';
import 'package:claimflow_africa/widgets/authentication/sign_method_card.dart';

void main() {
  group('Authentication Widgets Tests', () {

    testWidgets('SocialIcon renders four images and handles onTap callbacks', (WidgetTester tester) async {
      String? tappedProvider;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SocialIcon(
            onTap: (provider) {
              tappedProvider = provider;
            },
          ),
        ),
      ));

      // 4 image assets for fb, instagram, google, apple
      expect(find.byType(Image), findsNWidgets(4));

      // Because flutter test can't easily find specifically named image assets when using Image.asset
      // without complex semantic/key finders, we'll tap the images sequentially.
      
      final images = find.byType(Image);
      
      // Tap Facebook (First icon)
      await tester.tap(images.at(0));
      expect(tappedProvider, equals('facebook'));

      // Tap Instagram
      await tester.tap(images.at(1));
      expect(tappedProvider, equals('instagram'));

      // Tap Google
      await tester.tap(images.at(2));
      expect(tappedProvider, equals('google'));

      // Tap Apple
      await tester.tap(images.at(3));
      expect(tappedProvider, equals('apple'));
    });

    testWidgets('SigninMethodCard renders correctly with selected styling and handles tap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SigninMethodCard(
            icon: Icons.email,
            label: 'Sign in with Email',
            selected: true,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ));

      expect(find.text('Sign in with Email'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);

      final iconFinder = find.byIcon(Icons.email);
      final Icon iconWidget = tester.widget(iconFinder);
      
      // In the implementation selected colors the icon green
      expect(iconWidget.color, equals(Colors.green));

      await tester.tap(find.byType(SigninMethodCard));
      expect(tapped, isTrue);
    });

    testWidgets('SigninMethodCard renders correctly with unselected styling', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SigninMethodCard(
            icon: Icons.fingerprint,
            label: 'Biometrics',
            selected: false,
            onTap: () {},
          ),
        ),
      ));

      final iconFinder = find.byIcon(Icons.fingerprint);
      final Icon iconWidget = tester.widget(iconFinder);
      
      expect(iconWidget.color, equals(Colors.black));
    });

  });
}
