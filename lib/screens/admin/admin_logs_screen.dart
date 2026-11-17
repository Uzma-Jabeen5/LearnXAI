import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class _Log {
  final String time;
  final String initials;
  final Color color;
  final String name;
  final String role;
  final String action;
  final String target;
  final String module;
  final String kind;
  final String status;
  final String logId;
  final String actor;
  final String mode;
  final String resource;
  final List<List<String>> diff;

  const _Log({
    required this.time,
    required this.initials,
    required this.color,
    required this.name,
    required this.role,
    required this.action,
    required this.target,
    required this.module,
    required this.kind,
    required this.status,
    required this.logId,
    required this.actor,
    required this.mode,
    required this.resource,
    required this.diff,
  });

  bool get failed => status == 'Failed';
}

const _defaultDiff = [
  [' ', '"module": "ai_socratic_engine",'],
  [' ', '"course_id": "CS-301",'],
  ['-', '"scaffold_tier": "introductory",'],
  ['+', '"scaffold_tier": "academic_algorithmic",'],
  [' ', '"confidence_floor": 0.88,'],
  ['+', '"hallucination_guard": "strict_grounded",'],
  [' ', '"updated_by": "ahmed.khan@dept.ac.edu"'],
];

const _logs = [
  _Log(
    time: 'Oct 25, 2025 • 14:28:11',
    initials: 'AK',
    color: AdminColors.indigo,
    name: 'Dr. Ahmed Khan',
    role: 'Faculty Lead',
    action: 'AI Socratic Prompt Calibration',
    target: 'CS-301 Algorithm Scaffolding (Tier 2)',
    module: 'AI Engine',
    kind: 'Config Change',
    status: 'Success',
    logId: 'LOG-94821',
    actor: 'Dr. Ahmed Khan (Lead)',
    mode: 'JWT OAuth2 + MultiFactor',
    resource: 'cs301_scaffold_cfg_v4',
    diff: _defaultDiff,
  ),
  _Log(
    time: 'Oct 25, 2025 • 14:24:02',
    initials: 'SU',
    color: Color(0xFF1E1B4B),
    name: 'admin@learnx.internal',
    role: 'Root Superuser',
    action: 'RBAC Policy Elevation',
    target: 'CS-301 TA Grader Scope: Granted',
    module: 'RBAC',
    kind: 'Policy',
    status: 'Success',
    logId: 'LOG-94820',
    actor: 'admin@learnx.internal (Root)',
    mode: 'Hardware Key + MFA',
    resource: 'rbac_ta_grader_scope',
    diff: [
      [' ', '"role": "teaching_assistant",'],
      [' ', '"course_id": "CS-301",'],
      ['-', '"grader_scope": "read_only",'],
      ['+', '"grader_scope": "rubric_calibration",'],
      [' ', '"updated_by": "admin@learnx.internal"'],
    ],
  ),
  _Log(
    time: 'Oct 25, 2025 • 14:19:48',
    initials: 'DM',
    color: Color(0xFF6D6FB8),
    name: 'Daemon AutoProvision',
    role: 'Automated Bot',
    action: 'Batch SIS Provisioning Sync',
    target: 'Synchronized 142 student profiles',
    module: 'Provisioning',
    kind: 'Sync',
    status: 'Success',
    logId: 'LOG-94819',
    actor: 'Daemon AutoProvision (Bot)',
    mode: 'Service Account Token',
    resource: 'sis_batch_2025_10_25',
    diff: [
      [' ', '"source": "university_sis",'],
      ['-', '"profiles_synced": 0,'],
      ['+', '"profiles_synced": 142,'],
      [' ', '"updated_by": "daemon.autoprovision"'],
    ],
  ),
  _Log(
    time: 'Oct 25, 2025 • 14:15:30',
    initials: '!',
    color: Color(0xFFB3261E),
    name: 'guest.secops@ext',
    role: 'Unverified Actor',
    action: 'Failed Superuser Auth: Rate Limit',
    target: '5 consecutive invalid MFA challenges',
    module: 'Auth',
    kind: 'Auth Failure',
    status: 'Failed',
    logId: 'LOG-94818',
    actor: 'guest.secops@ext (Unverified)',
    mode: 'Password + Failed MFA',
    resource: 'superuser_auth_gate',
    diff: [
      [' ', '"endpoint": "/auth/superuser",'],
      ['-', '"attempt_state": "open",'],
      ['+', '"attempt_state": "rate_limited",'],
      ['+', '"failed_mfa_challenges": 5,'],
      [' ', '"source_ip": "203.0.113.42"'],
    ],
  ),
  _Log(
    time: 'Oct 25, 2025 • 14:11:55',
    initials: 'EN',
    color: AdminColors.teal,
    name: 'Elena Rostova',
    role: 'ABET Compliance Off.',
    action: 'Export Cryptographic Dossier',
    target: 'ABET Audit Archive 2024-Q3.tar.gz',
    module: 'Compliance',
    kind: 'Export',
    status: 'Success',
    logId: 'LOG-94817',
    actor: 'Elena Rostova (Compliance)',
    mode: 'SSO + MultiFactor',
    resource: 'abet_audit_2024_q3',
    diff: [
      [' ', '"archive": "ABET_Audit_2024-Q3.tar.gz",'],
      ['+', '"signed": true,'],
      ['+', '"signature": "sha256:e3b0c442..."'],
    ],
  ),
  _Log(
    time: 'Oct 25, 2025 • 14:08:12',
    initials: 'DK',
    color: Color(0xFFF59E0B),
    name: 'Docker Daemon v24',
    role: 'Worker Node 04',
    action: 'Sandbox Invoked: CS-202',
    target: 'Isolated LLVM memory check (Exec 140ms)',
    module: 'Sandbox',
    kind: 'Execution',
    status: 'Success',
    logId: 'LOG-94816',
    actor: 'Docker Daemon v24 (Worker 04)',
    mode: 'Internal Mesh Token',
    resource: 'sandbox_cs202_run',
    diff: [
      [' ', '"runtime": "llvm-17",'],
      [' ', '"memory_cap_mb": 512,'],
      ['+', '"exit_code": 0,'],
      ['+', '"exec_ms": 140'],
    ],
  ),
  _Log(
    time: 'Oct 25, 2025 • 14:02:40',
    initials: 'MS',
    color: Color(0xFF6D6FB8),
    name: 'Marcus Sterling',
    role: 'Teaching Assistant',
    action: 'Grading Override Threshold Shift',
    target: 'Confidence delta > 18% flagged for review',
    module: 'Grading',
    kind: 'Config Change',
    status: 'Warning',
    logId: 'LOG-94815',
    actor: 'Marcus Sterling (TA)',
    mode: 'JWT OAuth2',
    resource: 'grading_override_threshold',
    diff: [
      [' ', '"course_id": "CS-402",'],
      ['-', '"override_threshold": 0.10,'],
      ['+', '"override_threshold": 0.18,'],
      ['+', '"flag_for_review": true'],
    ],
  ),
];

class AdminLogsScreen extends StatefulWidget {
  const AdminLogsScreen({super.key});

  @override
  State<AdminLogsScreen> createState() => _AdminLogsScreenState();
}

class _AdminLogsScreenState extends State<AdminLogsScreen> {
  static const _modules = [
    'All Modules',
    'AI Engine',
    'RBAC',
    'Provisioning',
    'Auth',
    'Compliance',
    'Sandbox',
    'Grading',
  ];
  static const _actions = [
    'All Actions',
    'Config Change',
    'Policy',
    'Sync',
    'Auth Failure',
    'Export',
    'Execution',
  ];
  static const _statuses = ['All Statuses', 'Success', 'Failed', 'Warning'];
  static const _ranges = ['Last 24 Hours', 'Last 7 Days', 'Last 30 Days'];

  String _query = '';
  String _module = _modules.first;
  String _action = _actions.first;
  String _status = _statuses.first;
  String _range = _ranges[1];
  List<String> _chips = [
    'Environment: Production Cluster-01',
    'Compliance: FERPA & ABET Tier 1',
  ];
  int _page = 1;
  bool _live = true;
  _Log _selected = _logs.first;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_Log> get _filtered {
    return _logs.where((l) {
      final q = _query.trim().toLowerCase();
      final okQ = q.isEmpty ||
          l.name.toLowerCase().contains(q) ||
          l.action.toLowerCase().contains(q) ||
          l.target.toLowerCase().contains(q) ||
          l.logId.toLowerCase().contains(q);
      final okM = _module == _modules.first || l.module == _module;
      final okA = _action == _actions.first || l.kind == _action;
      final okS = _status == _statuses.first || l.status == _status;
      return okQ && okM && okA && okS;
    }).toList();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _resetFilters() {
    setState(() {
      _query = '';
      _searchCtrl.clear();
      _module = _modules.first;
      _action = _actions.first;
      _status = _statuses.first;
      _range = _ranges[1];
      _chips = [];
      _page = 1;
    });
  }

  String _traceJson(_Log l) {
    final body = l.diff
        .where((d) => d[0] != '-')
        .map((d) => '  ${d[1]}')
        .join('\n');
    return '{\n  "log_id": "${l.logId}",\n  "timestamp": "${l.time}",\n  "actor": "${l.actor}",\n  "resource": "${l.resource}",\n  "diff": {\n$body\n  }\n}';
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-logs',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'System Logs & Security Audit Trail',
              subtitle:
              'Monitor real-time platform operations, privileged authorizations, autograder sandboxes, and immutable audit logs.',
              actions: [
                AdminButton('Export Logs (CSV / JSON)',
                    icon: Icons.download_outlined,
                    onTap: () => _snack('Log export started')),
                AdminButton('Audit Filter Settings',
                    icon: Icons.tune,
                    primary: true,
                    onTap: () => _snack('Audit filter settings coming soon')),
              ],
            ),
            const SizedBox(height: 20),
            const AdminGrid(
              minItemWidth: 200,
              gap: 14,
              children: [
                _Stat('Total Recorded Events', '184,920',
                    Icons.show_chart_rounded, AdminColors.indigo,
                    'Captured across all modules', '+12.4%'),
                _Stat('Successful Operations', '99.84%',
                    Icons.check_circle_outline, AdminColors.teal,
                    '184,624 nominal events', 'Healthy'),
                _Stat('Security & Auth Events', '296 Flagged',
                    Icons.shield_outlined, AdminColors.brown,
                    'Privilege shifts & auth checks', '0 Breaches',
                    tagBg: Color(0xFFFFE9CF), tagFg: Color(0xFF8A4B00)),
                _Stat('Latest Sync Activity', '14s ago', Icons.sync,
                    AdminColors.indigo, 'Kafka event broker cluster', 'Live'),
              ],
            ),
            const SizedBox(height: 20),
            _filters(),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: _feed(),
              side: Column(
                children: [
                  _trace(),
                  const SizedBox(height: 20),
                  _ingestion(),
                ],
              ),
            ),
          ],
        ),
      ),
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
            minItemWidth: 160,
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
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() {
                          _query = v;
                          _page = 1;
                        }),
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'Search by user email, IP address...',
                          hintStyle: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.textGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _drop(_module, _modules, (v) => _module = v),
              _drop(_action, _actions, (v) => _action = v),
              _drop(_status, _statuses, (v) => _status = v),
              _drop(_range, _ranges, (v) => _range = v),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Active Filters:',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textGrey)),
              for (final c in _chips)
                Container(
                  padding:
                  const EdgeInsets.only(left: 12, top: 6, bottom: 6, right: 6),
                  decoration: BoxDecoration(
                    color: AppColors.chip,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c,
                          style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark)),
                      const SizedBox(width: 4),
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => setState(() => _chips.remove(c)),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.close,
                              size: 14, color: AdminColors.indigo),
                        ),
                      ),
                    ],
                  ),
                ),
              InkWell(
                onTap: _resetFilters,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  child: Text('Reset Filters',
                      style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                ),
              ),
              AdminButton('Apply Criteria',
                  icon: Icons.filter_alt_outlined,
                  primary: true,
                  onTap: () => _snack('Filter criteria applied')),
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

  // ---------------- Feed ----------------

  Widget _feed() {
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                child: Row(
                  children: [
                    Icon(Icons.circle,
                        size: 10,
                        color: _live ? AppColors.teal : AppColors.textGrey),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text('Real-Time Event Feed',
                          style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                    ),
                    const SizedBox(width: 8),
                    AdminTag(_live ? 'Stream Active' : 'Stream Paused',
                        bg: _live ? AppColors.mintBright : AppColors.chip,
                        fg: _live ? AppColors.teal : AppColors.textGrey,
                        fontSize: 10),
                    const Spacer(),
                    _iconBtn(Icons.refresh, () => _snack('Feed refreshed')),
                    const SizedBox(width: 8),
                    _iconBtn(Icons.view_column_outlined,
                            () => _snack('Column chooser coming soon')),
                  ],
                ),
              ),
              if (roomy)
                Container(
                  color: AdminColors.soft,
                  padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _th('TIMESTAMP (UTC)')),
                      Expanded(flex: 3, child: _th('PRINCIPAL / USER')),
                      Expanded(flex: 4, child: _th('ACTION & TARGET')),
                    ],
                  ),
                ),
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text('No events match these filters',
                      style: GoogleFonts.inter(color: AppColors.textGrey)),
                )
              else
                for (final l in rows) _row(l, roomy),
              _pagination(rows.length),
            ],
          );
        },
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.chip,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
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

  Widget _row(_Log l, bool roomy) {
    final isSel = identical(l, _selected);

    final time = Text(l.time,
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textDark));

    final principal = Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: l.color.withValues(alpha: l.failed ? 1 : 0.18),
            shape: BoxShape.circle,
          ),
          child: Text(l.initials,
              style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: l.failed
                      ? Colors.white
                      : (l.color == const Color(0xFF1E1B4B)
                      ? const Color(0xFF1E1B4B)
                      : l.color))),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              Text(l.role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: l.failed
                          ? AdminColors.red
                          : (l.role == 'Root Superuser'
                          ? AdminColors.indigo
                          : AppColors.textGrey))),
            ],
          ),
        ),
      ],
    );

    final action = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.action,
            style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: l.failed ? AdminColors.red : AppColors.textDark)),
        Text(l.target,
            style:
            GoogleFonts.inter(fontSize: 11.5, color: AppColors.textGrey)),
      ],
    );

    return InkWell(
      onTap: () => setState(() => _selected = l),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: l.failed
              ? const Color(0xFFFFF4F2)
              : (isSel ? AdminColors.soft : Colors.transparent),
          border: Border(
            bottom: const BorderSide(color: AdminColors.line),
            left: BorderSide(
                color: isSel ? AdminColors.indigo : Colors.transparent,
                width: 3),
          ),
        ),
        child: roomy
            ? Row(
          children: [
            Expanded(flex: 3, child: time),
            Expanded(flex: 3, child: principal),
            Expanded(flex: 4, child: action),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            time,
            const SizedBox(height: 8),
            principal,
            const SizedBox(height: 8),
            action,
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
                ? 'Showing 0 audit records'
                : 'Showing 1–$shown of 184,920 audit records',
            style:
            GoogleFonts.inter(fontSize: 12.5, color: AppColors.textGrey),
          ),
          Wrap(
            spacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              btn(
                  Text('‹ Prev',
                      style: GoogleFonts.inter(
                          fontSize: 12.5, fontWeight: FontWeight.w600)),
                  page: _page > 1 ? _page - 1 : null),
              num('1', 1),
              num('2', 2),
              num('3', 3),
              Text('...', style: GoogleFonts.inter(color: AppColors.textGrey)),
              num('2642', 2642),
              btn(
                  Text('Next ›',
                      style: GoogleFonts.inter(
                          fontSize: 12.5, fontWeight: FontWeight.w600)),
                  page: _page < 2642 ? _page + 1 : null),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Trace panel ----------------

  Widget _trace() {
    final l = _selected;
    Widget kv(String k, String v, {Color? c}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(k,
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey)),
          ),
          Expanded(
            child: Text(v,
                textAlign: TextAlign.right,
                style: GoogleFonts.robotoMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: c ?? AppColors.textDark)),
          ),
        ],
      ),
    );

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AdminColors.indigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Event Telemetry Trace',
                    style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              AdminTag(l.logId, fontSize: 10),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                kv('OpenTelemetry Trace:',
                    'trace_${l.logId.replaceAll('LOG-', '')}f92a10b4c'),
                kv('Originating Actor:', l.actor),
                kv('Authorization Mode:', l.mode, c: AdminColors.indigo),
                kv('Target Resource:', l.resource),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text('Context Diff (State Mutation)',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              Text('RFC 6902 Delta',
                  style: GoogleFonts.inter(
                      fontSize: 10.5, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF272B45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _code(' ', '{', null),
                for (final d in l.diff) _code(d[0], d[1], d[0]),
                _code(' ', '}', null),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.mintBright.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_outlined,
                        size: 16, color: AppColors.teal),
                    const SizedBox(width: 6),
                    Text('Cryptographic Ledger Proof',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                    'SHA-256 integrity digest validated against distributed audit chain. Zero tampering detected.',
                    style: GoogleFonts.inter(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.textGrey)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                      'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
                      style: GoogleFonts.robotoMono(
                          fontSize: 10, color: AppColors.textGrey)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    await Clipboard.setData(
                        ClipboardData(text: _traceJson(l)));
                    if (mounted) _snack('Trace JSON copied to clipboard');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.chip,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.copy_outlined,
                            size: 16, color: AppColors.textDark),
                        const SizedBox(width: 6),
                        Text('Copy JSON',
                            style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() => _live = !_live);
                    _snack(_live ? 'Live stream resumed' : 'Live stream paused');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: AdminColors.indigo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_live ? Icons.pause : Icons.play_arrow,
                            size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(_live ? 'Live Stream' : 'Resume Stream',
                            style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
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

  Widget _code(String mark, String text, String? kind) {
    Color? bg;
    Color fg = const Color(0xFFD7D9F2);
    if (kind == '-') {
      bg = const Color(0xFF5A2A35);
      fg = const Color(0xFFFFB4B4);
    } else if (kind == '+') {
      bg = const Color(0xFF1F4D45);
      fg = const Color(0xFF9DF2D8);
    }
    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Text(
        '${mark == ' ' ? '  ' : '$mark '}$text',
        style: GoogleFonts.robotoMono(fontSize: 11, height: 1.5, color: fg),
      ),
    );
  }

  // ---------------- Ingestion ----------------

  Widget _ingestion() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Ingestion Health',
                    style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              const AdminTag('0.4ms Lag',
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text('Broker Throughput',
                    style: GoogleFonts.inter(
                        fontSize: 12.5, color: AppColors.textGrey)),
              ),
              Text('4.8k ops/sec',
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.82,
              minHeight: 6,
              backgroundColor: AppColors.chip,
              color: AdminColors.indigo,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text('Cold Storage Retention',
                    style: GoogleFonts.inter(
                        fontSize: 12.5, color: AppColors.textGrey)),
              ),
              Text('365 Days (Compliant)',
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ],
          ),
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
  final String sub;
  final String tag;
  final Color tagBg;
  final Color tagFg;

  const _Stat(this.label, this.value, this.icon, this.color, this.sub,
      this.tag,
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
                        fontSize: 12, color: AppColors.textGrey)),
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
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(sub,
                  style: GoogleFonts.inter(
                      fontSize: 11.5, color: AppColors.textGrey)),
              AdminTag(tag, bg: tagBg, fg: tagFg, fontSize: 10),
            ],
          ),
        ],
      ),
    );
  }
}