import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _pill(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.textGrey),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Top badges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,
                            size: 8, color: AppColors.teal),
                        const SizedBox(width: 6),
                        Text(
                          'V2.4 NEURAL CORE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _pill('Socratic Engine', icon: Icons.lock_outline),
                ],
              ),

              // Center content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.school,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -8,
                            right: -8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.mintBright,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.auto_awesome,
                                  size: 14, color: AppColors.textDark),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                          children: const [
                            TextSpan(text: 'Learn'),
                            TextSpan(
                              text: 'X',
                              style: TextStyle(color: AppColors.primaryLight),
                            ),
                            TextSpan(text: 'AI'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'COGNITIVE ANALYTICS',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Learn Smarter. Think Deeper.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _pill('Socratic Tutors'),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.circle,
                                size: 5, color: AppColors.textGrey),
                          ),
                          _pill('Explainable AI'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom progress
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final percent = (_controller.value * 100).round();
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.sync,
                                  size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                'Ready to accelerate mastery.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$percent%',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          minHeight: 6,
                          backgroundColor: AppColors.chip,
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Research-Grade Mastery Architecture',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}