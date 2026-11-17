import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Task {
  String title;
  String status; // Active, Concluded, Archived
  String deadline;
  String note;
  int done;
  int total;

  _Task(this.title, this.status, this.deadline, this.note,
      this.done, this.total);
}

class _Criterion {
  String title;
  String desc;
  int pts;
  _Criterion(this.title, this.desc, this.pts);
}

class TeacherAssignmentsScreen extends StatefulWidget {
  const TeacherAssignmentsScreen({super.key});

  @override
  State<TeacherAssignmentsScreen> createState() =>
      _TeacherAssignmentsScreenState();
}

class _TeacherAssignmentsScreenState extends State<TeacherAssignmentsScreen> {
  static const _soft = Color(0xFFF4F7FF);
  static const _field = Color(0xFFF1F1FF);
  static const _amber = Color(0xFF8A4B00);
  static const _red = Color(0xFFB3261E);

  static const _deadlines = [
    'Oct 28, 2025 • 23:59',
    'Oct 30, 2025 • 23:59',
    'Nov 04, 2025 • 23:59',
  ];
  static const _graces = [
    '+48h (-5% per 12h)',
    '+24h (-10% per 12h)',
    'No grace window',
  ];
  static const _modules = [
    'CS-301 • Autograder',
    'CS-301 • Heuristic Search',
    'CS-301 • Neural Nets',
  ];

  final _title = TextEditingController(
      text: 'Lab 3: Reverse-Mode Autodiff DAG Engine & Gradient Checker');
  final _points = TextEditingController(text: '100');
  final _spec = TextEditingController(
      text:
      'Students are required to instantiate an explicit Directed Acyclic Graph (DAG) node engine representing multivariate reverse-mode automatic differentiation.\n\nKey Requirements:\n1. Implement forward and backward passes.\n2. Verify gradients with finite differences (epsilon 1e-5).');

  String _module = _modules.first;
  String _deadline = _deadlines.first;
  String _grace = _graces.first;
  bool _hints = true;
  bool _windowAdopted = false;
  bool _warningHidden = false;
  String _filter = 'All';

  final List<String> _deliverables = [
    '.py Python Module',
    '.ipynb Jupyter Notebook',
    '.pdf LaTeX Derivation',
  ];

  final List<_Task> _tasks = [
    _Task('Lab 3: Autodiff DAG Engine', 'Active',
        'Oct 28, 2025', '2 Days Remaining', 112, 140),
    _Task('Lab 2: Dijkstra & A* Admissible Heuristics', 'Concluded',
        'Oct 14, 2025', 'Evaluated', 140, 140),
    _Task('Problem Set 1: State Space Search Proofs', 'Archived',
        'Sep 29, 2025', 'Archived', 138, 140),
  ];

  final List<_Criterion> _rubric = [
    _Criterion('Gradient DAG Correctness',
        '12 hidden AST unit tests & numerical eps <= 1e-5 verification.', 50),
    _Criterion('Asymptotic Complexity & VRAM',
        'Linear O(N+E) runtime within <4GB execution ceiling.', 20),
    _Criterion('LaTeX Proof Derivation',
        'Formal proof of multivariate chain rule expansion in PDF.', 15),
    _Criterion('Modularity & PEP-8 Style',
        'Type hints, docstrings, and zero cyclic imports.', 15),
  ];

  @override
  void dispose() {
    _title.dispose();
    _points.dispose();
    _spec.dispose();
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

  int get _rubricTotal => _rubric.fold(0, (s, c) => s + c.pts);

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

  Widget _input(TextEditingController c, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
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
      currentRoute: '/teacher-assignments',
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
                          _workload(),
                          const SizedBox(height: 16),
                          _rubricCard(),
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
            Text('Fall Semester 2025 • Core Curriculum',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Course Assignment & Laboratory Manager',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Configure multi-criteria autograding rubrics, inspect AST test harnesses, monitor live code submissions, and balance student workload with calibrated Socratic AI diagnostics.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _snack('Gradebook exported (.CSV)'),
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Export Gradebook (.CSV)'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: _newAssignment,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Assignment'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  void _newAssignment() {
    setState(() {
      _title.text = '';
      _points.text = '100';
      _spec.text = '';
      _module = _modules.first;
      _deadline = _deadlines.last;
      _grace = _graces.first;
      _deliverables
        ..clear()
        ..add('.py Python Module');
    });
    _snack('Blank assignment ready');
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

    return _grid([
      tile(
        'ACTIVE ASSIGNMENTS',
        big('${_tasks.where((t) => t.status == 'Active').length}', 'Ongoing'),
        small('Next submission window: Lab 3 (in 48h)'),
        icon(Icons.assignment_outlined, AppColors.chip, AppColors.primary),
      ),
      tile(
        'COHORT SUBMISSIONS',
        Row(
          children: [
            Flexible(child: big('140 / 140', '')),
            const SizedBox(width: 8),
            SizedBox(
              width: 38,
              height: 38,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 38,
                    height: 38,
                    child: CircularProgressIndicator(
                      value: 0.89,
                      strokeWidth: 4,
                      backgroundColor: AppColors.chip,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  Text('89%',
                      style: GoogleFonts.inter(
                          fontSize: 8, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
        small('88.5% on-time pace • enrollment capacity fully tracked'),
        null,
      ),
      tile(
        'AUTOGRADER QUEUE',
        big('18', 'in Buffer'),
        Row(
          children: [
            Expanded(child: small('AST edge-case exceptions:')),
            const Pill('6 Manual Flags',
                bg: Color(0xFFFFE3E0), fg: _red, fontSize: 9),
          ],
        ),
        icon(Icons.terminal, const Color(0xFFFFE9CF), _amber),
      ),
      tile(
        'MASTERY BENCHMARK',
        big('84.2%', ''),
        Row(
          children: [
            const Icon(Icons.trending_up, size: 14, color: AppColors.teal),
            const SizedBox(width: 4),
            Expanded(child: small('+3.8% ahead of Fall 2024 cohort')),
          ],
        ),
        icon(Icons.show_chart, AppColors.mint, AppColors.teal),
      ),
    ], minItemWidth: 200);
  }

  // ---------- Formulation form ----------
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
                    Text('Assignment Formulation & Autograder Specs',
                        style: GoogleFonts.manrope(
                          fontSize: 17,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        )),
                    const SizedBox(height: 4),
                    Text(
                        'Configure computational test-harnesses, sandbox parameters, and student submission schemas.',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.textGrey)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Pill('Draft v2 • Autosaved',
                  bg: AppColors.chip, fg: AppColors.textGrey, fontSize: 9),
            ],
          ),
          const SizedBox(height: 16),
          _grid([
            _f('Assignment Title & Spec', _input(_title)),
            _f('Academic Module',
                _drop(_module, _modules, (v) => _module = v)),
          ], minItemWidth: 260),
          const SizedBox(height: 12),
          _grid([
            _f('Total Benchmark Points', _input(_points)),
            _f('Hard Submission Deadline',
                _drop(_deadline, _deadlines, (v) => _deadline = v)),
            _f('Grace Window & Deductions',
                _drop(_grace, _graces, (v) => _grace = v)),
          ], minItemWidth: 170),
          const SizedBox(height: 14),
          _label('Allowed Student Deliverables & Execution Environment'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final d in _deliverables)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.chip,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(d,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                fontSize: 11, color: AppColors.textDark)),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () =>
                            setState(() => _deliverables.remove(d)),
                        child: const Icon(Icons.close,
                            size: 14, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
              TextButton.icon(
                onPressed: _addExtension,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Extension'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                    'Laboratory Specification & Computational Constraints',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
              Text('Markdown & KaTeX enabled',
                  style: GoogleFonts.inter(
                      fontSize: 9, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _field,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final i in const [
                      Icons.format_bold,
                      Icons.format_italic,
                      Icons.code,
                      Icons.functions,
                      Icons.link,
                    ])
                      Icon(i, size: 18, color: AppColors.textGrey),
                    const SizedBox(width: 6),
                    Text(
                        'Autograder Sandbox: PyTorch 2.3 • CUDA 12.1 • 4GB VRAM Limit',
                        style: GoogleFonts.inter(
                            fontSize: 9, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _spec,
                  maxLines: 6,
                  style: GoogleFonts.inter(
                      fontSize: 12, height: 1.5, color: AppColors.textDark),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Describe the laboratory specification...',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _hints,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _hints = v ?? false),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(
                        'Enable Socratic AI hint triggers on unit-test failures',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textGrey)),
                  ),
                ],
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => _snack('Draft saved'),
                    style: _btn(AppColors.chip, AppColors.textDark),
                    child: const Text('Save Draft'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _publish,
                    icon: const Icon(Icons.rocket_launch_outlined, size: 16),
                    label: const Text('Publish Lab to Students'),
                    style: _btn(AppColors.primaryLight, Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addExtension() {
    const options = [
      '.zip Project Archive',
      '.md Report',
      '.csv Result Table',
      '.cpp C++ Source',
    ];
    final left = options.where((o) => !_deliverables.contains(o)).toList();
    if (left.isEmpty) {
      _snack('All extensions already added');
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Add extension'),
        children: [
          for (final o in left)
            SimpleDialogOption(
              onPressed: () {
                setState(() => _deliverables.add(o));
                Navigator.pop(ctx);
              },
              child: Text(o),
            ),
        ],
      ),
    );
  }

  void _publish() {
    if (_title.text.trim().isEmpty) {
      _snack('Please enter an assignment title first');
      return;
    }
    final pts = int.tryParse(_points.text.trim()) ?? 100;
    setState(() {
      _tasks.insert(
        0,
        _Task(_title.text.trim(), 'Active', _deadline.split(' • ').first,
            'Just published • $pts pts', 0, 140),
      );
      _filter = 'All';
    });
    _snack('Assignment published to 140 students');
  }

  // ---------- Roster ----------
  Widget _roster() {
    final list = _tasks.where((t) {
      if (_filter == 'Active') return t.status == 'Active';
      if (_filter == 'Concluded') return t.status == 'Concluded';
      return true;
    }).toList();

    Widget tab(String label) {
      final sel = _filter == label;
      return ChoiceChip(
        label: Text(
          label == 'All' ? 'All Curricula (${_tasks.length})' : label,
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
          Text('Active Roster & Evaluation Queue',
              style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 4),
          Text(
              'Live snapshot of coursework lifecycle, verification passes, and class grade status.',
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.4, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [tab('All'), tab('Active'), tab('Concluded')],
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No assignments in this view.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textGrey)),
              ),
            )
          else
            for (final t in list) _taskRow(t),
        ],
      ),
    );
  }

  Widget _taskRow(_Task t) {
    final active = t.status == 'Active';
    final done = t.status == 'Concluded';
    final pct = t.total == 0 ? 0.0 : t.done / t.total;
    final color = active
        ? AppColors.primary
        : done
        ? AppColors.teal
        : AppColors.primaryLight;

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
                    active ? Icons.account_tree_outlined : Icons.inventory_2_outlined,
                    size: 19,
                    color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.title,
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
                        Pill(t.status,
                            bg: active
                                ? AppColors.mint
                                : AppColors.chip,
                            fg: active
                                ? AppColors.teal
                                : AppColors.textGrey,
                            fontSize: 9),
                        Text('Deadline: ${t.deadline}',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(t.note,
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: active ? _amber : AppColors.textGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('SUBMISSIONS ${t.done} / ${t.total}',
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

  // ---------- AI workload calibration ----------
  Widget _workload() {
    Widget vec(String name, String level, double v, Color color) {
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
              const Icon(Icons.auto_awesome,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('AI Workload Calibration',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
              const Pill('94% Confidence',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
            ],
          ),
          const SizedBox(height: 4),
          Text('Cognitive effort projection across cohort',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
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
                      Text('PROJECTED STUDENT EFFORT',
                          style: GoogleFonts.inter(
                              fontSize: 9, color: AppColors.textGrey)),
                      Text('5.8 Hours',
                          style: GoogleFonts.manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          )),
                      Text('Cognitive Index: Upper Division',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textGrey)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('PACING RISK',
                        style: GoogleFonts.inter(
                            fontSize: 9, color: AppColors.textGrey)),
                    Text('Moderate',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _amber,
                        )),
                    Text('Within syllabus limits',
                        style: GoogleFonts.inter(
                            fontSize: 9, color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text('ALGORITHMIC COMPLEXITY VECTORS',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: AppColors.textGrey,
              )),
          const SizedBox(height: 8),
          vec('DAG Topological Recursion', 'High (78%)', 0.78,
              AppColors.primary),
          vec('Memory Management (PyTorch Tensors)', 'Medium (62%)', 0.62,
              _amber),
          vec('Finite-Difference Epsilon Proof', 'Fair (45%)', 0.45,
              AppColors.textGrey),
          if (!_warningHidden)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFED),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          size: 16, color: _red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text('Faculty Timeline Warning',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _red,
                            )),
                      ),
                      InkWell(
                        onTap: () =>
                            setState(() => _warningHidden = true),
                        child: const Icon(Icons.close,
                            size: 16, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                      'Deadline (Oct 28) overlaps with CS-340 Systems Midterm on Oct 27. 42 shared students face high stress velocity.',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          height: 1.5,
                          color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _windowAdopted
                          ? null
                          : () {
                        setState(() {
                          _windowAdopted = true;
                          _deadline = _deadlines[1];
                          _warningHidden = true;
                        });
                        _snack('Deadline moved to Oct 30');
                      },
                      icon: const Icon(Icons.schedule, size: 16),
                      label: const Text('Adopt Recommended Window (Oct 30)',
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      style: _btn(Colors.white, AppColors.primary),
                    ),
                  ),
                ],
              ),
            )
          else if (_windowAdopted)
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
                    child: Text(
                        'Recommended window adopted. Deadline is now Oct 30.',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.teal)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text('Engine v4.2 Cognitive Model',
                    style: GoogleFonts.inter(
                        fontSize: 9, color: AppColors.textGrey)),
              ),
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
              const SizedBox(width: 4),
              Text('Live Calibrated',
                  style: GoogleFonts.inter(
                      fontSize: 9, color: AppColors.teal)),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Rubric ----------
  Widget _rubricCard() {
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
                    Text('ABET Rubric Scoring Matrix',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        )),
                    Text('Automated autograder weights & rules',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ),
              Text('$_rubricTotal PTS',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _rubricTotal == 100
                        ? AppColors.primary
                        : _amber,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < _rubric.length; i++)
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
                      const Icon(Icons.verified_user_outlined,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_rubric[i].title,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            )),
                      ),
                      Pill('${_rubric[i].pts} PTS',
                          bg: AppColors.chip,
                          fg: AppColors.primary,
                          fontSize: 9),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => setState(() => _rubric.removeAt(i)),
                        child: const Icon(Icons.close,
                            size: 16, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(_rubric[i].desc,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          height: 1.45,
                          color: AppColors.textGrey)),
                ],
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addCriterion,
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('Add Evaluation Criterion'),
              style: _btn(AppColors.chip, AppColors.textDark),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _snack('Saved as ABET Departmental Preset'),
              icon: const Icon(Icons.bookmark_border, size: 16),
              label: const Text('Save as ABET Departmental Preset',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              style: _btn(AppColors.chip, AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  void _addCriterion() {
    final name = TextEditingController();
    final pts = TextEditingController(text: '10');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add evaluation criterion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Criterion name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: pts,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Points'),
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
                setState(() => _rubric.add(_Criterion(
                  name.text.trim(),
                  'Custom criterion added by faculty.',
                  int.tryParse(pts.text.trim()) ?? 10,
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