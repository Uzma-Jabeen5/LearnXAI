import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class _Test {
  final String title;
  final String course;
  final String type; // Midterm, Unit Test, Final
  final String date;
  final String time;
  final int minutes;
  final int questions;
  final String status; // Scheduled, Completed
  final int? score;
  final bool proctored;

  const _Test({
    required this.title,
    required this.course,
    required this.type,
    required this.date,
    required this.time,
    required this.minutes,
    required this.questions,
    required this.status,
    this.score,
    required this.proctored,
  });
}

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  String _filter = 'All';

  static const _tests = [
    _Test(
      title: 'Python Midterm Exam',
      course: 'Intro to Python',
      type: 'Midterm',
      date: 'Nov 02',
      time: '2:00 PM',
      minutes: 90,
      questions: 40,
      status: 'Scheduled',
      proctored: true,
    ),
    _Test(
      title: 'Unit 4 Test: Deep Learning',
      course: 'AI Fundamentals',
      type: 'Unit Test',
      date: 'Nov 08',
      time: '10:00 AM',
      minutes: 45,
      questions: 25,
      status: 'Scheduled',
      proctored: true,
    ),
    _Test(
      title: 'Unit 3 Test: Sorting',
      course: 'Data Structures & Algorithms',
      type: 'Unit Test',
      date: 'Oct 21',
      time: '11:00 AM',
      minutes: 45,
      questions: 25,
      status: 'Completed',
      score: 76,
      proctored: true,
    ),
    _Test(
      title: 'Search & Optimization Test',
      course: 'AI Fundamentals',
      type: 'Unit Test',
      date: 'Oct 05',
      time: '9:00 AM',
      minutes: 40,
      questions: 20,
      status: 'Completed',
      score: 91,
      proctored: false,
    ),
  ];

  int _count(String s) => _tests.where((t) => t.status == s).length;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/tests',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final cardW = wide ? (inner - 16) / 2 : inner;

          final list = _filter == 'All'
              ? _tests
              : _tests.where((t) => t.status == _filter).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                _summary(),
                const SizedBox(height: 16),
                _guidelines(),
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
          'Tests & Exams',
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Scheduled midterms, unit tests and your past results.',
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

    final done = _tests.where((t) => t.score != null).toList();
    final avg = done.isEmpty
        ? 0
        : (done.map((t) => t.score!).reduce((a, b) => a + b) / done.length)
        .round();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tile('Scheduled', '${_count('Scheduled')}', Icons.event_outlined,
            AppColors.primary),
        const SizedBox(width: 10),
        tile('Completed', '${_count('Completed')}',
            Icons.check_circle_outline, AppColors.teal),
        const SizedBox(width: 10),
        tile('Avg Score', '$avg%', Icons.insights, AppColors.primaryLight),
      ],
    );
  }

  Widget _guidelines() {
    Widget item(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.check_circle_outline,
                size: 14, color: AppColors.teal),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t,
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );

    return AppCard(
      color: const Color(0xFFF4F7FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Proctoring Guidelines',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Pill('Active & Verified',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 12),
          item('Use a quiet room with stable internet.'),
          item('Keep your camera on for the full test.'),
          item('Do not switch apps or tabs during the test.'),
        ],
      ),
    );
  }

  Widget _filters() {
    const options = ['All', 'Scheduled', 'Completed'];
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
            'No tests in this category.',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
          ),
        ),
      ),
    );
  }

  Widget _meta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textGrey),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey),
        ),
      ],
    );
  }

  Widget _card(BuildContext context, _Test t) {
    final completed = t.status == 'Completed';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Pill(t.type, fontSize: 10),
              const SizedBox(width: 8),
              Pill(
                t.status,
                bg: completed ? AppColors.mint : AppColors.chip,
                fg: completed ? AppColors.teal : AppColors.primary,
                fontSize: 10,
              ),
              const Spacer(),
              if (t.score != null)
                Text(
                  '${t.score}%',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.teal,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            t.title,
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
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _meta(Icons.event_outlined, '${t.date} • ${t.time}'),
              _meta(Icons.timer_outlined, '${t.minutes} min'),
              _meta(Icons.help_outline, '${t.questions} questions'),
              if (t.proctored)
                _meta(Icons.videocam_outlined, 'Proctored'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(
                  context, completed ? '/quiz-result' : '/quiz'),
              icon: Icon(completed ? Icons.fact_check_outlined : Icons.play_arrow,
                  size: 18),
              label: Text(completed ? 'View Result' : 'Start Test'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                completed ? AppColors.teal : AppColors.primaryLight,
                minimumSize: const Size(0, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}