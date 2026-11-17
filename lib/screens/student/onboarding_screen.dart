import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class _OnboardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String chip1;
  final IconData chip1Icon;
  final String chip2;
  final IconData chip2Icon;

  const _OnboardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.chip1,
    required this.chip1Icon,
    required this.chip2,
    required this.chip2Icon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _current = 0;

  static const List<_OnboardData> _pages = [
    _OnboardData(
      icon: Icons.trending_up_rounded,
      title: 'AI-Powered Personalized Learning',
      subtitle:
      'Get tailored learning paths, smart recommendations and focus on what matters most for you.',
      chip1: 'Dynamic Curricula',
      chip1Icon: Icons.auto_awesome,
      chip2: 'Socratic Logic',
      chip2Icon: Icons.psychology_alt_outlined,
    ),
    _OnboardData(
      icon: Icons.forum_outlined,
      title: 'Learn With a Socratic AI Tutor',
      subtitle:
      'Think through problems with guided questions that build real understanding, not just answers.',
      chip1: 'Guided Prompts',
      chip1Icon: Icons.lightbulb_outline,
      chip2: 'Deep Thinking',
      chip2Icon: Icons.psychology_outlined,
    ),
    _OnboardData(
      icon: Icons.insights_rounded,
      title: 'Track Your Mastery in Real Time',
      subtitle:
      'See your progress, spot weak areas early and understand every recommendation clearly.',
      chip1: 'Live Analytics',
      chip1Icon: Icons.bar_chart_rounded,
      chip2: 'Explainable AI',
      chip2Icon: Icons.verified_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _next() {
    if (_current == _pages.length - 1) {
      _goToLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _chip(String text, IconData icon, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFE8FFFA)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 230,
                height: 230,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDEEFF),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Icon(data.icon,
                          size: 64, color: AppColors.primary),
                    ),
                    Positioned(
                      top: 28,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.circle,
                                size: 8, color: AppColors.teal),
                            const SizedBox(width: 5),
                            Text(
                              'AI Adaptive',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 36,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.show_chart,
                                size: 16, color: AppColors.teal),
                            const SizedBox(width: 4),
                            Text(
                              '+28%',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
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
          ),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _chip(data.chip1, data.chip1Icon, AppColors.mint,
                  AppColors.teal),
              _chip(data.chip2, data.chip2Icon, AppColors.chip,
                  AppColors.textGrey),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _current == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.chip,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,
                            size: 9, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'STAGE ${_current + 1} OF ${_pages.length}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _goToLogin,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (context, i) => _buildPage(_pages[i]),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 36 : 12,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primary
                          : const Color(0xFFD5D6E5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _next,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLast ? 'Get Started' : 'Next'),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToLogin,
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}