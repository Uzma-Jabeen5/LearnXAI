import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/auth_top_bar.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _length = 6;
  static const int _startSeconds = 60;

  final List<TextEditingController> _controllers =
  List.generate(_length, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(_length, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = _startSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
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
    setState(() => _secondsLeft = _startSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _timeText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _resend() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    _startTimer();
    // Backend call to resend the OTP goes here later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A new code has been sent (demo)')),
    );
  }

  void _verify() {
    if (_code.length < _length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit code')),
      );
      return;
    }
    // Backend OTP check goes here later
    Navigator.pushNamed(context, '/new-password');
  }

  Widget _otpBox(int i) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: i == _length - 1 ? 0 : 8),
        child: Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace &&
                _controllers[i].text.isEmpty &&
                i > 0) {
              _focusNodes[i - 1].requestFocus();
              _controllers[i - 1].clear();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: SizedBox(
            height: 62,
            child: TextField(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
              onChanged: (v) {
                if (v.isNotEmpty && i < _length - 1) {
                  _focusNodes[i + 1].requestFocus();
                } else if (v.isNotEmpty && i == _length - 1) {
                  _focusNodes[i].unfocus();
                }
                setState(() {});
              },
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: _focusNodes[i].hasFocus
                    ? AppColors.inputFill
                    : Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email =
        (ModalRoute.of(context)?.settings.arguments as String?) ??
            'your email';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AuthTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    // Icon
                    SizedBox(
                      width: 120,
                      height: 110,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDEEFF),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Center(
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.mark_email_unread_outlined,
                                  size: 36,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: const BoxDecoration(
                                color: AppColors.teal,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lock_reset,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Check Your Email',
                      style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "We've sent a 6-digit verification code to your\nemail address.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        height: 1.6,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Email pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.alternate_email,
                              size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              email,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 6 boxes
                    Row(
                      children: List.generate(_length, _otpBox),
                    ),
                    const SizedBox(height: 28),

                    // Timer / resend
                    _secondsLeft > 0
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.schedule,
                            size: 20, color: AppColors.textGrey),
                        const SizedBox(width: 8),
                        Text(
                          'Resend code in ',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            color: AppColors.textGrey,
                          ),
                        ),
                        Text(
                          _timeText,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    )
                        : GestureDetector(
                      onTap: _resend,
                      child: Text(
                        'Resend code',
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),

                    ElevatedButton(
                      onPressed: _verify,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Verify Code'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.chevron_left,
                              size: 22, color: AppColors.textDark),
                          Text(
                            'Back to Forgot Password',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified_user_outlined,
                            size: 20, color: AppColors.teal),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '256-BIT ENCRYPTED ONE-TIME AUTHORIZATION',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}