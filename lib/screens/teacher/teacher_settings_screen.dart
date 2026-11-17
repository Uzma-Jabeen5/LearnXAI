import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class TeacherSettingsScreen extends StatefulWidget {
  const TeacherSettingsScreen({super.key});

  @override
  State<TeacherSettingsScreen> createState() => _TeacherSettingsScreenState();
}

class _TeacherSettingsScreenState extends State<TeacherSettingsScreen> {
  static const _amber = Color(0xFF8A4B00);

  int _nav = 2;
  String _depth = 'Detailed Diagnostic';
  bool _bottleneck = true;
  bool _hints = true;
  bool _radar = true;
  String _cadence = 'Daily Digest with Immediate High-Friction';
  bool _proctor = true;
  bool _docker = true;
  bool _digest = true;

  static const _cadences = [
    'Daily Digest with Immediate High-Friction',
    'Immediate (every event)',
    'Weekly Summary',
    'Manual only',
  ];

  void _reset() {
    setState(() {
      _depth = 'Detailed Diagnostic';
      _bottleneck = true;
      _hints = true;
      _radar = true;
      _cadence = _cadences.first;
      _proctor = true;
      _docker = true;
      _digest = true;
    });
    _snack('Changes discarded');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  ButtonStyle _btn(Color bg, Color fg) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
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

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/settings',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final navW = wide ? inner * 0.27 : inner;
          final mainW = wide ? inner - navW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INTELLIGENCE & RECORDS  >  System & Account Configuration',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey),
                ),
                const SizedBox(height: 8),
                _header(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SizedBox(width: navW, child: _hierarchy()),
                    SizedBox(
                      width: mainW,
                      child: Column(
                        children: [
                          _engine(),
                          const SizedBox(height: 16),
                          _dispatch(),
                          const SizedBox(height: 16),
                          _security(),
                          const SizedBox(height: 16),
                          _saveBar(),
                        ],
                      ),
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

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Faculty Cockpit Settings & Preferences',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage institutional profile security, Socratic AI explanation parameters, notification dispatch rules, and ABET privacy protocols.',
          style: GoogleFonts.inter(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Pill('ABET Syllabus v2.4 Aligned',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 11),
            Pill('SSO Active',
                bg: AppColors.mint, fg: AppColors.teal, fontSize: 11),
          ],
        ),
      ],
    );
  }

  // ---------- Settings hierarchy ----------
  Widget _hierarchy() {
    const items = [
      [Icons.manage_accounts_outlined, 'Account & Security', ''],
      [Icons.notifications_none, 'Notification Dispatch', '3 Rules'],
      [Icons.psychology_alt_outlined, 'Socratic AI Engine', 'v4.2'],
      [Icons.fact_check_outlined, 'ABET Accreditation', ''],
      [Icons.hub_outlined, 'Connected LMS & Git', 'Synced'],
      [Icons.shield_outlined, 'Privacy & FERPA Protocol', ''],
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SETTINGS HIERARCHY',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < items.length; i++)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _nav = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: _nav == i
                      ? const Color(0xFFF1F1FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(items[i][0] as IconData,
                        size: 18,
                        color: _nav == i
                            ? AppColors.primary
                            : AppColors.textGrey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        items[i][1] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: _nav == i
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _nav == i
                              ? AppColors.primary
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                    if ((items[i][2] as String).isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Pill(items[i][2] as String,
                          bg: AppColors.mint,
                          fg: AppColors.teal,
                          fontSize: 9),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cohort Nodes Active',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textGrey),
                      ),
                    ),
                    Text(
                      '4 Sections',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.8,
                    minHeight: 5,
                    backgroundColor: AppColors.chip,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'DeepTeach inference load: 14.8 ms/token',
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

  Widget _sectionTitle(IconData icon, String title, String sub,
      {String? pill}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.chip,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 1.4,
                  color: AppColors.textGrey,
                ),
              ),
              if (pill != null) ...[
                const SizedBox(height: 8),
                Pill(pill,
                    bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Socratic AI engine ----------
  Widget _engine() {
    Widget depth(String name, String body, String foot, {String? badge}) {
      final selected = _depth == name;
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _depth = name),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F1FF) : const Color(0xFFF8F9FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primaryLight : AppColors.chip,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (badge != null) ...[
                Pill(badge,
                    bg: AppColors.primary, fg: Colors.white, fontSize: 9),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color: selected
                        ? AppColors.primaryLight
                        : AppColors.textGrey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  height: 1.5,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                foot,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.primary : AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget toggle(IconData icon, String title, String sub, bool value,
        ValueChanged<bool> on) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      height: 1.4,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: value,
              activeColor: AppColors.primaryLight,
              onChanged: (v) => setState(() => on(v)),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.auto_awesome,
            'Socratic AI & Explainability Engine',
            'Calibrate student feedback heuristics and psychometric inference parameters.',
            pill: 'Engine: LearnX-DeepTeach v4.2',
          ),
          const SizedBox(height: 16),
          Text(
            'Faculty AI Reasoning & Explanation Depth',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Determines how the autonomous scaffolding engine surfaces diagnostics in both Faculty Cockpit and Student Sandboxes.',
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 14),
          _grid([
            depth(
                'Basic Heuristics',
                'High-level topic identification, key misconceptions, and summary error trends without step-level log traces.',
                'FAST INFERENCE'),
            depth(
                'Detailed Diagnostic',
                'Full causal root inference, distractor choices log, item discrimination coefficient, and calibrated confidence scores.',
                'Standard for ABET Reporting',
                badge: 'RECOMMENDED'),
            depth(
                'Research Mode',
                'Bayesian Knowledge Tracing (BKT) slip/guess matrices, LaTeX formal proofs, and cognitive load eye-gaze estimates.',
                'HIGH DENSITY'),
          ], minItemWidth: 180),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AUTONOMOUS SCAFFOLDING PERMISSIONS',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 12),
                toggle(
                    Icons.radar,
                    'Real-Time Cognitive Bottleneck Detection',
                    'Flag concepts autonomously when more than 25% of cohort drops below the master threshold during lab work.',
                    _bottleneck,
                        (v) => _bottleneck = v),
                toggle(
                    Icons.lightbulb_outline,
                    'Allow Socratic Hint Scaffolding in Student Sandbox',
                    'Disables code solutions; forces the AI to output question-based prompts to stimulate algorithmic reasoning.',
                    _hints,
                        (v) => _hints = v),
                toggle(
                    Icons.event_busy_outlined,
                    'Automated Workload & Deadline Collision Radar',
                    'Alerts faculty when scheduling tests that coincide with Math or Physics major midterms across departmental sync.',
                    _radar,
                        (v) => _radar = v),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Recommendation Dispatch Cadence',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Interval for autonomous remediation prompts sent to students.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: DropdownButton<String>(
              value: _cadence,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: [
                for (final c in _cadences)
                  DropdownMenuItem(
                    value: c,
                    child: Text(
                      c,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
              ],
              onChanged: (v) => setState(() => _cadence = v ?? _cadence),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Notification & dispatch routing ----------
  Widget _dispatch() {
    Widget rule(IconData icon, String title, String sub, String channel,
        bool value, ValueChanged<bool> on) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      height: 1.4,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Pill(channel,
                      bg: Colors.white, fg: AppColors.primary, fontSize: 10),
                ],
              ),
            ),
            Checkbox(
              value: value,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => on(v ?? false)),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.alt_route,
            'Notification & Dispatch Routing',
            'Define priority escalation channels for critical academic telemetry',
          ),
          const SizedBox(height: 16),
          rule(
              Icons.gpp_maybe_outlined,
              'Urgent Proctor & Integrity Alerts',
              'Flagged multi-device logins during timed midterm evaluations',
              'Instant SMS + Browser Push',
              _proctor,
                  (v) => _proctor = v),
          rule(
              Icons.terminal,
              'Autograder Docker Container Exceptions',
              'Infinite loop timeouts, memory leak spikes, or runtime sandbox crashes',
              'Cockpit Toast + Slack Webhook',
              _docker,
                  (v) => _docker = v),
          rule(
              Icons.summarize_outlined,
              'Daily Cohort Knowledge Tracing Digest',
              'Compiled mastery statistics, top misunderstood questions, and attendance',
              'Email at 07:00 AM EST',
              _digest,
                  (v) => _digest = v),
        ],
      ),
    );
  }

  // ---------- 2FA + sessions ----------
  Widget _security() {
    Widget row(IconData icon, String title, String sub, String action,
        {Color? actionColor}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    sub,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _snack('$action: $title'),
              child: Text(
                action,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: actionColor ?? AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final auth = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.key_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Authentication & 2FA',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Pill('Active',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Enforced hardware token security for grading modifications and student record exports.',
            style: GoogleFonts.inter(
              fontSize: 11,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 12),
          row(Icons.usb, 'YubiKey 5C NFC', 'Last used 22m ago', 'Manage'),
          row(Icons.verified_user_outlined, 'Institutional Authenticator',
              'Backup algorithm RFC-6238', 'Revoke',
              actionColor: const Color(0xFFB3261E)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Next credential review: Oct 2025',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textGrey),
                ),
              ),
              TextButton(
                onPressed: () => _snack('Change master passphrase'),
                child: Text(
                  'Change Master Passphrase',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final sessions = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sync_alt, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Active Session & Sync',
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
          Text(
            'IP 192.241.142.88',
            style: GoogleFonts.inter(fontSize: 10, color: AppColors.textGrey),
          ),
          const SizedBox(height: 6),
          Text(
            'Synchronized external institutional repositories and current connection state.',
            style: GoogleFonts.inter(
              fontSize: 11,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 12),
          row(Icons.apartment_outlined, 'University Faculty VPN Gateway',
              'Encrypted TLS 1.3 • Active Now', 'Active'),
          row(Icons.code, 'GitHub Classroom', '@CS-Faculty-Cohort-2025',
              'Linked'),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Canvas LMS v9.1: Connected',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textGrey),
                ),
              ),
              TextButton(
                onPressed: () => _snack('Other sessions terminated'),
                child: Text(
                  'Terminate Other Sessions',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB3261E),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return _grid([auth, sessions], minItemWidth: 300);
  }

  // ---------- Save bar ----------
  Widget _saveBar() {
    return AppCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sync, size: 18, color: AppColors.teal),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Last synchronized with Institutional Active Directory 14 mins ago',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      height: 1.4,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: _reset,
                style: _btn(AppColors.chip, AppColors.textDark),
                child: const Text('Discard Changes'),
              ),
              ElevatedButton.icon(
                onPressed: () => _snack('Configuration saved'),
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Save Configuration'),
                style: _btn(AppColors.primaryLight, Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}