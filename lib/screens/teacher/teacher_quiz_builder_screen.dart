import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Question {
  String title;
  String type;
  String detail;
  String bloom;
  String level;
  double marks;
  String stem;
  String latex;
  List<String> options;
  List<String> notes;
  int correct;
  String hint;
  bool open;

  _Question({
    required this.title,
    required this.type,
    required this.detail,
    required this.bloom,
    required this.level,
    required this.marks,
    required this.stem,
    this.latex = '',
    this.options = const [],
    this.notes = const [],
    this.correct = 0,
    this.hint = '',
    this.open = false,
  });
}

class TeacherQuizBuilderScreen extends StatefulWidget {
  const TeacherQuizBuilderScreen({super.key});

  @override
  State<TeacherQuizBuilderScreen> createState() =>
      _TeacherQuizBuilderScreenState();
}

class _TeacherQuizBuilderScreenState extends State<TeacherQuizBuilderScreen> {
  static const _soft = Color(0xFFF4F7FF);
  static const _field = Color(0xFFF1F1FF);
  static const _amber = Color(0xFF8A4B00);
  static const _red = Color(0xFFB3261E);

  final _title = TextEditingController(
      text: 'Quiz 3: Deep Neural Networks, Loss Surfaces & Optimization');

  String _module = 'Module 3: Optimization & Backprop';
  String _category = 'Formative Diagnostic';
  String _pass = '70%';
  String _time = '25 Minutes';
  String _attempts = '2 Retries (Best Grade)';
  String _schema = 'Multiple Choice';

  bool _recAdded = false;
  bool _random = true;
  bool _shuffle = true;
  bool _pacing = true;
  bool _kiosk = false;

  final List<String> _competencies = [
    'Gradient Topology Computation',
    'Automatic Differentiation (Reverse-Mode)',
    'Loss Plateau Escapes',
  ];

  late final List<_Question> _qs = [
    _Question(
      title: 'Computational Graph Reverse-Mode Adjoint',
      type: 'Multiple Choice',
      detail: 'Single Correct Attractor',
      bloom: 'Analysis (Bloom Level 4)',
      level: 'Medium',
      marks: 5,
      open: true,
      stem:
      'Consider a feed-forward layer computation embedded within a Directed Acyclic Graph (DAG) defined by intermediate tensor node v_k = sigma(W h + b). When computing the adjoint variable during the backward execution pass, which vector-Jacobian product correctly formulates the gradient pullback through the activation tensor?',
      latex: r"\bar{h} = W^T \left( \bar{v}_k \odot \sigma'(W h + b) \right)",
      options: [
        r"\bar{h} = W^T (\bar{v}_k \odot \sigma'(W h + b))",
        r"\bar{h} = W (\bar{v}_k \odot \sigma'(W h + b))",
        r"\bar{h} = \sigma'(W^T \bar{v}_k) \odot h",
        r"\bar{h} = \nabla_W \mathcal{L} + \bar{v}_k^T b",
      ],
      notes: [
        'Correct application of multivariable chain rule; the transposed weight matrix pulls back the element-wise pre-activation product.',
        'Shape Incompatibility Fallacy: forgets the transpose of weight matrix W, leading to rank misalignment during dimensional projection.',
        'Commutative Operator Confusion: incorrectly applies activation derivative downstream after spatial contraction.',
        'Parameter vs. Activation Confusion: conflates state-variable adjoint with parameter parameterization gradients.',
      ],
      hint:
      'Trace the dimensional layout of your latent embedding vector h. When multiplying by W, what matrix dimension must the incoming adjoint vector encounter to restore dimensionality d?',
    ),
    _Question(
      title: 'Hessian Matrix Conditioning & Saddle Escape',
      type: 'Multi-Select',
      detail: '3 Distractors',
      bloom: 'Evaluate (Bloom Level 5)',
      level: 'Hard',
      marks: 5,
      stem:
      'Select every statement that correctly describes how Hessian eigenvalues characterize a critical point of a loss surface.',
      options: [
        'Mixed-sign eigenvalues indicate a saddle point.',
        'All positive eigenvalues indicate a local minimum.',
        'A zero gradient always implies a global minimum.',
        'Negative eigenvalues indicate directions of descent.',
      ],
      notes: [
        'Correct: curvature differs in sign across directions.',
        'Correct: positive-definite curvature around the point.',
        'Fallacy: a zero gradient only marks a critical point.',
        'Correct: negative curvature gives escape directions.',
      ],
      hint: 'Think about what the sign of each eigenvalue says about curvature.',
    ),
    _Question(
      title: 'Adaptive Momentum (Adam, RMSProp)',
      type: 'Short Answer',
      detail: 'Mathematical Syntax Checker',
      bloom: 'Analyze (Bloom Level 4)',
      level: 'Medium',
      marks: 5,
      stem:
      'Write the bias-corrected first-moment estimate used by Adam in terms of m_t and beta_1.',
      hint: 'Which factor removes the initialization bias toward zero?',
    ),
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

  double get _totalMarks => _qs.fold(0.0, (s, q) => s + q.marks);

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/teacher-quiz-builder',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.66 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
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
                          _config(),
                          const SizedBox(height: 16),
                          _schemaBar(),
                          const SizedBox(height: 16),
                          for (int i = 0; i < _qs.length; i++) ...[
                            _questionCard(i),
                            const SizedBox(height: 12),
                          ],
                          _addQuestion(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _rigor(),
                          const SizedBox(height: 16),
                          _recommendation(),
                          const SizedBox(height: 16),
                          _proctoring(),
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
            const Pill('SCREEN 31 • ASSESSMENT DESIGN',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
            const Pill('Auto-Sync Enabled',
                bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Quiz Builder & Assessment Studio',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Formulate diagnostic quizzes, configure difficulty weights, and inspect AI Bloom taxonomy distribution for predictive cohort calibration.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _snack('Previewing quiz as a student'),
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('Preview'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: () => _snack('Question bank imported'),
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Import Question Bank'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: () => _snack('Draft saved'),
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Save Draft'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: () => _snack('Quiz published to CS-301'),
              icon: const Icon(Icons.rocket_launch_outlined, size: 18),
              label: const Text('Publish Quiz'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- Configuration ----------
  Widget _label(String t, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(t,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                )),
          ),
          if (trailing != null)
            Text(trailing,
                style: GoogleFonts.inter(
                    fontSize: 10, color: AppColors.textGrey)),
        ],
      ),
    );
  }

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

  Widget _field2(String label, Widget child, {String? trailing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_label(label, trailing: trailing), child],
    );
  }

  Widget _config() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune,
                    size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quiz Configuration & Metadata',
                        style: GoogleFonts.manrope(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      'Curricular boundary, pacing parameters, and institutional accreditation alignments.',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 8),
                    const Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Pill('ABET CAC-4',
                            bg: AppColors.chip,
                            fg: AppColors.primary,
                            fontSize: 9),
                        Pill('SO-1 & SO-6',
                            bg: AppColors.chip,
                            fg: AppColors.primary,
                            fontSize: 9),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _grid([
            _field2(
              'Quiz Assessment Title',
              TextField(
                controller: _title,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textDark),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _field,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              trailing: 'Mandatory',
            ),
            _field2(
              'Curricular Module',
              _drop(_module, const [
                'Module 3: Optimization & Backprop',
                'Module 2: Heuristic Search',
                'Module 4: Ethics & Bias',
              ], (v) => _module = v),
            ),
            _field2(
              'Category',
              _drop(_category, const [
                'Formative Diagnostic',
                'Summative Quiz',
                'Practice Drill',
              ], (v) => _category = v),
            ),
            _field2(
              'Pass Threshold',
              _drop(_pass, const ['50%', '60%', '70%', '80%', '90%'],
                      (v) => _pass = v),
            ),
            _field2(
              'Time Limit',
              _drop(_time, const [
                '10 Minutes',
                '15 Minutes',
                '25 Minutes',
                '45 Minutes',
                'No Limit',
              ], (v) => _time = v),
            ),
            _field2(
              'Permitted Attempts',
              _drop(_attempts, const [
                '1 Attempt',
                '2 Retries (Best Grade)',
                'Unlimited',
              ], (v) => _attempts = v),
            ),
          ], minItemWidth: 230),
          const SizedBox(height: 16),
          Text('Institutional Matrix',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final comp in _competencies)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _soft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.circle,
                          size: 7, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(comp,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                fontSize: 11, color: AppColors.textDark)),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () =>
                            setState(() => _competencies.remove(comp)),
                        child: const Icon(Icons.close,
                            size: 14, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
              TextButton.icon(
                onPressed: _addCompetency,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Map Competency'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addCompetency() {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Map competency'),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration:
          const InputDecoration(hintText: 'Competency or outcome name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (c.text.trim().isNotEmpty) {
                setState(() => _competencies.add(c.text.trim()));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // ---------- Schema selector ----------
  Widget _schemaBar() {
    const items = {
      'Multiple Choice': Icons.radio_button_checked,
      'Multi-Select': Icons.check_box_outlined,
      'True / False': Icons.toggle_on_outlined,
      'Short Answer': Icons.short_text,
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Schema Selector:',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            )),
        for (final e in items.entries)
          ChoiceChip(
            avatar: Icon(e.value,
                size: 16,
                color:
                _schema == e.key ? Colors.white : AppColors.textGrey),
            label: Text(e.key,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                  _schema == e.key ? Colors.white : AppColors.textDark,
                )),
            selected: _schema == e.key,
            selectedColor: AppColors.primary,
            backgroundColor: Colors.white,
            showCheckmark: false,
            onSelected: (_) => setState(() => _schema = e.key),
          ),
      ],
    );
  }

  // ---------- Question cards ----------
  Color _levelBg(String l) => l == 'Hard'
      ? const Color(0xFFFFE3E0)
      : l == 'Medium'
      ? AppColors.mint
      : AppColors.chip;
  Color _levelFg(String l) => l == 'Hard'
      ? _red
      : l == 'Medium'
      ? AppColors.teal
      : AppColors.primary;

  Widget _questionCard(int i) {
    final q = _qs[i];
    return AppCard(
      child: q.open ? _openQuestion(i, q) : _closedQuestion(i, q),
    );
  }

  Widget _numBadge(int i) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('${i + 1}',
          style: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          )),
    );
  }

  Widget _closedQuestion(int i, _Question q) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => q.open = true),
      child: Row(
        children: [
          _numBadge(i),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(q.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Pill(q.bloom,
                        bg: AppColors.chip,
                        fg: AppColors.primary,
                        fontSize: 9),
                    Pill(q.level,
                        bg: _levelBg(q.level),
                        fg: _levelFg(q.level),
                        fontSize: 9),
                    Pill('${q.marks.toStringAsFixed(1)} pts',
                        bg: Colors.white,
                        fg: AppColors.textGrey,
                        fontSize: 9),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${q.type} • ${q.detail}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.expand_more, color: AppColors.textGrey),
        ],
      ),
    );
  }

  Widget _openQuestion(int i, _Question q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _numBadge(i),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.title,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      )),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Pill(q.bloom,
                          bg: AppColors.mint,
                          fg: AppColors.teal,
                          fontSize: 9),
                      Pill(q.level,
                          bg: _levelBg(q.level),
                          fg: _levelFg(q.level),
                          fontSize: 9),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                      '${q.type} • ${q.detail} • ${q.marks.toStringAsFixed(1)} Marks',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textGrey)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _icon(Icons.copy_outlined, () {
              setState(() => _qs.insert(
                  i + 1,
                  _Question(
                    title: '${q.title} (Copy)',
                    type: q.type,
                    detail: q.detail,
                    bloom: q.bloom,
                    level: q.level,
                    marks: q.marks,
                    stem: q.stem,
                    latex: q.latex,
                    options: List.of(q.options),
                    notes: List.of(q.notes),
                    correct: q.correct,
                    hint: q.hint,
                  )));
              _snack('Question duplicated');
            }),
            _icon(Icons.delete_outline, () {
              if (_qs.length == 1) {
                _snack('A quiz needs at least one question');
                return;
              }
              setState(() => _qs.removeAt(i));
              _snack('Question deleted');
            }),
            _icon(Icons.expand_less, () => setState(() => q.open = false)),
          ],
        ),
        const SizedBox(height: 12),
        Text('Question Formulation & Mathematical Context',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            )),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _soft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(q.stem,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      height: 1.55,
                      color: AppColors.textDark)),
              if (q.latex.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(q.latex,
                            style: GoogleFonts.robotoMono(
                                fontSize: 11, color: AppColors.textDark)),
                      ),
                      const SizedBox(width: 8),
                      const Pill('Validated LaTeX',
                          bg: AppColors.chip,
                          fg: AppColors.textGrey,
                          fontSize: 8),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (q.options.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text('Distractor Options & Misconception Log',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 8),
          for (int o = 0; o < q.options.length; o++) _option(q, o),
        ] else ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Free-text response. The mathematical syntax checker grades the formula against the reference answer.',
              style: GoogleFonts.inter(
                  fontSize: 11, height: 1.5, color: AppColors.textGrey),
            ),
          ),
        ],
        if (q.hint.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.psychology_alt_outlined,
                        size: 16, color: AppColors.primary),
                    Text('Post-Attempt Socratic Guidance Trigger',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        )),
                    Text('Auto-Generated via Socratic Engine v4.2',
                        style: GoogleFonts.inter(
                            fontSize: 9, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 6),
                Text('"${q.hint}"',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        height: 1.5,
                        color: AppColors.textDark)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _icon(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: AppColors.textGrey),
      ),
    );
  }

  Widget _option(_Question q, int o) {
    final correct = q.correct == o;
    var d = 0;
    for (int k = 0; k < o; k++) {
      if (q.correct != k) d++;
    }
    final label = correct ? 'Ground Truth Correct' : 'Distractor ${d + 1}';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => q.correct = o),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: correct ? AppColors.mint : _soft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: correct ? AppColors.teal : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(String.fromCharCode(65 + o),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: correct ? Colors.white : AppColors.textDark,
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(q.options[o],
                      style: GoogleFonts.robotoMono(
                          fontSize: 11, color: AppColors.textDark)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Pill(label,
                    bg: correct ? AppColors.teal : Colors.white,
                    fg: correct ? Colors.white : AppColors.textGrey,
                    fontSize: 9),
              ],
            ),
            const SizedBox(height: 6),
            Text(o < q.notes.length ? q.notes[o] : '',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    height: 1.45,
                    color: correct ? AppColors.teal : _red)),
          ],
        ),
      ),
    );
  }

  Widget _addQuestion() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          for (final q in _qs) {
            q.open = false;
          }
          final isText = _schema == 'Short Answer';
          final isTf = _schema == 'True / False';
          _qs.add(_Question(
            title: 'New ${_schema} Question',
            type: _schema,
            detail: 'Edit prompt and answers',
            bloom: 'Apply (Bloom Level 3)',
            level: 'Medium',
            marks: 5,
            open: true,
            stem: 'Write the question prompt here.',
            options: isText
                ? []
                : isTf
                ? ['True', 'False']
                : [
              'Option A',
              'Option B',
              'Option C',
              'Option D',
            ],
            notes: isText
                ? []
                : isTf
                ? ['Correct statement.', 'Incorrect statement.']
                : [
              'Rationale for the correct answer.',
              'Describe the misconception.',
              'Describe the misconception.',
              'Describe the misconception.',
            ],
          ));
        });
        _snack('$_schema question added');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF0FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline,
                size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Add Next Curricular Question',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                )),
          ],
        ),
      ),
    );
  }

  // ---------- Right column ----------
  Widget _bar(String name, double v, String pct, Color color,
      {bool warn = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textDark)),
              ),
              const SizedBox(width: 6),
              Text(pct,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  )),
              const SizedBox(width: 4),
              Icon(warn ? Icons.info_outline : Icons.check_circle_outline,
                  size: 14, color: warn ? _amber : AppColors.teal),
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

  Widget _rigor() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Assessment Rigor Index',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
              const Pill('Calibrated',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 84,
                  height: 84,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 84,
                        height: 84,
                        child: CircularProgressIndicator(
                          value: 0.92,
                          strokeWidth: 7,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('92',
                              style: GoogleFonts.manrope(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              )),
                          Text('/ 100',
                              style: GoogleFonts.inter(
                                  fontSize: 9, color: AppColors.textGrey)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exceptional Balance',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          )),
                      const SizedBox(height: 4),
                      Text(
                        'Question distractors eliminate blind guessing via targeted misconception vectors.',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            height: 1.45,
                            color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text("Bloom's Taxonomy Distribution",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    )),
              ),
              Text('Target: Tier 3-5 Heavy',
                  style: GoogleFonts.inter(
                      fontSize: 9, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                      flex: 20,
                      child: Container(color: AppColors.primaryLight)),
                  Expanded(
                      flex: 55,
                      child: Container(color: AppColors.primary)),
                  Expanded(
                      flex: 25,
                      child: Container(color: AppColors.teal)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final t in const [
                '20% Recall',
                '55% Apply',
                '25% Evaluate'
              ])
                Flexible(
                  child: Text(t,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 9, color: AppColors.textGrey)),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Curricular Topic Coverage',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 8),
          _bar('Multivariable Derivatives & DAGs', 1.0, '100%',
              AppColors.teal),
          _bar('Hessian Curvature & Saddle Points', 0.88, '88%',
              AppColors.teal),
          _bar('Adaptive Momentum (Adam, RMSProp)', 0.75, '75%',
              AppColors.primary,
              warn: true),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Predicted Cohort Median',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textGrey)),
                      Text('78.4%',
                          style: GoogleFonts.manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          )),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Pill('Normal Distribution ±4.2% std deviation',
                      bg: AppColors.mint,
                      fg: AppColors.teal,
                      fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendation() {
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
                child: Text('AI Recommendation',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.circle,
                        size: 8, color: AppColors.teal),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('Underrepresented Invariant Detected',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Students consistently struggle with vanishing gradients in deep ReLU architectures. Adding 1 diagnostic probe on dying ReLUs will raise predictive validity by 14%.',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      height: 1.5,
                      color: AppColors.textDark),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _recAdded
                        ? null
                        : () {
                      setState(() {
                        _recAdded = true;
                        _qs.add(_Question(
                          title:
                          'Vanishing Gradients in Deep ReLU Networks',
                          type: 'Multiple Choice',
                          detail: 'Single Correct Attractor',
                          bloom: 'Analysis (Bloom Level 4)',
                          level: 'Medium',
                          marks: 5,
                          stem:
                          'A deep ReLU network stops improving because many units output zero for every input. Which diagnosis best explains this behaviour?',
                          options: const [
                            'Dying ReLU units from large negative pre-activations',
                            'Exploding gradients from a high learning rate only',
                            'Over-regularization of the output layer',
                            'Insufficient training data for the output layer',
                          ],
                          notes: const [
                            'Correct: units pushed into the zero region stop receiving gradient.',
                            'Fallacy: exploding gradients produce large, not zero, updates.',
                            'Fallacy: regularization does not zero out hidden activations.',
                            'Fallacy: data volume does not explain zero activations.',
                          ],
                          hint:
                          'What happens to the gradient of ReLU when its input is negative?',
                        ));
                      });
                      _snack('Recommended question inserted');
                    },
                    icon: const Icon(Icons.add_box_outlined, size: 16),
                    label: Text(
                      _recAdded
                          ? 'Question Inserted'
                          : 'Insert Recommended Question',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: _btn(AppColors.primary, Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _proctoring() {
    Widget row(String title, String sub, bool v, ValueChanged<bool> on) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      )),
                  Text(sub,
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textGrey)),
                ],
              ),
            ),
            Checkbox(
              value: v,
              activeColor: AppColors.primary,
              onChanged: (x) => setState(() => on(x ?? false)),
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
              const Icon(Icons.shield_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Proctoring & Delivery Guard',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          row('Randomize Question Sequence',
              'Each student receives permuted DAG trajectories', _random,
                  (v) => _random = v),
          row('Shuffle Distractors',
              'Permute A/B/C/D positions across attempts', _shuffle,
                  (v) => _shuffle = v),
          row('Strict Pacing Countdown',
              'Enforce server-side auto submission upon timeout', _pacing,
                  (v) => _pacing = v),
          row('Fullscreen Kiosk Guard',
              'Flag blur focus events and external copy/pastes', _kiosk,
                  (v) => _kiosk = v),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Total Assessment Points',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textGrey)),
                ),
                Text('${_totalMarks.toStringAsFixed(1)} Marks',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}