import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class _Rule {
  final String title;
  final String desc;
  final bool teacher;
  final bool student;
  final String? studentTag;

  const _Rule(this.title, this.desc, this.teacher, this.student,
      {this.studentTag});
}

class _Section {
  final String title;
  final IconData icon;
  final List<_Rule> rules;

  const _Section(this.title, this.icon, this.rules);
}

const _sections = [
  _Section('1. ACADEMIC OPERATIONS & USER GOVERNANCE', Icons.groups_outlined, [
    _Rule('Manage User Accounts & SIS Rosters',
        'Full provision, lifecycle decommission, and roster federation control.',
        false, false),
    _Rule('Create & Modify Curricula / Syllabi',
        'Author module taxonomies, prerequisite graphs, and learning milestones.',
        true, false),
    _Rule('Grade Assessments & Release Feedback',
        'Override autograded scoring metrics and publish analytical critiques.',
        true, false),
    _Rule('Enforce Examination ProctorGuard Protocols',
        'Toggle dual-camera telemetry, keystroke verification, and browser locks.',
        true, false),
  ]),
  _Section('2. EXPLAINABLE AI & SOCRATIC TELEMETRY', Icons.psychology_outlined, [
    _Rule('Calibrate Socratic Engine Prompt Scaffolding',
        'Define system role guidelines, hint tiers, and response temperature limits.',
        true, false),
    _Rule('Access Granular Cognitive Friction Traces',
        'Real-time attention drift telemetry, conceptual impasse graphs, and dwell logs.',
        true, false,
        studentTag: 'Self Only'),
    _Rule('Modify Bayesian Knowledge Tracing (BKT) Priors',
        'Adjust default slip, guess, transit, and prior mastery probability distributions.',
        false, false),
    _Rule('Trigger Cohort Automated Micro-Drills',
        'Dispatch adaptive push questions based on collective weak-topic clusters.',
        true, false),
  ]),
  _Section('3. ACCREDITATION & INSTITUTIONAL REPORTING',
      Icons.workspace_premium_outlined, [
        _Rule('Generate Official ABET Criterion Dossiers',
            'Compile longitudinal learning outcome rubrics and continuous improvement artifacts.',
            true, false),
        _Rule('Export Cryptographically Stamped Transcripts',
            'Sign official micro-credentials and sovereign skill credentials with root keys.',
            false, false),
        _Rule('Inspect Raw Autograder Execution Logs',
            'Access sandboxed Docker runtimes, stderr leaks, and memory consumption traces.',
            true, false,
            studentTag: 'Sanitized'),
        _Rule('Modify Platform Security & RBAC Policies',
            'Update active permission matrices, authorization scopes, and API key limits.',
            false, false),
      ]),
];

class AdminPermissionsScreen extends StatefulWidget {
  const AdminPermissionsScreen({super.key});

  @override
  State<AdminPermissionsScreen> createState() =>
      _AdminPermissionsScreenState();
}

class _AdminPermissionsScreenState extends State<AdminPermissionsScreen> {
  late List<bool> _teacher;
  late List<bool> _student;
  int _tier = 0;
  bool _lockdown = false;

  static const _tiers = [
    ['Administrator', '48/48', 'admin'],
    ['Teacher / Faculty', '34/48', 'teacher'],
    ['Student / Learner', '16/48', 'student'],
  ];

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    final all = [for (final s in _sections) ...s.rules];
    _teacher = [for (final r in all) r.teacher];
    _student = [for (final r in all) r.student];
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-permissions',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Permissions & Role-Based Access Control',
              tag: 'Enterprise Governance Core',
              subtitle:
              'Configure institutional roles, granular feature privileges, cognitive data visibility, and API governance policies across the LearnXAI ecosystem.',
              actions: [
                AdminButton('Reset to Defaults',
                    icon: Icons.restart_alt,
                    onTap: () {
                      setState(_reset);
                      _snack('Permissions reset to defaults');
                    }),
                AdminButton('Save Changes',
                    icon: Icons.check_circle_outline,
                    primary: true,
                    onTap: () => _snack('Permission policy saved')),
              ],
            ),
            const SizedBox(height: 20),
            _stats(),
            const SizedBox(height: 20),
            _tierBar(),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: _matrix(),
              side: Column(
                children: [
                  _posture(),
                  const SizedBox(height: 20),
                  _audit(),
                  const SizedBox(height: 20),
                  _emergency(),
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
        _Stat('Governed Roles', '3 Master Roles', 'Active',
            Icons.verified_user_outlined, AdminColors.indigo,
            'Superadmin, Faculty / Instructor, Student'),
        _Stat('Active Privilege Rules', '48 Rules', 'Enforced',
            Icons.vpn_key_outlined, AdminColors.teal,
            'Fine-grained across 8 core subsystems'),
        _Stat('Protected Endpoints', '14 Subsystems', 'Secured',
            Icons.lock_outline, AdminColors.indigo,
            'Restricted FERPA & ABET engines'),
        _Stat('Last Policy Audit', '2h ago', 'Audited',
            Icons.history_toggle_off, AdminColors.brown,
            'Modified by Enterprise Superuser (Dr. Root)'),
      ],
    );
  }

  // ---------------- Tier bar ----------------

  Widget _tierBar() {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 14,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('INSPECT ROLE TIER:',
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.textGrey)),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (var i = 0; i < _tiers.length; i++)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _tier = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _tier == i ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_tiers[i][0],
                              style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: _tier == i
                                      ? AdminColors.indigo
                                      : AppColors.textDark)),
                          const SizedBox(width: 8),
                          AdminTag(_tiers[i][1], fontSize: 10),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user_outlined,
                  size: 18, color: AppColors.teal),
              const SizedBox(width: 6),
              Text('1,248 Faculty Accounts Governed',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textDark)),
              const SizedBox(width: 10),
              Text('FERPA v2.4\nCompliant',
                  style: GoogleFonts.inter(
                      fontSize: 10.5, color: AppColors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Matrix ----------------

  Widget _matrix() {
    var index = 0;
    final children = <Widget>[
      _matrixHeader(),
      const Divider(height: 1, color: AdminColors.line),
    ];
    for (final s in _sections) {
      children.add(_sectionRow(s));
      for (final r in s.rules) {
        children.add(_ruleRow(r, index));
        index++;
      }
    }
    children.add(Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text('Showing 12 of 48 granular policy definitions',
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textGrey)),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _snack('All 48 rules expanded'),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Expand All Rules (48)',
                  style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    ));
    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }

  Widget _matrixHeader() {
    Widget col(String label, IconData icon, int tier) {
      final on = _tier == tier;
      return SizedBox(
        width: 64,
        child: Column(
          children: [
            Icon(icon,
                size: 16,
                color: on ? AdminColors.indigo : AppColors.textGrey),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: on ? AdminColors.indigo : AppColors.textGrey)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text('SUBSYSTEM & PRIVILEGE RULE',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.textGrey)),
          ),
          col('ADMIN', Icons.shield_outlined, 0),
          col('TEACHER', Icons.school_outlined, 1),
          col('STUDENT', Icons.person_outline, 2),
        ],
      ),
    );
  }

  Widget _sectionRow(_Section s) {
    return Container(
      width: double.infinity,
      color: AdminColors.soft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(s.icon, size: 16, color: AdminColors.indigo),
          const SizedBox(width: 8),
          Expanded(
            child: Text(s.title,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: AppColors.textDark)),
          ),
        ],
      ),
    );
  }

  Widget _ruleRow(_Rule r, int i) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.title,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 3),
                  Text(r.desc,
                      style: GoogleFonts.inter(
                          fontSize: 11.5,
                          height: 1.35,
                          color: AppColors.textGrey)),
                ],
              ),
            ),
          ),
          _cell(on: true, locked: true),
          _cell(
            on: _teacher[i],
            onTap: () => setState(() => _teacher[i] = !_teacher[i]),
          ),
          r.studentTag != null
              ? SizedBox(
            width: 64,
            child: Center(
              child: AdminTag(r.studentTag!,
                  bg: const Color(0xFFFFE9CF),
                  fg: const Color(0xFF8A4B00),
                  fontSize: 9.5),
            ),
          )
              : _cell(
            on: _student[i],
            onTap: () => setState(() => _student[i] = !_student[i]),
          ),
        ],
      ),
    );
  }

  Widget _cell({required bool on, bool locked = false, VoidCallback? onTap}) {
    return SizedBox(
      width: 64,
      child: Center(
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: locked ? null : onTap,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: on ? AdminColors.indigo : AppColors.chip,
              shape: BoxShape.circle,
            ),
            child: Icon(on ? Icons.check : Icons.close,
                size: 15, color: on ? Colors.white : AppColors.textGrey),
          ),
        ),
      ),
    );
  }

  // ---------------- Side cards ----------------

  Widget _posture() {
    const items = [
      [
        'ABET 2023-2029 Standards',
        'Criterion 3 & 5 Automated',
        'Pass',
        Icons.verified_outlined
      ],
      [
        'FERPA & GDPR Data Privacy',
        'Zero telemetry leak to LLM APIs',
        'Locked',
        Icons.privacy_tip_outlined
      ],
      [
        'Institutional 2FA State',
        '100% Admin & Faculty coverage',
        '100%',
        Icons.phonelink_lock_outlined
      ],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Security Posture',
                    style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              const AdminTag('99.8% Healthy',
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 8),
          Text(
              'Strict Principle of Least Privilege (PoLP) enforced across institutional tenancy.',
              style: GoogleFonts.inter(
                  fontSize: 12.5, height: 1.4, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          for (final it in items)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(it[3] as IconData, size: 20, color: AdminColors.indigo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it[0] as String,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        Text(it[1] as String,
                            style: GoogleFonts.inter(
                                fontSize: 11, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AdminTag(it[2] as String,
                      bg: AppColors.chip, fg: AdminColors.indigo, fontSize: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _audit() {
    const items = [
      [
        'Superuser elevated CS-301 TA Grader Node',
        'Granted rubric calibration privileges to Dr. Sara Ahmed',
        '1h ago • IP: 192.168.1.1',
      ],
      [
        'Faculty Group Policy Updated',
        'Enabled: Export Raw Autograder Sandbox Traces',
        '4h ago • Automated Policy Sync',
      ],
      [
        'Student Role Scope Constrained',
        'Restricted cross-cohort cognitive friction benchmark reads',
        'Yesterday • Platform Core v4.2',
      ],
    ];
    const colors = [AdminColors.indigo, AdminColors.teal, Color(0xFFB8BAD6)];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined,
                  size: 20, color: AdminColors.indigo),
              const SizedBox(width: 8),
              Text('Recent Audit Trail',
                  style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              const Spacer(),
              Text('LIVE FEED',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle, size: 10, color: colors[i]),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items[i][0],
                            style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Text(items[i][1],
                            style: GoogleFonts.inter(
                                fontSize: 11.5,
                                height: 1.35,
                                color: AppColors.textGrey)),
                        const SizedBox(height: 2),
                        Text(items[i][2],
                            style: GoogleFonts.inter(
                                fontSize: 10.5, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          InkWell(
            onTap: () => Navigator.pushReplacementNamed(
                context, '/admin-logs'),
            child: Text('View Complete Immutable Ledger →',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.indigo)),
          ),
        ],
      ),
    );
  }

  Widget _emergency() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gpp_maybe_outlined,
                  size: 20, color: AdminColors.red),
              const SizedBox(width: 8),
              Text('Emergency Governance',
                  style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4F2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Read-Only Lockdown',
                          style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AdminColors.red)),
                    ),
                    Switch(
                      value: _lockdown,
                      activeThumbColor: AdminColors.red,
                      onChanged: (v) {
                        setState(() => _lockdown = v);
                        _snack(v
                            ? 'Read-only lockdown enabled'
                            : 'Read-only lockdown disabled');
                      },
                    ),
                  ],
                ),
                Text(
                    'Immediately freeze all privilege mutations. Restricts all non-root users from altering exams or publishing score adjustments.',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.4,
                        color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _snack('Cryptographic signatures verified'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fingerprint,
                      size: 18, color: AppColors.textGrey),
                  const SizedBox(width: 8),
                  Text('Verify Cryptographic Signatures',
                      style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                ],
              ),
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

  const _Stat(this.label, this.value, this.tag, this.icon, this.color,
      this.sub);

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
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 4),
          AdminTag(tag,
              bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
          const SizedBox(height: 8),
          Text(sub,
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.35, color: AppColors.textGrey)),
        ],
      ),
    );
  }
}