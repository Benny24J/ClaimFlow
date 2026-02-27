import 'package:flutter/material.dart';
import 'biometric_auth_screen.dart';

class PinSignInScreen extends StatefulWidget {
  const PinSignInScreen({super.key});

  @override
  State<PinSignInScreen> createState() => _PinSignInScreenState();
}

class _PinSignInScreenState extends State<PinSignInScreen> {
  final int _pinLength = 4;
  String _enteredPin = '';

  void _onKeyPressed(String value) {
    if (_enteredPin.length < _pinLength) {
      setState(() => _enteredPin += value);
      if (_enteredPin.length == _pinLength) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
    }
  }

  void _verifyPin() {
    // TODO: Implement PIN verification logic
    debugPrint('PIN entered: $_enteredPin');
  }

  void _onFingerprintPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BiometricAuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
        

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Cancel button - top left
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Cancel',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Center the rest of the content
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                    // Logo
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/logo22.png',
                          height: 64,
                          width: 64,
                          errorBuilder: (_, __, ___) => Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shield_outlined,
                              size: 36,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ClaimFlow',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'AFRICA',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 3,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Welcome text
                    Text(
                      'Welcome Back',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Enter your PIN to access your dashboard',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 28),

                    // PIN dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pinLength, (index) {
                        final filled = index < _enteredPin.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: filled
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline,
                              width: 2,
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 32),

                    // Keypad
                    _Keypad(
                      onKeyPressed: _onKeyPressed,
                      onBackspace: _onBackspace,
                    ),

                    const SizedBox(height: 24),

                    // Use Fingerprint button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _onFingerprintPressed,
                        icon: const Icon(Icons.fingerprint, size: 20),
                        label: const Text('Use Fingerprint'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Home indicator
            Container(
              width: 120,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final void Function(String) onKeyPressed;
  final VoidCallback onBackspace;

  const _Keypad({
    required this.onKeyPressed,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Column(
      children: [
        ...keys.map(
          (row) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row
                .map((key) => _KeypadButton(
                      label: key,
                      onTap: () => onKeyPressed(key),
                    ))
                .toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80, height: 80),
            _KeypadButton(label: '0', onTap: () => onKeyPressed('0')),
            _BackspaceButton(onTap: onBackspace),
          ],
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeypadButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _BackspaceButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackspaceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Icon(
          Icons.backspace_outlined,
          size: 24,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }
}