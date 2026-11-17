import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class _Topic {
  final String name;
  final String course;
  final int mastery;
  final String severity; // High, Medium, Low
  final String reason;
  final int attempts;

  const _Topic({
    required this.name,
    required this.course,
    required this.mastery,
    required this.severity,
    required this.reason,
    required this.attempts,
  });
}

class WeakTopicsScreen extends StatefulWidget {
  const WeakTopicsScreen({super.key});

  @override
  State<WeakTopicsScreen> createState() => _WeakTopicsScreenState();
}

class _WeakTopicsScreenState extends State<WeakTopicsScreen> {
  String _filter = 'All';

  static const _topics = [
    _Topic(
      name: 'Recursion Base Cases',
      course: 'Data Structures & Algorithms',
      mastery: 38,
      severity: 'High',
      reason: 'Missed base-case questions in 3 of your last 4 quizzes.',
      attempts: 4,
    ),
    _Topic(
      name: 'Balanced Trees',
      course: 'Data Structures & Algorithms',
      mastery: 46,
      severity: 'High',
      reason: 'Confusion between AVL rotations and red-black rules.',
      attempts: 3,
    ),
    _Topic(
      name: 'DP Memoization',
      course: 'Data Structures & Algorithms',
      mastery: 55,
      severity: 'Medium',
      reason: 'Correct ideas, but slow on state definition.',
      attempts: 5,
    ),
    _Topic(
      name: 'Backpropagation',
      course: 'AI Fundamentals',
      mastery: 58,
      severity: 'Medium',
      reason: 'Chain rule steps were skipped in two answers.',
      attempts: 2,
    ),
    _Topic(
      name: 'Page Tables & TLB',
      course: 'Operating Systems',
      mastery: 64,
      severity: 'Low',
      reason: 'Minor slips on address translation examples.',
      attempts: 2,
    ),
  ];

  List<String> get _courses =>
      ['All', ..._topics.map((t) => t.course).toSet()];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/progress',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final cardW = wide ? (inner - 16) / 2 : inner;

          final list = _filter == 'All'
              ? _topics
              : _topics.where((t) => t.course == _filter).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                _summary(),
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
                      for (final t in list)
                        SizedBox(width: cardW, child: _card(context, t)),
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
          'Weak Topics',
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Concepts that need reinforcement, ranked by priority.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _summary() {
    Widget tile(String label, String value, IconData icon, Color color) {
      return Expanded(
        child: AppCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final high = _topics.where((t) => t.severity == 'High').length;
    final avg =
    (_topics.map((t) => t.mastery).reduce((a, b) => a + b) / _topics.length)
        .round();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tile('Weak Topics', '${_topics.length}', Icons.flag_outlined,
            AppColors.primary),
        const SizedBox(width: 10),
        tile('High Priority', '$high', Icons.priority_high,
            const Color(0xFFB3261E)),
        const SizedBox(width: 10),
        tile('Avg Mastery', '$avg%', Icons.insights, AppColors.teal),
      ],
    );
  }

  Widget _filters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in _courses)
          ChoiceChip(
            label: Text(
              o,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
            'No weak topics in this course. Nice work!',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, _Topic t) {
    final high = t.severity == 'High';
    final medium = t.severity == 'Medium';

    final Color sevBg = high
        ? const Color(0xFFFFE3E0)
        : medium
        ? const Color(0xFFFFE9CF)
        : AppColors.chip;
    final Color sevFg = high
        ? const Color(0xFFB3261E)
        : medium
        ? const Color(0xFF8A4B00)
        : AppColors.primary;
    final Color bar = high
        ? const Color(0xFFB3261E)
        : medium
        ? const Color(0xFFE08A1E)
        : AppColors.primaryLight;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Pill('${t.severity} priority', bg: sevBg, fg: sevFg, fontSize: 10),
              const Spacer(),
              Text(
                '${t.mastery}%',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: bar,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            t.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            t.course,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: t.mastery / 100,
              minHeight: 6,
              backgroundColor: AppColors.chip,
              valueColor: AlwaysStoppedAnimation<Color>(bar),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(Icons.info_outline,
                    size: 14, color: AppColors.textGrey),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  t.reason,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.5,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${t.attempts} attempts so far',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/ai-tutor'),
                icon: const Icon(Icons.psychology_alt_outlined, size: 18),
                label: const Text('Practice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/quiz'),
                icon: const Icon(Icons.quiz_outlined, size: 18),
                label: const Text('Quick Quiz'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chip,
                  foregroundColor: AppColors.textDark,
                  elevation: 0,
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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