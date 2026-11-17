import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class _User {
  final String name;
  final String sub;
  final String email;
  final String sis;
  final String role;
  final String status;
  final String dept;
  final String m1;
  final String m2;
  final List<String> courses;

  const _User(this.name, this.sub, this.email, this.sis, this.role,
      this.status, this.dept, this.m1, this.m2, this.courses);

  bool get isTeacher => role == 'Teacher';

  String get initials {
    final parts = name
        .replaceAll('Dr. ', '')
        .replaceAll('Prof. ', '')
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length == 1) return parts.first[0];
    return '${parts.first[0]}${parts.last[0]}';
  }
}

const _allUsers = [
  _User('Ayesha Khan', "BS AI '26 Cohort", 'ayesha@student.uni.edu',
      '#2024-001', 'Student', 'Active', 'CS & AI', '91.2%', '96.4%',
      ['CS-301 Algorithms', 'CS-402 Deep Learning', 'MATH-210 Linear Algebra']),
  _User('Dr. Ahmed Khan', 'Lead Faculty • CS & AI', 'ahmed@uni.edu',
      '#FAC-8821', 'Teacher', 'Active', 'CS & AI', '94.2%', '98.6%',
      ['CS-301 Algorithms', 'CS-610 Machine Learning']),
  _User('Usman Ali', 'MS CS Postgraduate', 'usman@student.uni.edu',
      '#2023-114', 'Student', 'Active', 'CS & AI', '88.5%', '92.1%',
      ['CS-610 Machine Learning', 'CS-204 Databases']),
  _User('Dr. Sara Ahmed', 'Professor • Mathematics', 'sara@uni.edu',
      '#FAC-9041', 'Teacher', 'Active', 'Mathematics', '91.8%', '97.2%',
      ['MATH-210 Linear Algebra', 'DS-102 Probability']),
  _User('Hamza Tariq', 'BS CS Applicant', 'hamza@student.uni.edu',
      '#2024-012', 'Student', 'Pending Verification', 'CS & AI', '—', '—',
      ['Awaiting enrollment']),
  _User('Ayesha Malik', 'Adjunct Lecturer', 'ayesha@uni.edu', '#FAC-7712',
      'Teacher', 'Disabled', 'Mathematics', '79.2%', '90.0%',
      ['DS-102 Probability']),
  _User('Zainab Iqbal', "BS AI '26 Cohort", 'zainab@student.uni.edu',
      '#2024-089', 'Student', 'Active', 'CS & AI', '93.0%', '95.5%',
      ['CS-301 Algorithms', 'CS-402 Deep Learning']),
];

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  static const _roles = ['All Roles', 'Student', 'Teacher'];
  static const _statuses = [
    'All Statuses',
    'Active',
    'Pending Verification',
    'Disabled'
  ];
  static const _depts = ['All Departments', 'CS & AI', 'Mathematics'];

  String _query = '';
  String _role = _roles.first;
  String _status = _statuses.first;
  String _dept = _depts.first;
  int _page = 1;
  _User _selected = _allUsers.first;
  final Set<String> _checked = {};

  List<_User> get _filtered {
    return _allUsers.where((u) {
      final q = _query.trim().toLowerCase();
      final matchQ = q.isEmpty ||
          u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q) ||
          u.sis.toLowerCase().contains(q);
      final matchR = _role == _roles.first || u.role == _role;
      final matchS = _status == _statuses.first || u.status == _status;
      final matchD = _dept == _depts.first || u.dept == _dept;
      return matchQ && matchR && matchS && matchD;
    }).toList();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-users',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Users Management',
              tag: '24,850 Records',
              subtitle:
              'Manage students, faculty, and administrative credentials across the LearnXAI explainable ecosystem.',
              actions: [
                AdminButton('Export Roster (CSV)',
                    icon: Icons.download_outlined,
                    onTap: () => _snack('Roster export started')),
                AdminButton('Add New User',
                    icon: Icons.person_add_alt_1,
                    primary: true,
                    onTap: () => _snack('Add user form coming soon')),
              ],
            ),
            const SizedBox(height: 20),
            _stats(),
            const SizedBox(height: 20),
            _filters(),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: _tableCard(),
              side: Column(
                children: [
                  _inspector(),
                  const SizedBox(height: 20),
                  _insight(),
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
        _Stat(
          'TOTAL USERS',
          '24,850',
          Icons.groups_outlined,
          AdminColors.indigo,
          _footerText('+12.0%', 'vs past term', AppColors.teal),
        ),
        _Stat(
          'ACTIVE USERS',
          '21,430',
          Icons.monitor_heart_outlined,
          AdminColors.teal,
          _footerText('+8.4%', '7-day active • 86.2%', AppColors.teal),
        ),
        _Stat(
          'STUDENTS ENROLLED',
          '23,602',
          Icons.school_outlined,
          AdminColors.indigo,
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.95,
                    minHeight: 6,
                    backgroundColor: AppColors.chip,
                    color: AdminColors.indigo,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('95%',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ),
        _Stat(
          'GOVERNED ROLES',
          '1,248',
          Icons.verified_user_outlined,
          AdminColors.indigo,
          Text('1,216 Teachers • 32 Super Admins',
              style:
              GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey)),
        ),
      ],
    );
  }

  Widget _footerText(String green, String rest, Color c) {
    return Wrap(
      spacing: 6,
      children: [
        Text(green,
            style: GoogleFonts.inter(
                fontSize: 11, fontWeight: FontWeight.w700, color: c)),
        Text(rest,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey)),
      ],
    );
  }

  // ---------------- Filters ----------------

  Widget _filters() {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: AdminGrid(
        minItemWidth: 170,
        gap: 12,
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
                const Icon(Icons.search, size: 20, color: AppColors.textGrey),
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
                      hintText: 'Search users...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.textGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _drop(_role, _roles, (v) => setState(() => _role = v)),
          _drop(_status, _statuses, (v) => setState(() => _status = v)),
          _drop(_dept, _depts, (v) => setState(() => _dept = v)),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _snack(_checked.isEmpty
                ? 'Select users first to batch edit permissions'
                : 'Batch permissions for ${_checked.length} users'),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.rule, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Batch Permissions',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drop(String value, List<String> items, ValueChanged<String> onCh) {
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
              onCh(v);
              setState(() => _page = 1);
            }
          },
        ),
      ),
    );
  }

  // ---------------- Table ----------------

  Widget _tableCard() {
    final rows = _filtered;
    final allChecked =
        rows.isNotEmpty && rows.every((u) => _checked.contains(u.sis));

    return AdminCard(
      padding: const EdgeInsets.all(0),
      child: LayoutBuilder(
        builder: (context, box) {
          final roomy = box.maxWidth >= 620;
          return Column(
            children: [
              if (roomy)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: allChecked,
                          activeColor: AdminColors.indigo,
                          onChanged: (v) => setState(() {
                            for (final u in rows) {
                              if (v == true) {
                                _checked.add(u.sis);
                              } else {
                                _checked.remove(u.sis);
                              }
                            }
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(flex: 4, child: _th('USER IDENTITY')),
                      Expanded(flex: 4, child: _th('EMAIL & SIS ID')),
                      Expanded(flex: 2, child: _th('ROLE')),
                      Expanded(flex: 3, child: _th('STATUS')),
                    ],
                  ),
                ),
              const Divider(height: 1, color: AdminColors.line),
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text('No users match these filters',
                      style: GoogleFonts.inter(color: AppColors.textGrey)),
                )
              else
                for (final u in rows) _row(u, roomy),
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

  Widget _avatar(_User u, {double size = 40}) {
    final c = u.isTeacher ? AdminColors.teal : AdminColors.indigo;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: Text(
        u.initials,
        style: GoogleFonts.manrope(
          fontSize: size * 0.34,
          fontWeight: FontWeight.w800,
          color: c,
        ),
      ),
    );
  }

  Widget _roleTag(_User u) => AdminTag(
    u.role,
    bg: u.isTeacher ? AppColors.mintBright : AppColors.chip,
    fg: u.isTeacher ? AppColors.teal : AppColors.primary,
  );

  Widget _statusTag(_User u) {
    switch (u.status) {
      case 'Active':
        return const AdminTag('● Active',
            bg: AppColors.mintBright, fg: AppColors.teal);
      case 'Disabled':
        return const AdminTag('● Disabled',
            bg: Color(0xFFFFE3E3), fg: AdminColors.red);
      default:
        return const AdminTag('● Pending Verification',
            bg: Color(0xFFFFE9CF), fg: Color(0xFF8A4B00));
    }
  }

  Widget _row(_User u, bool roomy) {
    final isSel = identical(u, _selected);
    final checked = _checked.contains(u.sis);

    final check = SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: checked,
        activeColor: AdminColors.indigo,
        onChanged: (v) => setState(() {
          if (v == true) {
            _checked.add(u.sis);
          } else {
            _checked.remove(u.sis);
          }
        }),
      ),
    );

    final identity = Row(
      children: [
        _avatar(u),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(u.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              Text(u.sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textGrey)),
            ],
          ),
        ),
      ],
    );

    final emailCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(u.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark)),
        Text('SIS: ${u.sis}',
            style:
            GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey)),
      ],
    );

    return InkWell(
      onTap: () => setState(() => _selected = u),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSel ? AdminColors.soft : Colors.transparent,
          border: const Border(bottom: BorderSide(color: AdminColors.line)),
        ),
        child: roomy
            ? Row(
          children: [
            check,
            const SizedBox(width: 12),
            Expanded(flex: 4, child: identity),
            Expanded(flex: 4, child: emailCol),
            Expanded(
                flex: 2,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: _roleTag(u))),
            Expanded(
                flex: 3,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: _statusTag(u))),
          ],
        )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            check,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  identity,
                  const SizedBox(height: 8),
                  emailCol,
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [_roleTag(u), _statusTag(u)],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pagination(int shown) {
    Widget pageBtn(String label, {int? page, bool enabled = true}) {
      final active = page != null && page == _page;
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: enabled && page != null ? () => setState(() => _page = page) : null,
        child: Container(
          constraints: const BoxConstraints(minWidth: 36),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AdminColors.indigo : AppColors.chip,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: active
                  ? Colors.white
                  : (enabled ? AppColors.textDark : AppColors.textGrey),
            ),
          ),
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
          Text(
            shown == 0
                ? 'Showing 0 users'
                : 'Showing 1 to $shown of 24,850 users',
            style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textGrey),
          ),
          Wrap(
            spacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              pageBtn('Previous',
                  page: _page > 1 ? _page - 1 : null, enabled: _page > 1),
              pageBtn('1', page: 1),
              pageBtn('2', page: 2),
              pageBtn('3', page: 3),
              Text('...',
                  style: GoogleFonts.inter(color: AppColors.textGrey)),
              pageBtn('3,550', page: 3550),
              pageBtn('Next', page: _page < 3550 ? _page + 1 : null),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Inspector ----------------

  Widget _inspector() {
    final u = _selected;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('USER QUICK INSPECTOR',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: AppColors.textGrey)),
              ),
              AdminTag(u.isTeacher ? 'Verified Faculty' : 'Verified Student'),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _avatar(u, size: 64),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.name,
                        style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    Text(u.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontSize: 12.5, color: AppColors.textDark)),
                    Text('SIS: ${u.sis}',
                        style: GoogleFonts.inter(
                            fontSize: 11.5, color: AppColors.textGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
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
                      child: Text('COGNITIVE VELOCITY',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: AppColors.textGrey)),
                    ),
                    const Icon(Icons.bolt,
                        size: 14, color: AdminColors.indigo),
                    Text(' Peak Band',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AdminColors.indigo)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: _metric(
                            u.isTeacher ? 'Efficacy Index' : 'Mastery Index',
                            u.m1)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _metric(
                            u.isTeacher ? 'Cohort Retention' : 'BKT Confidence',
                            u.m2)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('ACTIVE CURRICULA',
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColors.textGrey)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final c in u.courses) AdminTag(c)],
          ),
          const SizedBox(height: 16),
          const Divider(color: AdminColors.line),
          const SizedBox(height: 8),
          Text('GOVERNANCE CONTROLS',
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColors.textGrey)),
          const SizedBox(height: 10),
          _control(Icons.history, 'Reset Passphrase & MFA',
              'Reset sent to ${u.email}'),
          const SizedBox(height: 8),
          _control(Icons.shield_outlined, 'Audit Access & Prompt Logs',
              'Opening audit logs for ${u.name}'),
          const SizedBox(height: 8),
          _control(Icons.block, 'Suspend Active Session',
              'Session suspended for ${u.name}',
              danger: true),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.teal)),
        ],
      ),
    );
  }

  Widget _control(IconData icon, String label, String message,
      {bool danger = false}) {
    final fg = danger ? AdminColors.red : AppColors.textDark;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _snack(message),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: danger ? const Color(0xFFFFF0F0) : AdminColors.soft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w500, color: fg)),
            ),
            Icon(Icons.chevron_right, size: 18, color: fg),
          ],
        ),
      ),
    );
  }

  Widget _insight() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
              const SizedBox(width: 8),
              Text('AI DIAGNOSTIC INSIGHT',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.teal)),
            ],
          ),
          const SizedBox(height: 10),
          Text('Adaptive Socratic Calibration',
              style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 8),
          Text(
            'User exhibits a 94.2% conceptual retention rate across recursive algorithm tree proofs. Recommendation: Upgrade diagnostic threshold to Level 5 Autonomous Proof Evaluation.',
            style: GoogleFonts.inter(
                fontSize: 13, height: 1.45, color: AppColors.textGrey),
          ),
          const SizedBox(height: 14),
          AdminButton('Apply Calibration  →',
              onTap: () => _snack('Calibration applied to ${_selected.name}')),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Widget footer;

  const _Stat(this.label, this.value, this.icon, this.color, this.footer);

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
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
            ],
          ),
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 12),
          footer,
        ],
      ),
    );
  }
}