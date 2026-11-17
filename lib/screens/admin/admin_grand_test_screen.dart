import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

// ======================= Models =======================

class _Module {
  final String code;
  final String name;
  final int pct;
  const _Module(this.code, this.name, this.pct);
  _Module withPct(int p) => _Module(code, name, p);
}

class _Question {
  final String course;
  final String type;
  final String level;
  final int marks;
  final String text;
  final String meta;
  const _Question(
      this.course, this.type, this.level, this.marks, this.text, this.meta);
}

class _Preview {
  final String section;
  final String question;
  final String code;
  final List<String> options;
  final int marks;
  const _Preview(
      this.section, this.question, this.code, this.options, this.marks);
}

// ======================= Shared helpers =======================

Widget _label(String t) => Padding(
  padding: const EdgeInsets.only(bottom: 6),
  child: Text(t,
      style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppColors.textGrey)),
);

Widget _cardHead(String number, String title, String sub, {Widget? trailing}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AdminColors.soft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(number,
            style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AdminColors.indigo)),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(sub,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textGrey)),
            if (trailing != null) ...[
              const SizedBox(height: 8),
              trailing,
            ],
          ],
        ),
      ),
    ],
  );
}

Widget _segmented(List<String> labels, int selected, ValueChanged<int> onTap) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AdminColors.soft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onTap(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(labels[i],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight:
                        i == selected ? FontWeight.w700 : FontWeight.w500,
                        color: i == selected
                            ? AdminColors.indigo
                            : AppColors.textGrey)),
              ),
            ),
          ),
      ],
    ),
  );
}

Widget _field(TextEditingController c,
    {int maxLines = 1, ValueChanged<String>? onChanged}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    decoration: BoxDecoration(
      color: AdminColors.soft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: TextField(
      controller: c,
      maxLines: maxLines,
      minLines: maxLines > 1 ? maxLines : 1,
      onChanged: onChanged,
      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textDark),
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
    ),
  );
}

// ======================= Screen =======================

class AdminGrandTestScreen extends StatefulWidget {
  const AdminGrandTestScreen({super.key});

  @override
  State<AdminGrandTestScreen> createState() => _AdminGrandTestScreenState();
}

class _AdminGrandTestScreenState extends State<AdminGrandTestScreen> {
  static const _extraModules = [
    _Module('MA-210', 'Linear Algebra', 0),
    _Module('DS-220', 'Statistical Learning', 0),
    _Module('CS-318', 'Operating Systems', 0),
  ];
  static const _poolBase = {'CS-301': 20, 'CS-204': 14, 'CS-402': 14};
  static const _initialCounts = {'CS-301': 2, 'CS-204': 1, 'CS-402': 1};
  static const _difficulty = [
    'Standard (40%)',
    'Moderate (35%)',
    'Adaptive Hard (25%)'
  ];
  static const _previews = [
    _Preview(
        'Sec A: AI',
        r'Derive the gradient of risk $\mathcal{R}(\theta)$ under ridge penalty:',
        r'$\nabla_\theta \mathcal{L}(\theta) +' '\n' r'2\lambda\theta = \mathbf{0}$',
        [
          r'$\theta^* = (X^T X + \lambda I)^{-1} X^T y$',
          r'$\theta^* = (X X^T + \lambda I)^{-1} y$',
        ],
        10),
    _Preview(
        'Sec B: DS',
        r'Which step restores the red-black invariant after inserting key $k$ with a red uncle?',
        'insert(k) -> recolor(parent, uncle)\n-> rotate(grandparent)',
        [
          'Recolor parent and uncle, then continue upward',
          'Rotate the grandparent immediately',
        ],
        5),
    _Preview(
        'Sec C: Sys',
        r'How many replicas tolerate $f$ Byzantine faults in PBFT?',
        r'$n \geq 3f + 1$',
        [
          r'$n = 3f + 1$',
          r'$n = 2f + 1$',
        ],
        10),
  ];

  final _title = TextEditingController(
      text:
      'Fall 2025 Multi-Disciplinary Grand Assessment (AI & Systems Architecture)');
  final _objective = TextEditingController(
      text:
      'Comprehensive midterm evaluation spanning Foundations of Machine Learning, Advanced Data Structures, and Systems Architecture.');
  final _instructions = TextEditingController(
      text:
      'Candidates must complete all sections within the allocated 180-minute window. Scratchpad calculations must be typed in the embedded LaTeX editor. Code submissions will execute in an isolated autograder sandbox with memory limits (512MB RAM, 2s CPU limit).');

  List<_Module> _modules = const [
    _Module('CS-301', 'AI Fundamentals', 40),
    _Module('CS-204', 'Advanced Data Structures', 30),
    _Module('CS-402', 'Distributed Systems', 30),
  ];
  int _diff = 2;
  DateTime _date = DateTime(2025, 11, 14);

  bool _timer = true;
  bool _shuffle = true;
  bool _integrity = true;
  bool _fullscreen = true;
  bool _sandbox = true;
  int _attempts = 1;

  final List<_Question> _questions = [
    const _Question(
        'CS-301',
        'Algorithmic & Coding',
        'Hard Rigor',
        10,
        'Derive closed-form Hessian of multi-class cross-entropy loss with L2 regularization',
        'IRT Discrimination a=1.82 • Difficulty b=2.14 • Sandboxed Autograder'),
    const _Question(
        'CS-204',
        'Multiple Choice (4-Distractor)',
        'Medium Rigor',
        5,
        'Optimal Red-Black Tree rotation sequence under adversarial insertion order',
        'IRT Discrimination a=1.20 • Difficulty b=0.85 • Permuted Choices'),
    const _Question(
        'CS-402',
        'Multi-Step Proof',
        'Hard Rigor',
        10,
        'Byzantine Fault Tolerance consensus under partial network partition',
        'IRT Discrimination a=2.01 • Difficulty b=2.40 • LaTeX Scored'),
    const _Question(
        'CS-301',
        'True/False + Justification',
        'Medium Rigor',
        5,
        'Analyze eigenvalue decay in high-dimensional PCA reconstruction',
        'IRT Discrimination a=1.35 • Difficulty b=1.10 • Peer Consensus Check'),
  ];
  String _filter = 'All';
  int _addCount = 0;

  int _section = 0;
  int? _answer = 0;
  bool _marked = false;
  int _qNum = 1;

  @override
  void dispose() {
    _title.dispose();
    _objective.dispose();
    _instructions.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------- derived values ----------

  int get _items => 44 + _questions.length;

  int get _marks => 120 + _questions.fold<int>(0, (s, q) => s + q.marks);

  int get _minutes => 164 + (_items - 48) * 3;

  int get _coverage => _modules.fold<int>(0, (s, m) => s + m.pct);

  int _poolCount(String code) {
    final now = _questions.where((q) => q.course == code).length;
    return (_poolBase[code] ?? 0) + now - (_initialCounts[code] ?? 0);
  }

  List<_Question> get _visibleQuestions => _filter == 'All'
      ? _questions
      : _questions.where((q) => q.course == _filter).toList();

  String _dateLabel() => '${_months[_date.month - 1]} ${_date.day}, ${_date.year}';

  // ---------- module actions ----------

  void _rebalance(List<_Module> list) {
    final total = list.fold<int>(0, (s, m) => s + m.pct);
    if (total == 0) return;
    final scaled = [
      for (final m in list) m.withPct((m.pct * 100 / total).round())
    ];
    final diff = 100 - scaled.fold<int>(0, (s, m) => s + m.pct);
    scaled[0] = scaled[0].withPct(scaled[0].pct + diff);
    _modules = scaled;
  }

  void _addModule(_Module m) {
    setState(() {
      _rebalance([..._modules, m.withPct(25)]);
    });
  }

  void _removeModule(_Module m) {
    if (_modules.length == 1) {
      _snack('At least one curricular module is required');
      return;
    }
    setState(() {
      final rest = _modules.where((x) => x.code != m.code).toList();
      _rebalance(rest);
      if (_filter == m.code) _filter = 'All';
    });
  }

  void _autoBalance() {
    setState(() {
      final n = _modules.length;
      final base = 100 ~/ n;
      final list = [for (final m in _modules) m.withPct(base)];
      list[0] = list[0].withPct(base + (100 - base * n));
      _modules = list;
    });
    _snack('Blueprint balanced evenly across ${_modules.length} modules');
  }

  void _addQuestion() {
    final m = _modules[_addCount % _modules.length];
    setState(() {
      _questions.add(_Question(
          m.code,
          'Multiple Choice (4-Distractor)',
          'Medium Rigor',
          5,
          'New item awaiting calibration for ${m.name}',
          'IRT Discrimination a=1.00 • Difficulty b=1.00 • Uncalibrated'));
      _addCount++;
    });
    _snack('Question added to the item pool');
  }

  void _publish() {
    if (_title.text.trim().isEmpty) {
      _snack('Add a test title before publishing');
      return;
    }
    if (_coverage != 100) {
      _snack('Module coverage must total 100%');
      return;
    }
    _snack('Grand test scheduled for ${_dateLabel()}');
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
    );
    if (d != null) setState(() => _date = d);
  }

  // ======================= Build =======================

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-grand-test',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Grand Test & Cross-Curricular Assessment Creation',
              subtitle:
              'Construct, calibrate, and schedule high-stakes multi-split composite assessments with automated proctoring telemetry and psychometric difficulty curves.',
              actions: [
                AdminButton('Save Draft Spec',
                    icon: Icons.save_outlined,
                    onTap: () => _snack('Draft spec saved')),
                AdminButton('Publish & Schedule Grand Test',
                    icon: Icons.rocket_launch_outlined,
                    primary: true,
                    onTap: _publish),
              ],
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: AdminTag('SPEC v4-BETA', fontSize: 10),
            ),
            const SizedBox(height: 16),
            AdminGrid(
              minItemWidth: 200,
              gap: 14,
              children: [
                const _Stat('COMPOSITE RIGOR INDEX', '94.2', '/ 100',
                    Icons.track_changes, AdminColors.indigo,
                    "Calibrated: Bloom's Tier 4–6 High Analysis",
                    delta: '+3.1%'),
                const _Stat('TARGET COHORT SIZE', '1,420', 'Candidates',
                    Icons.groups_outlined, AdminColors.indigo,
                    'Fall 2025 Upper-Div CS & Data Science'),
                _Stat('SCHEDULED WINDOW', '180', 'Minutes Total',
                    Icons.timer_outlined, AdminColors.indigo,
                    '30s continuous checkpoint auto-save'),
                const _Stat('PSYCHOMETRIC VALIDITY', '99.1%', 'IRT Calibrated',
                    Icons.verified_outlined, AdminColors.teal,
                    'Item Response Theory Distractor Index'),
              ],
            ),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: Column(
                children: [
                  _identityCard(),
                  const SizedBox(height: 20),
                  _poolCard(),
                  const SizedBox(height: 20),
                  _honorCard(),
                ],
              ),
              side: Column(
                children: [
                  _proctorCard(),
                  const SizedBox(height: 20),
                  _candidateCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================= 1. Identity =======================

  Widget _identityCard() {
    final available = _extraModules
        .where((e) => !_modules.any((m) => m.code == e.code))
        .toList();

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHead('1', 'Curricular Scope & Grand Test Identity',
              'Define cross-disciplinary parameters, cohort authorization, and adaptive baseline.',
              trailing: const AdminTag('Standard Model v2', fontSize: 10)),
          const SizedBox(height: 18),
          _label('TEST TITLE & REGISTRY TOKEN'),
          _field(_title),
          const SizedBox(height: 16),
          _label('COHORT SCOPE & PEDAGOGICAL OBJECTIVE'),
          _field(_objective, maxLines: 3),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            children: [
              _label('CURRICULAR MODULES INTERSECTED'),
              Text(
                  '${_modules.length} modules bound ($_coverage% coverage)',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in _modules)
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  decoration: BoxDecoration(
                    color: AdminColors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 15, color: Colors.white),
                      const SizedBox(width: 6),
                      Text('${m.code}: ${m.name}  ${m.pct}%',
                          style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      const SizedBox(width: 6),
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _removeModule(m),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child:
                          Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              if (available.isNotEmpty)
                PopupMenuButton<_Module>(
                  onSelected: _addModule,
                  itemBuilder: (_) => [
                    for (final e in available)
                      PopupMenuItem(
                          value: e, child: Text('${e.code}: ${e.name}')),
                  ],
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: AdminColors.soft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add,
                            size: 15, color: AppColors.textDark),
                        const SizedBox(width: 4),
                        Text('Add Curricular Module',
                            style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          AdminGrid(
            minItemWidth: 240,
            gap: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('DIFFICULTY DISTRIBUTION MODEL'),
                  _segmented(_difficulty, _diff,
                          (i) => setState(() => _diff = i)),
                  const SizedBox(height: 8),
                  Text(
                      'Cognitive dynamic scaling triggered for high-scoring candidates.',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('ASSESSMENT SYNCHRONIZATION WINDOW'),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: AdminColors.soft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 18, color: AdminColors.indigo),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                '${_dateLabel()} • 09:00 - 12:00 EST',
                                style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Strict UTC sync across candidate regional proxy nodes.',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ======================= 2. Item pool =======================

  Widget _poolCard() {
    final rows = _visibleQuestions;
    final codes = ['All', ..._modules.map((m) => m.code)];

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHead('2', 'Item Pool & Questions Registry',
              '$_items Active Items • 150 Target Composite Marks • Calibrated Item Response Curves'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AdminButton('Auto-Balance',
                  icon: Icons.balance_outlined, onTap: _autoBalance),
              AdminButton('Import Bank',
                  icon: Icons.file_upload_outlined,
                  onTap: () => _snack('Question bank import coming soon')),
              AdminButton('Add Question',
                  icon: Icons.add_circle_outline,
                  primary: true,
                  onTap: _addQuestion),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('FILTER POOL:',
                        style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.textGrey)),
                    for (final c in codes)
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => setState(() => _filter = c),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: _filter == c
                                ? AdminColors.indigo
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                              '$c (${c == 'All' ? _items : _poolCount(c)})',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _filter == c
                                      ? Colors.white
                                      : AppColors.textDark)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Sorting: ',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textGrey)),
                  TextSpan(
                      text: 'Psychometric Difficulty (IRT)',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                ])),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text('No questions in this pool',
                    style: GoogleFonts.inter(color: AppColors.textGrey)),
              ),
            )
          else
            for (final q in rows) _questionRow(_questions.indexOf(q), q),
          const SizedBox(height: 4),
          _poolFooter(),
        ],
      ),
    );
  }

  Widget _miniIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AdminColors.soft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.textDark),
      ),
    );
  }

  Widget _questionRow(int i, _Question q) {
    final hard = q.level.startsWith('Hard');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AdminColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Q${i + 1}',
                style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AdminColors.indigo)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AdminTag(q.course, fontSize: 10),
                    Text(q.type,
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textGrey)),
                    AdminTag(q.level,
                        bg: hard
                            ? const Color(0xFFFFE3E3)
                            : AppColors.mintBright,
                        fg: hard ? AdminColors.red : AppColors.teal,
                        fontSize: 10),
                    Text('${q.marks} pts',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(q.text,
                    style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(q.meta,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _miniIcon(Icons.edit_outlined,
                            () => _snack('Editing Q${i + 1}')),
                    const SizedBox(width: 8),
                    _miniIcon(Icons.copy_outlined, () {
                      setState(() => _questions.insert(i + 1, q));
                      _snack('Q${i + 1} duplicated');
                    }),
                    const SizedBox(width: 8),
                    _miniIcon(Icons.delete_outline, () {
                      setState(() => _questions.removeAt(i));
                      _snack('Question removed from pool');
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _poolFooter() {
    final colors = [
      AdminColors.indigo,
      AdminColors.teal,
      const Color(0xFFF59E0B),
      AdminColors.brown,
    ];
    final codes = _modules.map((m) => m.code.split('-').last).join('/');
    final split = _modules.map((m) => m.pct).join('/');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _footStat('Total:', '$_items Questions Configured'),
              _footStat('Aggregate Marks:', '$_marks pts'),
              _footStat('Estimated P90 Duration:', '$_minutes mins'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  for (var i = 0; i < _modules.length; i++)
                    Expanded(
                      flex: _modules[i].pct == 0 ? 1 : _modules[i].pct,
                      child: Container(color: colors[i % colors.length]),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text('CS-$codes ($split)',
              style: GoogleFonts.robotoMono(
                  fontSize: 10, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _footStat(String k, String v) => Text.rich(TextSpan(children: [
    TextSpan(
        text: '$k ',
        style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.teal)),
    TextSpan(
        text: v,
        style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark)),
  ]));

  // ======================= 3. Honor code =======================

  Widget _honorCard() {
    Widget tool(IconData icon, String tip) => InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _snack('$tip formatting applied'),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: AppColors.textGrey),
      ),
    );

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHead('3', 'Candidate Instructions & Honor Code Declaration',
              'Pre-session directives, sandbox memory thresholds, and mandatory declarations.'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 2,
              children: [
                tool(Icons.format_bold, 'Bold'),
                tool(Icons.format_italic, 'Italic'),
                tool(Icons.format_underlined, 'Underline'),
                tool(Icons.code, 'Code'),
                tool(Icons.functions, 'LaTeX'),
                tool(Icons.format_list_bulleted, 'List'),
                Text('Markdown & KaTeX Enabled',
                    style: GoogleFonts.inter(
                        fontSize: 10.5, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AdminColors.line),
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            child: TextField(
              controller: _instructions,
              maxLines: 5,
              minLines: 4,
              style: GoogleFonts.inter(
                  fontSize: 12.5, height: 1.5, color: AppColors.textDark),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.gavel_outlined,
                    size: 18, color: AdminColors.indigo),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                      'By clicking "Begin Assessment", candidates authenticate that work rendered is strictly independent and acknowledge biometric keyboard rhythm telemetry.',
                      style: GoogleFonts.inter(
                          fontSize: 11.5,
                          height: 1.45,
                          color: AppColors.textGrey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================= Proctoring =======================

  Widget _toggleRow(String title, String sub, Widget trailing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(sub,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          trailing,
        ],
      ),
    );
  }

  Widget _switch(bool v, ValueChanged<bool> on) =>
      Switch(value: v, onChanged: on, activeTrackColor: AdminColors.indigo);

  Widget _proctorCard() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined,
                  size: 20, color: AdminColors.indigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Proctoring Telemetry',
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              const AdminTag('ENFORCED',
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 9.5),
            ],
          ),
          const SizedBox(height: 6),
          Text(
              'Rigorous automated anti-tamper controls and client hardware monitoring.',
              style:
              GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 14),
          _toggleRow(
              'Strict Countdown Timer',
              'Force auto-submit at 00:00:00 UTC',
              _switch(_timer, (v) => setState(() => _timer = v))),
          _toggleRow(
            'Attempt Limit Policy',
            'Strict single pass submission',
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () =>
                  setState(() => _attempts = _attempts == 1 ? 2 : 1),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                    _attempts == 1 ? 'Single Attempt (1)' : 'Two Attempts (2)',
                    style: GoogleFonts.robotoMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.indigo)),
              ),
            ),
          ),
          _toggleRow(
              'Dynamic Question Shuffling',
              'Permute distractors per seed',
              _switch(_shuffle, (v) => setState(() => _shuffle = v))),
          _toggleRow(
              'Cryptographic Integrity',
              'SHA-256 state serialization',
              _switch(_integrity, (v) => setState(() => _integrity = v))),
          _toggleRow(
              'Fullscreen Lock & Focus',
              'Auto-locks upon 3 blur strikes',
              _switch(_fullscreen, (v) => setState(() => _fullscreen = v))),
          _toggleRow(
              'Autograder Sandbox Isolation',
              '512MB RAM cap • zero socket access',
              _switch(_sandbox, (v) => setState(() => _sandbox = v))),
        ],
      ),
    );
  }

  // ======================= Candidate preview =======================

  Widget _candidateCard() {
    final p = _previews[_section];
    final pct = (_qNum / _items * 100).toStringAsFixed(1);

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.desktop_windows_outlined,
                  size: 20, color: AdminColors.indigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Candidate UI Preview',
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const AdminTag('REALTIME SIMULATOR', fontSize: 9.5),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle,
                            size: 8, color: AdminColors.red),
                        const SizedBox(width: 6),
                        Text('REC • PROCTORED',
                            style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 14, color: AdminColors.indigo),
                          const SizedBox(width: 4),
                          Text('02:58:45',
                              style: GoogleFonts.robotoMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.indigo)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    for (var i = 0; i < _previews.length; i++)
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => setState(() {
                          _section = i;
                          _answer = null;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: i == _section
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(_previews[i].section,
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: i == _section
                                      ? AdminColors.indigo
                                      : AppColors.textGrey)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 10,
                        children: [
                          Text('QUESTION $_qNum OF $_items',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  letterSpacing: 0.4,
                                  color: AppColors.textGrey)),
                          Text('${p.marks} MARKS',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.indigo)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(p.question,
                          style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: AppColors.textDark)),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AdminColors.soft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(p.code,
                            style: GoogleFonts.robotoMono(
                                fontSize: 10.5,
                                height: 1.5,
                                color: AppColors.textDark)),
                      ),
                      const SizedBox(height: 10),
                      for (var i = 0; i < p.options.length; i++)
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => setState(() => _answer = i),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _answer == i
                                  ? AdminColors.soft
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: _answer == i
                                      ? AdminColors.indigo
                                      : AdminColors.line),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                    _answer == i
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    size: 18,
                                    color: _answer == i
                                        ? AdminColors.indigo
                                        : AppColors.textGrey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(p.options[i],
                                      style: GoogleFonts.robotoMono(
                                          fontSize: 10.5,
                                          color: AppColors.textDark)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    Text('Paced Progress',
                        style: GoogleFonts.inter(
                            fontSize: 10.5, color: AppColors.textGrey)),
                    Text('$_qNum OF $_items ($pct%)',
                        style: GoogleFonts.inter(
                            fontSize: 10.5, color: AppColors.textGrey)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _qNum / _items,
                    minHeight: 5,
                    backgroundColor: AppColors.chip,
                    color: AdminColors.indigo,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AdminButton(
                      _marked ? 'Marked' : 'Mark for Review',
                      icon: _marked ? Icons.bookmark : Icons.bookmark_border,
                      onTap: () => setState(() => _marked = !_marked)),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AdminButton('Next Question',
                      icon: Icons.arrow_forward,
                      primary: true,
                      onTap: () => setState(() {
                        _section = (_section + 1) % _previews.length;
                        _qNum = _qNum % _items + 1;
                        _answer = null;
                        _marked = false;
                      })),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 18, color: AdminColors.indigo),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                      _sandbox
                          ? 'Autograder Sandbox: Ready\nClang-17 / Python 3.12 / Lean 4'
                          : 'Autograder Sandbox: Disabled',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textGrey)),
                ),
              ],
            ),
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
  final String unit;
  final IconData icon;
  final Color color;
  final String foot;
  final String? delta;

  const _Stat(this.label, this.value, this.unit, this.icon, this.color,
      this.foot,
      {this.delta});

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
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8,
            runSpacing: 2,
            children: [
              Text(value,
                  style: GoogleFonts.manrope(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(unit,
                    style: GoogleFonts.inter(
                        fontSize: 11.5, color: AppColors.textGrey)),
              ),
              if (delta != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('↗ $delta',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.teal)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(Icons.circle, size: 6, color: AppColors.teal),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(foot,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}