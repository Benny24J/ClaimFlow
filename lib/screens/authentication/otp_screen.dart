import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/screens/popup/new_password.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  static const int _totalSeconds = 195;
  int _secondsRemaining = _totalSeconds;
  Timer? _timer;
  bool _canResend = false;

  String _method = 'sms';
  String _contact = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _method = args['method'] ?? 'sms';
        _contact = args['contact'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = _totalSeconds;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
          _canResend = true;
        });
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}s';
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    setState(() {});
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      setState(() {});
    }
  }

  bool get _isComplete =>
      _controllers.every((c) => c.text.isNotEmpty);

  void _verify() {
    if (!_isComplete) return;
    showPasswordSuccessDialog(context);
  }

  void _resend() {
    if (!_canResend) return;
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'OTP resent to $_contact',
          style: GoogleFonts.inter(fontSize: 13),
        ),
        backgroundColor: ClaimFlowColors.primary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _method == 'sms'
        ? 'We\'ve sent the code to your phone'
        : 'We\'ve sent the code to your email';

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

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Enter OTP Code',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: ClaimFlowColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: ClaimFlowColors.textPrimary.withOpacity(0.5),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return _OtpBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (val) => _onChanged(val, index),
                    onKeyEvent: (event) => _onKeyEvent(event, index),
                  );
                }),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: _canResend
                    ? GestureDetector(
                        onTap: _resend,
                        child: Text(
                          'Resend Code',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ClaimFlowColors.primary,
                          ),
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          text: 'Code expires in ',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: ClaimFlowColors.textPrimary
                                .withOpacity(0.45),
                          ),
                          children: [
                            TextSpan(
                              text: _formattedTime,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: ClaimFlowColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isComplete ? _verify : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor:
                        ClaimFlowColors.primary.withOpacity(0.4),
                    disabledForegroundColor: Colors.white,
                  ),
                  child: Text(
                    'Verify',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/signin'),
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  final _keyboardFocusNode = FocusNode();

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      onKeyEvent: widget.onKeyEvent,
      child: SizedBox(
        width: 72,
        height: 72,
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.sourceSans3(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ClaimFlowColors.textPrimary,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: ClaimFlowColors.surface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ClaimFlowColors.textPrimary.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: ClaimFlowColors.primary,
                width: 1.8,
              ),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}