import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:claimflow_africa/screens/newuser/dashboard_screen.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final _auth = LocalAuthentication();

  _BiometricState _state = _BiometricState.idle;
  String _errorMessage = '';
  bool _biometricsAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  // ─── Check device support ──────────────────

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        setState(() {
          _biometricsAvailable = false;
          _state = _BiometricState.unavailable;
          _errorMessage =
              'Biometrics not available on this device. Please use your PIN.';
        });
        return;
      }

      final availableBiometrics = await _auth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        setState(() {
          _biometricsAvailable = false;
          _state = _BiometricState.unavailable;
          _errorMessage =
              'No biometrics enrolled. Please set up fingerprint or face in your device settings.';
        });
        return;
      }

      setState(() => _biometricsAvailable = true);

      // Auto-trigger on open
      _authenticate();
    } catch (e) {
      setState(() {
        _biometricsAvailable = false;
        _state = _BiometricState.error;
        _errorMessage = 'Could not check biometrics: $e';
      });
    }
  }

  // ─── Authenticate ──────────────────────────

  Future<void> _authenticate() async {
    if (!_biometricsAvailable) return;

    setState(() {
      _state = _BiometricState.authenticating;
      _errorMessage = '';
    });

    try {
      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint or face to sign in to ClaimFlow',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true, // keeps prompt alive if app goes to background
        ),
      );

      if (didAuthenticate) {
        setState(() => _state = _BiometricState.success);
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } else {
        // User cancelled or dismissed
        setState(() {
          _state = _BiometricState.idle;
          _errorMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        _state = _BiometricState.error;
        _errorMessage = _friendlyError(e.toString());
      });
    }
  }

  /// Converts PlatformException codes to user-friendly strings
  String _friendlyError(String raw) {
    if (raw.contains(auth_error.notEnrolled)) {
      return 'No biometrics enrolled on this device.';
    } else if (raw.contains(auth_error.lockedOut) ||
        raw.contains(auth_error.permanentlyLockedOut)) {
      return 'Biometrics locked due to too many attempts. Use your PIN.';
    } else if (raw.contains(auth_error.notAvailable)) {
      return 'Biometrics not available. Use your PIN instead.';
    }
    return 'Authentication failed. Please try again.';
  }

  // ─── UI ────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Fingerprint icon — changes color based on state
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _iconBorderColor(theme),
                    width: 2,
                  ),
                  color: _iconBgColor(theme),
                ),
                child: _state == _BiometricState.authenticating
                    ? Padding(
                        padding: const EdgeInsets.all(28),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : Icon(
                        _state == _BiometricState.success
                            ? Icons.check_rounded
                            : Icons.fingerprint,
                        size: 56,
                        color: _iconColor(theme),
                      ),
              ),

              const SizedBox(height: 28),

              // Title
              Text(
                'Biometric Authentication',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Subtitle / status message
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  key: ValueKey(_state),
                  _statusText(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _state == _BiometricState.error ||
                            _state == _BiometricState.unavailable
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // Authenticate button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _biometricsAvailable &&
                          _state != _BiometricState.authenticating &&
                          _state != _BiometricState.success
                      ? _authenticate
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    disabledBackgroundColor:
                        theme.colorScheme.primary.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _state == _BiometricState.error ? 'Try Again' : 'Authenticate',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel / Use PIN button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  _state == _BiometricState.unavailable
                      ? 'Use PIN instead'
                      : 'Cancel',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── State-driven helpers ──────────────────

  String _statusText() {
    switch (_state) {
      case _BiometricState.idle:
        return 'Authenticate using your fingerprint or face to access ClaimFlow.';
      case _BiometricState.authenticating:
        return 'Waiting for biometric confirmation…';
      case _BiometricState.success:
        return 'Authenticated successfully!';
      case _BiometricState.error:
        return _errorMessage;
      case _BiometricState.unavailable:
        return _errorMessage;
    }
  }

  Color _iconColor(ThemeData theme) {
    switch (_state) {
      case _BiometricState.success:
        return Colors.green;
      case _BiometricState.error:
      case _BiometricState.unavailable:
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurface.withOpacity(0.5);
    }
  }

  Color _iconBorderColor(ThemeData theme) {
    switch (_state) {
      case _BiometricState.success:
        return Colors.green.withOpacity(0.4);
      case _BiometricState.error:
      case _BiometricState.unavailable:
        return theme.colorScheme.error.withOpacity(0.4);
      case _BiometricState.authenticating:
        return theme.colorScheme.primary.withOpacity(0.3);
      default:
        return theme.colorScheme.onSurface.withOpacity(0.15);
    }
  }

  Color _iconBgColor(ThemeData theme) {
    switch (_state) {
      case _BiometricState.success:
        return Colors.green.withOpacity(0.08);
      case _BiometricState.error:
      case _BiometricState.unavailable:
        return theme.colorScheme.error.withOpacity(0.08);
      case _BiometricState.authenticating:
        return theme.colorScheme.primary.withOpacity(0.06);
      default:
        return Colors.transparent;
    }
  }
}

enum _BiometricState {
  idle,
  authenticating,
  success,
  error,
  unavailable,
}