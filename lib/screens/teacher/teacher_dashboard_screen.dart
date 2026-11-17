import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  static const _amber = Color(0xFF8A4B00);
  static const _red = Color(0xFFB3261E);
  static const _softAmber = Color(0xFFFFE9CF);
  static const _soft = Color(0xFFF4F7FF);

  // Routes that exist already. Add each new teacher route here as you build it.
  static const _ready = <String>{
    '/teacher-create-course',
    '/teacher-notes',
    '/teacher-lectures',
    '/teacher-notifications',
    '/teacher-quiz-builder',
  };

  void _open(BuildContext context, String route, String label) {
    if (_ready.contains(route)) {
      Navigator.pushNamed(context, route);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(label)));
    }
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  ButtonStyle _btn(Color bg, Color fg) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      minimumSize: const Size(0, 42),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  Widget _grid(List<Widget> items, {double minItemWidth = 200}) {
    return LayoutBuilder(
      builder: (context, cc) {
        int cols = ((cc.maxWidth + 12) / (minItemWidth + 12)).floor();
        if (cols < 1) cols = 1;
        if (cols > items.length) cols = items.length;
        final w = (cc.maxWidth - 12 * (cols - 1)) / cols;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [for (final i in items) SizedBox(width: w, child: i)],
        );
      },
    );
  }

  Widget _title(String t, {String? sub, Widget? trailing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                t,
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing],
          ],
        ),
        if (sub != null) ...[
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.4,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/teacher-dashboard',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.66 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                const SizedBox(height: 16),
                _stats(inner),
                const SizedBox(height: 16),
                _insights(context),
                const SizedBox(height: 16),
                _courses(context),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SizedBox(
                      width: mainW,
                      child: Column(
                        children: [
                          _trajectory(),
                          const SizedBox(height: 16),
                          _grid([_engagement(), _velocity()],
                              minItemWidth: 240),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _agenda(),
                          const SizedBox(height: 16),
                          _activity(context),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _dock(context),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------- Header ----------
  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Pill('Socratic Diagnostic Engine v4.2',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
            Pill('Real-Time Cohort Calibration Active',
                bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              child: Text(
                'Good Morning, Dr. Ahmed Khan',
                style: GoogleFonts.manrope(
                  fontSize: 26,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.verified, size: 20, color: AppColors.primary),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Faculty Cockpit • Fall Semester 2025 • Department of Computer Science & Artificial Intelligence',
          style: GoogleFonts.inter(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _snack(context, 'AI report generated'),
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Generate AI Report'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  _open(context, '/teacher-notes', 'Upload Content'),
              icon: const Icon(Icons.cloud_upload_outlined, size: 18),
              label: const Text('Upload Content'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: () => _open(
                  context, '/teacher-create-course', 'Create Course'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Course'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- Stat tiles ----------
  Widget _stats(double inner) {
    final tileW = inner >= 820
        ? (inner - 5 * 12) / 6
        : inner >= 560
        ? (inner - 2 * 12) / 3
        : (inner - 12) / 2;

    final tiles = [
      _tile(Icons.school_outlined, '+1 Net', AppColors.chip, AppColors.primary,
          '4', 'Active Courses', 'Syllabus pacing on track'),
      _tile(Icons.groups_outlined, '98.2% Pres.', AppColors.mint,
          AppColors.teal, '348', 'Total Students', 'Across 4 lectures'),
      _tile(Icons.fact_check_outlined, '6 Manual', _softAmber, _amber, '18',
          'Pending Reviews', '12 auto-cleared'),
      _tile(Icons.timer_outlined, 'T - 4 Days', AppColors.chip,
          AppColors.primary, '2', 'Scheduled Tests', 'CS-301 & CS-204'),
      _tile(Icons.psychology_alt_outlined, '+4.2% vel.', AppColors.mint,
          AppColors.teal, '78.4%', 'Average Mastery', 'Calibrated Socratic'),
      _tile(Icons.pie_chart_outline, 'On Track', AppColors.chip,
          AppColors.primary, '72.6%', 'Completion Rate', '94% cohort retained'),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [for (final t in tiles) SizedBox(width: tileW, child: t)],
    );
  }

  Widget _tile(IconData icon, String pill, Color pillBg, Color pillFg,
      String value, String label, String sub) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Pill(pill, bg: pillBg, fg: pillFg, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 24,
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
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          Text(
            sub,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 10, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  // ---------- AI insights ----------
  Widget _insights(BuildContext context) {
    Widget insight(
        String tag,
        Color tagColor,
        String scope,
        String title,
        String body,
        IconData evIcon,
        String evidence,
        String primary,
        Color primaryBg,
        String secondary,
        ) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.chip),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 8, color: tagColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    tag,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: tagColor,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              scope,
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.textGrey),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(evIcon, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      evidence,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        height: 1.45,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _snack(context, '$primary: done'),
                  style: _btn(primaryBg, Colors.white),
                  child: Text(primary),
                ),
                ElevatedButton(
                  onPressed: () => _snack(context, secondary),
                  style: _btn(AppColors.chip, AppColors.textDark),
                  child: Text(secondary),
                ),
              ],
            ),
          ],
        ),
      );
    }

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
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.hub_outlined,
                    size: 20, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Explainable AI Teaching Insights & Cohort Diagnostics',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Pedagogical traces derived from Bayesian Knowledge Tracing & execution runtime telemetry',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              const Pill('94.6% Model Confidence',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 14),
          _grid([
            insight(
              'INTERVENTION FLAG',
              _red,
              'CS-301 • Cohort A',
              'Decreasing Engagement Detected in Module 4 (Recursive Graph Search)',
              'Average quiz accuracy dropped by 18.2% over the past 10 days across 64 students. Mean time-to-solve increased by 3.8 minutes on DAG cycle-detection heuristics.',
              Icons.rule,
              'Evidence Trace: Bayesian Knowledge Tracing flagged 28 students failing base-case invariant assertions in Lab 3 unit test harness.',
              'Deploy Remediation Drill',
              AppColors.primaryLight,
              'Inspect Diagnostic Proof',
            ),
            insight(
              'VELOCITY UPLIFT',
              AppColors.teal,
              'CS-204 • Cohort B',
              'Algorithmic Speed Breakthrough in Dijkstra Priority Queues',
              '84% of cohort mastered binary min-heap relaxation logic 2.4 days ahead of scheduled milestone following Video Lecture 3.2 release.',
              Icons.check_circle_outline,
              'Pedagogical Suggestion: Socratic model suggests advancing cohort to A* search heuristics earlier or deploying optional stretch problems.',
              'Advance Curriculum Pace',
              AppColors.teal,
              'Assign Stretch Problem',
            ),
          ], minItemWidth: 300),
        ],
      ),
    );
  }

  // ---------- Active courses ----------
  Widget _courses(BuildContext context) {
    Widget course(String code, Color codeBg, Color codeFg, String title,
        int students, double progress, Color bar, IconData footIcon,
        String foot) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.chip),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Pill(code, bg: codeBg, fg: codeFg, fontSize: 10),
                const Spacer(),
                const Pill('Active',
                    bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.groups_outlined,
                    size: 14, color: AppColors.textGrey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$students Students Enrolled',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Syllabus Progress',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textGrey),
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: AppColors.chip,
                      valueColor: AlwaysStoppedAnimation<Color>(bar),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(footIcon, size: 13, color: AppColors.textGrey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          foot,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _open(context, '/teacher-notes', 'Edit Notes'),
                    style: _btn(AppColors.chip, AppColors.textDark),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Edit Notes'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _snack(context, 'Analytics: $code'),
                    style: _btn(AppColors.chip, AppColors.textDark),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Analytics'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Active Faculty Courses',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Pill('All Semesters',
                bg: Colors.white, fg: AppColors.textDark, fontSize: 10),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Real-time cohort synchronization, student enrollment, and syllabus milestones',
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        _grid([
          course('CS-301', AppColors.chip, AppColors.primary,
              'AI Fundamentals & Search Heuristics', 140, 0.72,
              AppColors.primary, Icons.event_outlined, 'Today 2:00 PM • Turing'),
          course('CS-204', AppColors.mint, AppColors.teal,
              'Data Structures & Advanced Algorithms', 98, 0.65, AppColors.teal,
              Icons.event_outlined, 'Tomorrow 10:00 AM • Lab'),
          course('CS-310', _softAmber, _amber,
              'Machine Learning & Neural Systems', 65, 0.42, _amber,
              Icons.assignment_outlined, 'HW 4 Due Friday 11:59 PM'),
          course('CS-402', AppColors.chip, AppColors.primary,
              'Deep Learning & Distributed NLP', 45, 0.85, AppColors.primary,
              Icons.slideshow_outlined, 'Project Demos Next Mon'),
        ], minItemWidth: 200),
      ],
    );
  }

  // ---------- Trajectory line chart ----------
  Widget _trajectory() {
    const a = [0.18, 0.28, 0.4, 0.5, 0.45, 0.5, 0.78, 0.92];
    const b = [0.2, 0.3, 0.38, 0.44, 0.52, 0.55, 0.7, 0.9];
    const labels = [
      'Week 1',
      'Week 3',
      'Week 5',
      'Week 7',
      'Week 8 (Midterm)'
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Weekly Cohort Performance Trajectory',
              sub:
              'Continuous mastery scores across CS-301 (AI) vs CS-204 (Algorithms)'),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Pill('CS-301',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
              Pill('CS-204',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
              Pill('Weeks 1 - 8',
                  bg: Colors.white, fg: AppColors.textGrey, fontSize: 10),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            width: double.infinity,
            child: CustomPaint(
              painter: _LinePainter(
                a: a,
                b: b,
                colorA: AppColors.primary,
                colorB: AppColors.teal,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final l in labels)
                Flexible(
                  child: Text(
                    l,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 9, color: AppColors.textGrey),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Weekly engagement bars ----------
  Widget _engagement() {
    const hours = [42.0, 68.0, 88.0, 64.0, 76.0, 32.0, 45.0];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const chartH = 110.0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Weekly Engagement Time',
              sub: 'Daily student playback & code simulator run hours'),
          const SizedBox(height: 14),
          SizedBox(
            height: chartH + 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < 7; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${hours[i].round()}h',
                          style: GoogleFonts.inter(
                              fontSize: 9, color: AppColors.textGrey),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 18,
                          height: chartH * hours[i] / 100,
                          decoration: BoxDecoration(
                            color: i == 2
                                ? AppColors.primary
                                : const Color(0xFFD9DBF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          days[i],
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight:
                            i == 2 ? FontWeight.w700 : FontWeight.w400,
                            color: i == 2
                                ? AppColors.primary
                                : AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Assignment velocity donut ----------
  Widget _velocity() {
    Widget legend(Color c, String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.circle, size: 9, color: c),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Assignment Velocity',
              sub: 'Cohort adherence on Lab 3 & Quiz 4'),
          const SizedBox(height: 14),
          Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(120, 120),
                    painter: _DonutPainter(
                      values: const [285, 42, 21],
                      colors: const [
                        AppColors.teal,
                        Color(0xFFE9A23B),
                        Color(0xFFE3E4F5),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '82%',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'ON-TIME',
                        style: GoogleFonts.inter(
                            fontSize: 9, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          legend(AppColors.teal, 'On-time Submissions', '285'),
          legend(const Color(0xFFE9A23B), 'Late Submissions', '42'),
          legend(const Color(0xFFE3E4F5), 'Pending Grading', '21'),
        ],
      ),
    );
  }

  // ---------- Agenda ----------
  Widget _agenda() {
    Widget item(String time, String ampm, String title, String sub,
        {String? tag}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _soft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 44,
              child: Column(
                children: [
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    ampm,
                    style: GoogleFonts.inter(
                        fontSize: 9, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      if (tag != null) ...[
                        const SizedBox(width: 6),
                        Pill(tag,
                            bg: AppColors.mint,
                            fg: AppColors.teal,
                            fontSize: 8),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Today's Faculty Agenda",
              trailing: const Pill('3 Sessions',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 9)),
          const SizedBox(height: 12),
          item('10:00', 'AM', 'Faculty Academic Board',
              'Curriculum approval for AI Lab II • Dean\'s Conference Room 101'),
          item('02:00', 'PM', 'CS-301 Live Lecture',
              'A* & Heuristic Admissibility Proofs • Turing Hall 402',
              tag: 'UPCOMING'),
          item('04:30', 'PM', 'Socratic Office Hours',
              'Open Diagnostic clinic for struggling cohorts • Room 402 + Zoom Bridge'),
        ],
      ),
    );
  }

  // ---------- Cohort activity stream ----------
  Widget _activity(BuildContext context) {
    Widget item(IconData icon, Color color, String text, String time,
        {String? badge}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      height: 1.4,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(height: 4),
                    Pill(badge,
                        bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(
            'Cohort Activity Stream',
            trailing: GestureDetector(
              onTap: () => _open(
                  context, '/teacher-notifications', 'Opening all activity'),
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          item(Icons.check_circle_outline, AppColors.teal,
              'Farah Yameen submitted Lab 3: Cycle Detector.', '8m ago',
              badge: 'Autograder: 98/100'),
          item(Icons.quiz_outlined, AppColors.primary,
              'Quiz 3 Graph Heuristics published to 140 students.',
              '42m ago • CS-301'),
          item(Icons.play_circle_outline, AppColors.primary,
              'Lecture 4.1 Video uploaded and AI transcribed with auto-timestamping.',
              '2h ago • Turing Hall'),
          item(Icons.edit_note, _amber,
              'Dr. Sara Ali added collaborative teaching notes to CS-310.',
              '3h ago • AI Dept Sync'),
        ],
      ),
    );
  }

  // ---------- Command dock ----------
  Widget _dock(BuildContext context) {
    Widget small(IconData icon, String label, VoidCallback onTap) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: _btn(AppColors.chip, AppColors.textDark),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.primary),
              Text(
                'Faculty Command Dock',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '• Direct pedagogical controls',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              small(Icons.add_circle_outline, 'New Course',
                      () => _open(context, '/teacher-create-course',
                      'Create Course')),
              small(Icons.upload_file_outlined, 'Upload Slides',
                      () => _open(context, '/teacher-notes', 'Upload Content')),
              small(Icons.videocam_outlined, 'Record Lecture',
                      () => _open(context, '/teacher-lectures',
                      'Lecture Studio')),
              small(Icons.quiz_outlined, 'Draft Midterm Quiz',
                      () => _open(context, '/teacher-quiz-builder',
                      'Quiz Builder')),
              ElevatedButton.icon(
                onPressed: () =>
                    _snack(context, 'Faculty report downloaded'),
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Download Faculty Report'),
                style: _btn(AppColors.primaryLight, Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- Painters ----------
class _LinePainter extends CustomPainter {
  final List<double> a;
  final List<double> b;
  final Color colorA;
  final Color colorB;

  _LinePainter({
    required this.a,
    required this.b,
    required this.colorA,
    required this.colorB,
  });

  Path _smooth(List<double> d, Size size) {
    final p = Path();
    final dx = size.width / (d.length - 1);
    for (int i = 0; i < d.length; i++) {
      final x = i * dx;
      final y = size.height * (1 - d[i]);
      if (i == 0) {
        p.moveTo(x, y);
      } else {
        final px = (i - 1) * dx;
        final py = size.height * (1 - d[i - 1]);
        final cx = (px + x) / 2;
        p.cubicTo(cx, py, cx, y, x, y);
      }
    }
    return p;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFE9EAF6)
      ..strokeWidth = 1;
    for (int i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final pb = _smooth(b, size);
    final fill = Path.from(pb)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()..color = colorB.withValues(alpha: 0.10),
    );

    canvas.drawPath(
      pb,
      Paint()
        ..color = colorB
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      _smooth(a, size),
      Paint()
        ..color = colorA
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) => false;
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _DonutPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 16.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final total = values.fold<double>(0, (s, v) => s + v);
    double start = -math.pi / 2;
    const gap = 0.04;

    for (int i = 0; i < values.length; i++) {
      final sweep = values[i] / total * 2 * math.pi - gap;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke,
      );
      start += values[i] / total * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => false;
}