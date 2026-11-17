import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Student {
  final String name;
  final String id;
  final int mastery;
  final int hours;
  final String weak;
  bool nudged;

  _Student(this.name, this.id, this.mastery, this.hours, this.weak,
      {this.nudged = false});

  String get risk {
    if (mastery < 60) return 'High';
    if (mastery < 75) return 'Medium';
    return 'Low';
  }
}

class TeacherAnalyticsScreen extends StatefulWidget {
  const TeacherAnalyticsScreen({super.key});

  @override
  State<TeacherAnalyticsScreen> createState() =>
      _TeacherAnalyticsScreenState();
}

class _TeacherAnalyticsScreenState extends State<TeacherAnalyticsScreen> {
  static const _soft = Color(0xFFF4F7FF);
  static const _field = Color(0xFFF1F1FF);
  static const _amber = Color(0xFF8A4B00);
  static const _red = Color(0xFFB3261E);

  static const _modules = [
    'CS-301 • Heuristic Search',
    'CS-301 • Autograder',
    'CS-301 • Neural Nets',
  ];

  static const _sorts = [
    'Mastery (low first)',
    'Mastery (high first)',
    'Name (A to Z)',
  ];

  static const Map<String, List<String>> _trendLabels = {
    '7D': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    '30D': ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
    'Semester': ['W2', 'W4', 'W6', 'W8', 'W10', 'W12'],
  };

  static const Map<String, List<int>> _trendValues = {
    '7D': [78, 80, 79, 83, 85, 82, 84],
    '30D': [74, 79, 82, 84],
    'Semester': [66, 71, 75, 79, 82, 84],
  };

  static const Map<String, List<List<Object>>> _topics = {
    'CS-301 • Heuristic Search': [
      ['A* Admissibility', 88],
      ['Consistency Proofs', 71],
      ['Minimax & Pruning', 64],
      ['Graph Search Basics', 92],
    ],
    'CS-301 • Autograder': [
      ['DAG Construction', 79],
      ['Reverse-Mode Passes', 67],
      ['Gradient Checking', 58],
      ['Unit Test Hygiene', 85],
    ],
    'CS-301 • Neural Nets': [
      ['Backpropagation', 74],
      ['Activation Functions', 90],
      ['Regularization', 62],
      ['Optimizers', 77],
    ],
  };

  final _search = TextEditingController();

  String _range = '30D';
  String _module = _modules.first;
  String _sort = _sorts.first;
  String _filter = 'All';
  String _query = '';

  final List<_Student> _students = [
    _Student('Aisha Khan', 'CS301-0102', 93, 11, 'None flagged'),
    _Student('Bilal Ahmed', 'CS301-0287', 54, 3, 'Minimax & Pruning'),
    _Student('Hina Raza', 'CS301-0344', 81, 8, 'Consistency Proofs'),
    _Student('Usman Tariq', 'CS301-0412', 47, 2, 'Gradient Checking'),
    _Student('Sana Malik', 'CS301-0519', 88, 9, 'Regularization'),
    _Student('Farhan Ali', 'CS301-0620', 69, 5, 'Reverse-Mode Passes'),
    _Student('Maryam Iqbal', 'CS301-0733', 96, 12, 'None flagged'),
    _Student('Zain Abbas', 'CS301-0841', 72, 4, 'Backpropagation'),
  ];

  @override
  void dispose() {
    _search.dispose();
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

  Color _riskColor(String risk) {
    if (risk == 'High') return _red;
    if (risk == 'Medium') return _amber;
    return AppColors.teal;
  }

  Color _riskBg(String risk) {
    if (risk == 'High') return const Color(0xFFFFE3E0);
    if (risk == 'Medium') return const Color(0xFFFFE9CF);
    return AppColors.mint;
  }

  Color _barColor(int v) {
    if (v >= 80) return AppColors.teal;
    if (v >= 65) return AppColors.primary;
    return _amber;
  }

  int get _flagged => _students.where((s) => s.risk != 'Low').length;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/teacher-analytics',
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
                          _trendCard(),
                          const SizedBox(height: 16),
                          _rosterCard(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _topicCard(),
                          const SizedBox(height: 16),
                          _queueCard(),
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
            Text('Fall Semester 2025 • Learning Analytics',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Student Analytics',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'See how the cohort is progressing, which topics are slipping, and who needs a nudge before the next deadline.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _snack('Analytics exported (.CSV)'),
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Export Analytics (.CSV)'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: () => _snack('Data refreshed just now'),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Refresh Data'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
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
        'COHORT MASTERY',
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
      tile(
        'NEEDS ATTENTION',
        big('$_flagged', 'of ${_students.length}'),
        small('Students below 75% mastery in the tracked group'),
        icon(Icons.priority_high, const Color(0xFFFFE9CF), _amber),
      ),
      tile(
        'AVG WEEKLY STUDY',
        big('6.8', 'hrs'),
        small('Across 140 enrolled students'),
        icon(Icons.schedule, AppColors.chip, AppColors.primary),
      ),
      tile(
        'ON-TIME SUBMISSION',
        big('88.5%', ''),
        small('Last three assignments combined'),
        icon(Icons.task_alt_outlined, AppColors.mint, AppColors.teal),
      ),
    ], minItemWidth: 200);
  }

  // ---------- Trend chart ----------
  Widget _trendCard() {
    final labels = _trendLabels[_range]!;
    final values = _trendValues[_range]!;

    Widget chip(String label) {
      final sel = _range == label;
      return ChoiceChip(
        label: Text(
          label,
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
        onSelected: (_) => setState(() => _range = label),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cohort Mastery Trend',
              style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 4),
          Text('Average mastery score across all enrolled students.',
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.4, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [chip('7D'), chip('30D'), chip('Semester')],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < values.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${values[i]}',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              )),
                          const SizedBox(height: 4),
                          Container(
                            height: 120 * (values[i] / 100),
                            decoration: BoxDecoration(
                              color: _barColor(values[i]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(labels[i],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                  fontSize: 9, color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Student roster ----------
  Widget _rosterCard() {
    var list = _students.where((s) {
      if (_filter == 'At Risk' && s.risk == 'Low') return false;
      if (_filter == 'Top' && s.mastery < 85) return false;
      if (_query.isNotEmpty &&
          !s.name.toLowerCase().contains(_query.toLowerCase()) &&
          !s.id.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    if (_sort == _sorts[0]) {
      list.sort((a, b) => a.mastery.compareTo(b.mastery));
    } else if (_sort == _sorts[1]) {
      list.sort((a, b) => b.mastery.compareTo(a.mastery));
    } else {
      list.sort((a, b) => a.name.compareTo(b.name));
    }

    Widget tab(String label) {
      final sel = _filter == label;
      return ChoiceChip(
        label: Text(
          label,
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
          Text('Student Performance',
              style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 4),
          Text('Tap a student to see their weak topics and study pattern.',
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.4, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          _grid([
            TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v.trim()),
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textDark),
              decoration: InputDecoration(
                filled: true,
                fillColor: _field,
                hintText: 'Search name or ID',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            _drop(_sort, _sorts, (v) => _sort = v),
          ], minItemWidth: 220),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [tab('All'), tab('At Risk'), tab('Top')],
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No students match this view.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textGrey)),
              ),
            )
          else
            for (final s in list) _studentRow(s),
        ],
      ),
    );
  }

  Widget _studentRow(_Student s) {
    final color = _barColor(s.mastery);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showStudent(s),
      child: Container(
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
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.chip,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    s.name.substring(0, 1),
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          )),
                      Text('${s.id} • ${s.hours} hrs this week',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textGrey)),
                    ],
                  ),
                ),
                Pill('${s.risk} risk',
                    bg: _riskBg(s.risk), fg: _riskColor(s.risk), fontSize: 9),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('MASTERY',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textGrey)),
                const Spacer(),
                Text('${s.mastery}%',
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
                value: s.mastery / 100,
                minHeight: 6,
                backgroundColor: AppColors.chip,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStudent(_Student s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${s.id}'),
            const SizedBox(height: 6),
            Text('Mastery: ${s.mastery}%'),
            Text('Study time this week: ${s.hours} hrs'),
            Text('Risk level: ${s.risk}'),
            const SizedBox(height: 6),
            Text('Weakest topic: ${s.weak}'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close')),
          if (s.risk != 'Low' && !s.nudged)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _nudge(s);
              },
              child: const Text('Send Nudge'),
            ),
        ],
      ),
    );
  }

  void _nudge(_Student s) {
    setState(() => s.nudged = true);
    _snack('Nudge sent to ${s.name}');
  }

  // ---------- Topic mastery ----------
  Widget _topicCard() {
    final topics = _topics[_module]!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view_rounded,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Topic Mastery',
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
          Text('Where the cohort is strong and where it struggles',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          _drop(_module, _modules, (v) => _module = v),
          const SizedBox(height: 14),
          for (final t in topics)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(t[0] as String,
                            style: GoogleFonts.inter(
                                fontSize: 11, color: AppColors.textDark)),
                      ),
                      Text('${t[1]}%',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _barColor(t[1] as int),
                          )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (t[1] as int) / 100,
                      minHeight: 6,
                      backgroundColor: AppColors.chip,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          _barColor(t[1] as int)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------- Intervention queue ----------
  Widget _queueCard() {
    final queue = _students.where((s) => s.risk != 'Low').toList()
      ..sort((a, b) => a.mastery.compareTo(b.mastery));

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
                child: Text('Intervention Queue',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
              Pill('${queue.where((s) => !s.nudged).length} Pending',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 9),
            ],
          ),
          const SizedBox(height: 4),
          Text('Students most likely to benefit from a nudge',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          if (queue.isEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('Nobody needs a nudge right now.',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.teal)),
            )
          else
            for (final s in queue)
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
                        Expanded(
                          child: Text(s.name,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              )),
                        ),
                        Pill('${s.mastery}%',
                            bg: _riskBg(s.risk),
                            fg: _riskColor(s.risk),
                            fontSize: 9),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Struggling with ${s.weak}',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            height: 1.4,
                            color: AppColors.textGrey)),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: s.nudged ? null : () => _nudge(s),
                        icon: Icon(
                            s.nudged ? Icons.check : Icons.send_outlined,
                            size: 14),
                        label: Text(s.nudged ? 'Nudge sent' : 'Send Nudge'),
                        style: _btn(Colors.white, AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}