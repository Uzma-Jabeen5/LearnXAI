import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  int _tab = 0; // 0 pending, 1 submitted, 2 graded
  bool _agreed = true;
  bool _fileStaged = true;

  static const _tabs = ['Pending / In Progress', 'Submitted / In Review', 'Graded'];
  static const _counts = [2, 1, 1];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/assignments',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;

          final list = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _cards(),
          );
          final side = Column(
            children: [
              _dropzone(),
              const SizedBox(height: 16),
              _stuckCard(),
            ],
          );

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                _filterBar(),
                const SizedBox(height: 16),
                responsiveRow(
                  wide: wide,
                  flex: const [2, 1],
                  children: [list, side],
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
    Widget stat(IconData icon, Color bg, String label, String value, Color vc) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textGrey)),
                Text(value,
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: vc)),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course Assignments & Labs',
          style: GoogleFonts.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Track deadlines, submit code repositories and notebook solutions, and view real-time autograder telemetries and faculty rubrics.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            stat(Icons.verified_outlined, AppColors.mint, 'Submission Rate',
                '100% On-Time', AppColors.textDark),
            stat(Icons.bar_chart, AppColors.chip, 'Avg Lab Grade', '94.2%',
                AppColors.primary),
          ],
        ),
      ],
    );
  }

  // ---------- Tabs, search, course filter ----------
  Widget _filterBar() {
    final tabs = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < _tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => _tab = i),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _tab == i
                      ? AppColors.primaryLight
                      : const Color(0xFFF1F1FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      _tabs[i],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _tab == i ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _tab == i ? Colors.white24 : AppColors.chip,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_counts[i]}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _tab == i ? Colors.white : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );

    final search = Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: AppColors.textGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Search problem sets, topics...',
              overflow: TextOverflow.ellipsis,
              style:
              GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
            ),
          ),
        ],
      ),
    );

    final course = Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'All Enrolled Courses',
              overflow: TextOverflow.ellipsis,
              style:
              GoogleFonts.inter(fontSize: 12, color: AppColors.textDark),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tabs,
          const SizedBox(height: 12),
          search,
          const SizedBox(height: 10),
          course,
        ],
      ),
    );
  }

  // ---------- Cards for the selected tab ----------
  List<Widget> _cards() {
    if (_tab == 0) {
      return [
        _pendingCard(
          course: 'CS-301 AI FUNDAMENTALS • Prof. Dr. Ahmed Khan',
          icon: Icons.terminal,
          due: 'Due in 3 days (Oct 26, 11:59 PM)',
          title: 'Lab 3: Implementation of Backprop DAG & Gradient Verification',
          desc:
          'Construct an automatic reverse-mode autodiff graph using dynamic computational DAGs. Complete numerical gradient approximations to pass dual-precision verification tests across convolutional primitives.',
          deliverables: 'Jupyter Notebook (.ipynb) + PDF Derivation',
          rubric: 'Autograder (70 pts) • Code QA (15) • Reflection (15)',
          progress: 0.5,
          progressLabel: '2 of 4 Subproblems Passing CI',
          buttons: const ['Open in Jupyter Sandbox', 'Ask Socratic AI'],
          primary: 'Upload Solution',
        ),
        const SizedBox(height: 16),
        _pendingCard(
          course: 'CS-204 DATA STRUCTURES • Prof. Usman',
          icon: Icons.account_tree_outlined,
          due: 'Due in 6 days (Oct 29, 11:59 PM)',
          title: 'Problem Set 4: Red-Black Trees & AVL Rotation Benchmarks',
          desc:
          'Implement rigorous left/right rotations and self-balancing color invariants. Benchmark CPU cache line misses against standard binary search trees using random integer sequences up to N=10^6.',
          deliverables: 'Total Points: 100 • 3 Test Suites',
          rubric: 'Status: Not Started',
          progress: null,
          progressLabel: '',
          buttons: const ['Download Starter Files (.zip)'],
          primary: 'Begin Problem Set',
        ),
      ];
    }
    if (_tab == 1) {
      return [_submittedCard()];
    }
    return [_gradedCard()];
  }

  Widget _pendingCard({
    required String course,
    required IconData icon,
    required String due,
    required String title,
    required String desc,
    required String deliverables,
    required String rubric,
    required double? progress,
    required String progressLabel,
    required List<String> buttons,
    required String primary,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  course,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Pill(due,
              bg: const Color(0xFFFFE9CF),
              fg: const Color(0xFF8A4B00),
              fontSize: 10),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 18,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.inter(
                fontSize: 12, height: 1.5, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deliverables',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textGrey)),
                Text(deliverables,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textDark)),
                const SizedBox(height: 8),
                Text('Evaluation Rubric',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textGrey)),
                Text(rubric,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textDark)),
              ],
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(progressLabel,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textGrey)),
                ),
                Text('${(progress * 100).round()}% Complete',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.chip,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryLight),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final b in buttons) _softButton(b),
              _primaryButton(primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _submittedCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.mintBright,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                const Icon(Icons.grid_view_rounded, color: AppColors.teal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'CS-310 MACHINE LEARNING • Dr. Sara Ali',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Pill('Submitted Yesterday • On Time',
              bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
          const SizedBox(height: 10),
          Text(
            'Project 1: Support Vector Machine Kernel Optimization',
            style: GoogleFonts.manrope(
              fontSize: 18,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE9FBF6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.speed, color: AppColors.teal),
                    const SizedBox(width: 10),
                    Text(
                      'Autograder Pass: 96 / 100',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '48/50 Unit Tests Passed • Quadratic Solver Precision validated',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey),
                ),
                const SizedBox(height: 8),
                const Pill('Awaiting Faculty Code Review', fontSize: 10),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.commit, size: 16, color: AppColors.textGrey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Git Commit: d98e72c (Main branch)',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _softButton('View Diff & Submission History'),
        ],
      ),
    );
  }

  Widget _gradedCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.workspace_premium_outlined,
                    color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CS-204 DATA STRUCTURES • Prof. Usman',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lab 2: Dijkstra & A* Graph Navigation Optimizations',
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Text(
                      '98 / 100',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Grade: A+',
                      style: GoogleFonts.inter(
                          fontSize: 9, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Prof. Usman's Annotation",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '"Outstanding runtime complexity breakdown. Your priority queue implementation avoided standard re-heapification overheads on sparse maps, beating benchmark targets by 18%."',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.stars_outlined, size: 16, color: AppColors.teal),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Selected for Cohort Hall of Fame',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.teal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _softButton('View Complete Breakdown Rubric'),
        ],
      ),
    );
  }

  // ---------- Buttons ----------
  Widget _softButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.chip,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        minimumSize: const Size(0, 42),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      child: Text(text),
    );
  }

  Widget _primaryButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        minimumSize: const Size(0, 42),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      child: Text(text),
    );
  }

  // ---------- Side column ----------
  Widget _dropzone() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.upload_file, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Quick Submission Dropzone',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Pill('Auto-CI Active', fontSize: 10),
          const SizedBox(height: 12),
          Text('Target Task',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 6),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Lab 3: Backprop DAG (CS-301)',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 12)),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.chip,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cloud_upload_outlined,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 10),
                Text(
                  'Drop files here or click to browse',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Accepts .ipynb, .py, .pdf up to 50MB',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_fileStaged)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('backprop_dag_impl.ipynb',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('1.4 MB • Staged for CI',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _fileStaged = false),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _agreed,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _agreed = v ?? false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'I confirm this code is my original work and conforms to the Academic Integrity Code of Conduct.',
                  style: GoogleFonts.inter(
                      fontSize: 11, height: 1.4, color: AppColors.textGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: (_agreed && _fileStaged)
                ? () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Autograder started (demo)')),
            )
                : null,
            icon: const Icon(Icons.play_arrow, size: 18),
            label: const Text('Run Pre-Flight Autograder & Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              minimumSize: const Size(double.infinity, 48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stuckCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_alt_outlined,
                  color: AppColors.teal),
              const SizedBox(width: 8),
              Text(
                'Stuck on Derivation?',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'LearnXAI can walk you through computational graph chain-rule branches without writing the final code for you.',
            style: GoogleFonts.inter(
                fontSize: 12, height: 1.5, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/ai-tutor'),
            icon: const Icon(Icons.forum_outlined, size: 18),
            label: const Text('Launch Socratic Discussion'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mint,
              foregroundColor: AppColors.teal,
              elevation: 0,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}