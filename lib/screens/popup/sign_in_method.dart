import 'package:flutter/material.dart';
import 'package:claimflow_africa/widgets/authentication/sign_method_card.dart';

enum SigninMethod { pin, biometric, email }

class SignInMethod extends StatefulWidget {
  const SignInMethod({super.key});

  @override
  State<SignInMethod> createState() => _SignInMethodScreenState();
}

class _SignInMethodScreenState extends State<SignInMethod> {
  SigninMethod? selectedMethod;

  void _continue() {
    if (selectedMethod == null) return;

    switch (selectedMethod!) {
      case SigninMethod.pin:
        Navigator.pushNamed(context, '/pinsignin');
        break;
      case SigninMethod.biometric:
        Navigator.pushNamed(context, '/biometric-signin');
        break;
      case SigninMethod.email:
        Navigator.pushNamed(context, '/signin');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              Image.asset(
                'assets/images/logo22.png',
                width: 80,
                height: 80,
              ),

              const SizedBox(height: 12),

              Text(
                'Welcome Back',
                style: theme.textTheme.titleLarge,
              ),

              const SizedBox(height: 6),

              Text(
                'The care behind every claim',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 16),

              Text(
                'You can sign in using your PIN, biometric, or email address.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),

              const SizedBox(height: 24),

              SigninMethodCard(
                icon: Icons.lock,
                label: 'Pin',
                selected: selectedMethod == SigninMethod.pin,
                onTap: () =>
                    setState(() => selectedMethod = SigninMethod.pin),
              ),

              const SizedBox(height: 12),

              SigninMethodCard(
                icon: Icons.fingerprint,
                label: 'Biometric',
                selected: selectedMethod == SigninMethod.biometric,
                onTap: () =>
                    setState(() => selectedMethod = SigninMethod.biometric),
              ),

              const SizedBox(height: 12),

              SigninMethodCard(
                icon: Icons.email_outlined,
                label: 'Email Address',
                selected: selectedMethod == SigninMethod.email,
                onTap: () =>
                    setState(() => selectedMethod = SigninMethod.email),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 57,
                child: ElevatedButton(
                  onPressed: selectedMethod == null ? null : _continue,
                  child: const Text("Let’s go →"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}