import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Report {
  final String title;
  final String type;
  final String format;
  final String date;
  final String size;
  final String status; // Ready, Scheduled

  _Report(this.title, this.type, this.format, this.date, this.size,
      this.status);
}

class _Schedule {
  final String title;
  final String freq;
  bool on;
  _Schedule(this.title, this.freq, this.on);
}

class _Template {
  final String title;
  final String desc;
  final IconData icon;
  final String type;
  _Template(this.title, this.desc, this.icon, this.type);
}

class TeacherReportsScreen extends StatefulWidget {
  const TeacherReportsScreen({super.key});

  @override
  State<TeacherReportsScreen> createState() => _TeacherReportsScreenState();
}

class _TeacherReportsScreenState extends State<TeacherReportsScreen> {
  static const _soft = Color(0xFFF4F7FF);
  static const _field = Color(0xFFF1F1FF);
  static const _amber = Color(0xFF8A4B00);

  static const _types = [
    'Cohort Performance Summary',
    'Assignment Grade Sheet',
    'Exam Integrity Report',
    'Attendance & Engagement',
  ];
  static const _modules = [
    'All Modules',
    'CS-301 • Heuristic Search',
    'CS-301 • Autograder',
    'CS-301 • Neural Nets',
  ];
  static const _ranges = [
    'Last 7 days',
    'Last 30 days',
    'Full semester',
  ];
  static const _formats = ['PDF', 'CSV', 'XLSX'];
  static const _sectionNames = [
    'Grade distribution',
    'Topic mastery',
    'At-risk students',
    'Submission timeline',
    'Integrity flags',
  ];

  final _title = TextEditingController(text: 'Fall 2025 Midterm Summary');

  String _type = _types.first;
  String _module = _modules.first;
  String _range = _ranges[2];
  String _format = 'PDF';
  String _filter = 'All';

  final Set<String> _sections = {
    'Grade distribution',
    'Topic mastery',
    'At-risk students',
  };

  final List<_Report> _reports = [
    _Report('Lab 2 Grade Sheet', 'Assignment Grade Sheet', 'XLSX',
        'Oct 15, 2025', '212 KB', 'Ready'),
    _Report('Checkpoint Exam 1 Integrity Review', 'Exam Integrity Report',
        'PDF', 'Oct 03, 2025', '1.4 MB', 'Ready'),
    _Report('Weekly Engagement Digest', 'Attendance & Engagement', 'CSV',
        'Every Monday', '86 KB', 'Scheduled'),
    _Report('Monthly Cohort Summary', 'Cohort Performance Summary', 'PDF',
        '1st of each month', '2.1 MB', 'Scheduled'),
  ];

  final List<_Schedule> _schedules = [
    _Schedule('Weekly Engagement Digest', 'Every Monday, 08:00', true),
    _Schedule('Monthly Cohort Summary', '1st of each month', true),
    _Schedule('Exam Integrity Report', 'After every exam', false),
  ];

  final List<_Template> _templates = [
    _Template('Midterm Review Pack', 'Grades, mastery and at-risk list.',
        Icons.fact_check_outlined, 'Cohort Performance Summary'),
    _Template('Lab Grade Export', 'Per-student scores for one assignment.',
        Icons.table_chart_outlined, 'Assignment Grade Sheet'),
    _Template('Proctoring Audit', 'All integrity flags from an exam.',
        Icons.shield_outlined, 'Exam Integrity Report'),
  ];

  @override
  void dispose() {
    _title.dispose();
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
      minimumSize: const Size(0, 42),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  Widget _grid(List<Widget> items, {double minItemWidth = 200}) {
    return LayoutBuilder(
      builder: (context, cc) {
        int cols = ((cc.maxWidth + 12) / (minItemWidth + 12)).floor();
        if (cols < 1) cols = 1;
        if (cols > items.length && items.isNotEmpty) cols = items.length;
        final w = (cc.maxWidth - 12 * (cols - 1)) / cols;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [for (final i in items) SizedBox(width: w, child: i)],
        );
      },
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        )),
  );

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
              child: Text(o,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textDark)),
            ),
        ],
        onChanged: (v) => setState(() => on(v ?? value)),
      ),
    );
  }

  Widget _input(TextEditingController c) {
    return TextField(
      controller: c,
      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: _field,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _f(String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_label(label), child],
  );

  IconData _formatIcon(String f) {
    if (f == 'PDF') return Icons.picture_as_pdf_outlined;
    if (f == 'CSV') return Icons.table_rows_outlined;
    return Icons.grid_on_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/teacher-reports',
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
                _stats(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SizedBox(
                      width: mainW,
                      child: Column(
                        children: [
                          _builderCard(),
                          const SizedBox(height: 16),
                          _historyCard(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _templatesCard(),
                          const SizedBox(height: 16),
                          _scheduleCard(),
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
            const Pill('CS-301 TRACK',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
            Text('Fall Semester 2025 • Reporting Desk',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Reports',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Build grade sheets, cohort summaries and integrity audits, then download them or schedule them to run on their own.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _snack('All reports bundled (.ZIP)'),
              icon: const Icon(Icons.folder_zip_outlined, size: 18),
              label: const Text('Download All (.ZIP)'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: _resetBuilder,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Report'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  void _resetBuilder() {
    setState(() {
      _title.text = '';
      _type = _types.first;
      _module = _modules.first;
      _range = _ranges[2];
      _format = 'PDF';
      _sections
        ..clear()
        ..add('Grade distribution');
    });
    _snack('Blank report ready');
  }

  // ---------- Stats ----------
  Widget _stats() {
    Widget tile(String label, Widget body, Widget foot, Widget? side) {
      return AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          letterSpacing: 0.4,
                          color: AppColors.textGrey)),
                ),
                if (side != null) side,
              ],
            ),
            const SizedBox(height: 8),
            body,
            const SizedBox(height: 8),
            foot,
          ],
        ),
      );
    }

    Widget big(String v, String unit) => Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 6,
      children: [
        Text(v,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            )),
        if (unit.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(unit,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                )),
          ),
      ],
    );

    Widget small(String t) => Text(t,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(fontSize: 10, color: AppColors.textGrey));

    Widget icon(IconData i, Color bg, Color fg) => Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(i, size: 17, color: fg),
    );

    final ready = _reports.where((r) => r.status == 'Ready').length;
    final active = _schedules.where((s) => s.on).length;

    return _grid([
      tile(
        'REPORTS READY',
        big('$ready', 'Files'),
        small('Available to download right now'),
        icon(Icons.description_outlined, AppColors.chip, AppColors.primary),
      ),
      tile(
        'ACTIVE SCHEDULES',
        big('$active', 'of ${_schedules.length}'),
        small('Reports that run without you'),
        icon(Icons.event_repeat_outlined, AppColors.mint, AppColors.teal),
      ),
      tile(
        'LAST EXPORT',
        big('Today', ''),
        small('Lab 2 Grade Sheet • XLSX'),
        icon(Icons.download_done_outlined, const Color(0xFFFFE9CF), _amber),
      ),
      tile(
        'STORAGE USED',
        big('3.8', 'MB'),
        small('Of 500 MB faculty allowance'),
        icon(Icons.cloud_outlined, AppColors.mint, AppColors.teal),
      ),
    ], minItemWidth: 200);
  }

  // ---------- Report builder ----------
  Widget _builderCard() {
    Widget formatChip(String f) {
      final sel = _format == f;
      return ChoiceChip(
        label: Text(
          f,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: sel ? Colors.white : AppColors.textDark,
          ),
        ),
        selected: sel,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.chip,
        showCheckmark: false,
        onSelected: (_) => setState(() => _format = f),
      );
    }

    Widget sectionChip(String name) {
      final sel = _sections.contains(name);
      return FilterChip(
        label: Text(
          name,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: sel ? Colors.white : AppColors.textDark,
          ),
        ),
        selected: sel,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.chip,
        checkmarkColor: Colors.white,
        onSelected: (v) => setState(() {
          if (v) {
            _sections.add(name);
          } else {
            _sections.remove(name);
          }
        }),
      );
    }

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
                    Text('Report Builder',
                        style: GoogleFonts.manrope(
                          fontSize: 17,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        )),
                    const SizedBox(height: 4),
                    Text(
                        'Pick what the report covers, choose a format, and generate it.',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.textGrey)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Pill('Draft • Unsaved',
                  bg: AppColors.chip, fg: AppColors.textGrey, fontSize: 9),
            ],
          ),
          const SizedBox(height: 16),
          _grid([
            _f('Report Title', _input(_title)),
            _f('Report Type', _drop(_type, _types, (v) => _type = v)),
          ], minItemWidth: 260),
          const SizedBox(height: 12),
          _grid([
            _f('Module', _drop(_module, _modules, (v) => _module = v)),
            _f('Date Range', _drop(_range, _ranges, (v) => _range = v)),
          ], minItemWidth: 220),
          const SizedBox(height: 14),
          _label('File Format'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final f in _formats) formatChip(f)],
          ),
          const SizedBox(height: 14),
          _label('Include Sections'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final s in _sectionNames) sectionChip(s)],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: _schedulePrompt,
                  style: _btn(AppColors.chip, AppColors.textDark),
                  child: const Text('Add to Schedule'),
                ),
                ElevatedButton.icon(
                  onPressed: _generate,
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Generate Report'),
                  style: _btn(AppColors.primaryLight, Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _generate() {
    if (_title.text.trim().isEmpty) {
      _snack('Please enter a report title first');
      return;
    }
    if (_sections.isEmpty) {
      _snack('Select at least one section to include');
      return;
    }
    setState(() {
      _reports.insert(
        0,
        _Report(_title.text.trim(), _type, _format, 'Just now',
            '${120 + _sections.length * 40} KB', 'Ready'),
      );
      _filter = 'All';
    });
    _snack('Report generated as $_format');
  }

  void _schedulePrompt() {
    if (_title.text.trim().isEmpty) {
      _snack('Please enter a report title first');
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Run this report'),
        children: [
          for (final f in const [
            'Every Monday, 08:00',
            '1st of each month',
            'After every exam',
          ])
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  _schedules.add(_Schedule(_title.text.trim(), f, true));
                  _reports.insert(
                    0,
                    _Report(_title.text.trim(), _type, _format, f, 'Pending',
                        'Scheduled'),
                  );
                });
                Navigator.pop(ctx);
                _snack('Scheduled: $f');
              },
              child: Text(f),
            ),
        ],
      ),
    );
  }

  // ---------- History ----------
  Widget _historyCard() {
    final list = _reports.where((r) {
      if (_filter == 'Ready') return r.status == 'Ready';
      if (_filter == 'Scheduled') return r.status == 'Scheduled';
      return true;
    }).toList();

    Widget tab(String label) {
      final sel = _filter == label;
      return ChoiceChip(
        label: Text(
          label == 'All' ? 'All Reports (${_reports.length})' : label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: sel ? Colors.white : AppColors.textDark,
          ),
        ),
        selected: sel,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.chip,
        showCheckmark: false,
        onSelected: (_) => setState(() => _filter = label),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Report History',
              style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 4),
          Text('Everything you generated or scheduled for this course.',
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.4, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [tab('All'), tab('Ready'), tab('Scheduled')],
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No reports in this view.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textGrey)),
              ),
            )
          else
            for (final r in list) _reportRow(r),
        ],
      ),
    );
  }

  Widget _reportRow(_Report r) {
    final ready = r.status == 'Ready';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _soft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_formatIcon(r.format),
                    size: 19, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        )),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Pill(r.status,
                            bg: ready ? AppColors.mint : AppColors.chip,
                            fg: ready ? AppColors.teal : AppColors.primary,
                            fontSize: 9),
                        Text('${r.format} • ${r.size}',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('${r.type} • ${r.date}',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: AppColors.textGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: ready
                    ? () => _snack('Downloading ${r.title}.${r.format}')
                    : null,
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text('Download'),
                style: _btn(Colors.white, AppColors.primary),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _reports.remove(r));
                  _snack('Report removed');
                },
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete'),
                style: _btn(Colors.white, const Color(0xFFB3261E)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Templates ----------
  Widget _templatesCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Quick Templates',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Tap one to fill in the builder',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          for (final t in _templates)
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() {
                  _title.text = t.title;
                  _type = t.type;
                });
                _snack('${t.title} loaded');
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _soft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.chip,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(t.icon, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              )),
                          const SizedBox(height: 2),
                          Text(t.desc,
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  height: 1.4,
                                  color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        size: 18, color: AppColors.textGrey),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------- Scheduled reports ----------
  Widget _scheduleCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_repeat_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Scheduled Reports',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
              Pill('${_schedules.where((s) => s.on).length} Active',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
            ],
          ),
          const SizedBox(height: 4),
          Text('Switch a schedule off to pause it',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          for (final s in _schedules)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.title,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            )),
                        const SizedBox(height: 2),
                        Text(s.freq,
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  Switch(
                    value: s.on,
                    activeTrackColor: AppColors.primary,
                    onChanged: (v) {
                      setState(() => s.on = v);
                      _snack(v ? '${s.title} resumed' : '${s.title} paused');
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}