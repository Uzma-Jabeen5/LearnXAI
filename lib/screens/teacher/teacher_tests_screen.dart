import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Exam {
  String title;
  String status; // Scheduled, Completed
  String date;
  String note;
  int done;
  int total;

  _Exam(this.title, this.status, this.date, this.note, this.done,
      this.total);
}

class _Section {
  String title;
  String desc;
  int marks;
  _Section(this.title, this.desc, this.marks);
}

class _Rule {
  final String title;
  final String desc;
  bool on;
  _Rule(this.title, this.desc, this.on);
}

class _Flag {
  final String student;
  final String issue;
  final String level; // High, Medium
  _Flag(this.student, this.issue, this.level);
}

class TeacherTestsScreen extends StatefulWidget {
  const TeacherTestsScreen({super.key});

  @override
  State<TeacherTestsScreen> createState() => _TeacherTestsScreenState();
}

class _TeacherTestsScreenState extends State<TeacherTestsScreen> {
  static const _soft = Color(0xFFF4F7FF);
  static const _field = Color(0xFFF1F1FF);
  static const _amber = Color(0xFF8A4B00);
  static const _red = Color(0xFFB3261E);

  static const _modules = [
    'CS-301 • Heuristic Search',
    'CS-301 • Autograder',
    'CS-301 • Neural Nets',
  ];
  static const _dates = [
    'Nov 06, 2025 • 10:00',
    'Nov 08, 2025 • 14:00',
    'Nov 12, 2025 • 10:00',
  ];
  static const _durations = [
    '90 minutes',
    '120 minutes',
    '180 minutes',
  ];

  final _title = TextEditingController(
      text: 'Midterm: Search, Heuristics & Game Theory');
  final _marks = TextEditingController(text: '100');
  final _instructions = TextEditingController(
      text:
      'Closed book. One approved calculator allowed. Your webcam must stay on for the full sitting. Leaving the exam window is logged and reviewed by faculty.');

  String _module = _modules.first;
  String _date = _dates.first;
  String _duration = _durations[1];
  String _filter = 'All';
  bool _flagsClear = false;

  final List<_Rule> _rules = [
    _Rule('Webcam identity check',
        'Verify the candidate face against the registrar photo.', true),
    _Rule('Tab-switch lock',
        'Log every time the candidate leaves the exam window.', true),
    _Rule('Screen recording',
        'Record the screen for post-exam integrity review.', false),
    _Rule('Randomize question order',
        'Each candidate gets a different question sequence.', true),
    _Rule('Browser lockdown',
        'Block copy, paste and right-click during the exam.', true),
  ];

  final List<_Section> _sections = [
    _Section('Section A: Uninformed Search',
        '20 multiple-choice questions on BFS, DFS and UCS.', 30),
    _Section('Section B: Heuristics & A*',
        'Admissibility proofs and consistency checks.', 40),
    _Section('Section C: Adversarial Search',
        'Minimax and alpha-beta pruning trace problems.', 30),
  ];

  final List<_Exam> _exams = [
    _Exam('Midterm: Search, Heuristics & Game Theory', 'Scheduled',
        'Nov 06, 2025', 'Opens 10:00 • 100 marks', 0, 140),
    _Exam('Checkpoint Exam 1: Uninformed Search', 'Completed',
        'Oct 02, 2025', 'Graded', 140, 140),
    _Exam('Diagnostic Exam: Prerequisites', 'Completed', 'Sep 18, 2025',
        'Graded', 138, 140),
  ];

  final List<_Flag> _flags = [
    _Flag('Candidate #0412', 'Left exam window 6 times in 10 min', 'High'),
    _Flag('Candidate #0287', 'Second face detected on webcam', 'High'),
    _Flag('Candidate #0903', 'Webcam covered for 40 seconds', 'Medium'),
  ];

  @override
  void dispose() {
    _title.dispose();
    _marks.dispose();
    _instructions.dispose();
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

  int get _blueprintTotal => _sections.fold(0, (s, c) => s + c.marks);

  int get _targetMarks => int.tryParse(_marks.text.trim()) ?? 100;

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

  Widget _input(TextEditingController c,
      {int maxLines = 1, ValueChanged<String>? onChanged}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      onChanged: onChanged,
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

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/teacher-tests',
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
                          _formCard(),
                          const SizedBox(height: 16),
                          _roster(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _monitor(),
                          const SizedBox(height: 16),
                          _blueprintCard(),
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
            Text('Fall Semester 2025 • Examination Cell',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Proctored Examination Builder',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Set up timed exams, choose proctoring rules, shape the section blueprint, and watch integrity signals while candidates are sitting the paper.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _snack('Exam results exported (.CSV)'),
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Export Results (.CSV)'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: _newExam,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Exam'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  void _newExam() {
    setState(() {
      _title.text = '';
      _marks.text = '100';
      _instructions.text = '';
      _module = _modules.first;
      _date = _dates.last;
      _duration = _durations.first;
      _sections
        ..clear()
        ..add(_Section('Section A', 'Describe this section.', 100));
    });
    _snack('Blank exam ready');
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

    final scheduled = _exams.where((e) => e.status == 'Scheduled').length;
    final high = _flags.where((f) => f.level == 'High').length;

    return _grid([
      tile(
        'SCHEDULED EXAMS',
        big('$scheduled', 'Upcoming'),
        small('Next sitting: Midterm on Nov 06'),
        icon(Icons.event_note_outlined, AppColors.chip, AppColors.primary),
      ),
      tile(
        'ENROLLED CANDIDATES',
        big('140', ''),
        small('All seats checked against the registrar roster'),
        icon(Icons.groups_outlined, AppColors.mint, AppColors.teal),
      ),
      tile(
        'INTEGRITY FLAGS',
        big('${_flags.length}', 'Open'),
        Row(
          children: [
            Expanded(child: small('Waiting for faculty review')),
            Pill('$high High',
                bg: const Color(0xFFFFE3E0), fg: _red, fontSize: 9),
          ],
        ),
        icon(Icons.shield_outlined, const Color(0xFFFFE9CF), _amber),
      ),
      tile(
        'READINESS INDEX',
        big('81.6%', ''),
        Row(
          children: [
            const Icon(Icons.trending_up, size: 14, color: AppColors.teal),
            const SizedBox(width: 4),
            Expanded(child: small('+2.4% ahead of Fall 2024 cohort')),
          ],
        ),
        icon(Icons.show_chart, AppColors.mint, AppColors.teal),
      ),
    ], minItemWidth: 200);
  }

  // ---------- Exam setup form ----------
  Widget _formCard() {
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
                    Text('Exam Setup & Proctoring Rules',
                        style: GoogleFonts.manrope(
                          fontSize: 17,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        )),
                    const SizedBox(height: 4),
                    Text(
                        'Set the sitting details, then pick how strictly the exam is supervised.',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.textGrey)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Pill('Draft v1 • Autosaved',
                  bg: AppColors.chip, fg: AppColors.textGrey, fontSize: 9),
            ],
          ),
          const SizedBox(height: 16),
          _grid([
            _f('Exam Title', _input(_title)),
            _f('Academic Module',
                _drop(_module, _modules, (v) => _module = v)),
          ], minItemWidth: 260),
          const SizedBox(height: 12),
          _grid([
            _f('Total Marks',
                _input(_marks, onChanged: (_) => setState(() {}))),
            _f('Exam Date & Start Time',
                _drop(_date, _dates, (v) => _date = v)),
            _f('Duration', _drop(_duration, _durations, (v) => _duration = v)),
          ], minItemWidth: 170),
          const SizedBox(height: 14),
          _label('Proctoring Rules'),
          for (final r in _rules)
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
                        Text(r.title,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            )),
                        const SizedBox(height: 2),
                        Text(r.desc,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                height: 1.4,
                                color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  Switch(
                    value: r.on,
                    activeTrackColor: AppColors.primary,
                    onChanged: (v) => setState(() => r.on = v),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          _label('Instructions Shown to Candidates'),
          _input(_instructions, maxLines: 4),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => _snack('Draft saved'),
                  style: _btn(AppColors.chip, AppColors.textDark),
                  child: const Text('Save Draft'),
                ),
                ElevatedButton.icon(
                  onPressed: _schedule,
                  icon: const Icon(Icons.event_available_outlined, size: 16),
                  label: const Text('Schedule Exam'),
                  style: _btn(AppColors.primaryLight, Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _schedule() {
    if (_title.text.trim().isEmpty) {
      _snack('Please enter an exam title first');
      return;
    }
    if (_blueprintTotal != _targetMarks) {
      _snack('Section marks add up to $_blueprintTotal, not $_targetMarks');
      return;
    }
    final parts = _date.split(' • ');
    setState(() {
      _exams.insert(
        0,
        _Exam(_title.text.trim(), 'Scheduled', parts.first,
            'Opens ${parts.last} • $_targetMarks marks', 0, 140),
      );
      _filter = 'All';
    });
    _snack('Exam scheduled for 140 candidates');
  }

  // ---------- Roster ----------
  Widget _roster() {
    final list = _exams.where((e) {
      if (_filter == 'Scheduled') return e.status == 'Scheduled';
      if (_filter == 'Completed') return e.status == 'Completed';
      return true;
    }).toList();

    Widget tab(String label) {
      final sel = _filter == label;
      return ChoiceChip(
        label: Text(
          label == 'All' ? 'All Exams (${_exams.length})' : label,
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
          Text('Exam Calendar & Results',
              style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 4),
          Text('Every sitting for this course, from upcoming to graded.',
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.4, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [tab('All'), tab('Scheduled'), tab('Completed')],
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No exams in this view.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textGrey)),
              ),
            )
          else
            for (final e in list) _examRow(e),
        ],
      ),
    );
  }

  Widget _examRow(_Exam e) {
    final upcoming = e.status == 'Scheduled';
    final pct = e.total == 0 ? 0.0 : e.done / e.total;
    final color = upcoming ? AppColors.primary : AppColors.teal;

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
                child: Icon(
                    upcoming ? Icons.timer_outlined : Icons.task_alt_outlined,
                    size: 19,
                    color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.title,
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
                        Pill(e.status,
                            bg: upcoming ? AppColors.mint : AppColors.chip,
                            fg: upcoming
                                ? AppColors.teal
                                : AppColors.textGrey,
                            fontSize: 9),
                        Text('Date: ${e.date}',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(e.note,
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: upcoming ? _amber : AppColors.textGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('ATTEMPTED ${e.done} / ${e.total}',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textGrey)),
              const Spacer(),
              Text('${(pct * 100).toStringAsFixed(pct == 1 ? 0 : 1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: AppColors.chip,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Live integrity monitor ----------
  Widget _monitor() {
    Widget signal(String name, String level, double v, Color color) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(name,
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textDark)),
                ),
                Text(level,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                    )),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 5,
                backgroundColor: AppColors.chip,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.visibility_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Integrity Monitor',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
              const Pill('Live',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
            ],
          ),
          const SizedBox(height: 4),
          Text('Signals from the last proctored sitting',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          signal('Tab-switch events', 'Low (14%)', 0.14, AppColors.teal),
          signal('Identity mismatches', 'Low (6%)', 0.06, AppColors.teal),
          signal('Multiple faces detected', 'Medium (31%)', 0.31, _amber),
          signal('Webcam obstructed', 'Medium (22%)', 0.22, _amber),
          const SizedBox(height: 4),
          Text('OPEN FLAGS',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: AppColors.textGrey,
              )),
          const SizedBox(height: 8),
          if (_flags.isEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 16, color: AppColors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('All flags reviewed. Nothing is waiting.',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.teal)),
                  ),
                ],
              ),
            )
          else
            for (int i = 0; i < _flags.length; i++)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _flags[i].level == 'High'
                      ? const Color(0xFFFFEFED)
                      : const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 16,
                        color: _flags[i].level == 'High' ? _red : _amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_flags[i].student,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              )),
                          const SizedBox(height: 2),
                          Text(_flags[i].issue,
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  height: 1.4,
                                  color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _flags.removeAt(i);
                          _flagsClear = _flags.isEmpty;
                        });
                        _snack('Flag dismissed');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text('Dismiss',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
          if (_flagsClear) const SizedBox.shrink(),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text('Engine v4.2 Integrity Model',
                    style: GoogleFonts.inter(
                        fontSize: 9, color: AppColors.textGrey)),
              ),
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
              const SizedBox(width: 4),
              Text('Monitoring',
                  style:
                  GoogleFonts.inter(fontSize: 9, color: AppColors.teal)),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Section blueprint ----------
  Widget _blueprintCard() {
    final balanced = _blueprintTotal == _targetMarks;

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
                    Text('Exam Blueprint',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        )),
                    Text('Marks per section',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ),
              Text('$_blueprintTotal / $_targetMarks',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: balanced ? AppColors.primary : _amber,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < _sections.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.view_list_outlined,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_sections[i].title,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            )),
                      ),
                      Pill('${_sections[i].marks} MARKS',
                          bg: AppColors.chip,
                          fg: AppColors.primary,
                          fontSize: 9),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => setState(() => _sections.removeAt(i)),
                        child: const Icon(Icons.close,
                            size: 16, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(_sections[i].desc,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          height: 1.45,
                          color: AppColors.textGrey)),
                ],
              ),
            ),
          if (!balanced)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                  'Section marks must add up to $_targetMarks before you can schedule.',
                  style: GoogleFonts.inter(fontSize: 10, color: _amber)),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addSection,
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('Add Section'),
              style: _btn(AppColors.chip, AppColors.textDark),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _snack('Saved as Departmental Exam Template'),
              icon: const Icon(Icons.bookmark_border, size: 16),
              label: const Text('Save as Exam Template',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              style: _btn(AppColors.chip, AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  void _addSection() {
    final name = TextEditingController();
    final marks = TextEditingController(text: '10');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add exam section'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Section name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: marks,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Marks'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (name.text.trim().isNotEmpty) {
                setState(() => _sections.add(_Section(
                  name.text.trim(),
                  'Custom section added by faculty.',
                  int.tryParse(marks.text.trim()) ?? 10,
                )));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}