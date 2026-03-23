import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'biometric_auth_screen.dart';
import 'package:claimflow_africa/screens/newuser/dashboard_screen.dart';

/// Modes the PIN screen can be in
enum _PinMode {
  create,   // No PIN saved yet — user is creating one
  confirm,  // User just entered a new PIN — confirm it
  verify,   // PIN already exists — user is signing in
}

class PinSignInScreen extends StatefulWidget {
  const PinSignInScreen({super.key});

  @override
  State<PinSignInScreen> createState() => _PinSignInScreenState();
}

class _PinSignInScreenState extends State<PinSignInScreen>
    with SingleTickerProviderStateMixin {
  static const _storage = FlutterSecureStorage();
  static const _pinKey = 'user_pin_hash';
  static const _attemptsKey = 'pin_failed_attempts';
  static const _lockUntilKey = 'pin_lock_until';
  static const _maxAttempts = 5;
  static const _lockDurationSeconds = 30;

  final int _pinLength = 4;

  _PinMode _mode = _PinMode.verify; // default; overridden in initState
  String _enteredPin = '';
  String _firstPin = ''; // stores first entry during create flow
  bool _hasError = false;
  String _errorMessage = '';
  bool _isLoading = true; // true while we check storage on launch

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _checkPinExists();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  // ─── Startup check ─────────────────────────

  Future<void> _checkPinExists() async {
    final storedHash = await _storage.read(key: _pinKey);
    setState(() {
      _mode = storedHash == null ? _PinMode.create : _PinMode.verify;
      _isLoading = false;
    });
  }

  // ─── Labels per mode ───────────────────────

  String get _title {
    switch (_mode) {
      case _PinMode.create:
        return 'Create your PIN';
      case _PinMode.confirm:
        return 'Confirm your PIN';
      case _PinMode.verify:
        return 'Welcome Back';
    }
  }

  String get _subtitle {
    switch (_mode) {
      case _PinMode.create:
        return 'Choose a 4-digit PIN to secure your account';
      case _PinMode.confirm:
        return 'Enter the same PIN again to confirm';
      case _PinMode.verify:
        return 'Enter your PIN to access your dashboard';
    }
  }

  // ─── Helpers ───────────────────────────────

  String _hashPin(String pin) =>
      sha256.convert(utf8.encode(pin)).toString();

  // ─── Lockout logic ─────────────────────────

  Future<bool> _isLockedOut() async {
    final lockUntilStr = await _storage.read(key: _lockUntilKey);
    if (lockUntilStr == null) return false;
    final lockUntil = DateTime.parse(lockUntilStr);
    return DateTime.now().isBefore(lockUntil);
  }

  Future<Duration> _remainingLockTime() async {
    final lockUntilStr = await _storage.read(key: _lockUntilKey);
    if (lockUntilStr == null) return Duration.zero;
    final lockUntil = DateTime.parse(lockUntilStr);
    final remaining = lockUntil.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Future<void> _recordFailedAttempt() async {
    final attemptsStr = await _storage.read(key: _attemptsKey);
    final attempts = int.tryParse(attemptsStr ?? '0') ?? 0;
    final newAttempts = attempts + 1;
    await _storage.write(key: _attemptsKey, value: newAttempts.toString());

    if (newAttempts >= _maxAttempts) {
      final lockUntil = DateTime.now()
          .add(const Duration(seconds: _lockDurationSeconds));
      await _storage.write(
          key: _lockUntilKey, value: lockUntil.toIso8601String());
      await _storage.write(key: _attemptsKey, value: '0');
    }
  }

  Future<void> _resetFailedAttempts() async {
    await _storage.delete(key: _attemptsKey);
    await _storage.delete(key: _lockUntilKey);
  }

  // ─── Input handlers ────────────────────────

  void _onKeyPressed(String value) {
    if (_hasError) _clearError();
    if (_enteredPin.length < _pinLength) {
      setState(() => _enteredPin += value);
    }
  }

  void _onBackspace() {
    if (_hasError) _clearError();
    if (_enteredPin.isNotEmpty) {
      setState(() =>
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
    }
  }

  void _onEnter() {
    if (_enteredPin.length < _pinLength) {
      _triggerError('Please enter all $_pinLength digits');
      return;
    }

    switch (_mode) {
      case _PinMode.create:
        _handleCreate();
        break;
      case _PinMode.confirm:
        _handleConfirm();
        break;
      case _PinMode.verify:
        _handleVerify();
        break;
    }
  }

  // ─── Mode handlers ─────────────────────────

  void _handleCreate() {
    // Save the first entry and move to confirm step
    setState(() {
      _firstPin = _enteredPin;
      _enteredPin = '';
      _mode = _PinMode.confirm;
    });
  }

  void _handleConfirm() {
    if (_enteredPin != _firstPin) {
      setState(() {
        _firstPin = '';
        _mode = _PinMode.create;
      });
      _triggerError("PINs don't match. Please try again.");
      return;
    }
    _saveNewPin(_enteredPin);
  }

  Future<void> _saveNewPin(String pin) async {
    setState(() => _isLoading = true);
    final hash = _hashPin(pin);
    await _storage.write(key: _pinKey, value: hash);
    await _resetFailedAttempts();
    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  Future<void> _handleVerify() async {
    setState(() => _isLoading = true);

    // Check lockout
    if (await _isLockedOut()) {
      final remaining = await _remainingLockTime();
      setState(() => _isLoading = false);
      _triggerError(
          'Too many attempts. Try again in ${remaining.inSeconds + 1} seconds.');
      return;
    }

    final storedHash = await _storage.read(key: _pinKey);
    final enteredHash = _hashPin(_enteredPin);

    if (enteredHash == storedHash) {
      await _resetFailedAttempts();
      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } else {
      await _recordFailedAttempt();
      setState(() => _isLoading = false);

      final attemptsStr = await _storage.read(key: _attemptsKey);
      final attempts = int.tryParse(attemptsStr ?? '0') ?? 0;
      final remaining = _maxAttempts - attempts;

      if (attempts == 0) {
        _triggerError(
            'Too many attempts. Try again in $_lockDurationSeconds seconds.');
      } else {
        _triggerError(
            'Incorrect PIN. $remaining attempt${remaining == 1 ? '' : 's'} remaining.');
      }
    }
  }

  // ─── Error helpers ─────────────────────────

  void _triggerError(String message) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
      _enteredPin = '';
    });
    _shakeController.forward(from: 0);
  }

  void _clearError() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
  }

  void _onFingerprintPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BiometricAuthScreen()),
    );
  }

  // ─── UI ────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Cancel button (hide during create/confirm — user must finish)
                        if (_mode == _PinMode.verify)
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
                          )
                        else if (_mode == _PinMode.confirm)
                          // Allow going back to create step
                          TextButton(
                            onPressed: () => setState(() {
                              _mode = _PinMode.create;
                              _enteredPin = '';
                              _firstPin = '';
                              _hasError = false;
                            }),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Back',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 20),

                        const SizedBox(height: 24),

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
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.1),
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

                              // Title & subtitle — animate when mode changes
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Column(
                                  key: ValueKey(_mode),
                                  children: [
                                    Text(
                                      _title,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _subtitle,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              // PIN dots with shake animation
                              AnimatedBuilder(
                                animation: _shakeAnimation,
                                builder: (context, child) {
                                  final offset = _shakeAnimation.value == 0
                                      ? 0.0
                                      : ((_shakeAnimation.value * 4).round() %
                                                  2 ==
                                              0
                                          ? 8.0
                                          : -8.0) *
                                          _shakeAnimation.value;
                                  return Transform.translate(
                                    offset: Offset(offset, 0),
                                    child: child,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(_pinLength, (index) {
                                    final filled = index < _enteredPin.length;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _hasError
                                            ? theme.colorScheme.error
                                            : filled
                                                ? theme.colorScheme.primary
                                                : Colors.transparent,
                                        border: Border.all(
                                          color: _hasError
                                              ? theme.colorScheme.error
                                              : filled
                                                  ? theme.colorScheme.primary
                                                  : theme.colorScheme.outline,
                                          width: 2,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),

                              // Error message
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _hasError
                                    ? Padding(
                                        key: const ValueKey('error'),
                                        padding:
                                            const EdgeInsets.only(top: 10),
                                        child: Text(
                                          _errorMessage,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.colorScheme.error,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : const SizedBox(
                                        key: ValueKey('no-error'), height: 10),
                              ),

                              const SizedBox(height: 20),

                              // Keypad
                              _Keypad(
                                onKeyPressed: _onKeyPressed,
                                onBackspace: _onBackspace,
                                onEnter: _onEnter,
                              ),

                              const SizedBox(height: 24),

                              // Fingerprint button — only show in verify mode
                              if (_mode == _PinMode.verify)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _onFingerprintPressed,
                                    icon: const Icon(Icons.fingerprint,
                                        size: 20),
                                    label: const Text('Use Fingerprint'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                      foregroundColor:
                                          theme.colorScheme.onPrimary,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
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

            // Loading overlay
            if (_isLoading)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black12,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Keypad
// ─────────────────────────────────────────────

class _Keypad extends StatelessWidget {
  final void Function(String) onKeyPressed;
  final VoidCallback onBackspace;
  final VoidCallback onEnter;

  const _Keypad({
    required this.onKeyPressed,
    required this.onBackspace,
    required this.onEnter,
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
            _BackspaceButton(onTap: onBackspace),
            _KeypadButton(label: '0', onTap: () => onKeyPressed('0')),
            _EnterButton(onTap: onEnter),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Keypad Button
// ─────────────────────────────────────────────

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

// ─────────────────────────────────────────────
// Backspace Button
// ─────────────────────────────────────────────

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

// ─────────────────────────────────────────────
// Enter Button
// ─────────────────────────────────────────────

class _EnterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _EnterButton({required this.onTap});

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
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.arrow_forward_rounded,
          size: 26,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}