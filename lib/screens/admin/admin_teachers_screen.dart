import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class _Teacher {
  final String name;
  final String email;
  final String degree;
  final String title;
  final String dept;
  final String office;
  final int courses;
  final int students;
  final double efficacy;
  final String band;
  final bool abet;
  final String status;
  final String retention;
  final String rigor;
  final List<double> trend;

  const _Teacher({
    required this.name,
    required this.email,
    required this.degree,
    required this.title,
    required this.dept,
    required this.office,
    required this.courses,
    required this.students,
    required this.efficacy,
    required this.band,
    required this.abet,
    required this.status,
    required this.retention,
    required this.rigor,
    required this.trend,
  });

  String get initials {
    final parts = name
        .replaceAll('Dr. ', '')
        .replaceAll('Prof. ', '')
        .replaceAll('Mr. ', '')
        .replaceAll('Ms. ', '')
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    return '${parts.first[0]}${parts.last[0]}';
  }
}

const _teachers = [
  _Teacher(
    name: 'Dr. Ahmed Khan',
    email: 'ahmed.khan@uni.edu',
    degree: 'Ph.D. Stanford',
    title: 'Full Professor',
    dept: 'Computer Science',
    office: 'Turing Hall 408',
    courses: 5,
    students: 250,
    efficacy: 94.2,
    band: 'Top 2% Faculty',
    abet: true,
    status: 'Active',
    retention: '98.6%',
    rigor: '92 / 100',
    trend: [3, 3.4, 3.1, 4.2, 4.0, 5.2, 5.6, 6.4],
  ),
  _Teacher(
    name: 'Dr. Sara Ahmed',
    email: 'sara@uni.edu',
    degree: 'Ph.D. Princeton',
    title: 'Professor',
    dept: 'Mathematics',
    office: 'Euler Bldg 204',
    courses: 4,
    students: 198,
    efficacy: 91.8,
    band: 'ABET Certified',
    abet: true,
    status: 'Active',
    retention: '97.2%',
    rigor: '90 / 100',
    trend: [3.2, 3.5, 3.9, 4.1, 4.6, 4.9, 5.4, 5.9],
  ),
  _Teacher(
    name: 'Prof. Ali Raza',
    email: 'ali@uni.edu',
    degree: 'M.S. MIT',
    title: 'Associate Professor',
    dept: 'Physics & EE',
    office: 'Newton Wing 110',
    courses: 3,
    students: 176,
    efficacy: 88.5,
    band: 'Standard Band',
    abet: false,
    status: 'Active',
    retention: '94.0%',
    rigor: '85 / 100',
    trend: [3.0, 3.1, 3.4, 3.3, 3.8, 4.0, 4.1, 4.4],
  ),
  _Teacher(
    name: 'Dr. Fatima Noor',
    email: 'fatima@uni.edu',
    degree: 'Ph.D. Cambridge',
    title: 'Associate Professor',
    dept: 'Computer Science',
    office: 'Ada Lovelace 302',
    courses: 6,
    students: 310,
    efficacy: 95.0,
    band: 'Excellence Star',
    abet: true,
    status: 'Active',
    retention: '99.1%',
    rigor: '95 / 100',
    trend: [3.5, 3.9, 4.2, 4.8, 5.1, 5.6, 6.0, 6.8],
  ),
  _Teacher(
    name: 'Mr. Usman Tariq',
    email: 'usman@uni.edu',
    degree: 'M.Phil Oxford',
    title: 'Lecturer',
    dept: 'Humanities & Ethics',
    office: 'Russell Hall 105',
    courses: 2,
    students: 142,
    efficacy: 86.4,
    band: 'Standard Band',
    abet: false,
    status: 'Active',
    retention: '92.3%',
    rigor: '82 / 100',
    trend: [3.0, 3.0, 3.2, 3.4, 3.3, 3.7, 3.9, 4.0],
  ),
  _Teacher(
    name: 'Ms. Ayesha Malik',
    email: 'ayesha@uni.edu',
    degree: 'M.S. Harvard',
    title: 'Adjunct Lecturer',
    dept: 'Business & FinTech',
    office: 'Smith Hall 402',
    courses: 3,
    students: 96,
    efficacy: 79.2,
    band: 'Review Needed',
    abet: false,
    status: 'On Leave',
    retention: '88.0%',
    rigor: '74 / 100',
    trend: [3.4, 3.3, 3.2, 3.0, 3.1, 2.9, 2.8, 2.7],
  ),
];

class AdminTeachersScreen extends StatefulWidget {
  const AdminTeachersScreen({super.key});

  @override
  State<AdminTeachersScreen> createState() => _AdminTeachersScreenState();
}

class _AdminTeachersScreenState extends State<AdminTeachersScreen> {
  static const _depts = [
    'All Departments',
    'Computer Science',
    'Mathematics',
    'Physics & EE',
    'Humanities & Ethics',
    'Business & FinTech',
  ];
  static const _statuses = ['All Statuses', 'Active', 'On Leave'];
  static const _loads = ['Load: All', 'Light (1-3)', 'Heavy (4+)'];
  static const _quick = [
    'Active Only (1,216)',
    'ABET Evaluators (48)',
    'High Engagement (>90 Efficacy)',
    'Fall 2025 Term',
  ];

  String _query = '';
  String _dept = _depts.first;
  String _status = _statuses.first;
  String _load = _loads.first;
  int? _quickSel;
  int _page = 1;
  _Teacher _selected = _teachers.first;

  List<_Teacher> get _filtered {
    return _teachers.where((t) {
      final q = _query.trim().toLowerCase();
      final okQ = q.isEmpty ||
          t.name.toLowerCase().contains(q) ||
          t.email.toLowerCase().contains(q);
      final okD = _dept == _depts.first || t.dept == _dept;
      final okS = _status == _statuses.first || t.status == _status;
      final okL = _load == _loads.first ||
          (_load == _loads[1] && t.courses <= 3) ||
          (_load == _loads[2] && t.courses >= 4);
      var okQuick = true;
      if (_quickSel == 0) okQuick = t.status == 'Active';
      if (_quickSel == 1) okQuick = t.abet;
      if (_quickSel == 2) okQuick = t.efficacy > 90;
      return okQ && okD && okS && okL && okQuick;
    }).toList();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-teachers',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Teachers Management',
              subtitle:
              'Supervise credentialed faculty, course ownership, instructional analytics, and departmental ABET alignment.',
              actions: [
                AdminButton('Audit Teaching Loads',
                    icon: Icons.balance_outlined,
                    onTap: () => _snack('Teaching load audit started')),
                AdminButton('Add Faculty Member',
                    icon: Icons.person_add_alt_1,
                    primary: true,
                    onTap: () => _snack('Add faculty form coming soon')),
              ],
            ),
            const SizedBox(height: 20),
            _stats(),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: Column(
                children: [
                  _filters(),
                  const SizedBox(height: 20),
                  _tableCard(),
                ],
              ),
              side: Column(
                children: [
                  _dossier(),
                  const SizedBox(height: 20),
                  _byDepartment(),
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
    return AdminGrid(
      minItemWidth: 200,
      gap: 14,
      children: [
        _Stat('Total Faculty', '1,248', '+5.1%', Icons.groups_outlined,
            AdminColors.indigo, '1,216 Active Instructors • Term Growth', 0.9),
        _Stat('Active Courses Managed', '342', '100%', Icons.menu_book_outlined,
            AdminColors.teal, 'Across 8 academic departments', 1.0),
        _Stat('Total Students Taught', '23,602', 'µ 142 / Cohort',
            Icons.school_outlined, AdminColors.indigo,
            'Active enrollments Fall 2025', 0.85),
        _Stat('Avg Teaching Efficacy', '93.4', '+3.2%',
            Icons.psychology_alt_outlined, AdminColors.teal,
            'Calibrated Socratic AI rating', 0.93,
            suffix: ' /100'),
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
            minItemWidth: 150,
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
                          hintText: 'Search faculty...',
                          hintStyle: GoogleFonts.inter(
                              fontSize: 14, color: AppColors.textGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _drop(_dept, _depts, (v) => _dept = v),
              _drop(_status, _statuses, (v) => _status = v),
              _drop(_load, _loads, (v) => _load = v),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('QUICK SELECT:',
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

  // ---------------- Table ----------------

  Widget _tableCard() {
    final rows = _filtered;
    return AdminCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, box) {
          final roomy = box.maxWidth >= 640;
          return Column(
            children: [
              if (roomy)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: _th('FACULTY MEMBER')),
                      Expanded(flex: 4, child: _th('DEPARTMENT & OFFICE')),
                      Expanded(flex: 2, child: _th('COURSES')),
                      Expanded(flex: 2, child: _th('STUDENTS')),
                      Expanded(flex: 3, child: _th('EFFICACY INDEX')),
                    ],
                  ),
                ),
              const Divider(height: 1, color: AdminColors.line),
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text('No faculty match these filters',
                      style: GoogleFonts.inter(color: AppColors.textGrey)),
                )
              else
                for (final t in rows) _row(t, roomy),
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

  Widget _avatar(_Teacher t, {double size = 44}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AdminColors.indigo.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: Text(
        t.initials,
        style: GoogleFonts.manrope(
          fontSize: size * 0.34,
          fontWeight: FontWeight.w800,
          color: AdminColors.indigo,
        ),
      ),
    );
  }

  Color _effColor(_Teacher t) =>
      t.efficacy < 80 ? AdminColors.brown : AdminColors.indigo;

  Widget _row(_Teacher t, bool roomy) {
    final isSel = identical(t, _selected);

    final identity = Row(
      children: [
        _avatar(t),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              Text('${t.email} • ${t.degree}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 11.5, color: AppColors.textGrey)),
            ],
          ),
        ),
      ],
    );

    final deptCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.dept,
            style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark)),
        Text(t.office,
            style:
            GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey)),
      ],
    );

    final coursesTag = AdminTag('${t.courses}');

    final effCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(
              text: t.efficacy.toStringAsFixed(1),
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _effColor(t))),
          TextSpan(
              text: ' /100',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
        ])),
        Text(t.band,
            style:
            GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey)),
      ],
    );

    return InkWell(
      onTap: () => setState(() => _selected = t),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSel ? AdminColors.soft : Colors.transparent,
          border: const Border(bottom: BorderSide(color: AdminColors.line)),
        ),
        child: roomy
            ? Row(
          children: [
            Expanded(flex: 5, child: identity),
            Expanded(flex: 4, child: deptCol),
            Expanded(
                flex: 2,
                child: Align(
                    alignment: Alignment.centerLeft, child: coursesTag)),
            Expanded(
                flex: 2,
                child: Text('${t.students}',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark))),
            Expanded(flex: 3, child: effCol),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            identity,
            const SizedBox(height: 8),
            deptCol,
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Courses:',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textGrey)),
                coursesTag,
                Text('Students: ${t.students}',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textDark)),
                effCol,
              ],
            ),
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
                ? 'Showing 0 faculty'
                : 'Showing 1–$shown of 1,248 registered faculty',
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
              num('208', 208),
              btn(const Icon(Icons.chevron_right, size: 18),
                  page: _page < 208 ? _page + 1 : null),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Dossier ----------------

  Widget _dossier() {
    final t = _selected;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.school_outlined,
                    color: AdminColors.indigo),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FACULTY DOSSIER',
                        style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: AdminColors.indigo)),
                    Text(t.name,
                        style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    Text('${t.title} • ${t.degree}',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textGrey)),
                  ],
                ),
              ),
              AdminTag(t.status == 'Active' ? 'Tenured' : 'On Leave',
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AdminTag(t.dept),
              AdminTag(t.office),
              if (t.abet) const AdminTag('ABET Evaluator'),
              const AdminTag('IEEE Senior Member'),
            ],
          ),
          const SizedBox(height: 16),
          AdminGrid(
            minItemWidth: 120,
            gap: 10,
            children: [
              _mini('Course Completion', t.efficacy.toStringAsFixed(1) + '%',
                  '±1.4% vs Dept Avg'),
              _mini('Cohort Retention', t.retention, 'Zero Attrition'),
              _mini('Active Load', '${t.courses} Core Courses',
                  '${t.students} Enrolled',
                  big: false),
              _mini('Assessment Rigor', t.rigor, 'High Fidelity'),
            ],
          ),
          const SizedBox(height: 16),
          _trend(t),
          const SizedBox(height: 16),
          _telemetry(t),
          const SizedBox(height: 14),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _snack('Accreditation report for ${t.name} exported'),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download_outlined,
                      size: 18, color: AdminColors.indigo),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text('Download Accreditation Report (.PDF)',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mini(String label, String value, String sub, {bool big = true}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: big ? 20 : 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(sub,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.indigo)),
        ],
      ),
    );
  }

  Widget _trend(_Teacher t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Instructional Velocity Trend',
                    style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              Text('12-Week Delta',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            width: double.infinity,
            child: CustomPaint(painter: _TrendPainter(t.trend)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final s in ['W1 Baseline', 'Midterm (W6)', 'Current (W12)'])
                Text(s,
                    style: GoogleFonts.inter(
                        fontSize: 10.5, color: AppColors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _telemetry(_Teacher t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Explainable AI Faculty Telemetry',
                    style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              const AdminTag('96.4% Calibrated',
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "${t.name}'s Socratic scaffolding in ${t.dept == 'Computer Science' ? 'CS-301' : 'core modules'} reversed cohort cognitive stagnation on Reverse-Mode DAG Autodiff within 48 hours.",
            style: GoogleFonts.inter(
                fontSize: 12.5, height: 1.45, color: AppColors.textGrey),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text('Model: Telemetry Engine v4.2',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
              ),
              InkWell(
                onTap: () => _snack('Opening full dossier for ${t.name}'),
                child: Text('View Full Dossier →',
                    style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.indigo)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Faculty by department ----------------

  Widget _byDepartment() {
    const rows = [
      ['Computer Science & AI', '420 Instructors (33.6%)', 0.336,
        AdminColors.indigo],
      ['Mathematics & Statistics', '310 Instructors (24.8%)', 0.248,
        AdminColors.teal],
      ['Physics & Electrical Eng', '240 Instructors (19.2%)', 0.192,
        AdminColors.indigo],
      ['Business & FinTech', '178 Instructors (14.2%)', 0.142,
        AdminColors.brown],
      ['Humanities & Ethics', '100 Instructors (8.2%)', 0.082,
        Color(0xFFB8BAD6)],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionTitle(
            'Faculty by Department',
            subtitle: 'Active instructional load allocation',
          ),
          const SizedBox(height: 16),
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(r[0] as String,
                            style: GoogleFonts.inter(
                                fontSize: 12, color: AppColors.textDark)),
                      ),
                      Text(r[1] as String,
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (r[2] as double) * 2.5 > 1
                          ? 1
                          : (r[2] as double) * 2.5,
                      minHeight: 6,
                      backgroundColor: AppColors.chip,
                      color: r[3] as Color,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final String tag;
  final IconData icon;
  final Color color;
  final String sub;
  final double progress;
  final String suffix;

  const _Stat(this.label, this.value, this.tag, this.icon, this.color,
      this.sub, this.progress,
      {this.suffix = ''});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textGrey)),
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
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: value,
                    style: GoogleFonts.manrope(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                if (suffix.isNotEmpty)
                  TextSpan(
                      text: suffix,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textGrey)),
              ])),
              AdminTag(tag,
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 6),
          Text(sub,
              style:
              GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppColors.chip,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<double> data;
  _TrendPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    var lo = data.first, hi = data.first;
    for (final v in data) {
      if (v < lo) lo = v;
      if (v > hi) hi = v;
    }
    if (hi == lo) hi = lo + 1;
    const pad = 6.0;
    final w = size.width - pad * 2;
    final h = size.height - pad * 2;

    Offset pt(int i) => Offset(
      pad + w * i / (data.length - 1),
      pad + h * (1 - (data[i] - lo) / (hi - lo)),
    );

    final path = Path()..moveTo(pt(0).dx, pt(0).dy);
    for (var i = 1; i < data.length; i++) {
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
            AdminColors.indigo.withValues(alpha: 0.25),
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
    canvas.drawCircle(
        pt(data.length - 1), 4, Paint()..color = AdminColors.indigo);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter old) => old.data != data;
}