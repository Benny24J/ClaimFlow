import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/riskflag_model.dart';
import 'package:claimflow_africa/dmodels/user_profile_model.dart';
import 'package:claimflow_africa/screens/all/ar_ageing_dashboard.dart';
import 'package:claimflow_africa/screens/all/claim_list_screen.dart';
import 'package:claimflow_africa/screens/all/risk_alerts.dart';
import 'package:claimflow_africa/screens/authentication/forgot_password_screen.dart';
import 'package:claimflow_africa/screens/authentication/otp_screen.dart';
import 'package:claimflow_africa/screens/newuser/claim_success_screen.dart';
import 'package:claimflow_africa/screens/newuser/new_claim_screen.dart';
import 'package:claimflow_africa/screens/popup/biometric_auth_screen.dart';
import 'package:claimflow_africa/screens/newuser/welcome_screen.dart';
import 'package:claimflow_africa/screens/all/claim_details_screen.dart';
import 'package:claimflow_africa/screens/settings1/help/claims_management.dart';
import 'package:claimflow_africa/screens/settings1/help/financial_reports.dart';
import 'package:claimflow_africa/screens/settings1/help/get_started.dart';
import 'package:claimflow_africa/screens/settings1/help/help_center_screen.dart';
import 'package:claimflow_africa/screens/settings1/help/risk_prevention.dart';
import 'package:claimflow_africa/screens/settings1/help/teams_and_settings.dart';
import 'package:claimflow_africa/screens/settings1/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:claimflow_africa/screens/settings1/settings.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/screens/intro/splash_screen.dart';
import 'package:claimflow_africa/screens/intro/onboarding_screen.dart';
import 'package:claimflow_africa/screens/authentication/signin_screen.dart';
import 'package:claimflow_africa/screens/authentication/signup_screen.dart';
import 'package:claimflow_africa/screens/popup/sign_in_method.dart';
import 'package:claimflow_africa/screens/popup/pin_signin_screen.dart';
import 'package:claimflow_africa/screens/newuser/dashboard_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ClaimModelAdapter());
  await Hive.openBox<ClaimModel>('claims');
  final box = Hive.box<ClaimModel>('claims');
  print(' Hive ready — Claims in local db: ${box.length}');
  Hive.registerAdapter(UserProfileModelAdapter());
await Hive.openBox<UserProfileModel>('userProfile');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClaimFlow Africa',
      theme: claimFlowTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      
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
        '/help/topic/getting-started': (_) => const GetStartedScreen(),
        '/help/topic/risk': (_) => const RiskPrevention(),
        '/help/topic/claims': (_) => const ClaimsManagement(),
        '/help/topic/financial': (_) => const FinancialReports(),
        '/help/topic/settings': (_) => const TeamAndSettings(),
        '/risks': (_) => const RiskAlerts(),
        '/ageing': (_) => const ARAgingDashboard(),
        '/otp-verification': (_) => const OtpVerificationScreen(),
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