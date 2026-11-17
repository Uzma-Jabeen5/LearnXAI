import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Intervention {
  final String category;
  final String tag;
  final Color accent;
  final Color tagBg;
  final Color tagFg;
  final String scope;
  final String conf;
  final String lift;
  final String title;
  final String analysisTitle;
  final String analysis;
  final List<String> evidence;
  final String action;
  final String secondary;
  final String primary;

  const _Intervention({
    required this.category,
    required this.tag,
    required this.accent,
    required this.tagBg,
    required this.tagFg,
    required this.scope,
    required this.conf,
    required this.lift,
    required this.title,
    required this.analysisTitle,
    required this.analysis,
    required this.evidence,
    required this.action,
    required this.secondary,
    required this.primary,
  });
}

class TeacherRecommendationsScreen extends StatefulWidget {
  const TeacherRecommendationsScreen({super.key});

  @override
  State<TeacherRecommendationsScreen> createState() =>
      _TeacherRecommendationsScreenState();
}

class _TeacherRecommendationsScreenState
    extends State<TeacherRecommendationsScreen> {
  String _filter = 'All';

  static const _red = Color(0xFFB3261E);
  static const _amber = Color(0xFF8A4B00);

  static const _items = [
    _Intervention(
      category: 'Course Content',
      tag: 'Critical Pedagogical Block',
      accent: _red,
      tagBg: Color(0xFFFFE3E0),
      tagFg: _red,
      scope: 'Course: CS-301 (Machine Learning Foundations)',
      conf: '94.8% Bayesian Traced',
      lift: '+14.2% Est. Midterm Lift',
      title: 'Remediate Vector-Jacobian Transpose Projection Stagnation',
      analysisTitle: 'Causal Cognitive Root Analysis',
      analysis:
      '78% of students in Lecture Section A confuse reverse-mode automatic differentiation matrix dimensionality with forward-mode Jacobians during Quiz 3 Question 6. Students systematically miscompute tensor backward propagation shapes.',
      evidence: [
        '48 failed distractor attempts logged on matrix transpose question',
        '32 PyTorch shape mismatch autograder traces in Lab 3',
      ],
      action:
      'Inject 15-minute Interactive Computational Graph Trace into Lecture 3.4',
      secondary: 'Inspect Empirical Proofs',
      primary: 'Deploy Scaffolding Drill',
    ),
    _Intervention(
      category: 'Assessment Calibration',
      tag: 'Psychometric Drift Detected',
      accent: _amber,
      tagBg: Color(0xFFFFE9CF),
      tagFg: _amber,
      scope: 'Assessment: Quiz 4 (Optimization Surfaces)',
      conf: '91.2% Psychometric Conf.',
      lift: 'Prevents 8.5% Misclassification',
      title: 'Rebalance Question 4 Difficulty on Loss Surface Saddle Points',
      analysisTitle: 'Psychometric Diagnostic Trace',
      analysis:
      'Item discrimination index (D = 0.22) indicates ambiguity in Distractor C negative Hessian eigenvalue phrasing rather than fundamental knowledge gaps. Top-performing students are penalizing themselves over phrasing technicalities.',
      evidence: [
        '42 top-quartile students wrongly selected distractor C',
        'Negative point-biserial coefficient detected (-0.18)',
      ],
      action:
      'Re-weight distractor ambiguity or trigger automated student clarification hint',
      secondary: 'Review Distractor Analytics',
      primary: 'Apply Item Correction',
    ),
    _Intervention(
      category: 'Student Engagement',
      tag: 'Honors Acceleration Opportunity',
      accent: AppColors.teal,
      tagBg: AppColors.mint,
      tagFg: AppColors.teal,
      scope: 'Track: CS-301 Honours / Lab 4',
      conf: '98.2% Calibrated Certainty',
      lift: 'ABET Criterion 5 Lift',
      title:
      'Activate Monte Carlo Tree Search Stretch Challenge for Upper Quartile',
      analysisTitle: 'Cognitive Velocity Telemetry',
      analysis:
      'Top 35% of the student cohort (49 students) achieved 100% test-suite completion on Minimax Alpha-Beta pruning 48 hours ahead of schedule with zero AST syntax faults. Current cognitive idle time is increasing.',
      evidence: [
        '48 hours ahead of baseline lab pacing',
        'Ready for Competitive Sandbox deployment',
      ],
      action:
      'Auto-unlock optional MCTS sandbox for tournament bonus credits',
      secondary: 'Configure Grading Weights',
      primary: 'Release Stretch Module',
    ),
  ];

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/recommendations',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.64 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;
          final tileW =
          c.maxWidth >= 700 ? (inner - 36) / 4 : (inner - 12) / 2;

          final list = _items
              .where((i) => _filter == 'All' || i.category == _filter)
              .toList();

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _crumbs(),
                const SizedBox(height: 8),
                _header(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: tileW,
                      child: _tile('TEACHING EFFECTIVENESS', '94.2', '/ 100',
                          '+3.8%', AppColors.mint, AppColors.teal),
                    ),
                    SizedBox(
                      width: tileW,
                      child: _tile('COHORT COGNITIVE TELEMETRY', '91.8%',
                          'Active', '140 Enrolled', AppColors.chip,
                          AppColors.primary),
                    ),
                    SizedBox(
                      width: tileW,
                      child: _tile('CURRICULAR HEALTH', '88.5%', 'Mastery',
                          '1 Flagged', const Color(0xFFFFE9CF), _amber),
                    ),
                    SizedBox(
                      width: tileW,
                      child: _tile('REMEDIATION PIPELINES', '14',
                          'Students Rescued', '3 Deployed', AppColors.mint,
                          AppColors.teal),
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
                    SizedBox(
                      width: mainW,
                      child: Column(
                        children: [
                          if (list.isEmpty)
                            _empty()
                          else
                            for (final i in list) ...[
                              _card(i),
                              const SizedBox(height: 16),
                            ],
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _engine(),
                          const SizedBox(height: 16),
                          _abet(),
                          const SizedBox(height: 16),
                          _queue(),
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

  Widget _crumbs() {
    return Text(
      'Academic Operations  >  Faculty Pedagogical Decision Support  >  Curricular Interventions',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Recommendations & Curricular Interventions',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Explainable AI-driven pedagogical suggestions and cognitive remediation strategies calibrated to optimize student learning velocity and guarantee ABET Criterion 3 & 5 compliance.',
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
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Pill('Model Sensitivity: 0.85',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 11),
            ElevatedButton.icon(
              onPressed: () => _snack('Telemetry synthesized'),
              icon: const Icon(Icons.bolt, size: 18),
              label: const Text('Synthesize Telemetry'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
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

  // Full-width button that truncates long labels instead of overflowing.
  Widget _wideBtn(IconData icon, String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: _btn(AppColors.chip, AppColors.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Stat tile (fixed) ----------
  Widget _tile(String label, String value, String unit, String pill,
      Color pillBg, Color pillFg) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 10,
              letterSpacing: 0.4,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 6),
          Pill(pill, bg: pillBg, fg: pillFg, fontSize: 9),
          const SizedBox(height: 8),
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
        ],
      ),
    );
  }

  Widget _filters() {
    const options = [
      'All',
      'Teaching Improvement',
      'Course Content',
      'Student Engagement',
      'Assessment Calibration',
    ];
    const counts = {
      'All': 12,
      'Teaching Improvement': 4,
      'Course Content': 3,
      'Student Engagement': 3,
      'Assessment Calibration': 2,
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          ChoiceChip(
            label: Text(
              o == 'All'
                  ? 'All Interventions (${counts[o]})'
                  : '$o (${counts[o]})',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _filter == o ? Colors.white : AppColors.textDark,
              ),
            ),
            selected: _filter == o,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.chip,
            showCheckmark: false,
            onSelected: (_) => setState(() => _filter = o),
          ),
      ],
    );
  }

  Widget _empty() {
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No interventions in this category.',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
          ),
        ),
      ),
    );
  }

  // ---------- Intervention card (fixed, no IntrinsicHeight) ----------
  Widget _card(_Intervention i) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Pill(i.tag, bg: i.tagBg, fg: i.tagFg, fontSize: 10),
                    Text(
                      i.scope,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Pill(i.conf,
                        bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
                    Pill(i.lift,
                        bg: const Color(0xFFFFE9CF), fg: _amber, fontSize: 10),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  i.title,
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.hub_outlined,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              i.analysisTitle,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        i.analysis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          height: 1.55,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (final e in i.evidence)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Icon(Icons.circle,
                                    size: 6, color: AppColors.textGrey),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  e,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.auto_fix_high,
                          size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        i.action,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          height: 1.4,
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
                      onPressed: () => _snack(i.secondary),
                      style: _btn(AppColors.chip, AppColors.textDark),
                      child: Text(i.secondary),
                    ),
                    ElevatedButton(
                      onPressed: () => _snack('${i.primary}: done'),
                      style: _btn(AppColors.primaryLight, Colors.white),
                      child: Text(i.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: ColoredBox(color: i.accent),
          ),
        ],
      ),
    );
  }

  Widget _sideTitle(String t, {String? pill, Color? bg, Color? fg}) {
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
          Pill(pill,
              bg: bg ?? AppColors.mint,
              fg: fg ?? AppColors.teal,
              fontSize: 9),
        ],
      ],
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              k,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _engine() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sideTitle('Inference Engine', pill: 'DETERMINISTIC 4.2'),
          const SizedBox(height: 14),
          _kv('Pedagogical Model', 'LearnX-DeepTeach v4.2'),
          _kv('Knowledge Tracing', 'DKT + Bayesian IRT'),
          _kv('Last Telemetry Sync', '3 mins ago (Real-time)'),
          Row(
            children: [
              Flexible(
                child: Text(
                  'Inference Confidence',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textGrey),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.964,
                    minHeight: 6,
                    backgroundColor: AppColors.chip,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '96.4%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _abet() {
    Widget criterion(
        String name, String status, double v, Color color, String note) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 6,
                backgroundColor: AppColors.chip,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              note,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textGrey,
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
          _sideTitle('ABET Remediation Matrix',
              pill: 'AY 2025-26', bg: AppColors.chip, fg: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            'Continuous assessment adherence mapping student intervention success against engineering accreditation criteria.',
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 14),
          criterion('Criterion 1: Complex Problem Solving', '92% Met', 0.92,
              AppColors.teal, 'Intervention #1 directly supports this standard'),
          criterion(
              'Criterion 3: Engineering Analysis & Data',
              '79% (At Risk)',
              0.79,
              _amber,
              'Hessian Saddle Point rebalancing will restore index to 86%'),
          criterion(
              'Criterion 5: Autonomous Algorithmic Design',
              '98% Exceeded',
              0.98,
              AppColors.primaryLight,
              'Honors MCTS Challenge activates high-tier evidence'),
        ],
      ),
    );
  }

  Widget _queue() {
    Widget student(String initials, String name, String idx, Color color) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Text(
                initials,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
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
                    'Conf. Index: $idx',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _snack('Invitation sent to $name'),
              child: Text(
                'Invite',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
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
          _sideTitle('Priority Student Queue',
              pill: '4 Queued', bg: const Color(0xFFFFE3E0), fg: _red),
          const SizedBox(height: 6),
          Text(
            'Students flagged by DKT for one-on-one Jacobian matrix clarification before Midterm:',
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 12),
          student('MK', 'Mustafa Karim', '41%', AppColors.primary),
          student('ZA', 'Zoya Al-Mansoor', '44%', AppColors.teal),
          student('BL', 'Bilal Tariq', '52%', const Color(0xFF6B3A00)),
          const SizedBox(height: 4),
          _wideBtn(Icons.event_outlined, 'Schedule Auto-Office Hours Slot',
                  () => _snack('Office hours slot scheduled')),
          const SizedBox(height: 8),
          _wideBtn(Icons.picture_as_pdf_outlined,
              'Export Remediation Plan (ABET PDF)',
                  () => _snack('Remediation plan exported')),
        ],
      ),
    );
  }
}