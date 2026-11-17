import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Insight {
  final String title;
  final String body;
  final String type; // Risk, Content, Pacing
  final int confidence;
  final String action;
  bool applied;
  bool dismissed;

  _Insight(this.title, this.body, this.type, this.confidence, this.action,
      {this.applied = false, this.dismissed = false});
}

class _Msg {
  final String q;
  final String a;
  _Msg(this.q, this.a);
}

class _Action {
  final String title;
  bool done;
  _Action(this.title, this.done);
}

class _Source {
  final String name;
  final String desc;
  bool on;
  _Source(this.name, this.desc, this.on);
}

class TeacherAiInsightsScreen extends StatefulWidget {
  const TeacherAiInsightsScreen({super.key});

  @override
  State<TeacherAiInsightsScreen> createState() =>
      _TeacherAiInsightsScreenState();
}

class _TeacherAiInsightsScreenState extends State<TeacherAiInsightsScreen> {
  static const _soft = Color(0xFFF4F7FF);
  static const _field = Color(0xFFF1F1FF);
  static const _amber = Color(0xFF8A4B00);
  static const _red = Color(0xFFB3261E);

  static const _suggestions = [
    'Who is at risk of failing?',
    'Which topic needs more practice?',
    'Is the Lab 3 deadline a problem?',
  ];

  final _ask = TextEditingController();

  String _filter = 'All';

  final List<_Insight> _insights = [
    _Insight(
      '7 students are trending toward failing Lab 3',
      'Their commit activity dropped 60% this week and none have opened the gradient checker spec. Early contact now gives them time to recover before Oct 28.',
      'Risk',
      91,
      'Send Nudge to 7 Students',
    ),
    _Insight(
      'Lab 3 deadline overlaps the CS-340 midterm',
      '42 students share both courses and the deadline falls the day after their midterm. Moving it two days cuts the predicted stress load noticeably.',
      'Pacing',
      88,
      'Move Deadline to Oct 30',
    ),
    _Insight(
      'Minimax & Pruning is the weakest topic',
      'Cohort mastery sits at 64%, well under the 84% average. Most wrong answers come from tracing alpha-beta cutoffs by hand.',
      'Content',
      84,
      'Add Practice Set',
    ),
    _Insight(
      'Lecture 6 loses viewers at 18:30',
      '42% of students stop watching at the same point, right after the consistency proof begins. A short worked example before that point should help.',
      'Content',
      79,
      'Split Lecture in Two',
    ),
    _Insight(
      'The cohort is finishing quizzes faster than planned',
      'Average completion time is 20% under the estimate for the last three quizzes, with scores holding steady. There is room to release the next module early.',
      'Pacing',
      72,
      'Unlock Next Module',
    ),
  ];

  final List<_Msg> _chat = [];

  final List<_Action> _actions = [
    _Action('Review the 7 at-risk students from Lab 3', false),
    _Action('Confirm the new Lab 3 deadline with the registrar', false),
    _Action('Upload a Minimax practice worksheet', false),
    _Action('Re-record the consistency proof segment', false),
  ];

  final List<_Source> _sources = [
    _Source('Submission activity', 'Commits, uploads and timing.', true),
    _Source('Quiz & exam scores', 'Marks and per-topic results.', true),
    _Source('Video engagement', 'Watch time and drop-off points.', true),
    _Source('Proctoring signals', 'Integrity flags from exams.', false),
  ];

  @override
  void dispose() {
    _ask.dispose();
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

  Color _typeColor(String t) {
    if (t == 'Risk') return _red;
    if (t == 'Pacing') return _amber;
    return AppColors.primary;
  }

  Color _typeBg(String t) {
    if (t == 'Risk') return const Color(0xFFFFE3E0);
    if (t == 'Pacing') return const Color(0xFFFFE9CF);
    return AppColors.chip;
  }

  IconData _typeIcon(String t) {
    if (t == 'Risk') return Icons.warning_amber_rounded;
    if (t == 'Pacing') return Icons.schedule;
    return Icons.menu_book_outlined;
  }

  int get _pending =>
      _insights.where((i) => !i.dismissed && !i.applied).length;

  int get _appliedCount => _insights.where((i) => i.applied).length;

  int get _avgConfidence {
    final live = _insights.where((i) => !i.dismissed).toList();
    if (live.isEmpty) return 0;
    final total = live.fold<int>(0, (s, i) => s + i.confidence);
    return (total / live.length).round();
  }

  int get _sourcesOn => _sources.where((s) => s.on).length;

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/teacher-ai-insights',
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
                          _feedCard(),
                          const SizedBox(height: 16),
                          _askCard(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _confidenceCard(),
                          const SizedBox(height: 16),
                          _actionsCard(),
                          const SizedBox(height: 16),
                          _sourcesCard(),
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
            Text('Fall Semester 2025 • Faculty Intelligence',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'AI Insights',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'The engine reads submissions, scores and video activity, then suggests what to do next. Apply a suggestion, dismiss it, or ask a question of your own.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _snack('Insights exported (.PDF)'),
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Export Insights (.PDF)'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: _resetInsights,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset Insights'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  void _resetInsights() {
    setState(() {
      for (final i in _insights) {
        i.applied = false;
        i.dismissed = false;
      }
      _filter = 'All';
    });
    _snack('All insights restored');
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
        'NEW INSIGHTS',
        big('$_pending', 'Waiting'),
        small('Suggestions you have not acted on yet'),
        icon(Icons.auto_awesome, AppColors.chip, AppColors.primary),
      ),
      tile(
        'ACTIONS APPLIED',
        big('$_appliedCount', 'of ${_insights.length}'),
        small('Suggestions you accepted this term'),
        icon(Icons.task_alt_outlined, AppColors.mint, AppColors.teal),
      ),
      tile(
        'AVG CONFIDENCE',
        big('$_avgConfidence%', ''),
        small('Across the insights still on the board'),
        icon(Icons.speed_outlined, const Color(0xFFFFE9CF), _amber),
      ),
      tile(
        'DATA SOURCES',
        big('$_sourcesOn', 'of ${_sources.length}'),
        small('Feeding the engine right now'),
        icon(Icons.storage_outlined, AppColors.mint, AppColors.teal),
      ),
    ], minItemWidth: 200);
  }

  // ---------- Insight feed ----------
  Widget _feedCard() {
    final list = _insights.where((i) {
      if (i.dismissed) return false;
      if (_filter == 'All') return true;
      return i.type == _filter;
    }).toList();

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
          Text('Insight Feed',
              style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 4),
          Text('Ranked by how much each one could change the term.',
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.4, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [tab('All'), tab('Risk'), tab('Content'), tab('Pacing')],
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No insights in this view.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textGrey)),
              ),
            )
          else
            for (final i in list) _insightRow(i),
        ],
      ),
    );
  }

  Widget _insightRow(_Insight i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: i.applied ? AppColors.mint : _soft,
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
                  color: _typeBg(i.type),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_typeIcon(i.type),
                    size: 19, color: _typeColor(i.type)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(i.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        )),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Pill(i.type,
                            bg: _typeBg(i.type),
                            fg: _typeColor(i.type),
                            fontSize: 9),
                        Text('${i.confidence}% confidence',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.textGrey)),
                        if (i.applied)
                          const Pill('Applied',
                              bg: Colors.white,
                              fg: AppColors.teal,
                              fontSize: 9),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(i.body,
              style: GoogleFonts.inter(
                  fontSize: 11, height: 1.5, color: AppColors.textDark)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: i.applied
                    ? null
                    : () {
                  setState(() => i.applied = true);
                  _snack('Applied: ${i.action}');
                },
                icon: Icon(i.applied ? Icons.check : Icons.bolt_outlined,
                    size: 16),
                label: Text(i.applied ? 'Applied' : i.action),
                style: _btn(AppColors.primaryLight, Colors.white),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => i.dismissed = true);
                  _snack('Insight dismissed');
                },
                style: _btn(Colors.white, AppColors.textGrey),
                child: const Text('Dismiss'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Ask the engine ----------
  String _answer(String q) {
    final t = q.toLowerCase();
    if (t.contains('risk') || t.contains('fail') || t.contains('struggl')) {
      return '7 students look at risk on Lab 3. Their activity fell about 60% this week. Usman Tariq and Bilal Ahmed are the lowest on mastery, so a nudge to those two first would be sensible.';
    }
    if (t.contains('deadline') || t.contains('overlap') || t.contains('lab 3')) {
      return 'Yes, it is a problem. The Oct 28 deadline sits right after the CS-340 midterm on Oct 27, and 42 students share both. Moving it to Oct 30 is the cleanest fix.';
    }
    if (t.contains('topic') || t.contains('practice') || t.contains('weak')) {
      return 'Minimax & Pruning is the weakest at 64%, followed by Regularization at 62% in the Neural Nets module. A short practice set on alpha-beta tracing would help most.';
    }
    if (t.contains('video') || t.contains('lecture')) {
      return 'Lecture 6 loses 42% of viewers at 18:30, right where the consistency proof starts. Splitting it or adding a worked example there should bring them back.';
    }
    return 'I could not match that to a pattern in the current data. Try asking about at-risk students, weak topics, deadlines or lecture engagement.';
  }

  void _send(String text) {
    final q = text.trim();
    if (q.isEmpty) {
      _snack('Type a question first');
      return;
    }
    setState(() {
      _chat.insert(0, _Msg(q, _answer(q)));
      _ask.clear();
    });
  }

  Widget _askCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_alt_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Ask the Insight Engine',
                    style: GoogleFonts.manrope(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
              if (_chat.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => _chat.clear()),
                  child: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Ask about your cohort in plain words.',
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ask,
                  onSubmitted: _send,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.textDark),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _field,
                    hintText: 'e.g. Which topic needs more practice?',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _send(_ask.text),
                style: _btn(AppColors.primaryLight, Colors.white),
                child: const Icon(Icons.send_rounded, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in _suggestions)
                ActionChip(
                  label: Text(s,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textDark)),
                  backgroundColor: AppColors.chip,
                  side: BorderSide.none,
                  onPressed: () => _send(s),
                ),
            ],
          ),
          if (_chat.isNotEmpty) const SizedBox(height: 14),
          for (final m in _chat)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.q,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      )),
                  const SizedBox(height: 6),
                  Text(m.a,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          height: 1.5,
                          color: AppColors.textGrey)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------- Confidence ----------
  Widget _confidenceCard() {
    Widget bar(String name, double v, Color color) {
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
                Text('${(v * 100).round()}%',
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

    // More sources switched on means a higher base confidence.
    final base = 0.55 + (_sourcesOn / _sources.length) * 0.35;

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
                child: Text('Model Confidence',
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
          Text('How sure the engine is, by insight type',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          bar('Risk predictions', (base + 0.04).clamp(0.0, 1.0), _red),
          bar('Content suggestions', base.clamp(0.0, 1.0),
              AppColors.primary),
          bar('Pacing advice', (base - 0.06).clamp(0.0, 1.0), _amber),
          Text('Switch data sources on below to raise these numbers.',
              style: GoogleFonts.inter(
                  fontSize: 10, height: 1.4, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  // ---------- Recommended actions ----------
  Widget _actionsCard() {
    final done = _actions.where((a) => a.done).length;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.checklist_rounded,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Recommended Actions',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
              Pill('$done / ${_actions.length}',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 9),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: done / _actions.length,
              minHeight: 6,
              backgroundColor: AppColors.chip,
              valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.teal),
            ),
          ),
          const SizedBox(height: 10),
          for (final a in _actions)
            CheckboxListTile(
              value: a.done,
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.primary,
              title: Text(a.title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    height: 1.4,
                    color: a.done ? AppColors.textGrey : AppColors.textDark,
                    decoration: a.done ? TextDecoration.lineThrough : null,
                  )),
              onChanged: (v) => setState(() => a.done = v ?? false),
            ),
        ],
      ),
    );
  }

  // ---------- Data sources ----------
  Widget _sourcesCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Data Sources',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Choose what the engine is allowed to read',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 12),
          for (final s in _sources)
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
                        Text(s.name,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            )),
                        const SizedBox(height: 2),
                        Text(s.desc,
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  Switch(
                    value: s.on,
                    activeTrackColor: AppColors.primary,
                    onChanged: (v) => setState(() => s.on = v),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}