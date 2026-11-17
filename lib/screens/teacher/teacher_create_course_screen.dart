import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class TeacherCreateCourseScreen extends StatefulWidget {
  const TeacherCreateCourseScreen({super.key});

  @override
  State<TeacherCreateCourseScreen> createState() =>
      _TeacherCreateCourseScreenState();
}

class _TeacherCreateCourseScreenState extends State<TeacherCreateCourseScreen> {
  static const _soft = Color(0xFFF4F7FF);
  static const _field = Color(0xFFF1F1FF);

  final _title = TextEditingController(
      text: 'CS-301: AI Fundamentals & Search Heuristics');
  final _code = TextEditingController(text: 'CS-301');
  final _overview = TextEditingController(
      text:
      'Comprehensive study of artificial intelligence, search algorithms, heuristic optimization, adversarial game theory, and probabilistic reasoning models. Includes practical laboratory implementations of graph traversal, constraint satisfaction, and Bellman utility optimization.');

  String _dept = 'Computer Science & AI';
  String _semester = 'Fall Semester 2025';
  String _credits = '4.0 Academic Units (Lecture + Lab)';
  String _track = 'Artificial Intelligence & Robotics';
  String _level = 'Intermediate / Upper Division';
  String _visibility = 'Dept Only';
  String _admission = 'Instructor Consent Required (Waitlist)';
  double _seats = 150;
  bool _adopted = false;
  bool _advisorHidden = false;

  final List<String> _outcomes = [
    'Derive and implement minimax search with alpha-beta pruning and evaluation heuristic limits.',
    'Analyze theoretical space/time computational bounds of A* heuristic search using admissible and consistent benchmarks.',
    'Formulate discrete Markov Decision Processes and solve for optimal policy vectors using Bellman equations.',
  ];

  final List<String> _prereqs = [
    'CS-204  Data Structures & Algorithms',
    'MATH-210  Multivariable Linear Algebra',
    'MATH-225  Discrete Probability',
  ];

  final List<List<String>> _modules = [
    [
      '01',
      'Foundations of State-Space Search & Heuristics',
      'Weeks 1-3',
      'BFS, DFS, Uniform Cost Search, Graph Traversal Invariants, Closed Set Optimization',
      '4 Lessons',
      '1 Python Lab',
      '1 Quiz',
    ],
    [
      '02',
      'Heuristic Optimization & A* Admissibility',
      'Weeks 4-7',
      'Manhattan & Euclidean distances, Consistency proofs, Sub-optimal bounds',
      '4 Lessons',
      '1 Benchmark Test',
      '1 Quiz',
    ],
    [
      '03',
      'Adversarial Games & Minimax Invariants',
      'Weeks 8-11',
      'Zero-sum matrix games, Alpha-Beta cutoffs, Monte Carlo Tree Search',
      '5 Lessons',
      '1 Chess Bot Lab',
      '1 Midterm Exam',
    ],
  ];

  @override
  void dispose() {
    _title.dispose();
    _code.dispose();
    _overview.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  ButtonStyle _btn(Color bg, Color fg) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _label(String t, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              t,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.textGrey),
            ),
        ],
      ),
    );
  }

  Widget _text(TextEditingController c, {int maxLines = 1, IconData? icon}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: _field,
        suffixIcon:
        icon == null ? null : Icon(icon, size: 18, color: AppColors.textGrey),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _drop(String value, List<String> options, ValueChanged<String> on) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _field,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: [
          for (final o in options)
            DropdownMenuItem(
              value: o,
              child: Text(
                o,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textDark),
              ),
            ),
        ],
        onChanged: (v) => setState(() => on(v ?? value)),
      ),
    );
  }

  Widget _field2(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_label(label), child],
    );
  }

  Widget _cardTitle(String t, String sub, {String? pill}) {
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
            if (pill != null) ...[
              const SizedBox(width: 8),
              Pill(pill, bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          sub,
          style: GoogleFonts.inter(
              fontSize: 12, height: 1.4, color: AppColors.textGrey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/teacher-create-course',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.64 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                _stepper(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SizedBox(width: mainW, child: _identity()),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _media(),
                          const SizedBox(height: 16),
                          _access(),
                          if (!_advisorHidden) ...[
                            const SizedBox(height: 16),
                            _advisor(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _modulesPreview(),
                const SizedBox(height: 16),
                _footer(),
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
        Wrap(
          spacing: 10,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Pill('Curriculum Builder Studio',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
            Text('Academic Year 2025-2026',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Create New Academic Course',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Design syllabus structure, learning outcomes, credit units, and prerequisite dependencies for accredited curricula.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _snack('Version drafts opened'),
              icon: const Icon(Icons.history, size: 18),
              label: const Text('Version Drafts'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: () => _snack('Syllabus PDF imported'),
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Import Syllabus PDF'),
              style: _btn(AppColors.chip, AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- Stepper ----------
  Widget _stepper() {
    Widget step(int n, String t, String sub, bool active) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF1F1FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.chip,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$n',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : AppColors.textGrey,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          t,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: active
                                ? AppColors.primary
                                : AppColors.textDark,
                          ),
                        ),
                      ),
                      if (active) ...[
                        const SizedBox(width: 6),
                        const Pill('ACTIVE',
                            bg: AppColors.primary,
                            fg: Colors.white,
                            fontSize: 8),
                      ],
                    ],
                  ),
                  Text(
                    sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
      padding: const EdgeInsets.all(8),
      child: _grid([
        step(1, 'Basic Details', 'Course codes & accreditation', true),
        step(2, 'Curriculum & Modules', 'Lectures, outcomes & labs', false),
        step(3, 'Resources & Materials', 'Textbooks, slides & labs', false),
        step(4, 'Review & Publish', 'Catalog indexation approval', false),
      ], minItemWidth: 200),
    );
  }

  // ---------- Identity form ----------
  Widget _identity() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Course Identity & Accreditation',
              'Primary identification metadata recognized by faculty registrars.',
              pill: 'ABET Aligned'),
          const SizedBox(height: 16),
          _label('Course Title & Catalog Name',
              trailing: '${_title.text.length} / 100'),
          _text(_title, icon: Icons.school_outlined),
          const SizedBox(height: 14),
          _grid([
            _field2('Course Code', _text(_code)),
            _field2(
              'Academic Department',
              _drop(_dept, const [
                'Computer Science & AI',
                'Electrical Engineering',
                'Mathematics',
              ], (v) => _dept = v),
            ),
            _field2(
              'Academic Semester',
              _drop(_semester, const [
                'Fall Semester 2025',
                'Spring Semester 2026',
                'Summer 2026',
              ], (v) => _semester = v),
            ),
            _field2(
              'Credit Units (ECTS/US)',
              _drop(_credits, const [
                '4.0 Academic Units (Lecture + Lab)',
                '3.0 Academic Units (Lecture)',
                '2.0 Academic Units (Seminar)',
              ], (v) => _credits = v),
            ),
            _field2(
              'Curricular Track',
              _drop(_track, const [
                'Artificial Intelligence & Robotics',
                'Data Science',
                'Systems & Security',
              ], (v) => _track = v),
            ),
            _field2(
              'Course Level',
              _drop(_level, const [
                'Intermediate / Upper Division',
                'Introductory',
                'Graduate',
              ], (v) => _level = v),
            ),
          ], minItemWidth: 220),
          const SizedBox(height: 14),
          _label('Syllabus Overview & Abstract', trailing: 'Markdown Supported'),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _field,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final i in const [
                      Icons.format_bold,
                      Icons.format_italic,
                      Icons.format_list_bulleted,
                      Icons.code,
                    ])
                      Icon(i, size: 18, color: AppColors.textGrey),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => _snack('AI polishing applied'),
                      child: const Pill('AI Polishing',
                          bg: AppColors.chip,
                          fg: AppColors.primary,
                          fontSize: 9),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _overview,
                  maxLines: 5,
                  style: GoogleFonts.inter(
                      fontSize: 12, height: 1.5, color: AppColors.textDark),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target Learning Outcomes (ABET Criteria 3)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Specific measurable competencies students acquire upon completion.',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _addOutcome,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Outcome'),
                style: _btn(AppColors.chip, AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < _outcomes.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.chip,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _outcomes[i],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.45,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => _outcomes.removeAt(i)),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(Icons.close,
                          size: 16, color: AppColors.textGrey),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          _label('Prerequisite Course Dependencies'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final p in _prereqs)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            p,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => setState(() => _prereqs.remove(p)),
                          child: const Icon(Icons.close,
                              size: 14, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                TextButton.icon(
                  onPressed: _addPrereq,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Attach Prerequisite'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addOutcome() {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add learning outcome'),
        content: TextField(
          controller: c,
          maxLines: 3,
          autofocus: true,
          decoration:
          const InputDecoration(hintText: 'Describe a measurable outcome'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (c.text.trim().isNotEmpty) {
                setState(() => _outcomes.add(c.text.trim()));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addPrereq() {
    const options = [
      'CS-101  Intro to Programming',
      'CS-210  Computer Architecture',
      'STAT-200  Probability & Statistics',
    ];
    final left = options.where((o) => !_prereqs.contains(o)).toList();
    if (left.isEmpty) {
      _snack('No more prerequisites available');
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Attach prerequisite'),
        children: [
          for (final o in left)
            SimpleDialogOption(
              onPressed: () {
                setState(() => _prereqs.add(o));
                Navigator.pop(ctx);
              },
              child: Text(o),
            ),
        ],
      ),
    );
  }

  // ---------- Right column ----------
  Widget _media() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Course Media Assets',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text('16:9 Display',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.chip,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.cloud_upload_outlined,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 10),
                Text(
                  'Upload Syllabus Banner & Thumbnail',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Min 1280x720px, PNG, WEBP, or high-res JPG. Used for LMS student portal and course catalog.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 11, height: 1.4, color: AppColors.textGrey),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _snack('Browse media'),
                  style: _btn(Colors.white, AppColors.textDark),
                  child: const Text('Browse Media'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.chip,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_outlined,
                      size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'cs301_cover_render_v2.webp',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        '1920 x 1080 • 1.4 MB',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.sync, size: 16, color: AppColors.textGrey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _access() {
    Widget vis(IconData icon, String label) {
      final sel = _visibility == label;
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _visibility = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: sel ? AppColors.primary : _soft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 18, color: sel ? Colors.white : AppColors.textGrey),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: sel ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Access & Enrollment Gates',
              'Determine registration rules and student roster security policies.'),
          const SizedBox(height: 14),
          _label('Catalog Visibility'),
          Row(
            children: [
              Expanded(child: vis(Icons.public, 'Public Catalog')),
              const SizedBox(width: 8),
              Expanded(child: vis(Icons.apartment, 'Dept Only')),
              const SizedBox(width: 8),
              Expanded(child: vis(Icons.lock_outline, 'Private Roster')),
            ],
          ),
          const SizedBox(height: 14),
          _label('Registration Admission Rule'),
          _drop(_admission, const [
            'Instructor Consent Required (Waitlist)',
            'Open Enrollment',
            'Prerequisite Check Only',
          ], (v) => _admission = v),
          const SizedBox(height: 14),
          _label('Cohort Seat Limit', trailing: '${_seats.round()} Students (Active)'),
          Slider(
            value: _seats,
            min: 20,
            max: 300,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.chip,
            onChanged: (v) => setState(() => _seats = v),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Pill('${_seats.round()}',
                bg: AppColors.chip, fg: AppColors.textDark, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _advisor() {
    return AppCard(
      color: const Color(0xFFF1F1FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'AI CURRICULUM ADVISOR',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Pill('ABET Compliant 98.4%',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Based on the 2025 ACM/IEEE Curriculum recommendations, adding a dedicated 2-week module on "Ethical AI & Algorithmic Bias Mitigation" directly increases accreditation alignment score by +24%.',
            style: GoogleFonts.inter(
                fontSize: 12, height: 1.5, color: AppColors.textDark),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('ABET Criterion 3.4 Alignment',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textGrey)),
                    ),
                    Text(
                      _adopted ? '98%' : '74% → 98% with Suggestion',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _adopted ? 0.98 : 0.74,
                    minHeight: 6,
                    backgroundColor: AppColors.chip,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.teal),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: _adopted
                      ? null
                      : () {
                    setState(() {
                      _adopted = true;
                      _modules.add([
                        '04',
                        'Ethical AI & Algorithmic Bias Mitigation',
                        'Weeks 12-13',
                        'Fairness metrics, bias audits, responsible deployment',
                        '3 Lessons',
                        '1 Audit Lab',
                        '1 Quiz',
                      ]);
                    });
                    _snack('Suggested module adopted');
                  },
                  icon: const Icon(Icons.add_task, size: 16),
                  label: Text(
                    _adopted ? 'Module Adopted' : 'Adopt Suggested Module',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: _btn(AppColors.primary, Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => setState(() => _advisorHidden = true),
                child: const Text('Dismiss'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Modules preview ----------
  Widget _modulesPreview() {
    Widget meta(IconData icon, String t) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textGrey),
        const SizedBox(width: 4),
        Text(t,
            style: GoogleFonts.inter(
                fontSize: 10, color: AppColors.textGrey)),
      ],
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Structured Modules Preview',
                          style: GoogleFonts.manrope(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        Pill('${_modules.length} Modules Drafted',
                            bg: AppColors.mint,
                            fg: AppColors.teal,
                            fontSize: 9),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Preview generated syllabus sequence. Customize lectures, labs, and graded assessments in Step 2.',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => setState(() {
              final n = (_modules.length + 1).toString().padLeft(2, '0');
              _modules.add([
                n,
                'New Module',
                'Weeks TBD',
                'Describe the topics covered in this module',
                '0 Lessons',
                '0 Labs',
                '0 Quizzes',
              ]);
            }),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add New Module'),
            style: _btn(AppColors.chip, AppColors.textDark),
          ),
          const SizedBox(height: 12),
          for (final m in _modules)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      m[0],
                      style: GoogleFonts.manrope(
                        fontSize: 14,
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
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              m[1],
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            Pill(m[2],
                                bg: AppColors.mint,
                                fg: AppColors.teal,
                                fontSize: 9),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m[3],
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              height: 1.4,
                              color: AppColors.textGrey),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 14,
                          runSpacing: 4,
                          children: [
                            meta(Icons.menu_book_outlined, m[4]),
                            meta(Icons.terminal, m[5]),
                            meta(Icons.quiz_outlined, m[6]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.drag_indicator,
                      size: 18, color: AppColors.textGrey),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------- Footer ----------
  Widget _footer() {
    return AppCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _title.text =
                    'CS-301: AI Fundamentals & Search Heuristics';
                    _code.text = 'CS-301';
                    _seats = 150;
                    _visibility = 'Dept Only';
                  });
                  _snack('Changes discarded');
                },
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Discard Changes'),
                style: _btn(AppColors.chip, AppColors.textDark),
              ),
              ElevatedButton.icon(
                onPressed: () => _snack('Draft saved'),
                icon: const Icon(Icons.save_outlined, size: 16),
                label: const Text('Save Draft'),
                style: _btn(AppColors.chip, AppColors.textDark),
              ),
              Text(
                'Step 1 of 4 Completed',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => _snack('Curriculum Builder opens in Step 2'),
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Continue to Curriculum Builder'),
            style: _btn(AppColors.primaryLight, Colors.white),
          ),
        ],
      ),
    );
  }
}