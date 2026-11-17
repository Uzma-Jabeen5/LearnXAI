import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class _Course {
  final String initials;
  final String title;
  final String code;
  final String level;
  final String category;
  final String owner;
  final String ownerInfo;
  final String dept;
  final String status;
  final bool socratic;
  final int fill;
  final int modules;
  final int sets;
  final int quizzes;
  final String retention;
  final String abet;
  final String term;

  const _Course({
    required this.initials,
    required this.title,
    required this.code,
    required this.level,
    required this.category,
    required this.owner,
    required this.ownerInfo,
    required this.dept,
    required this.status,
    required this.socratic,
    required this.fill,
    required this.modules,
    required this.sets,
    required this.quizzes,
    required this.retention,
    required this.abet,
    required this.term,
  });
}

const _courses = [
  _Course(
    initials: 'AI',
    title: 'AI Fundamentals & Heuristics',
    code: 'CS-301',
    level: 'Undergrad Core',
    category: 'Core',
    owner: 'Dr. Ahmed Khan',
    ownerInfo: 'Stanford Ph.D.',
    dept: 'CS & AI',
    status: 'Active',
    socratic: true,
    fill: 97,
    modules: 14,
    sets: 28,
    quizzes: 4,
    retention: '94.2%',
    abet: '98.4 / 100',
    term: 'Fall 2025 • Section A & B',
  ),
  _Course(
    initials: 'DS',
    title: 'Data Structures & Algorithmic Rigor',
    code: 'CS-402',
    level: 'Sophomore Core',
    category: 'Core',
    owner: 'Dr. Sara Ahmed',
    ownerInfo: 'MIT Postdoc',
    dept: 'Mathematics',
    status: 'Active',
    socratic: true,
    fill: 92,
    modules: 12,
    sets: 24,
    quizzes: 4,
    retention: '91.8%',
    abet: '96.1 / 100',
    term: 'Fall 2025 • Section A',
  ),
  _Course(
    initials: 'ML',
    title: 'Machine Learning & Causal Inference',
    code: 'CS-610',
    level: 'Graduate Elective',
    category: 'Elective',
    owner: 'Prof. Ali Raza',
    ownerInfo: 'Oxford D.Phil',
    dept: 'CS & AI',
    status: 'Active',
    socratic: true,
    fill: 96,
    modules: 16,
    sets: 30,
    quizzes: 5,
    retention: '93.5%',
    abet: '97.0 / 100',
    term: 'Fall 2025 • Section A',
  ),
  _Course(
    initials: 'DB',
    title: 'Database Systems & Distributed State',
    code: 'CS-204',
    level: 'Sophomore Core',
    category: 'Core',
    owner: 'Dr. Usman Tariq',
    ownerInfo: 'CMU Ph.D.',
    dept: 'Computer Systems',
    status: 'Needs Recertification',
    socratic: false,
    fill: 85,
    modules: 10,
    sets: 20,
    quizzes: 3,
    retention: '88.4%',
    abet: '90.2 / 100',
    term: 'Fall 2025 • Section B',
  ),
  _Course(
    initials: 'NN',
    title: 'Deep Neural Architectures & Loss Geometry',
    code: 'AI-505',
    level: 'New Curricula',
    category: 'New Curricula',
    owner: 'Dr. Fatima Noor',
    ownerInfo: 'Berkeley Postdoc',
    dept: 'CS & AI',
    status: 'Pending Approval',
    socratic: true,
    fill: 60,
    modules: 12,
    sets: 18,
    quizzes: 3,
    retention: '—',
    abet: 'Pending review',
    term: 'Fall 2025 • Awaiting approval',
  ),
  _Course(
    initials: 'PS',
    title: 'Computational Probability & Inference',
    code: 'DS-102',
    level: 'Freshman Intro',
    category: 'Core',
    owner: 'Ms. Ayesha Malik',
    ownerInfo: 'Faculty Associate',
    dept: 'Data Science',
    status: 'Active',
    socratic: false,
    fill: 94,
    modules: 9,
    sets: 16,
    quizzes: 3,
    retention: '90.1%',
    abet: '93.7 / 100',
    term: 'Fall 2025 • Section A',
  ),
];

class AdminCoursesScreen extends StatefulWidget {
  const AdminCoursesScreen({super.key});

  @override
  State<AdminCoursesScreen> createState() => _AdminCoursesScreenState();
}

class _AdminCoursesScreenState extends State<AdminCoursesScreen> {
  static const _cats = ['All Categories', 'Core', 'Elective', 'New Curricula'];
  static const _depts = [
    'All Departments',
    'CS & AI',
    'Mathematics',
    'Computer Systems',
    'Data Science',
  ];
  static const _statuses = [
    'All Statuses',
    'Active',
    'Pending Approval',
    'Needs Recertification',
  ];
  static const _quick = [
    'Active Only (318)',
    'Pending Approval (16)',
    'Needs ABET Recertification (8)',
    'Socratic AI Active (310)',
    'High Enrollment (>95%)',
  ];

  String _query = '';
  String _cat = _cats.first;
  String _dept = _depts.first;
  String _status = _statuses.first;
  int? _quickSel;
  int _page = 1;
  _Course _selected = _courses.first;

  List<_Course> get _filtered {
    return _courses.where((c) {
      final q = _query.trim().toLowerCase();
      final okQ = q.isEmpty ||
          c.title.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q) ||
          c.owner.toLowerCase().contains(q);
      final okC = _cat == _cats.first || c.category == _cat;
      final okD = _dept == _depts.first || c.dept == _dept;
      final okS = _status == _statuses.first || c.status == _status;
      var okQ2 = true;
      if (_quickSel == 0) okQ2 = c.status == 'Active';
      if (_quickSel == 1) okQ2 = c.status == 'Pending Approval';
      if (_quickSel == 2) okQ2 = c.status == 'Needs Recertification';
      if (_quickSel == 3) okQ2 = c.socratic;
      if (_quickSel == 4) okQ2 = c.fill > 95;
      return okQ && okC && okD && okS && okQ2;
    }).toList();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-courses',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Courses Management',
              tag: '342 Accredited Curricula',
              subtitle:
              'Supervise institutional syllabi, course accreditation status, faculty ownership, and real-time student enrollment telemetry across the LearnXAI ecosystem.',
              actions: [
                AdminButton('Bulk Syllabi Audit',
                    icon: Icons.download_outlined,
                    onTap: () => _snack('Bulk syllabi audit started')),
                AdminButton('Create New Course',
                    icon: Icons.add,
                    primary: true,
                    onTap: () => _snack('Create course form coming soon')),
              ],
            ),
            const SizedBox(height: 20),
            _stats(),
            const SizedBox(height: 20),
            _filters(),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: Column(
                children: [
                  _roster(),
                  const SizedBox(height: 20),
                  const _CapacityCard(),
                ],
              ),
              side: Column(
                children: [
                  _detail(),
                  const SizedBox(height: 20),
                  const _FrictionCard(),
                  const SizedBox(height: 20),
                  _fastTrack(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Stats ----------------

  Widget _stats() {
    return const AdminGrid(
      minItemWidth: 200,
      gap: 14,
      children: [
        _Stat('TOTAL CURRICULA', '342', '+15 Term', Icons.menu_book_outlined,
            AdminColors.indigo, 'Active catalog across 8 academic departments'),
        _Stat('PUBLISHED & ACTIVE', '318', '93.0% Live',
            Icons.verified_outlined, AdminColors.teal,
            'ABET-compliant curricula with Socratic AI enabled'),
        _Stat('GOVERNANCE REVIEW', '16', 'Action Req.',
            Icons.assignment_late_outlined, AdminColors.brown,
            'Awaiting dean & ABET certification sign-off',
            tagBg: Color(0xFFFFE9CF), tagFg: Color(0xFF8A4B00)),
        _Stat('TOTAL ENROLLMENTS', '23,602', '+12.4% YoY',
            Icons.groups_outlined, AdminColors.indigo,
            'Active student seats across registered sections'),
      ],
    );
  }

  // ---------------- Filters ----------------

  Widget _filters() {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminGrid(
            minItemWidth: 170,
            gap: 10,
            children: [
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AdminColors.soft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 20, color: AppColors.textGrey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() {
                          _query = v;
                          _page = 1;
                        }),
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'Search by title, code, instructor...',
                          hintStyle: GoogleFonts.inter(
                              fontSize: 13.5, color: AppColors.textGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _drop(_cat, _cats, (v) => _cat = v),
              _drop(_dept, _depts, (v) => _dept = v),
              _drop(_status, _statuses, (v) => _status = v),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('QUICK VIEWS:',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.textGrey)),
              for (var i = 0; i < _quick.length; i++)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => setState(() {
                    _quickSel = _quickSel == i ? null : i;
                    _page = 1;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: _quickSel == i
                          ? AdminColors.indigo
                          : AppColors.chip,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _quick[i],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _quickSel == i
                            ? Colors.white
                            : AppColors.primary,
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

  Widget _drop(String value, List<String> items, void Function(String) set) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark),
          items: [
            for (final i in items) DropdownMenuItem(value: i, child: Text(i))
          ],
          onChanged: (v) {
            if (v != null) {
              setState(() {
                set(v);
                _page = 1;
              });
            }
          },
        ),
      ),
    );
  }

  // ---------------- Roster ----------------

  Widget _roster() {
    final rows = _filtered;
    return AdminCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, box) {
          final roomy = box.maxWidth >= 640;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Text('Curricular Roster',
                        style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(width: 8),
                    Text('(Fall 2025 Term)',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textGrey)),
                    const Spacer(),
                    const Icon(Icons.ios_share,
                        size: 18, color: AppColors.textGrey),
                    const SizedBox(width: 12),
                    const Icon(Icons.tune,
                        size: 18, color: AppColors.textGrey),
                  ],
                ),
              ),
              if (roomy)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: _th('COURSE & CODE')),
                      Expanded(flex: 4, child: _th('FACULTY OWNER')),
                      Expanded(flex: 3, child: _th('DEPARTMENT')),
                    ],
                  ),
                ),
              const Divider(height: 1, color: AdminColors.line),
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text('No courses match these filters',
                      style: GoogleFonts.inter(color: AppColors.textGrey)),
                )
              else
                for (final c in rows) _row(c, roomy),
              _pagination(rows.length),
            ],
          );
        },
      ),
    );
  }

  Widget _th(String t) => Text(
    t,
    style: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.6,
      color: AppColors.textGrey,
    ),
  );

  Color _badgeColor(_Course c) {
    if (c.status == 'Pending Approval') return AdminColors.brown;
    if (c.status == 'Needs Recertification') return AdminColors.red;
    return c.initials == 'AI' ? AdminColors.indigo : const Color(0xFF6D6FB8);
  }

  Widget _row(_Course c, bool roomy) {
    final isSel = identical(c, _selected);
    final badge = Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _badgeColor(c).withValues(alpha: c.initials == 'AI' ? 1 : 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        c.initials,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: c.initials == 'AI' ? Colors.white : _badgeColor(c),
        ),
      ),
    );

    final course = Row(
      children: [
        badge,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              const SizedBox(height: 2),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: c.code,
                    style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.indigo)),
                TextSpan(
                    text: '  •  ${c.level}',
                    style: GoogleFonts.inter(
                        fontSize: 11.5, color: AppColors.textGrey)),
              ])),
            ],
          ),
        ),
      ],
    );

    final owner = Row(
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AdminColors.soft, shape: BoxShape.circle),
          child: Text(
            c.owner
                .replaceAll('Dr. ', '')
                .replaceAll('Prof. ', '')
                .replaceAll('Ms. ', '')
                .split(' ')
                .map((p) => p[0])
                .take(2)
                .join(),
            style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AdminColors.indigo),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.owner,
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              Text(c.ownerInfo,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ),
      ],
    );

    final dept = Align(
      alignment: Alignment.centerLeft,
      child: AdminTag(c.dept),
    );

    return InkWell(
      onTap: () => setState(() => _selected = c),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSel
              ? (c.status == 'Pending Approval'
              ? const Color(0xFFFFF8EC)
              : AdminColors.soft)
              : Colors.transparent,
          border: const Border(bottom: BorderSide(color: AdminColors.line)),
        ),
        child: roomy
            ? Row(
          children: [
            Expanded(flex: 5, child: course),
            Expanded(flex: 4, child: owner),
            Expanded(flex: 3, child: dept),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            course,
            const SizedBox(height: 8),
            owner,
            const SizedBox(height: 8),
            dept,
          ],
        ),
      ),
    );
  }

  Widget _pagination(int shown) {
    Widget btn(Widget child, {int? page, bool active = false}) {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: page == null ? null : () => setState(() => _page = page),
        child: Container(
          constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AdminColors.indigo : AppColors.chip,
            borderRadius: BorderRadius.circular(10),
          ),
          child: child,
        ),
      );
    }

    Widget num(String s, int p) => btn(
      Text(s,
          style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: _page == p ? Colors.white : AppColors.textDark)),
      page: p,
      active: _page == p,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        spacing: 16,
        children: [
          Text(
            shown == 0
                ? 'Showing 0 curricula'
                : 'Showing 1–$shown of 342 institutional curricula',
            style:
            GoogleFonts.inter(fontSize: 12.5, color: AppColors.textGrey),
          ),
          Wrap(
            spacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              btn(const Icon(Icons.chevron_left, size: 18),
                  page: _page > 1 ? _page - 1 : null),
              num('1', 1),
              num('2', 2),
              num('3', 3),
              Text('...', style: GoogleFonts.inter(color: AppColors.textGrey)),
              num('58', 58),
              btn(const Icon(Icons.chevron_right, size: 18),
                  page: _page < 58 ? _page + 1 : null),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Detail panel ----------------

  Widget _detail() {
    final c = _selected;
    final pending = c.status == 'Pending Approval';
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AdminTag('${c.code} • ${c.level}'),
              const Spacer(),
              const Icon(Icons.view_in_ar_outlined,
                  size: 22, color: AdminColors.indigo),
            ],
          ),
          const SizedBox(height: 12),
          Text(c.title,
              style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text('Term: ${c.term}',
              style:
              GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: AppColors.chip, shape: BoxShape.circle),
                  child: const Icon(Icons.person_outline,
                      color: AdminColors.indigo),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.owner,
                          style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      Text('${c.dept} Dept Lead • ${c.ownerInfo}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontSize: 11.5, color: AppColors.textGrey)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _snack('Message sent to ${c.owner}'),
                  child: const Icon(Icons.mail_outline,
                      size: 20, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.mintBright.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('ABET CURRICULAR INTEGRITY',
                          style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: AppColors.teal)),
                    ),
                    AdminTag(c.abet,
                        bg: AppColors.mintBright,
                        fg: AppColors.teal,
                        fontSize: 10),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Criterion 3.1 & 3.2 verified. Socratic rubrics align fully with autonomous problem solving benchmarks.',
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      height: 1.4,
                      color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AdminGrid(
            minItemWidth: 120,
            gap: 10,
            children: [
              _mini('${c.modules}', 'Modules'),
              _mini('${c.sets}', 'Problem Sets & Labs'),
              _mini('${c.quizzes}', 'Milestone Quizzes'),
              _mini(c.retention, 'Retention Rate', teal: true),
            ],
          ),
          const SizedBox(height: 14),
          _action(Icons.edit_note, 'Edit Syllabi Specification',
              'Editing syllabus for ${c.code}'),
          const SizedBox(height: 8),
          _action(Icons.rule, 'Review Assessment Mappings',
              'Opening assessment mappings for ${c.code}'),
          const SizedBox(height: 8),
          _action(Icons.groups_outlined, 'Manage Enrolled Cohorts',
              'Opening cohorts for ${c.code}'),
          if (pending) ...[
            const SizedBox(height: 8),
            _action(Icons.check_circle_outline, 'Approve Fall Term',
                '${c.code} approved for Fall Term'),
          ],
        ],
      ),
    );
  }

  Widget _mini(String value, String label, {bool teal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: teal ? AppColors.teal : AppColors.textDark)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style:
              GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String label, String message) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _snack(message),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: AdminColors.soft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.textDark),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Fast-track approval ----------------

  Widget _fastTrack() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AdminTag('Fast-Track Approval',
                  bg: Color(0xFFFFE9CF), fg: Color(0xFF8A4B00)),
              const Spacer(),
              const Icon(Icons.notifications_none,
                  size: 20, color: AppColors.textGrey),
            ],
          ),
          const SizedBox(height: 12),
          Text('AI-505: Deep Neural Architectures',
              style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_outlined,
                    size: 20, color: AdminColors.indigo),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Submitted by Dr. Fatima Noor',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark)),
                      Text('3 hours ago • Awaiting Term Clearance',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textGrey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'New syllabus curriculum introduces transformer architectures and tensor calculus. Dean signature attached.',
            style: GoogleFonts.inter(
                fontSize: 12.5, height: 1.45, color: AppColors.textGrey),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AdminButton('Approve Fall Term',
                  primary: true,
                  onTap: () => _snack('AI-505 approved for Fall Term')),
              AdminButton('Request Revision',
                  onTap: () => _snack('Revision requested for AI-505')),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================= Stat card =======================

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final String tag;
  final IconData icon;
  final Color color;
  final String sub;
  final Color tagBg;
  final Color tagFg;

  const _Stat(this.label, this.value, this.tag, this.icon, this.color,
      this.sub,
      {this.tagBg = AppColors.mintBright, this.tagFg = AppColors.teal});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: AppColors.textGrey)),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 19, color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(value,
                  style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              AdminTag(tag, bg: tagBg, fg: tagFg, fontSize: 10),
            ],
          ),
          const SizedBox(height: 8),
          Text(sub,
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.35, color: AppColors.textGrey)),
        ],
      ),
    );
  }
}

// ======================= Capacity card =======================

class _CapacityCard extends StatelessWidget {
  const _CapacityCard();

  static const _tiles = [
    ['Computer Science & AI', '142', '98.1% Capacity'],
    ['Mathematics & Theory', '88', '89.4% Capacity'],
    ['Computer Systems', '64', '85.2% Capacity'],
    ['Data Science Lab', '48', '94.0% Capacity'],
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionTitle(
            'Departmental Syllabus Distribution & Capacity',
            subtitle:
            'Live seat utilization index mapped against ABET audit threshold',
            trailing: AdminTag('Optimal Fill: 92.4%',
                bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
          ),
          const SizedBox(height: 16),
          AdminGrid(
            minItemWidth: 130,
            gap: 10,
            children: [
              for (final t in _tiles)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AdminColors.soft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t[0],
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textGrey)),
                      const SizedBox(height: 4),
                      Text('${t[1]} Courses',
                          style: GoogleFonts.manrope(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark)),
                      const SizedBox(height: 4),
                      Text('● ${t[2]}',
                          style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.teal)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            width: double.infinity,
            child: CustomPaint(painter: _AreaPainter()),
          ),
        ],
      ),
    );
  }
}

class _AreaPainter extends CustomPainter {
  static const _data = [0.25, 0.32, 0.42, 0.55, 0.7, 0.68, 0.8, 0.88, 0.92];

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 6.0;
    final w = size.width - pad * 2;
    final h = size.height - pad * 2;

    Offset pt(int i) => Offset(
      pad + w * i / (_data.length - 1),
      pad + h * (1 - _data[i]),
    );

    final path = Path()..moveTo(pt(0).dx, pt(0).dy);
    for (var i = 1; i < _data.length; i++) {
      final a = pt(i - 1);
      final b = pt(i);
      final mx = (a.dx + b.dx) / 2;
      path.cubicTo(mx, a.dy, mx, b.dy, b.dx, b.dy);
    }

    final fill = Path.from(path)
      ..lineTo(pad + w, pad + h)
      ..lineTo(pad, pad + h)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AdminColors.indigo.withValues(alpha: 0.22),
            AdminColors.indigo.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AdminColors.indigo,
    );
    for (final i in [2, 5]) {
      canvas.drawCircle(pt(i), 4, Paint()..color = AdminColors.teal);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ======================= Friction telemetry =======================

class _FrictionCard extends StatelessWidget {
  const _FrictionCard();

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Cognitive Friction Telemetry',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              Text('Live Feed',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Reverse-Mode AutoDiff DAGs',
                          style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark)),
                    ),
                    Text('42% Friction',
                        style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AdminColors.brown)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.42,
                    minHeight: 6,
                    backgroundColor: AppColors.chip,
                    color: AdminColors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '23 students queried Socratic Bot regarding computational graph backpropagation recursion depth in Module 7.',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      height: 1.4,
                      color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text('Socratic Engine Mode\nGuided Scaffolding',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
              ),
              const AdminTag('96.4% Calibrated',
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
            ],
          ),
        ],
      ),
    );
  }
}