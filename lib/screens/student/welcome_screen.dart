import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String tag,
    required Color tagBg,
    required Color tagText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.chip,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        tag,
                        maxLines: 1,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: tagText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.school,
                    size: 44,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: GoogleFonts.manrope(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                        children: const [
                          TextSpan(text: 'LearnX'),
                          TextSpan(
                            text: 'AI',
                            style: TextStyle(color: AppColors.primaryLight),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.circle, size: 9, color: AppColors.teal),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Your AI Learning Analytics Companion',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 28),

              // Feature cards
              _featureCard(
                icon: Icons.route_outlined,
                title: 'Personalized Learning Path',
                subtitle: 'Dynamic curricula mapped to your retention',
                tag: 'Adaptive',
                tagBg: AppColors.mint,
                tagText: AppColors.teal,
              ),
              _featureCard(
                icon: Icons.psychology_alt_outlined,
                title: 'Socratic AI Tutor',
                subtitle: 'Guided reasoning prompts over direct answers',
                tag: 'Interactive',
                tagBg: AppColors.chip,
                tagText: AppColors.primary,
              ),
              _featureCard(
                icon: Icons.bar_chart_rounded,
                title: 'Progress Tracking & Analytics',
                subtitle: 'Mastery velocity & calibrated recall scoring',
                tag: 'Real-time',
                tagBg: const Color(0xFFFFF0E0),
                tagText: const Color(0xFF8A4B00),
              ),
              _featureCard(
                icon: Icons.verified_outlined,
                title: 'Explainable AI Insights',
                subtitle: 'Transparent citations with structured diagnostics',
                tag: '99.4% Verifiable',
                tagBg: AppColors.mint,
                tagText: AppColors.teal,
              ),
              const SizedBox(height: 4),

              // Active engine card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFECEDFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.teal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Engine',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Cognitive Diagnostic v4.2',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.circle,
                              size: 8, color: AppColors.teal),
                          const SizedBox(width: 6),
                          Text(
                            'Online',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Get Started
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/onboarding'),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Get Started'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Login link
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      'Login',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLight,
                      ),
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