import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_top_bar.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String get _pw => _passwordController.text;

  bool get _hasLength => _pw.length >= 8;
  bool get _hasUpper => RegExp(r'[A-Z]').hasMatch(_pw);
  bool get _hasLower => RegExp(r'[a-z]').hasMatch(_pw);
  bool get _hasNumOrSpecial => RegExp(r'[0-9]|[^A-Za-z0-9]').hasMatch(_pw);

  int get _metCount => [_hasLength, _hasUpper, _hasLower, _hasNumOrSpecial]
      .where((e) => e)
      .length;

  bool get _confirmFilled => _confirmController.text.isNotEmpty;
  bool get _matches => _pw == _confirmController.text;
  bool get _canSubmit => _metCount == 4 && _confirmFilled && _matches;

  String get _strengthLabel {
    switch (_metCount) {
      case 0:
        return 'Unset';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      default:
        return 'Strong';
    }
  }

  Color get _strengthColor {
    switch (_metCount) {
      case 0:
        return AppColors.textGrey;
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orange;
      case 3:
        return const Color(0xFF2E9E6B);
      default:
        return AppColors.teal;
    }
  }

  void _reset() {
    // Backend password reset call goes here later
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/password-changed',
          (route) => false,
    );
  }

  Widget _rule(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: met ? AppColors.teal : const Color(0xFFE6E7F5),
              shape: BoxShape.circle,
            ),
            child: met
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 14),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: met ? AppColors.textDark : AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AuthTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  children: [
                    // Header icon
                    SizedBox(
                      width: 120,
                      height: 110,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 104,
                            height: 104,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE4E5FF),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock_reset,
                                  size: 38,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: const BoxDecoration(
                                color: AppColors.mintBright,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_user_outlined,
                                size: 18,
                                color: AppColors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create New Password',
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your new password must be different from\nprevious ones.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // New password label + strength
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New Password',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Security: $_strengthLabel',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _strengthColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      hint: 'Enter secure password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      fillColor: Colors.white,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 18),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirm Password',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      hint: 'Confirm new password',
                      icon: Icons.lock_clock_outlined,
                      isPassword: true,
                      fillColor: Colors.white,
                      controller: _confirmController,
                    ),
                    if (_confirmFilled && !_matches)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, left: 6),
                          child: Text(
                            'Passwords do not match',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),

                    // Strength bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _metCount / 4,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE0E3F7),
                        valueColor:
                        AlwaysStoppedAnimation<Color>(_strengthColor),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Checklist
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PASSWORD CHECKLIST',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                '$_metCount/4 Met',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.teal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _rule('At least 8 characters', _hasLength),
                          _rule('One uppercase letter', _hasUpper),
                          _rule('One lowercase letter', _hasLower),
                          _rule('One number or special character',
                              _hasNumOrSpecial),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    ElevatedButton(
                      onPressed: _canSubmit ? _reset : null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.45),
                        disabledForegroundColor: Colors.white,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Reset Password'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                            (route) => false,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_back,
                              size: 20, color: AppColors.textDark),
                          const SizedBox(width: 8),
                          Text(
                            'Back to Login',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.chip,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user,
                              size: 20, color: AppColors.teal),
                          const SizedBox(width: 8),
                          Text(
                            '256-Bit Encrypted Credential Sync',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
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