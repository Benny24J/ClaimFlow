// screens/sign_up_screen.dart
import 'package:claimflow_africa/widgets/authentication/social_icon.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _togglePassword() => setState(() => _obscurePassword = !_obscurePassword);
  void _toggleConfirm() => setState(() => _obscureConfirm = !_obscureConfirm);

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // TODO: Handle signup logic
      Navigator.pushReplacementNamed(context, '/welcome');
    }
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
              Image.asset('assets/images/logo22.png', width: 80, height: 80),
              const SizedBox(height: 16),
              Text('Secure access to your clinics dashboard', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Create Account',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Full Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                          )
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter full name' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(borderSide: BorderSide(
                            width: 1,
                          )),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.contains('@') ? null : 'Enter a valid email',
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(borderSide: BorderSide(
                            width: 1,
                          )),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: _togglePassword,
                        ),
                      ),
                      validator: (value) => value!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                          )
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscureConfirm ? Icons.visibility : Icons.visibility_off),
                          onPressed: _toggleConfirm,
                        ),
                      ),
                      validator: (value) => value != _passwordController.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _signUp, child: const Text('Sign Up')),
              ),
              const SizedBox(height: 24),

              
              Row(
                children: [
                  Expanded(child: Divider(color: theme.colorScheme.outline)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Sign up with', style: theme.textTheme.bodyMedium),
                  ),
                  Expanded(child: Divider(color: theme.colorScheme.outline)),
                ],
              ),
              const SizedBox(height: 16),
              SocialIcon(onTap: (provider) {
                print('Sign up with $provider');
              }),
              const SizedBox(height: 32),

              // Already have account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: theme.textTheme.bodyMedium),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signinmethod');
                    },
                    child: Text('Sign In',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}