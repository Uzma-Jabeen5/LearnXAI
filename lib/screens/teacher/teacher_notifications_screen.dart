import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Alert {
  final String id;
  final String group; // Today, Yesterday, Earlier This Week
  final String type; // student, autograder, system
  final String tag;
  final Color accent;
  final Color tagBg;
  final Color tagFg;
  final String time;
  final String scope;
  final String title;
  final String body;
  final String foot;
  final String secondary;
  final String? primary;

  const _Alert({
    required this.id,
    required this.group,
    required this.type,
    required this.tag,
    required this.accent,
    required this.tagBg,
    required this.tagFg,
    required this.time,
    required this.scope,
    required this.title,
    required this.body,
    required this.foot,
    required this.secondary,
    this.primary,
  });
}

class TeacherNotificationsScreen extends StatefulWidget {
  const TeacherNotificationsScreen({super.key});

  @override
  State<TeacherNotificationsScreen> createState() =>
      _TeacherNotificationsScreenState();
}

class _TeacherNotificationsScreenState
    extends State<TeacherNotificationsScreen> {
  static const _red = Color(0xFFB3261E);
  static const _amber = Color(0xFF8A4B00);

  String _filter = 'All';
  String _query = '';

  final Set<String> _read = {'a4', 'a5', 'a6'};
  final Set<String> _dismissed = {};

  bool _oom = true;
  bool _drift = true;
  bool _peer = false;

  static const _alerts = [
    _Alert(
      id: 'a1',
      group: 'Today',
      type: 'student',
      tag: 'AI Diagnostic • Critical',
      accent: _red,
      tagBg: Color(0xFFFFE3E0),
      tagFg: _red,
      time: '12m ago',
      scope: 'CS-301 Section A & B',
      title: 'Cognitive Bottleneck Detected: Reverse-Mode DAG Autodiff',
      body:
      'Socratic Engine flagged 48 students consistently failing Distractor C in Quiz 3 (Jacobian matrix propagation step). Dynamic micro-remedial primer synthesized and queued.',
      foot: 'Predicted midterm impact: -14.2% on Question 4',
      secondary: 'Dismiss',
      primary: 'Review AI Primer',
    ),
    _Alert(
      id: 'a2',
      group: 'Today',
      type: 'autograder',
      tag: 'Autograder Queue • Warning',
      accent: _amber,
      tagBg: Color(0xFFFFE9CF),
      tagFg: _amber,
      time: '35m ago',
      scope: 'Worker Node #04',
      title: 'Container Memory Limit Exceeded in Lab 3 PyTorch Autograder',
      body:
      'Student Farah Yasmin (CS-2024-056) submission triggered CUDA Out-of-Memory (OOM) during batch tensor allocation on test bench unit test test_sparse_attention().',
      foot: 'Exit code 137 (SIGKILL) • Allocated: 512MB limit',
      secondary: 'Inspect Sandbox Logs',
      primary: 'Grant 256MB VRAM Buffer',
    ),
    _Alert(
      id: 'a3',
      group: 'Today',
      type: 'system',
      tag: 'Milestone Reached • Info',
      accent: AppColors.teal,
      tagBg: AppColors.mint,
      tagFg: AppColors.teal,
      time: '2h ago',
      scope: 'CS-301 Section A',
      title: '100% Submission Threshold Reached: Problem Set 1 (Markov Chains)',
      body:
      'All 140 enrolled candidates have completed their peer-reviewed proofs. Autograder batch pipeline finished with a median score of 89.4%. Master gradebook is verified for dispatch.',
      foot: 'Blind Peer Grading completed with kappa = 0.88',
      secondary: 'Export LaTeX Scores',
      primary: 'Publish to Banner SIS',
    ),
    _Alert(
      id: 'a4',
      group: 'Yesterday',
      type: 'student',
      tag: 'Student Advisory • Routine',
      accent: AppColors.primary,
      tagBg: AppColors.chip,
      tagFg: AppColors.primary,
      time: 'Yesterday, 16:45',
      scope: 'CS-301',
      title: '1:1 Office Hour Review Booked by Hamza Tariq (CS-2024-118)',
      body:
      'Student indicated persistent confusion on Vanishing Gradient math in Deep Recurrent Layers. The Socratic engine attached his 3 recent quiz transcripts and failure trees.',
      foot: 'Scheduled: Today @ 15:30 (Room Turing-304) • Quiz 3 Score: 54%',
      secondary: 'View BKT Tree Profile',
      primary: 'Confirm Calendar Slot',
    ),
    _Alert(
      id: 'a5',
      group: 'Yesterday',
      type: 'system',
      tag: 'ABET Compliance • Scheduled Engine',
      accent: AppColors.primary,
      tagBg: AppColors.chip,
      tagFg: AppColors.primary,
      time: 'Yesterday, 09:15',
      scope: 'Outcome 3.1 & 3.2',
      title: 'Midterm Accreditation Dossier Draft Synthesized',
      body:
      'Automated aggregation of student mastery metrics against ABET Criterion 3. Socratic Audit Engine verified 91.2% alignment for Section A with evidence artifacts attached.',
      foot: 'Dossier_CS301_ABET_Midterm_v1.pdf (14.2 MB)',
      secondary: 'Inspect PDF Dossier',
    ),
    _Alert(
      id: 'a6',
      group: 'Earlier This Week',
      type: 'system',
      tag: 'Cluster Infrastructure',
      accent: AppColors.primary,
      tagBg: AppColors.chip,
      tagFg: AppColors.primary,
      time: '3 days ago',
      scope: 'Worker cluster',
      title: 'LLM Fine-Tuning Worker Upgrade Complete (v4.2.1)',
      body:
      'Inference latency dropped by 38% across real-time tutoring feedback sessions. No downtime incurred during hot swap.',
      foot: 'Rollout finished on all 4 worker nodes',
      secondary: 'View Release Notes',
    ),
  ];

  static const _groups = ['Today', 'Yesterday', 'Earlier This Week'];

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  List<_Alert> get _visible => _alerts
      .where((a) => !_dismissed.contains(a.id))
      .where((a) {
    switch (_filter) {
      case 'Unread':
        return !_read.contains(a.id);
      case 'Student Signals':
        return a.type == 'student';
      case 'Autograder':
        return a.type == 'autograder';
      case 'System':
        return a.type == 'system';
      default:
        return true;
    }
  })
      .where((a) {
    if (_query.trim().isEmpty) return true;
    final q = _query.toLowerCase();
    return a.title.toLowerCase().contains(q) ||
        a.body.toLowerCase().contains(q) ||
        a.scope.toLowerCase().contains(q);
  })
      .toList();

  int get _unread => _alerts
      .where((a) => !_dismissed.contains(a.id) && !_read.contains(a.id))
      .length;

  ButtonStyle _btn(Color bg, Color fg) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      minimumSize: const Size(0, 40),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/notifications',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.66 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;
          final tileW =
          c.maxWidth >= 700 ? (inner - 36) / 4 : (inner - 12) / 2;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Faculty Intelligence  >  Records & Telemetry  >  Alert Dispatch Center',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey),
                ),
                const SizedBox(height: 8),
                _header(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: tileW,
                      child: _tile('8', 'Critical', 'Unread Actionable Alerts',
                          'Action Needed', const Color(0xFFFFE3E0), _red,
                          Icons.notifications_active_outlined),
                    ),
                    SizedBox(
                      width: tileW,
                      child: _tile('142', '3 OOM Flags',
                          'Autograder Sandbox Runs', '97.8% pass',
                          AppColors.chip, AppColors.primary,
                          Icons.terminal),
                    ),
                    SizedBox(
                      width: tileW,
                      child: _tile('14', 'At-Risk', 'Cognitive Drift Triggers',
                          '+4 this week', AppColors.mint, AppColors.teal,
                          Icons.psychology_alt_outlined),
                    ),
                    SizedBox(
                      width: tileW,
                      child: _tile('18', 'Delivered', 'Cohort Broadcasts',
                          'CS-301 & CS-502', AppColors.chip,
                          AppColors.primary, Icons.cell_tower),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _filters(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SizedBox(width: mainW, child: _feed()),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _doctor(),
                          const SizedBox(height: 16),
                          _channels(),
                          const SizedBox(height: 16),
                          _routing(),
                          const SizedBox(height: 16),
                          _adaptive(),
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
        Wrap(
          spacing: 10,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Notifications & Real-Time Alerts',
              style: GoogleFonts.manrope(
                fontSize: 26,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const Pill('Live Stream',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Centralized faculty telemetry stream monitoring cognitive hurdles, autograder sandboxes, Socratic triggers, and departmental ABET compliance.',
          style: GoogleFonts.inter(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: _unread == 0
                  ? null
                  : () => setState(
                      () => _read.addAll(_alerts.map((a) => a.id))),
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Mark All as Read'),
              style: _btn(AppColors.chip, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: () => _snack('Alert preferences opened'),
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Alert Preferences'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tile(String value, String unit, String label, String pill,
      Color pillBg, Color pillFg, IconData icon) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: pillFg),
              const SizedBox(width: 8),
              Flexible(
                child: Pill(pill, bg: pillBg, fg: pillFg, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 6,
            children: [
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    final options = {
      'All': _alerts.where((a) => !_dismissed.contains(a.id)).length,
      'Unread': _unread,
      'Student Signals': _alerts.where((a) => a.type == 'student').length,
      'Autograder': _alerts.where((a) => a.type == 'autograder').length,
      'System': _alerts.where((a) => a.type == 'system').length,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final e in options.entries)
              ChoiceChip(
                label: Text(
                  '${e.key} (${e.value})',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                    _filter == e.key ? Colors.white : AppColors.textDark,
                  ),
                ),
                selected: _filter == e.key,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.chip,
                showCheckmark: false,
                onSelected: (_) => setState(() => _filter = e.key),
              ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          onChanged: (v) => setState(() => _query = v),
          style: GoogleFonts.inter(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Filter by student, course, or keyword',
            hintStyle:
            GoogleFonts.inter(fontSize: 13, color: AppColors.textGrey),
            prefixIcon: const Icon(Icons.search,
                size: 20, color: AppColors.textGrey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _feed() {
    final list = _visible;
    if (list.isEmpty) {
      return AppCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Text(
              'No alerts match this filter.',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final g in _groups)
          if (list.any((a) => a.group == g)) ...[
            _groupHeader(g),
            const SizedBox(height: 10),
            for (final a in list.where((a) => a.group == g)) ...[
              _card(a),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 6),
          ],
      ],
    );
  }

  Widget _groupHeader(String g) {
    String? pill;
    if (g == 'Today') pill = '3 Urgent';
    if (g == 'Yesterday') pill = 'Archive';

    return Row(
      children: [
        Text(
          g,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(width: 8),
        if (pill != null)
          Pill(pill,
              bg: g == 'Today' ? const Color(0xFFFFE3E0) : AppColors.chip,
              fg: g == 'Today' ? _red : AppColors.primary,
              fontSize: 10),
        if (g == 'Earlier This Week') ...[
          const Spacer(),
          Text(
            '23 Archived Records',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey),
          ),
        ],
      ],
    );
  }

  Widget _card(_Alert a) {
    final unread = !_read.contains(a.id);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: InkWell(
              onTap: () => setState(() => _read.add(a.id)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Pill(a.tag,
                                bg: a.tagBg, fg: a.tagFg, fontSize: 10),
                            Text(
                              '${a.time} • ${a.scope}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.circle, size: 10, color: a.accent),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    a.title,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.body,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      height: 1.55,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Icon(Icons.info_outline,
                            size: 14, color: AppColors.textGrey),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          a.foot,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (a.secondary == 'Dismiss') {
                            setState(() => _dismissed.add(a.id));
                          } else {
                            _snack(a.secondary);
                          }
                        },
                        style: _btn(AppColors.chip, AppColors.textDark),
                        child: Text(a.secondary),
                      ),
                      if (a.primary != null)
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _read.add(a.id));
                            _snack('${a.primary}: done');
                          },
                          style: _btn(
                              a.accent == _amber
                                  ? _amber
                                  : AppColors.primaryLight,
                              Colors.white),
                          child: Text(a.primary!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: ColoredBox(color: a.accent),
          ),
        ],
      ),
    );
  }

  Widget _sideTitle(String t, {String? pill}) {
    return Row(
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
    );
  }

  Widget _doctor() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'AK',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Ahmed Khan',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Associate Professor & Chair of AI',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Faculty ID: FA-9041',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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
                        'Socratic Audit Engine v4.2',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Pill('Synchronized',
                        bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.96,
                    minHeight: 5,
                    backgroundColor: AppColors.chip,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Latency: 42ms   •   Telemetry buffer: 1.2k events/min',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _channels() {
    Widget ch(IconData icon, String name, String sub, String pct) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
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
                    name,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              pct,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.teal,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.circle, size: 8, color: AppColors.teal),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sideTitle('Delivery Channels', pill: 'All Systems Normal'),
          const SizedBox(height: 14),
          ch(Icons.desktop_windows_outlined, 'Web Cockpit',
              'Real-time WebSocket', '100%'),
          ch(Icons.hub_outlined, 'Canvas LMS Webhook',
              'Batch sync every 15m', '99.8%'),
          ch(Icons.phone_iphone, 'Mobile Push (APNs)',
              'High-priority alerts', '98.6%'),
          ch(Icons.mail_outline, 'Daily Dean Digest',
              'Dispatched 07:00 AM', 'Active'),
        ],
      ),
    );
  }

  Widget _routing() {
    Widget row(String title, String sub, bool value, ValueChanged<bool> on) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
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
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
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
          _sideTitle('Faculty Routing Policy'),
          const SizedBox(height: 12),
          row('Instant OOM Crash Alerts', 'SMS on cluster memory fault', _oom,
                  (v) => _oom = v),
          row('Cognitive Drift Triggers', 'Notify when >25% fail a concept',
              _drift, (v) => _drift = v),
          row('Peer Review Completion', 'Quiet hours during 22:00 - 07:00',
              _peer, (v) => _peer = v),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _snack('ABET audit rules opened'),
              style: _btn(AppColors.chip, AppColors.primary),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.settings_suggest_outlined, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Configure ABET Audit Rules',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  Widget _adaptive() {
    return AppCard(
      color: const Color(0xFFF4F7FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_alt_outlined,
                  size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'ADAPTIVE FILTERING ACTIVE',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'The dispatch engine uses continuous Bayesian Knowledge Tracing to prioritize student signals. Routine automated quiz submissions are batched into the 17:00 PM summary.',
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}