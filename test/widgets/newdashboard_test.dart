import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claimflow_africa/widgets/newdashboard/stat_card.dart';
import 'package:claimflow_africa/widgets/newdashboard/stats_row.dart';
import 'package:claimflow_africa/widgets/newdashboard/new_claim_card.dart';
import 'package:claimflow_africa/widgets/newdashboard/new_user_section.dart';
import 'package:claimflow_africa/widgets/newdashboard/helper_card.dart';
import 'package:claimflow_africa/widgets/newdashboard/setup_complete_banner.dart';

void main() {
  group('NewDashboard Widgets Tests', () {
    
    testWidgets('StatCard renders icon, value, and label', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: StatCard(
            icon: Icons.check,
            value: 42,
            label: 'TEST LABEL',
          ),
        ),
      ));

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(find.text('TEST LABEL'), findsOneWidget);
    });

    testWidgets('StatCard applies alert style when isAlert is true', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: StatCard(
            icon: Icons.warning,
            value: 5,
            label: 'ALERTS',
            isAlert: true,
          ),
        ),
      ));

      final iconFinder = find.byIcon(Icons.warning);
      final Icon iconWidget = tester.widget(iconFinder);
      
      // We expect the color to be orange
      expect(iconWidget.color, equals(Colors.orange));
    });

    testWidgets('StatsRow renders three StatCards and handles tap', (WidgetTester tester) async {
      bool riskAlertTapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatsRow(
            claimsSubmitted: 10,
            pendingReview: 5,
            riskAlerts: 2,
            onRiskAlertsTap: () {
              riskAlertTapped = true;
            },
          ),
        ),
      ));

      expect(find.byType(StatCard), findsNWidgets(3));
      
      expect(find.text('10'), findsOneWidget);
      expect(find.text('CLAIMS\nSUBMITTED'), findsOneWidget);
      
      expect(find.text('5'), findsOneWidget);
      expect(find.text('PENDING\nREVIEW'), findsOneWidget);
      
      expect(find.text('2'), findsOneWidget);
      expect(find.text('RISK\nALERTS'), findsOneWidget);

      await tester.tap(find.text('RISK\nALERTS'));
      expect(riskAlertTapped, isTrue);
    });

    testWidgets('NewClaimCard renders content and handles tap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NewClaimCard(
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ));

      expect(find.text('Submit Your First Claim'), findsOneWidget);
      expect(find.text('New Claim'), findsOneWidget);

      await tester.tap(find.text('New Claim'));
      expect(tapped, isTrue);
    });

    testWidgets('NewUserSection renders header and HelperCards, handles taps', (WidgetTester tester) async {
      bool dismissTapped = false;
      bool viewSampleTapped = false;
      bool learnProcessTapped = false;
      bool inviteTeamTapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NewUserSection(
            onDismiss: () => dismissTapped = true,
            onViewSampleClaim: () => viewSampleTapped = true,
            onLearnProcess: () => learnProcessTapped = true,
            onInviteTeam: () => inviteTeamTapped = true,
          ),
        ),
      ));

      expect(find.text('New to ClaimFlow?'), findsOneWidget);
      expect(find.byType(HelperCard), findsNWidgets(3));

      // Test Dismiss Tap
      await tester.tap(find.byIcon(Icons.close));
      expect(dismissTapped, isTrue);

      // Test View Sample Tap
      await tester.tap(find.text('View Sample Claim'));
      expect(viewSampleTapped, isTrue);

      // Test Learn Process Tap
      await tester.tap(find.text('Learn Submission Process'));
      expect(learnProcessTapped, isTrue);

      // Test Invite Team Tap
      await tester.tap(find.text('Invite Team Member'));
      expect(inviteTeamTapped, isTrue);
    });

    testWidgets('SetupCompleteBanner renders content and handles dismiss tap', (WidgetTester tester) async {
      bool dismissed = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SetupCompleteBanner(
            onDismiss: () {
              dismissed = true;
            },
          ),
        ),
      ));

      expect(find.text('Organization Setup Complete'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      expect(dismissed, isTrue);
    });

  });
}
