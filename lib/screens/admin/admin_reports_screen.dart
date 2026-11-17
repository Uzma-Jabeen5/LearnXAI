import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class _Report {
  final String title;
  final String scope;
  final String by;
  final String time;
  final String size;
  final String format;
  final IconData icon;
  final Color color;

  const _Report(this.title, this.scope, this.by, this.time, this.size,
      this.format, this.icon, this.color);
}

class _Dept {
  final String name;
  final String tag;
  final String sub;
  final double value;
  final double threshold;
  final Color color;

  const _Dept(this.name, this.tag, this.sub, this.value, this.threshold,
      this.color);
}

// Section header that stacks the trailing widget under the title,
// so long titles never get squeezed on narrow screens.
Widget _head(String title, {String? subtitle, Widget? trailing}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark)),
      if (subtitle != null) ...[
        const SizedBox(height: 4),
        Text(subtitle,
            style:
            GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey)),
      ],
      if (trailing != null) ...[
        const SizedBox(height: 10),
        trailing,
      ],
    ],
  );
}

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  static const _terms = ['Fall 2025', 'Spring 2025', 'Fall 2024'];
  static const _cats = [
    'All Reports',
    'Accreditation',
    'Cognitive',
    'Faculty',
    'AI Diagnostics'
  ];
  static const _deptNames = [
    'All Departments',
    'Computer Science & AI',
    'Applied Data Science',
    'Systems & Networks',
    'Pure & Applied Mathematics',
  ];
  static const _levels = [
    'All Semesters',
    'Freshman',
    'Sophomore',
    'Upper-Division',
    'Graduate'
  ];

  static const _depts = [
    _Dept('Computer Science & Artificial Intelligence', '+6.8% Target Lead',
        '92 Curricula • 912 Enrolled', 0.818, 0.841, AdminColors.indigo),
    _Dept('Applied Data Science & Informatics', '+2.4% Target Lead',
        '64 Curricula • 520 Enrolled', 0.774, 0.795, AdminColors.teal),
    _Dept('Systems Architecture & Networks', 'Near Baseline',
        '58 Curricula • 488 Enrolled', 0.742, 0.730, AdminColors.indigo),
    _Dept('Pure & Applied Mathematics', '-5.6% Remediation Focus',
        '48 Curricula • 569 Enrolled', 0.694, 0.702, AdminColors.brown),
  ];

  final List<_Report> _reports = [
    const _Report(
        'ABET_Criterion_3_FullAudit_Fall2025',
        'All 8 Departments • Continuous Learning Dossier',
        'Platform Admin (Root)',
        'Today, 08:42 AM',
        '14.8 MB',
        'PDF',
        Icons.description_outlined,
        AdminColors.indigo),
    const _Report(
        'Student_Cognitive_Friction_Breakdown_W14',
        'CS & Data Science • 1,420 Submissions',
        'Automated CRON',
        'Yesterday, 11:59 PM',
        '4.2 MB',
        'CSV',
        Icons.table_chart_outlined,
        AdminColors.teal),
    const _Report(
        'Socratic_Engine_Drift_Sensitivity_Nov2025',
        'GPT-4o vs Claude-3.5-Sonnet Parity Telemetry',
        'AI Ops Superuser',
        'Nov 28, 2025',
        '8.1 MB',
        'PDF',
        Icons.smart_toy_outlined,
        AdminColors.indigo),
    const _Report(
        'Faculty_Instructional_Velocity_Midterm_Q3',
        '32 Faculty • Rubric Parity & Grading SLA',
        'Dean of Academic Affairs',
        'Nov 24, 2025',
        '2.7 MB',
        'CSV',
        Icons.school_outlined,
        AdminColors.brown),
  ];

  String _term = _terms.first;
  String _cat = _cats.first;
  String _dept = _deptNames.first;
  String _level = _levels.first;
  String _search = '';
  int _page = 1;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  List<_Dept> get _visibleDepts {
    if (_dept == _deptNames.first) return _depts;
    final key = _dept.split(' ').first;
    return _depts.where((d) => d.name.startsWith(key)).toList();
  }

  List<_Report> get _visibleReports {
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return _reports;
    return _reports
        .where((r) =>
    r.title.toLowerCase().contains(q) ||
        r.scope.toLowerCase().contains(q))
        .toList();
  }

  void _generate(String name, String scope, String format) {
    setState(() {
      _reports.insert(
        0,
        _Report(name, scope, 'Platform Admin (Root)', 'Just now', '1.2 MB',
            format, Icons.description_outlined, AdminColors.indigo),
      );
    });
    _snack('$name generated and archived');
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-reports',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Reports & Longitudinal Analytics',
              subtitle:
              'Generate, schedule, and evaluate comprehensive institutional learning performance, faculty engagement, and AI intervention efficacy across all academic cohorts.',
              actions: [
                AdminButton('Schedule Automated Report',
                    icon: Icons.event_repeat_outlined,
                    onTap: () => _snack('Report scheduler coming soon')),
                AdminButton('Generate Custom Dossier',
                    icon: Icons.auto_awesome,
                    primary: true,
                    onTap: () => _generate('Custom_Dossier_Fall2025',
                        'Custom scope • All Departments', 'PDF')),
              ],
            ),
            const SizedBox(height: 20),
            const AdminGrid(
              minItemWidth: 200,
              gap: 14,
              children: [
                _Stat('INSTITUTIONAL GROWTH', '2,489 Users',
                    Icons.groups_outlined, AdminColors.indigo,
                    '+12.0% YoY', '1,842 students, 32 faculty',
                    '94.2% longitudinal retention'),
                _Stat('CURRICULAR VELOCITY', '68.4%',
                    Icons.menu_book_outlined, AdminColors.teal,
                    '+5.8% term lift', '342 active curricula',
                    'Avg. master score 78.2%'),
                _Stat('SOCRATIC AI RESOLUTION', '91.6%',
                    Icons.psychology_outlined, AdminColors.indigo,
                    '14,820 guided inquiries', 'Misconception recovery',
                    '+18.4%'),
                _Stat('ABET ACCREDITATION', '98.4 / 100',
                    Icons.verified_outlined, AdminColors.teal,
                    '8 / 8 Departments compliant', 'Cycle 2025',
                    'continuous readiness'),
              ],
            ),
            const SizedBox(height: 20),
            _filters(),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: Column(
                children: [
                  const _GrowthCard(),
                  const SizedBox(height: 20),
                  _masteryCard(),
                ],
              ),
              side: Column(
                children: [
                  const _EfficacyCard(),
                  const SizedBox(height: 20),
                  _complianceCard(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _dossiers(),
            const SizedBox(height: 20),
            _archive(),
          ],
        ),
      ),
    );
  }

  // ---------------- Filters ----------------

  Widget _filters() {
    final wide = MediaQuery.of(context).size.width >= 900;

    Widget labeled(String label, Widget child) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.textGrey)),
        const SizedBox(height: 6),
        child,
      ],
    );

    final apply = AdminButton('Apply Filter',
        primary: true, onTap: () => _snack('Filters applied'));
    final export = AdminButton('Export',
        icon: Icons.download_outlined,
        onTap: () => _snack('Export (PDF/CSV) started'));

    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminGrid(
            minItemWidth: 160,
            gap: 12,
            children: [
              labeled('ACADEMIC TERM',
                  _drop(_term, _terms, (v) => _term = v)),
              labeled('REPORT CATEGORY',
                  _drop(_cat, _cats, (v) => _cat = v)),
              labeled('ACADEMIC DEPARTMENT',
                  _drop(_dept, _deptNames, (v) => _dept = v)),
              labeled('COHORT LEVEL',
                  _drop(_level, _levels, (v) => _level = v)),
            ],
          ),
          const SizedBox(height: 14),
          wide
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [apply, const SizedBox(width: 10), export],
          )
              : Row(
            children: [
              Expanded(child: apply),
              const SizedBox(width: 10),
              Expanded(child: export),
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
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark),
          items: [
            for (final i in items)
              DropdownMenuItem(
                  value: i, child: Text(i, overflow: TextOverflow.ellipsis))
          ],
          onChanged: (v) {
            if (v != null) setState(() => set(v));
          },
        ),
      ),
    );
  }

  // ---------------- Mastery bars ----------------

  Widget _masteryCard() {
    final list = _visibleDepts;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(
            'Curricular Completion & Departmental Mastery',
            subtitle:
            'Progress benchmarked against the 75% institutional objective baseline',
            trailing: const AdminTag('Institutional Target: 75.0%',
                fontSize: 10),
          ),
          const SizedBox(height: 16),
          for (final d in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + percentage on one line
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(d.name,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                      ),
                      const SizedBox(width: 8),
                      Text('${(d.value * 100).toStringAsFixed(1)}%',
                          style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: d.color)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Tag on its own line so it never squeezes the name
                  AdminTag(d.tag,
                      bg: d.color == AdminColors.brown
                          ? const Color(0xFFFFE9CF)
                          : AppColors.mintBright,
                      fg: d.color == AdminColors.brown
                          ? const Color(0xFF8A4B00)
                          : AppColors.teal,
                      fontSize: 9.5),
                  const SizedBox(height: 8),
                  _MasteryBar(d.value, d.threshold, d.color),
                  const SizedBox(height: 6),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 12,
                    runSpacing: 2,
                    children: [
                      Text(d.sub,
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textGrey)),
                      Text(
                          'Mastery Threshold: ${(d.threshold * 100).toStringAsFixed(1)}%',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textGrey)),
                    ],
                  ),
                ],
              ),
            ),
          if (list.isEmpty)
            Text('No departments match this filter',
                style: GoogleFonts.inter(color: AppColors.textGrey)),
        ],
      ),
    );
  }

  // ---------------- Compliance ----------------

  Widget _complianceCard() {
    const rows = [
      [
        'ABET Criterion 3 (Student Outcomes)',
        'Continuous Assessment Cycle',
        '100%'
      ],
      ['ABET Criterion 5 (Curriculum)', 'Cognitive Rigor & Parity', '98.4%'],
      ['FERPA Privacy & PII Shield', 'Automated Redaction Engine', '100%'],
      ['AI Pedagogical Safety Index', 'Hallucination Mitigation', '99.7%'],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(
            'Institutional Compliance',
            trailing: const AdminTag('ABET / FERPA',
                bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
          ),
          const SizedBox(height: 14),
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r[0],
                            style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        Text(r[1],
                            style: GoogleFonts.inter(
                                fontSize: 11, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(r[2],
                      style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AdminColors.indigo)),
                ],
              ),
            ),
          AdminButton('Export Official Accreditation Audit',
              icon: Icons.verified_outlined,
              onTap: () => _generate('ABET_Official_Accreditation_Audit',
                  'All 8 Departments • Official Audit', 'PDF')),
        ],
      ),
    );
  }

  // ---------------- Dossier cards ----------------

  Widget _dossiers() {
    const items = [
      [
        'ABET Criterion 3 & 5 Audit',
        'Comprehensive psychometric distributions, outcome mapping matrices, and cross-departmental curricular mastery benchmarks.',
        'ABET_Criterion_3_5_Audit',
        'PDF',
      ],
      [
        'Cohort Misconception Matrix',
        'Deep telemetry on top 5 cognitive friction bottlenecks: pointer arithmetic, recursion, backpropagation, and state machines.',
        'Cohort_Misconception_Matrix',
        'CSV',
      ],
      [
        'Faculty Load & Grading SLA',
        'Turnaround diagnostics, auto-grader alignment variance, and qualitative rubric parity analysis across 32 active educators.',
        'Faculty_Load_Grading_SLA',
        'CSV',
      ],
      [
        'AI Drift & Pedagogical Diagnostics',
        'Bayesian Knowledge Tracing (BKT) precision, student rating telemetry, hallucination flags, and model latency histograms.',
        'AI_Drift_Pedagogical_Diagnostics',
        'PDF',
      ],
    ];
    const icons = [
      Icons.balance_outlined,
      Icons.account_tree_outlined,
      Icons.fact_check_outlined,
      Icons.psychology_outlined,
    ];
    const colors = [
      AdminColors.indigo,
      Color(0xFFE5484D),
      AdminColors.teal,
      AdminColors.indigo,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 4,
          children: [
            Text('Targeted Longitudinal Dossiers',
                style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            Text('● 4 Async Nodes Ready',
                style:
                GoogleFonts.inter(fontSize: 11, color: AppColors.teal)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
            'Select pre-computed psychometric templates or compile instantaneous deep-dives',
            style:
            GoogleFonts.inter(fontSize: 12.5, color: AppColors.textGrey)),
        const SizedBox(height: 14),
        AdminGrid(
          minItemWidth: 220,
          gap: 14,
          children: [
            for (var i = 0; i < items.length; i++)
              AdminCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: colors[i].withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icons[i], color: colors[i]),
                    ),
                    const SizedBox(height: 12),
                    Text(items[i][0],
                        style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(height: 6),
                    Text(items[i][1],
                        style: GoogleFonts.inter(
                            fontSize: 11.5,
                            height: 1.4,
                            color: AppColors.textGrey)),
                    const SizedBox(height: 14),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () =>
                          _generate(items[i][2], items[i][0], items[i][3]),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AdminColors.soft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bolt,
                                size: 16, color: AdminColors.indigo),
                            const SizedBox(width: 6),
                            Text('Generate Instantly',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AdminColors.indigo)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ---------------- Archive ----------------

  Widget _archive() {
    final rows = _visibleReports;
    return AdminCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, box) {
          final roomy = box.maxWidth >= 760;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: math.max(200, box.maxWidth - 40)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recent Generated Reports & Archived Runs',
                              style: GoogleFonts.manrope(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Text(
                              'Authenticated platform audit trails and downloadable data packages',
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: math.max(200, box.maxWidth - 40)),
                      child: SizedBox(
                        width: 260,
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AdminColors.soft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search,
                                  size: 18, color: AppColors.textGrey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: (v) =>
                                      setState(() => _search = v),
                                  style: GoogleFonts.inter(fontSize: 13),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintText: 'Filter archived dossiers...',
                                    hintStyle: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        color: AppColors.textGrey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (roomy)
                Container(
                  color: AdminColors.soft,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Row(
                    children: [
                      Expanded(flex: 6, child: _th('REPORT TITLE & SCOPE')),
                      Expanded(flex: 3, child: _th('GENERATED BY')),
                      Expanded(flex: 2, child: _th('TIMESTAMP')),
                      Expanded(flex: 1, child: _th('SIZE')),
                      Expanded(flex: 1, child: _th('FORMAT')),
                      Expanded(flex: 2, child: _th('ACTION')),
                    ],
                  ),
                ),
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text('No archived reports match',
                      style: GoogleFonts.inter(color: AppColors.textGrey)),
                )
              else
                for (final r in rows) _archiveRow(r, roomy),
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
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      color: AppColors.textGrey,
    ),
  );

  Widget _archiveRow(_Report r, bool roomy) {
    final title = Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: r.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(r.icon, size: 19, color: r.color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.title,
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              Text(r.scope,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ),
      ],
    );

    final by = Text(r.by,
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textDark));
    final time = Text(r.time,
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey));
    final size = Text(r.size,
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey));
    final format = Align(
      alignment: Alignment.centerLeft,
      child: AdminTag(r.format,
          bg: r.format == 'PDF'
              ? const Color(0xFFFFE3E3)
              : AppColors.mintBright,
          fg: r.format == 'PDF' ? AdminColors.red : AppColors.teal,
          fontSize: 10),
    );
    final download = InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _snack('Downloading ${r.title}.${r.format.toLowerCase()}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AdminColors.soft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.download_outlined,
                size: 15, color: AdminColors.indigo),
            const SizedBox(width: 4),
            Text('Download',
                style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.indigo)),
          ],
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.line)),
      ),
      child: roomy
          ? Row(
        children: [
          Expanded(flex: 6, child: title),
          Expanded(flex: 3, child: by),
          Expanded(flex: 2, child: time),
          Expanded(flex: 1, child: size),
          Expanded(flex: 1, child: format),
          Expanded(
              flex: 2,
              child: Align(
                  alignment: Alignment.centerLeft, child: download)),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [by, time, size, format, download],
          ),
        ],
      ),
    );
  }

  Widget _pagination(int shown) {
    Widget btn(String s, int? page, {bool active = false}) {
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
          child: Text(s,
              style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.textDark)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        spacing: 16,
        children: [
          Text('Showing $shown of 48 generated dossiers',
              style: GoogleFonts.inter(
                  fontSize: 12.5, color: AppColors.textGrey)),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              btn('Previous', _page > 1 ? _page - 1 : null),
              btn('1', 1, active: _page == 1),
              btn('2', 2, active: _page == 2),
              btn('3', 3, active: _page == 3),
              btn('Next', _page < 3 ? _page + 1 : null),
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
  final IconData icon;
  final Color color;
  final String tag;
  final String line1;
  final String line2;

  const _Stat(this.label, this.value, this.icon, this.color, this.tag,
      this.line1, this.line2);

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
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
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
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('↗ $tag',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal)),
                const SizedBox(height: 2),
                Text(line1,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
                Text(line2,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= Mastery bar with threshold marker =======================

class _MasteryBar extends StatelessWidget {
  final double value;
  final double threshold;
  final Color color;

  const _MasteryBar(this.value, this.threshold, this.color);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        return SizedBox(
          height: 12,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                top: 3,
                bottom: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.chip,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 3,
                bottom: 3,
                width: w * value,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Positioned(
                left: w * threshold - 1,
                top: 0,
                bottom: 0,
                width: 2,
                child: Container(color: AdminColors.red),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ======================= Growth chart =======================

class _GrowthCard extends StatelessWidget {
  const _GrowthCard();

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(
            'User Growth & Longitudinal Engagement',
            subtitle:
            'Weekly active student trajectory vs newly verified enrollments (Fall 2025)',
            trailing: Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                _legend(AdminColors.indigo, 'Active Learners'),
                _legend(AdminColors.teal, 'New Enrollments'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 230,
            width: double.infinity,
            child: CustomPaint(painter: _GrowthPainter()),
          ),
          const SizedBox(height: 10),
          Text.rich(TextSpan(children: [
            TextSpan(
                text: 'Peak concurrency: ',
                style: GoogleFonts.inter(
                    fontSize: 11.5, color: AppColors.textGrey)),
            TextSpan(
                text: '1,842 learners',
                style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            TextSpan(
                text:
                ' logged during Midterm Revision Week (Nov 03 - Nov 09).',
                style: GoogleFonts.inter(
                    fontSize: 11.5, color: AppColors.textGrey)),
          ])),
          const SizedBox(height: 6),
          Text('● Telemetry validated',
              style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.teal)),
        ],
      ),
    );
  }

  Widget _legend(Color c, String t) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      ),
      const SizedBox(width: 5),
      Text(t,
          style:
          GoogleFonts.inter(fontSize: 11.5, color: AppColors.textDark)),
    ],
  );
}

class _GrowthPainter extends CustomPainter {
  static const _a = [0.18, 0.30, 0.42, 0.40, 0.72, 0.80, 0.74, 0.84, 0.78];
  static const _b = [0.12, 0.20, 0.26, 0.30, 0.42, 0.50, 0.46, 0.55, 0.52];
  static const _x = [
    'Aug 18',
    'Sep 08',
    'Sep 29',
    'Oct 20',
    'Nov 10',
    'Dec 01'
  ];
  static const _y = ['2,000', '1,500', '1,000', '500'];

  void _label(Canvas c, String s, Offset o, {bool center = false}) {
    final tp = TextPainter(
      text: TextSpan(
          text: s,
          style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
      textDirection: TextDirection.ltr,
    )..layout();
    c.drawText(tp, o, center);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const left = 38.0, bottom = 22.0, top = 8.0;
    final w = size.width - left - 6;
    final h = size.height - bottom - top;

    final grid = Paint()
      ..color = AdminColors.line
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = top + h * i / 3;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), grid);
      _label(canvas, _y[i], Offset(0, y - 6));
    }

    Offset pt(List<double> d, int i) => Offset(
      left + w * i / (d.length - 1),
      top + h * (1 - d[i]),
    );

    Path curve(List<double> d) {
      final p = Path()..moveTo(pt(d, 0).dx, pt(d, 0).dy);
      for (var i = 1; i < d.length; i++) {
        final a = pt(d, i - 1);
        final b = pt(d, i);
        final mx = (a.dx + b.dx) / 2;
        p.cubicTo(mx, a.dy, mx, b.dy, b.dx, b.dy);
      }
      return p;
    }

    final pa = curve(_a);
    final fill = Path.from(pa)
      ..lineTo(left + w, top + h)
      ..lineTo(left, top + h)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AdminColors.indigo.withValues(alpha: 0.2),
            AdminColors.indigo.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, top, size.width, h)),
    );
    canvas.drawPath(
        pa,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = AdminColors.indigo);
    canvas.drawPath(
        curve(_b),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = AdminColors.teal);

    canvas.drawCircle(
        pt(_a, _a.length - 1), 4, Paint()..color = AdminColors.indigo);
    canvas.drawCircle(
        pt(_b, _b.length - 1), 4, Paint()..color = AdminColors.teal);

    for (var i = 0; i < _x.length; i++) {
      final x = left + w * i / (_x.length - 1);
      _label(canvas, _x[i], Offset(x, size.height - 14), center: true);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

extension on Canvas {
  void drawText(TextPainter tp, Offset pos, bool center) {
    tp.paint(this, Offset(center ? pos.dx - tp.width / 2 : pos.dx, pos.dy));
  }
}

// ======================= Cognitive efficacy donut =======================

class _EfficacyCard extends StatelessWidget {
  const _EfficacyCard();

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['First-Principles Inquiry', '62%', AdminColors.indigo],
      ['Multi-Step Guided Hints', '26%', AdminColors.teal],
      ['Deep Remediation Spiral', '12%', Color(0xFFF59E0B)],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(
            'Cognitive Resolution Efficacy',
            subtitle:
            'Distribution of Socratic engine guidance modes without direct code/solution disclosure.',
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 170,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                      size: const Size(170, 170), painter: _DonutPainter()),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('94.6%',
                          style: GoogleFonts.manrope(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark)),
                      Text('CONFIDENCE',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              letterSpacing: 0.5,
                              color: AppColors.textGrey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final r in rows)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: r[2] as Color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(r[0] as String,
                        style: GoogleFonts.inter(
                            fontSize: 12.5, color: AppColors.textDark)),
                  ),
                  Text(r[1] as String,
                      style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.mintBright.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
                'Zero answer leaks registered across 14,820 student sessions. All solutions guided through autonomous scaffolding.',
                style: GoogleFonts.inter(
                    fontSize: 11.5, height: 1.4, color: AppColors.teal)),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 22.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    const fr = [0.62, 0.26, 0.12];
    const cols = [
      AdminColors.indigo,
      AdminColors.teal,
      Color(0xFFF59E0B),
    ];
    var start = -math.pi / 2;
    const gap = 0.05;
    for (var i = 0; i < fr.length; i++) {
      final sweep = 2 * math.pi * fr[i];
      canvas.drawArc(
        rect,
        start + gap / 2,
        sweep - gap,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = cols[i],
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}