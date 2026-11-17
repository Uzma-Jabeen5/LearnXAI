import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class AssessmentsScreen extends StatefulWidget {
  const AssessmentsScreen({super.key});

  @override
  State<AssessmentsScreen> createState() => _AssessmentsScreenState();
}

class _Item {
  final int type; // 0 quiz, 1 assignment, 2 test, 3 practice
  final IconData icon;
  final Color iconBg;
  final String label;
  final Color labelBg;
  final Color labelFg;
  final String course;
  final String due;
  final Color dueBg;
  final Color dueFg;
  final String title;
  final List<String> metas;
  final String action;
  final String route;
  final String note;
  final bool primary;

  const _Item({
    required this.type,
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.labelBg,
    required this.labelFg,
    required this.course,
    required this.due,
    required this.dueBg,
    required this.dueFg,
    required this.title,
    required this.metas,
    required this.action,
    required this.route,
    required this.note,
    this.primary = true,
  });
}

class _AssessmentsScreenState extends State<AssessmentsScreen> {
  int _filter = 0; // 0 all, 1 quizzes, 2 assignments, 3 tests

  static const _filters = ['All (4)', 'Quizzes', 'Assignments', 'Tests'];

  static const _items = [
    _Item(
      type: 0,
      icon: Icons.assignment_outlined,
      iconBg: AppColors.chip,
      label: 'Quiz',
      labelBg: AppColors.chip,
      labelFg: AppColors.primary,
      course: 'CS-301 • AI Fundamentals',
      due: 'Due in 2 days',
      dueBg: Color(0xFFFFE3E0),
      dueFg: Color(0xFFB3261E),
      title: 'Quiz 3: Deep Neural Networks & Backpropagation',
      metas: ['25 Mins', 'Weight: 15%', '15 Questions'],
      action: 'Start Quiz',
      route: '/quiz',
      note: 'Attempts: 1 of 1',
    ),
    _Item(
      type: 1,
      icon: Icons.code,
      iconBg: AppColors.mint,
      label: 'Assignment',
      labelBg: AppColors.mint,
      labelFg: AppColors.teal,
      course: 'CS-301 • AI Fundamentals',
      due: 'Due Oct 27 (5 days)',
      dueBg: AppColors.chip,
      dueFg: AppColors.primary,
      title: 'Lab 4: PyTorch Convolutional Filters & Feature Maps',
      metas: ['~3.5 hrs effort', 'Weight: 20%', 'GitHub / Zip'],
      action: 'View Details',
      route: '/assignments',
      note: 'Auto-grader Ready',
      primary: false,
    ),
    _Item(
      type: 2,
      icon: Icons.verified_user_outlined,
      iconBg: AppColors.chip,
      label: 'Official Test',
      labelBg: AppColors.chip,
      labelFg: AppColors.textGrey,
      course: 'CS-204 • Data Structures',
      due: 'Nov 02 • 10:00 AM',
      dueBg: AppColors.chip,
      dueFg: AppColors.primary,
      title: 'Data Structures Midterm Examination (Proctored)',
      metas: ['90 Mins', 'Weight: 35%', 'LockDown Browser'],
      action: 'Review Rules',
      route: '/tests',
      note: 'System Check Done',
      primary: false,
    ),
    _Item(
      type: 3,
      icon: Icons.psychology_alt_outlined,
      iconBg: AppColors.mint,
      label: 'Formative Practice',
      labelBg: AppColors.mint,
      labelFg: AppColors.teal,
      course: 'CS-204 • Data Structures',
      due: 'Always Available',
      dueBg: AppColors.mint,
      dueFg: AppColors.teal,
      title: 'Recursion & Binary Search Trees Diagnostic Check',
      metas: ['15 Mins', 'Practice (0% GPA impact)', 'Socratic Hints On'],
      action: 'Practice Now',
      route: '/quiz',
      note: 'Unlimited retries',
    ),
  ];

  List<_Item> get _visible {
    if (_filter == 0) return _items;
    if (_filter == 1) return _items.where((i) => i.type == 0 || i.type == 3).toList();
    if (_filter == 2) return _items.where((i) => i.type == 1).toList();
    return _items.where((i) => i.type == 2).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/assessments',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                _stats(c.maxWidth >= 700),
                const SizedBox(height: 16),
                _categories(c.maxWidth >= 700),
                const SizedBox(height: 16),
                _sandbox(c.maxWidth >= 700),
                const SizedBox(height: 16),
                responsiveRow(
                  wide: wide,
                  flex: const [2, 1],
                  children: [
                    _scheduled(),
                    Column(
                      children: [
                        _recentScores(),
                        const SizedBox(height: 16),
                        _protocols(),
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

  // ---------- Header ----------
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assessments & Evaluations',
          style: GoogleFonts.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage your proctored quizzes, programming assignment labs, semester milestones, and calibrated cognitive diagnostics in one centralized cockpit.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEEFF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.circle, size: 9, color: AppColors.teal),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Proctoring Guard: Active & Verified',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Stats ----------
  Widget _statCard(String title, IconData icon, String big, String unit,
      String foot, Color footColor, Color footBg) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(big,
                  style: GoogleFonts.manrope(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              const SizedBox(width: 6),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(unit,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.teal)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: footBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(foot,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: footColor)),
          ),
        ],
      ),
    );
  }

  Widget _stats(bool wide) {
    final cards = [
      _statCard('Active Quizzes', Icons.assignment_outlined, '3',
          'available', '1 due in 48 hrs', const Color(0xFFB3261E),
          const Color(0xFFFFE3E0)),
      _statCard('Assignments', Icons.description_outlined, '4', 'ongoing',
          '1 grading pending', AppColors.textGrey, AppColors.chip),
      _statCard('Midterms & Tests', Icons.school_outlined, '2', 'scheduled',
          'Midterm: Nov 02', AppColors.primary, AppColors.chip),
      _statCard('Cumulative Mastery', Icons.trending_up, '84.6%', '+4.2%',
          'Top 12th Percentile', AppColors.teal, AppColors.mint),
    ];
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 4; i++) ...[
            if (i > 0) const SizedBox(width: 14),
            Expanded(child: cards[i]),
          ],
        ],
      );
    }
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 12),
          Expanded(child: cards[1]),
        ]),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: cards[2]),
          const SizedBox(width: 12),
          Expanded(child: cards[3]),
        ]),
      ],
    );
  }

  // ---------- Three category cards ----------
  Widget _category(IconData icon, Color iconBg, String title, String badge,
      Color badgeBg, Color badgeFg, String desc, String button, String route,
      Color btnFg) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(title,
                  style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              Pill(badge, bg: badgeBg, fg: badgeFg, fontSize: 10),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc,
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.5, color: AppColors.textGrey)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, route),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6E8FF),
              foregroundColor: btnFg,
              elevation: 0,
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
            child: Text('$button  →'),
          ),
        ],
      ),
    );
  }

  Widget _categories(bool wide) {
    final cards = [
      _category(
          Icons.fact_check_outlined,
          AppColors.primary,
          'Quizzes',
          '1 New • 2 Completed',
          AppColors.chip,
          AppColors.primary,
          'Fast, conceptual timed checks measuring topic retention, theoretical proofs, and weekly lecture comprehension.',
          'View Quizzes',
          '/quiz',
          AppColors.primary),
      _category(
          Icons.terminal,
          AppColors.teal,
          'Assignments',
          '4 Active • 1 Graded',
          AppColors.mint,
          AppColors.teal,
          'Comprehensive algorithmic problem sets, Jupyter analytical labs, unit tests, and production code submissions.',
          'View Assignments',
          '/assignments',
          AppColors.teal),
      _category(
          Icons.shield_outlined,
          const Color(0xFF1F2937),
          'Tests & Midterms',
          '1 Practice • 1 Official',
          AppColors.chip,
          AppColors.primary,
          'High-stakes formal examinations administered through encrypted secure lock-down browser sandboxes.',
          'View Tests',
          '/tests',
          AppColors.textDark),
    ];
    return responsiveRow(wide: wide, children: cards);
  }

  // ---------- Purple sandbox banner ----------
  Widget _sandbox(bool wide) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI SOCRATIC CALIBRATION • Pre-Test Diagnostic',
          style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: AppColors.mintBright),
        ),
        const SizedBox(height: 6),
        Text(
          'Adaptive Socratic Practice Sandbox',
          style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          'Prepare for upcoming evaluations with AI-generated formative question sets that diagnose your weak topics before high-stakes grading. Practice with zero impact on GPA.',
          style: GoogleFonts.inter(
              fontSize: 12, height: 1.5, color: Colors.white70),
        ),
      ],
    );

    final button = ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, '/quiz'),
      icon: const Icon(Icons.auto_awesome, size: 18),
      label: const Text('Launch Practice Session'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        minimumSize: const Size(0, 50),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        textStyle:
        GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4338CA), Color(0xFF3523CF)],
        ),
      ),
      child: wide
          ? Row(
        children: [
          Expanded(child: text),
          const SizedBox(width: 20),
          button,
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [text, const SizedBox(height: 16), button],
      ),
    );
  }

  // ---------- Scheduled assessments ----------
  Widget _scheduled() {
    final tabs = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < _filters.length; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            GestureDetector(
              onTap: () => setState(() => _filter = i),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _filter == i ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: _filter == i
                      ? Border.all(color: AppColors.chip)
                      : null,
                ),
                child: Text(
                  _filters[i],
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _filter == i
                        ? AppColors.primary
                        : AppColors.textGrey,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Scheduled Assessments',
              style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text('Live roster of tasks requiring immediate action or preparation.',
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: tabs,
          ),
          const SizedBox(height: 14),
          for (final it in _visible) _itemCard(it),
        ],
      ),
    );
  }

  Widget _itemCard(_Item it) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEEFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: it.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(it.icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Pill(it.label,
                        bg: it.labelBg, fg: it.labelFg, fontSize: 10),
                    Text(it.course,
                        style: GoogleFonts.inter(
                            fontSize: 10, color: AppColors.textGrey)),
                    Pill(it.due, bg: it.dueBg, fg: it.dueFg, fontSize: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(it.title,
              style: GoogleFonts.manrope(
                  fontSize: 16,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              for (final m in it.metas)
                Text(m,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, it.route),
                style: ElevatedButton.styleFrom(
                  backgroundColor: it.primary
                      ? AppColors.primaryLight
                      : const Color(0xFFE6E8FF),
                  foregroundColor:
                  it.primary ? Colors.white : AppColors.primary,
                  elevation: 0,
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                child: Text(it.action),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(it.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Recent scores ----------
  Widget _recentScores() {
    Widget row(int pct, String title, String sub, String badge) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      value: pct / 100,
                      strokeWidth: 4,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryLight),
                    ),
                  ),
                  Text('$pct%',
                      style: GoogleFonts.inter(
                          fontSize: 10, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(sub,
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textGrey)),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Pill(badge, bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
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
              Expanded(
                child: Text('Recent Scores',
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
              ),
              Text('Analytics →',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Last 3 evaluations calibrated',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          row(92, 'Quiz 2: Vector Embeddings', 'CS-301 • 3 days ago',
              'Top 5%'),
          row(98, 'Lab 3: Graph Traversal AST', 'CS-204 • Graded',
              'Perfect'),
          row(85, 'Quiz 1: Asymptotic Bounds', 'CS-204 • 12 days ago',
              'Good'),
        ],
      ),
    );
  }

  // ---------- Evaluation protocols ----------
  Widget _protocols() {
    Widget point(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline,
              size: 16, color: AppColors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: Text(t,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    height: 1.5,
                    color: AppColors.textGrey)),
          ),
        ],
      ),
    );

    return AppCard(
      color: const Color(0xFFF4F5FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Evaluation Protocols',
                  style: GoogleFonts.manrope(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'LearnXAI strictly adheres to IEEE 1484.1 Learning Technology Architecture standards. Submissions are continuously auto-saved to local indexed storage with zero session loss during network drops.',
            style: GoogleFonts.inter(
                fontSize: 11, height: 1.5, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
          point(
              'Tab switching and clipboard monitoring are active for official midterms.'),
          point(
              'Automatic code plagiarism checks performed using MOSS parsing engines.'),
          point(
              'Accommodations and extra time automatically synced with student disability registry.'),
        ],
      ),
    );
  }
}