import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/dmodels/user_profile_model.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _validationPassed = false;

  String _phone = '(+234) 7000 0000';
  String _email = 'name@gmail.com';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _loadUserProfile() {
    final box = Hive.box<UserProfileModel>('userProfile');
    if (box.isNotEmpty) {
      final profile = box.getAt(0)!;
      setState(() {
        _phone = profile.phone.isNotEmpty ? profile.phone : '(+234) 7000 0000';
        _email = profile.email.isNotEmpty ? profile.email : 'name@gmail.com';
      });
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    final hasMinLength = password.length >= 6;
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final passwordsMatch = password == confirm && confirm.isNotEmpty;

    setState(() {
      _validationPassed = hasMinLength && hasNumber && passwordsMatch;
    });
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate() && _validationPassed) {
      // TODO: Save new password logic
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  void _sendOtp(String method) {
    Navigator.pushNamed(
      context,
      '/otp-verification',
      arguments: {
        'method': method,
        'contact': method == 'sms' ? _phone : _email,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClaimFlowColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back,
                    color: ClaimFlowColors.textPrimary),
                padding: EdgeInsets.zero,
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Forgot Password',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: ClaimFlowColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Reset your password',
                style: GoogleFonts.sourceSans3(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: ClaimFlowColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '(Please enter your new password)',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: ClaimFlowColors.textPrimary.withOpacity(0.45),
                ),
              ),

              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: ClaimFlowColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: ClaimFlowColors.textPrimary.withOpacity(0.35),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: ClaimFlowColors.textPrimary.withOpacity(0.4),
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'Password must contain a number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: ClaimFlowColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: ClaimFlowColors.textPrimary.withOpacity(0.35),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: ClaimFlowColors.textPrimary.withOpacity(0.4),
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Validation checkbox row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _validationPassed
                          ? ClaimFlowColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: _validationPassed
                            ? ClaimFlowColors.primary
                            : ClaimFlowColors.textPrimary.withOpacity(0.3),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _validationPassed
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your Password must contain; at least 6 characters and numbers',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: ClaimFlowColors.textPrimary.withOpacity(0.5),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

            
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validationPassed ? _resetPassword : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor:
                        ClaimFlowColors.primary.withOpacity(0.4),
                    disabledForegroundColor: Colors.white,
                  ),
                  child: Text(
                    'Reset Password',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  'or',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ClaimFlowColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Reset your password via ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: ClaimFlowColors.textPrimary.withOpacity(0.55),
                    ),
                    children: [
                      TextSpan(
                        text: 'OTP',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: ClaimFlowColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

             
              _OtpOptionCard(
                icon: Icons.sms_outlined,
                iconBgColor: ClaimFlowColors.primary,
                iconColor: Colors.white,
                title: 'Send OTP via SMS',
                subtitle: _phone,
                onTap: () => _sendOtp('sms'),
              ),

              const SizedBox(height: 12),

              _OtpOptionCard(
                icon: Icons.mail_outline,
                iconBgColor: ClaimFlowColors.textPrimary.withOpacity(0.08),
                iconColor: ClaimFlowColors.textPrimary.withOpacity(0.5),
                title: 'Send OTP via Email',
                subtitle: _email,
                onTap: () => _sendOtp('email'),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpOptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OtpOptionCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ClaimFlowColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sourceSans3(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ClaimFlowColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: ClaimFlowColors.textPrimary.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}