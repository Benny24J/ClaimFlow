
import 'package:claimflow_africa/widgets/authentication/social_icon.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePassword() => setState(() => _obscurePassword = !_obscurePassword);

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // TODO: handle login logic
    }
  }

  void _forgotPassword() {
    // TODO: handle forgot password logic
    print('Forgot Password tapped');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/images/logo22.png', width: 80, height: 80),
              const SizedBox(height: 16),
              Text('Welcome Back', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Sign In',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.contains('@') ? null : 'Enter a valid email',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: _togglePassword,
                        ),
                      ),
                      validator: (value) =>
                          value!.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                    // Forgot Password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Sign In button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _signIn, child: const Text('Sign In')),
              ),
              const SizedBox(height: 24),

              // Divider row
              Row(
                children: [
                  Expanded(child: Divider(color: theme.colorScheme.outline)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Sign in with', style: theme.textTheme.bodyMedium),
                  ),
                  Expanded(child: Divider(color: theme.colorScheme.outline)),
                ],
              ),
              const SizedBox(height: 16),

              // Social login
              SocialIcon(onTap: (provider) {
                print('Sign in with $provider');
              }),
              const SizedBox(height: 32),

              // Don't have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: theme.textTheme.bodyMedium),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text('Sign Up',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}