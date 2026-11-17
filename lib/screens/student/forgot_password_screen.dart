import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_top_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (!_formKey.currentState!.validate()) return;
    // Backend call to send the OTP goes here later
    Navigator.pushNamed(
      context,
      '/otp',
      arguments: _emailController.text.trim(),
    );
  }

  Widget _helpChip(String text, IconData icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$text coming soon')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.chip,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.textDark),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header icon
                            Center(
                              child: SizedBox(
                                width: 140,
                                height: 140,
                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 130,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEDEEFF),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE4E5FF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.mark_email_unread_outlined,
                                        size: 44,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: AppColors.mintBright,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.lock_reset,
                                          size: 18,
                                          color: AppColors.teal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Center(
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.manrope(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                "Enter your email address and we'll send you a verification code to reset your password.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),
                            Text(
                              'Email Address',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            AppTextField(
                              hint: 'Enter your email',
                              icon: Icons.mail_outline,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                final ok =
                                RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                    .hasMatch(v.trim());
                                return ok
                                    ? null
                                    : 'Enter a valid email address';
                              },
                            ),
                            const SizedBox(height: 18),

                            // SSO info box
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F1FF),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.chip,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.psychology_alt_outlined,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Institutional SSO or Personal?',
                                          style: GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'If you signed up with your university or Google Workspace, you can continue directly on the login screen.',
                                          style: GoogleFonts.inter(
                                            fontSize: 15,
                                            height: 1.4,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),

                            ElevatedButton(
                              onPressed: _sendOtp,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Send OTP'),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Text(
                                    'OR',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Center(
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: [
                                  _helpChip('Need Help?',
                                      Icons.help_outline),
                                  _helpChip('Security FAQs',
                                      Icons.shield_outlined),
                                ],
                              ),
                            ),
                            const SizedBox(height: 26),
                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                      (route) => false,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.arrow_back,
                                        size: 20, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Back to Login',
                                      style: GoogleFonts.inter(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified_user_outlined,
                            size: 20, color: AppColors.teal),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'LearnXAI 256-bit Socratic Encryption Guarantee',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
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