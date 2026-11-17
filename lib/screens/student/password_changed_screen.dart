import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  Widget _dot(double size, Color color, {double? top, double? left, double? right, double? bottom}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Success icon with decorative dots
              SizedBox(
                width: 280,
                height: 230,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.mintBright.withValues(alpha: 0.25),
                            AppColors.mintBright.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.teal.withValues(alpha: 0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check,
                          size: 70, color: Colors.white),
                    ),
                    _dot(22, const Color(0xFFFFB454), top: 25, left: 40),
                    _dot(18, AppColors.primaryLight, bottom: 40, left: 55),
                    _dot(14, AppColors.mintBright, top: 70, right: 25),
                    _dot(26, AppColors.mintBright, bottom: 45, right: 55),
                    _dot(26, AppColors.teal, top: 10, right: 60),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Password Changed!',
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your password has been updated successfully.\nYou can now log in with your new password.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.6,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 22),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEEFF),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user_outlined,
                        size: 20, color: AppColors.teal),
                    const SizedBox(width: 8),
                    Text(
                      '256-bit Token Encrypted',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Go to Login'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              SizedBox(
                width: 80,
                height: 60,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.school,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '"A new chapter in your learning journey begins!"',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LearnXAI',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.circle, size: 6, color: AppColors.teal),
                  const SizedBox(width: 8),
                  Text(
                    'Cognitive Engine',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                    ),
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