import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class _Rec {
  final String title;
  final String reason;
  final String type; // Lesson, Practice, Quiz, Review
  final String course;
  final int minutes;
  final int confidence;
  final String route;
  final IconData icon;
  final String button;

  const _Rec({
    required this.title,
    required this.reason,
    required this.type,
    required this.course,
    required this.minutes,
    required this.confidence,
    required this.route,
    required this.icon,
    required this.button,
  });
}

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  String _filter = 'All';
  final Set<String> _dismissed = {};

  static const _recs = [
    _Rec(
      title: 'Review Backpropagation with the Socratic Tutor',
      reason:
      'You skipped chain rule steps in two answers. A guided session closes this gap fastest.',
      type: 'Practice',
      course: 'AI Fundamentals',
      minutes: 15,
      confidence: 92,
      route: '/ai-tutor',
      icon: Icons.psychology_alt_outlined,
      button: 'Start Session',
    ),
    _Rec(
      title: 'Continue: Neural Network Architectures',
      reason:
      'This is your next lesson and it unlocks the Unit 4 Test.',
      type: 'Lesson',
      course: 'AI Fundamentals',
      minutes: 30,
      confidence: 88,
      route: '/lesson',
      icon: Icons.play_circle_outline,
      button: 'Open Lesson',
    ),
    _Rec(
      title: 'Take a 5-question Recursion Quiz',
      reason:
      'Base-case errors appeared in 3 of your last 4 quizzes. Short repeated practice improves recall.',
      type: 'Quiz',
      course: 'Data Structures & Algorithms',
      minutes: 10,
      confidence: 85,
      route: '/quiz',
      icon: Icons.quiz_outlined,
      button: 'Start Quiz',
    ),
    _Rec(
      title: 'Revisit Balanced Trees',
      reason:
      'Your mastery is 46%. Reviewing rotations before the next test should raise it.',
      type: 'Review',
      course: 'Data Structures & Algorithms',
      minutes: 20,
      confidence: 81,
      route: '/weak-topics',
      icon: Icons.flag_outlined,
      button: 'View Gap',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/recommendations',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final cardW = wide ? (inner - 16) / 2 : inner;

          final list = _recs
              .where((r) => !_dismissed.contains(r.title))
              .where((r) => _filter == 'All' || r.type == _filter)
              .toList();

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                _banner(),
                const SizedBox(height: 16),
                _filters(),
                const SizedBox(height: 16),
                if (list.isEmpty)
                  _empty()
                else
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final r in list)
                        SizedBox(width: cardW, child: _card(context, r)),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Personalized next steps based on your mastery, pace and gaps.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _banner() {
    return AppCard(
      color: const Color(0xFFF4F7FF),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.chip,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s plan: about 45 minutes',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Finishing these 3 steps keeps you on track for your 75% daily goal.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.4,
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

  Widget _filters() {
    const options = ['All', 'Lesson', 'Practice', 'Quiz', 'Review'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          ChoiceChip(
            label: Text(
              o,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _filter == o ? Colors.white : AppColors.textDark,
              ),
            ),
            selected: _filter == o,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.chip,
            showCheckmark: false,
            onSelected: (_) => setState(() => _filter = o),
          ),
      ],
    );
  }

  Widget _empty() {
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No recommendations here. You are all caught up!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, _Rec r) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(r.icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Pill(r.type, fontSize: 10),
              const Spacer(),
              Pill('${r.confidence}% match',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            r.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 16,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${r.course} • ${r.minutes} min',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(Icons.info_outline,
                      size: 14, color: AppColors.primary),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Why: ${r.reason}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, r.route),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(
                    r.button,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => setState(() => _dismissed.add(r.title)),
                child: Text(
                  'Dismiss',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}