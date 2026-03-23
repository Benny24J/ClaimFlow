import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/riskflag_model.dart';
import 'package:claimflow_africa/screens/all/ar_ageing_dashboard.dart';
import 'package:claimflow_africa/screens/all/claim_details_screen.dart';
import 'package:claimflow_africa/screens/all/claim_list_screen.dart';
import 'package:claimflow_africa/screens/all/risk_alerts.dart';
import 'package:claimflow_africa/screens/authentication/forgot_password_screen.dart';
import 'package:claimflow_africa/screens/authentication/otp_screen.dart';
import 'package:claimflow_africa/screens/authentication/signin_screen.dart';
import 'package:claimflow_africa/screens/authentication/signup_screen.dart';
import 'package:claimflow_africa/screens/intro/onboarding_screen.dart';
import 'package:claimflow_africa/screens/intro/splash_screen.dart';
import 'package:claimflow_africa/screens/newuser/claim_success_screen.dart';
import 'package:claimflow_africa/screens/newuser/dashboard_screen.dart';
import 'package:claimflow_africa/screens/newuser/new_claim_screen.dart';
import 'package:claimflow_africa/screens/newuser/welcome_screen.dart';
import 'package:claimflow_africa/screens/organization/clinics_screen.dart';
import 'package:claimflow_africa/screens/popup/biometric_auth_screen.dart';
import 'package:claimflow_africa/screens/popup/pin_signin_screen.dart';
import 'package:claimflow_africa/screens/popup/sign_in_method.dart';
import 'package:claimflow_africa/screens/settings1/help/help_center_screen.dart';
import 'package:claimflow_africa/screens/settings1/help/help_topic_detail_screen.dart';
import 'package:claimflow_africa/screens/settings1/profile_screen.dart';
import 'package:claimflow_africa/screens/settings1/settings.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'ClaimFlow Africa',
      theme: claimFlowTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

    builder: (context, child) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: child!,
    ),
  );
},
      routes: {
        '/': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/signinmethod': (_) => const SignInMethod(),
        '/signin': (_) => const SignInScreen(),
        '/pinsignin': (_) => const PinSignInScreen(),
        '/biometric-signin': (_) => const BiometricAuthScreen(),
        '/welcome': (_) => const WelcomeScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/new-claim': (_) => const NewClaimScreen(),
        '/claims': (_) => const ClaimListScreen(),
        '/settings': (_) => const Settings(),
        '/profile': (_) => const ProfileScreen(),
        '/help': (_) => const HelpCenterScreen(),
        '/risks': (_) => const RiskAlerts(),
        '/ageing': (_) => const ARAgingDashboard(),
        '/otp-verification': (_) => const OtpVerificationScreen(),
        '/organization': (_) => const ClinicsScreen(),
        '/help/topic/getting-started': (_) => const HelpTopicDetailScreen(
  topicTitle: 'Getting Started',
  topicIcon: Icons.article_outlined,
  iconColor: Color(0xFF2196F3),
  articles: [
    HelpArticle(title: 'How to Create Your First Claim', readTime: '3 min read'),
    HelpArticle(title: 'Navigating the Dashboard', readTime: '4 min read'),
    HelpArticle(title: 'Setting Up Your Profile', readTime: '2 min read'),
  ],
),
'/help/topic/risk': (_) => const HelpTopicDetailScreen(
  topicTitle: 'Risk Prevention',
  topicIcon: Icons.shield_outlined,
  iconColor: Color(0xFFE53935),
  articles: [
    HelpArticle(title: 'What Risk Alerts Mean', readTime: '5 min read'),
    HelpArticle(title: 'Preventing Claim Denials', readTime: '8 min read'),
    HelpArticle(title: 'Duplicate Detection System', readTime: '4 min read'),
  ],
),
'/help/topic/claims': (_) => const HelpTopicDetailScreen(
  topicTitle: 'Claims Management',
  topicIcon: Icons.description_outlined,
  iconColor: Color(0xFF4CAF50),
  articles: [
    HelpArticle(title: 'Multi-Step Claim Submission', readTime: '6 min read'),
    HelpArticle(title: 'Editing and Updating Claims', readTime: '4 min read'),
    HelpArticle(title: 'Tracking Claim Status', readTime: '3 min read'),
    HelpArticle(title: 'Handling Claim Rejections', readTime: '7 min read'),
  ],
),
'/help/topic/financial': (_) => const HelpTopicDetailScreen(
  topicTitle: 'Financial Reports',
  topicIcon: Icons.attach_money,
  iconColor: Color(0xFF8BC34A),
  articles: [
    HelpArticle(title: 'Understanding A/R Aging', readTime: '6 min read'),
    HelpArticle(title: 'Revenue Cycle Analytics', readTime: '7 min read'),
    HelpArticle(title: 'Payer Performance Tracking', readTime: '5 min read'),
  ],
),
'/help/topic/settings': (_) => const HelpTopicDetailScreen(
  topicTitle: 'Team & Settings',
  topicIcon: Icons.groups_outlined,
  iconColor: Color(0xFF9E9E9E),
  articles: [
    HelpArticle(title: 'Adding Team Members', readTime: '4 min read'),
    HelpArticle(title: 'Role-Based Performance', readTime: '6 min read'),
    HelpArticle(title: 'Notification Preferences', readTime: '3 min read'),
  ],
),

        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/claim-success': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ClaimSuccessScreen(
            claim: args['claim'] as ClaimModel,
            isSynced: args['isSynced'] as bool,
          );
        },
        '/claim-details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ClaimDetailsScreen(
            claim: args['claim'] as ClaimModel,
            riskFlags: args['riskFlags'] as List<RiskFlag>,
          );
        },
      },
    );
  }
}