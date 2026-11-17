import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/dashboard',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          const gap = SizedBox(height: 18);
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _greeting(wide),
                gap,
                _insight(wide),
                gap,
                _stats(wide),
                gap,
                Row(
                  children: [
                    Text(
                      'Continue Learning',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Pill('2 In Progress'),
                    const Spacer(),
                    Text(
                      'View full syllabus',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                responsiveRow(
                  wide: wide,
                  children: [
                    _courseCard(
                      tag: 'ACTIVE COHORT',
                      meta: 'CS 482 • Dr. Ahmed Khan',
                      title: 'AI Fundamentals',
                      percent: 72,
                      barColor: AppColors.primaryLight,
                      moduleText: 'Module 4: Deep Learning Foundations',
                      nextText: 'Next: Neural Network Architectures',
                      remain: '22m remain',
                      extra: 'Unit 4 Test ready',
                      icon: Icons.psychology_alt_outlined,
                      buttonColor: AppColors.primaryLight,
                    ),
                    _courseCard(
                      tag: 'CORE TRACK',
                      meta: 'CS 204 • Prof. Usman',
                      title: 'Data Structures & Algorithms',
                      percent: 45,
                      barColor: AppColors.teal,
                      moduleText: 'Module 2: Tree Traversals & Search',
                      nextText: 'Next: Binary Search Traversal',
                      remain: '35m remain',
                      extra: '2 code labs',
                      icon: Icons.data_object,
                      buttonColor: AppColors.teal,
                    ),
                  ],
                ),
                gap,
                responsiveRow(
                  wide: wide,
                  flex: const [2, 1],
                  children: [
                    _effortChart(),
                    Column(
                      children: [
                        _events(),
                        const SizedBox(height: 16),
                        _signals(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------- Greeting ----------
  Widget _greeting(bool wide) {
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Pill('TELEMETRIC REALTIME MODEL • FALL SEMESTER 2025'),
            Pill('Telemetry Engine Calibrated',
                bg: AppColors.mint, fg: AppColors.teal),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Good Morning, Farah 👋',
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textGrey,
            ),
            children: const [
              TextSpan(
                  text: 'Keep going! Your cognitive retention index is up '),
              TextSpan(
                text: '+14%',
                style: TextStyle(
                  color: AppColors.teal,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                  text:
                  ' this week across algorithmic reasoning and state validation models.'),
            ],
          ),
        ),
      ],
    );

    final goal = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 6,
                    backgroundColor: Colors.white,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                  ),
                ),
                Text(
                  '75%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DAILY GOAL',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: AppColors.textGrey,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '45',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    TextSpan(
                      text: ' / 60 min',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '15 min left to target',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return AppCard(
      child: wide
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          goal,
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [left, const SizedBox(height: 16), goal],
      ),
    );
  }

  // ---------- Cognitive Reasoning Insight ----------
  Widget _insight(bool wide) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.psychology_alt_outlined,
                  color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cognitive Reasoning Insight',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Pill('Confidence: 91%',
                          bg: AppColors.mint, fg: AppColors.teal),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'ID: XAI-RC-8842',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.robotoMono(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Your recursion performance improved by 18% following Socratic hint sessions. Pattern recognition logs show self-derived base cases reduced infinite stack recurrence errors across your last 4 test harnesses.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textDark,
          ),
        ),
      ],
    );

    final buttons = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.account_tree_outlined, size: 18),
          label: const Text('View Explanation & Proof'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            minimumSize: const Size(0, 50),
            textStyle:
            GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.terminal, size: 18),
          label: const Text('Launch Targeted Practice'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.chip,
            foregroundColor: AppColors.textDark,
            elevation: 0,
            minimumSize: const Size(0, 50),
            textStyle:
            GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );

    return AppCard(
      color: const Color(0xFFF4F7FF),
      child: wide
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 3, child: text),
          const SizedBox(width: 20),
          Expanded(flex: 2, child: buttons),
        ],
      )
          : Column(
        children: [text, const SizedBox(height: 16), buttons],
      ),
    );
  }

  // ---------- Stats row ----------
  Widget _stats(bool wide) {
    final cards = [
      _overallMastery(),
      _weekly(),
      _pending(),
      _reinforce(),
    ];
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: 14),
            Expanded(child: cards[i]),
          ],
        ],
      );
    }
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 12),
            Expanded(child: cards[1]),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: cards[2]),
            const SizedBox(width: 12),
            Expanded(child: cards[3]),
          ],
        ),
      ],
    );
  }

  Widget _statTitle(String t, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            t,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textGrey,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 6),
          trailing,
        ],
      ],
    );
  }

  Widget _overallMastery() {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statTitle('Overall Mastery',
              trailing: const Pill('94% Conf.',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 10)),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '82%',
                style: GoogleFonts.manrope(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '+4.2%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Top 8th percentile within peer syllabus index',
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.4,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.82,
              minHeight: 6,
              backgroundColor: AppColors.chip,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekly() {
    final heights = [0.25, 0.45, 0.35, 1.0, 0.5, 0.65, 0.3];
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statTitle('Weekly Trajectory',
              trailing: Text(
                'Target 80%',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              )),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '71%',
                style: GoogleFonts.manrope(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'pace',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 46,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < 7; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        height: 30 * heights[i] + 8,
                        decoration: BoxDecoration(
                          color: i == 3
                              ? AppColors.primaryLight
                              : const Color(0xFFD9DBF5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (final d in days)
                Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pending() {
    Widget task(String name, String due, Color c) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            due,
            style: GoogleFonts.inter(fontSize: 10, color: c),
          ),
        ],
      ),
    );

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statTitle('Pending Tasks',
              trailing: const Pill('4 in 48h',
                  bg: Color(0xFFFFE9CF), fg: Color(0xFF8A4B00), fontSize: 10)),
          const SizedBox(height: 14),
          task('OS Memory Paging', 'High Pri', const Color(0xFF8A4B00)),
          task('Graph DFS/BFS Set', 'Tomorrow', AppColors.textGrey),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '2 assignments, 2 quizzes',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reinforce() {
    Widget chip(String t) => Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9CF).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        t,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6B3A00),
        ),
      ),
    );

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statTitle('Reinforcement Scope',
              trailing: const Pill('3 Concepts', fontSize: 10)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: [
              chip('Recursion Base'),
              chip('Balanced Trees'),
              chip('DP Memoization'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.sync, size: 14, color: AppColors.teal),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Socratic model queue ready',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Continue learning card ----------
  Widget _courseCard({
    required String tag,
    required String meta,
    required String title,
    required int percent,
    required Color barColor,
    required String moduleText,
    required String nextText,
    required String remain,
    required String extra,
    required IconData icon,
    required Color buttonColor,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Pill(tag,
                            bg: AppColors.mint,
                            fg: AppColors.teal,
                            fontSize: 9),
                        Text(
                          meta,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$percent%',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            moduleText,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          Text(
            nextText,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 6,
              backgroundColor: AppColors.chip,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.timer_outlined,
                  size: 16, color: AppColors.textGrey),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  remain,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  extra,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text('Resume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
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

  // ---------- Cognitive effort chart ----------
  Widget _effortChart() {
    // practice, ai tutor, video (hours)
    const data = [
      [1.2, 0.6, 0.4],
      [1.5, 1.0, 0.6],
      [1.0, 0.8, 0.5],
      [2.0, 1.4, 0.9],
      [1.3, 0.6, 0.7],
      [0.8, 0.5, 0.9],
      [0.5, 0.4, 0.3],
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const maxH = 5.0;
    const chartH = 200.0;

    Widget legend(String t, Color c) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: c),
        const SizedBox(width: 6),
        Text(
          t,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
      ],
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Cognitive Effort & Activity',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const Pill('Last 7 Days', fontSize: 10),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Hours spent across Interactive Practice, Socratic AI Dialogs, and Video Sessions',
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            children: [
              legend('Practice', AppColors.primaryLight),
              legend('AI Tutor', AppColors.teal),
              legend('Video', const Color(0xFFD9DBF5)),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: chartH + 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < 7; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (i == 3)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Pill('Peak', fontSize: 9),
                          ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 30,
                            child: Column(
                              children: [
                                Container(
                                  height: chartH * data[i][2] / maxH,
                                  color: const Color(0xFFD9DBF5),
                                ),
                                Container(
                                  height: chartH * data[i][1] / maxH,
                                  color: AppColors.teal,
                                ),
                                Container(
                                  height: chartH * data[i][0] / maxH,
                                  color: AppColors.primaryLight,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[i],
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(),
          Row(
            children: [
              const Icon(Icons.insights, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                    children: const [
                      TextSpan(text: 'Avg session duration: '),
                      TextSpan(
                        text: '42 minutes',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      TextSpan(text: ' • Socratic query factor: 2.8x'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Upcoming events ----------
  Widget _events() {
    Widget ev(String code, String title, String sub, String days) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                code,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              days,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
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
          Row(
            children: [
              const Icon(Icons.event_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Upcoming Events',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                '3 Deadlines',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ev('QZ', 'Quiz: AI Fundamentals', 'Perceptron & Linear Models',
              '2 days'),
          ev('AS', 'C++ Virtual Memory Lab', 'Page Tables & TLB', '3 days'),
          ev('EX', 'Python Midterm Exam', 'Proctored • 90 Minutes', '5 days'),
        ],
      ),
    );
  }

  // ---------- Recent signals ----------
  Widget _signals() {
    Widget sig(IconData icon, Color c, String title, String sub, String time) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: c),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 10,
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
          Row(
            children: [
              const Icon(Icons.notifications_none,
                  size: 20, color: AppColors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Recent Signals',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
            ],
          ),
          const SizedBox(height: 14),
          sig(
              Icons.check_circle_outline,
              AppColors.teal,
              'Quiz Results Posted: Graph Traversal',
              'Scored 88% (exceeded predicted curve)',
              '1 hour ago'),
          sig(
              Icons.description_outlined,
              AppColors.primary,
              'New Assignment Uploaded',
              'Dr. Tariq posted: Advanced Heuristics Part 2',
              '4 hours ago'),
          sig(
              Icons.hub_outlined,
              AppColors.primary,
              'Cognitive Knowledge Graph Sync',
              '5 new concept nodes linked to syllabus taxonomy',
              'Yesterday'),
        ],
      ),
    );
  }
}