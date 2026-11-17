import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class _Model {
  final String name;
  final IconData icon;
  final String version;
  final String subsystem;
  final String retrained;
  final String arch;
  final String extra;
  final String desc;
  final List<List<String>> metrics;
  final String health;
  final bool shadow;
  bool live;

  _Model({
    required this.name,
    required this.icon,
    required this.version,
    required this.subsystem,
    required this.retrained,
    required this.arch,
    required this.extra,
    required this.desc,
    required this.metrics,
    required this.health,
    this.shadow = false,
    this.live = true,
  });
}

class AdminModelsScreen extends StatefulWidget {
  const AdminModelsScreen({super.key});

  @override
  State<AdminModelsScreen> createState() => _AdminModelsScreenState();
}

class _AdminModelsScreenState extends State<AdminModelsScreen> {
  static const _statuses = [
    'Status: All',
    'Status: Active Serving',
    'Status: Calibrating'
  ];
  static const _systems = [
    'Subsystem: All Domains',
    'Prediction',
    'Tutoring',
    'Curriculum'
  ];

  String _query = '';
  String _status = _statuses.first;
  String _system = _systems.first;

  final List<_Model> _models = [
    _Model(
      name: 'Student Performance Predictor',
      icon: Icons.psychology_outlined,
      version: 'v3.2.0',
      subsystem: 'Prediction',
      retrained: 'Retrained Oct 20, 2025',
      arch: 'Multi-Task Transformer & Causal Graph',
      extra: 'Dataset: 2.4M interaction traces',
      desc:
      'Predicts student cognitive fatigue and milestone completion 14 days in advance, continuously inferring latent course mastery trajectories and issuing early warning flags for academic remediation.',
      metrics: [
        ['Inference Accuracy', '92.4%', '▲ +0.8% vs v3.1'],
        ['Precision Score', '94.1%', 'AUC: 0.962'],
        ['Sensitivity Recall', '91.8%', 'Type II Minimized'],
        ['Median Latency', '12 ms', '4 Pods Dedicated'],
      ],
      health: 'Model Health: Drift delta 0.02 (Optimal)',
    ),
    _Model(
      name: 'Weak Topic & Misconception Detector',
      icon: Icons.center_focus_strong_outlined,
      version: 'v4.1.2',
      subsystem: 'Tutoring',
      retrained: 'Retrained Oct 22, 2025',
      arch: 'Bayesian Knowledge Tracing (BKT) + AST Differential',
      extra: 'Distractor C Error Recognition',
      desc:
      'Detects subtle semantic pitfalls and algorithmic errors in student assignment submissions via code AST differentials and continuous knowledge decay modeling.',
      metrics: [
        ['Diagnostics Acc', '88.6%', 'High Confidence'],
        ['F1-Score', '91.2%', 'Weighted Harmonic'],
        ['Recall', '93.0%', 'Zero Graph Leak'],
        ['Median Latency', '16 ms', '6 Pods Dedicated'],
      ],
      health: 'Canary active: 10% on CS-301',
    ),
    _Model(
      name: 'Socratic Recommendation Engine',
      icon: Icons.chat_bubble_outline,
      version: 'v2.8.4',
      subsystem: 'Tutoring',
      retrained: 'Retrained Oct 18, 2025',
      arch: 'Policy-Constrained Guided Scaffolding',
      extra: 'In-lecture Micro-Remediations',
      desc:
      'Generates dynamically stepped hints without handing over direct solutions. Uses pedagogical constraints to steer students toward self-directed reasoning and intuition validation.',
      metrics: [
        ['Alignment Index', '96.2%', 'Strict Pedagogical'],
        ['Safety Compliance', '99.4%', 'Zero Solution Leaks'],
        ['Scaffold Quality', '4.8 / 5.0', 'Faculty Rated'],
        ['Median Latency', '22 ms', '4 Pods Dedicated'],
      ],
      health: 'RLHF Policy: Enforced v1.8',
    ),
    _Model(
      name: 'Curricular Friction Evaluator',
      icon: Icons.account_tree_outlined,
      version: 'v1.0.0',
      subsystem: 'Curriculum',
      retrained: 'Retrained Oct 24, 2025',
      arch: 'Attention Graph Density & Dwell-Time Regressor',
      extra: 'Validation Run 88/100',
      desc:
      'Correlates lecture playback scrubbing, code editor dwell times, and submission friction points to identify poorly authored curriculum modules before end-of-semester course evaluations.',
      metrics: [
        ['Validation Accuracy', '94.0%', 'Converging'],
        ['Pearson Correlation', 'r = 0.89', 'p < 0.001'],
        ['Dwell-Time Fit', '0.038 MSE', 'Target < 0.05'],
        ['Latency Bench', '18 ms', '2 Pods Shadowed'],
      ],
      health: 'Shadow traffic parity: 99.8% match',
      shadow: true,
      live: false,
    ),
  ];

  List<_Model> get _filtered {
    return _models.where((m) {
      final q = _query.trim().toLowerCase();
      final okQ = q.isEmpty ||
          m.name.toLowerCase().contains(q) ||
          m.arch.toLowerCase().contains(q);
      final okS = _status == _statuses.first ||
          (_status == _statuses[1] && m.live) ||
          (_status == _statuses[2] && !m.live);
      final okD = _system == _systems.first || m.subsystem == _system;
      return okQ && okS && okD;
    }).toList();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    final rows = _filtered;
    return AppShell(
      currentRoute: '/admin-models',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'AI Model Registry',
              tag: '4 Production Models • Calibrated v4.2',
              subtitle:
              'Manage, monitor, benchmark, and calibrate Explainable AI inference pipelines across student learning diagnostics, automated tutoring interventions, and faculty telemetry.',
              actions: [
                AdminButton('Export Benchmark Audit',
                    icon: Icons.download_outlined,
                    onTap: () => _snack('Benchmark audit export started')),
                AdminButton('Register New Model',
                    icon: Icons.add_circle_outline,
                    primary: true,
                    onTap: () => _snack('Model registration form coming soon')),
              ],
            ),
            const SizedBox(height: 20),
            _stats(),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: Column(
                children: [
                  _filters(),
                  const SizedBox(height: 20),
                  if (rows.isEmpty)
                    AdminCard(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text('No models match these filters',
                              style: GoogleFonts.inter(
                                  color: AppColors.textGrey)),
                        ),
                      ),
                    ),
                  for (final m in rows) ...[
                    _modelCard(m),
                    const SizedBox(height: 20),
                  ],
                  const _TrainingCard(),
                ],
              ),
              side: Column(
                children: [
                  const _DriftCard(),
                  const SizedBox(height: 20),
                  const _AbCard(),
                  const SizedBox(height: 20),
                  const _SafetyCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Stats ----------------

  Widget _stats() {
    return const AdminGrid(
      minItemWidth: 200,
      gap: 14,
      children: [
        _Stat('TOTAL AI MODELS', '4 Models', Icons.layers_outlined,
            AdminColors.indigo, '● 100% active in runtime  •  Cluster Alpha'),
        _Stat('INFERENCE NODES', '16 Pods', Icons.bolt_outlined,
            AdminColors.teal, '14.2 ms / token P95  •  4.8k QPS Peak',
            tag: '+2 Autoscaled'),
        _Stat('DIAGNOSTIC ACCURACY', '94.8%', Icons.track_changes_outlined,
            AdminColors.indigo, 'Target threshold: 92.0%',
            tag: '+1.4% Lift'),
        _Stat('LAST CALIBRATION', '18m ago', Icons.sync, AdminColors.indigo,
            'Bayesian Tracing • CRON-04'),
      ],
    );
  }

  // ---------------- Filters ----------------

  Widget _filters() {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: AdminGrid(
        minItemWidth: 180,
        gap: 10,
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20, color: AppColors.textGrey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Filter models by architecture...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 13.5, color: AppColors.textGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _drop(_status, _statuses, (v) => _status = v),
          _drop(_system, _systems, (v) => _system = v),
        ],
      ),
    );
  }

  Widget _drop(String value, List<String> items, void Function(String) set) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark),
          items: [
            for (final i in items) DropdownMenuItem(value: i, child: Text(i))
          ],
          onChanged: (v) {
            if (v != null) setState(() => set(v));
          },
        ),
      ),
    );
  }

  // ---------------- Model card ----------------

  Widget _modelCard(_Model m) {
    final shadow = !m.live;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: shadow
            ? const Border(
            left: BorderSide(color: Color(0xFFF59E0B), width: 4))
            : null,
      ),
      child: AdminCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: shadow
                        ? const Color(0xFFFFE9CF)
                        : AppColors.chip,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(m.icon,
                      color: shadow
                          ? AdminColors.brown
                          : AdminColors.indigo),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(m.name,
                              style: GoogleFonts.manrope(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark)),
                          AdminTag(m.version, fontSize: 10),
                          shadow
                              ? const AdminTag('Calibrating (Shadow Mode)',
                              bg: Color(0xFFFFE9CF),
                              fg: Color(0xFF8A4B00),
                              fontSize: 10)
                              : const AdminTag('● Active & Serving',
                              bg: AppColors.mintBright,
                              fg: AppColors.teal,
                              fontSize: 10),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('${m.arch}  •  ${m.extra}',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.textGrey)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(m.retrained,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(m.desc,
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppColors.textGrey)),
            ),
            const SizedBox(height: 14),
            AdminGrid(
              minItemWidth: 120,
              gap: 10,
              children: [
                for (final x in m.metrics)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AdminColors.soft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(x[0],
                            style: GoogleFonts.inter(
                                fontSize: 10.5, color: AppColors.textGrey)),
                        const SizedBox(height: 4),
                        Text(x[1],
                            style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Text(x[2],
                            style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: AdminColors.indigo)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('● ${m.health}',
                    style: GoogleFonts.inter(
                        fontSize: 11.5, color: AppColors.textGrey)),
                if (shadow) ...[
                  _small(Icons.rule, 'Review Validation Loss',
                          () => _snack('Opening validation loss report')),
                  _small(Icons.rocket_launch_outlined, 'Deploy to Live', () {
                    setState(() => m.live = true);
                    _snack('${m.name} deployed to live traffic');
                  }, fill: AdminColors.teal),
                  InkWell(
                    onTap: () => _snack('${m.name} disabled'),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Disable',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AdminColors.red)),
                    ),
                  ),
                ] else ...[
                  _small(Icons.tune, 'Inspect Weights',
                          () => _snack('Inspecting weights for ${m.name}')),
                  _small(Icons.speed, 'Benchmark Test',
                          () => _snack('Benchmark started for ${m.name}')),
                  _small(Icons.history, 'Manage Version',
                          () => _snack('Version manager for ${m.version}'),
                      fill: AdminColors.indigo),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _small(IconData icon, String label, VoidCallback onTap,
      {Color? fill}) {
    final fg = fill != null ? Colors.white : AppColors.textDark;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: fill ?? AdminColors.soft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: fg),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11.5, fontWeight: FontWeight.w600, color: fg)),
          ],
        ),
      ),
    );
  }
}

// ======================= Stat card =======================

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String sub;
  final String? tag;

  const _Stat(this.label, this.value, this.icon, this.color, this.sub,
      {this.tag});

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
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textGrey)),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 19, color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(value,
                  style: GoogleFonts.manrope(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              if (tag != null)
                AdminTag(tag!,
                    bg: AppColors.mintBright,
                    fg: AppColors.teal,
                    fontSize: 10),
            ],
          ),
          const SizedBox(height: 8),
          Text(sub,
              style: GoogleFonts.inter(
                  fontSize: 11.5, height: 1.35, color: AppColors.textGrey)),
        ],
      ),
    );
  }
}

// ======================= Side cards =======================

class _DriftCard extends StatelessWidget {
  const _DriftCard();

  Widget _row(String l, Widget r) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(l,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textGrey)),
        ),
        r,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_outlined,
                  size: 20, color: AdminColors.indigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Health & Drift Detection',
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              const AdminTag('Live Feed',
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Real-time Drift Index (PSI)',
                          style: GoogleFonts.inter(
                              fontSize: 11.5, color: AppColors.textGrey)),
                    ),
                    Text('0.04',
                        style: GoogleFonts.robotoMono(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AdminColors.indigo)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.04 / 0.15,
                    minHeight: 6,
                    backgroundColor: AppColors.chip,
                    color: AdminColors.indigo,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text('Current: 0.04',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textGrey)),
                    ),
                    Text('Threshold Boundary: < 0.15',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          _row(
              'Feature Attribution Stability',
              Text('98.7%',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark))),
          _row(
              'FERPA/ABET Calibration Boundary',
              Text('✔ Compliant',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teal))),
          _row(
              'Cluster Compute Allocation',
              Text('4x NVIDIA A100',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark))),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('64 vCPUs • 256GB Unified RAM',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textGrey)),
                    ),
                    Text('68% Utilized',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.68,
                    minHeight: 6,
                    backgroundColor: AppColors.chip,
                    color: AdminColors.indigo,
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

class _AbCard extends StatelessWidget {
  const _AbCard();

  @override
  Widget build(BuildContext context) {
    Widget row(String l, String r) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(l,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textGrey)),
          ),
          Flexible(
            child: Text(r,
                textAlign: TextAlign.right,
                style: GoogleFonts.robotoMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
          ),
        ],
      ),
    );

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Active A/B Experimentation',
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              const AdminTag('Canary', fontSize: 10),
            ],
          ),
          const SizedBox(height: 10),
          row('Candidate:', 'BKT-v4.2-Candidate'),
          row('Production Baseline:', 'v4.1.2-Stable'),
          row('Traffic Partitioning:', '10% Canary (CS-301 Sec B)'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.mintBright.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('↗ +3.2% Lift Measured',
                    style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal)),
                const SizedBox(height: 4),
                Text(
                    'Statistically significant increase in true positive misconception recovery without latency degradation.',
                    style: GoogleFonts.inter(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AdminButton('Promote Candidate to Primary',
              icon: Icons.rocket_launch_outlined,
              primary: true,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Candidate promoted to primary')))),
        ],
      ),
    );
  }
}

class _SafetyCard extends StatelessWidget {
  const _SafetyCard();

  static const _items = [
    [
      'ABET Algorithmic Audit 2023-2029',
      'Validated unbiased diagnostic scoring across international student demographics.',
      'STATUS: PASSED',
      Icons.verified_outlined
    ],
    [
      'Hallucination Suppression',
      'Multi-hop reflection anchoring against official course syllabi and lab test suites.',
      '99.98% Index Score',
      Icons.shield_outlined
    ],
    [
      'Zero-Direct-Solution Constraint',
      'Engine strictly forbidden from outputting copy-paste code completions during graded milestones.',
      'POLICY ENFORCED',
      Icons.lock_outline
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Safety & Compliance',
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              const AdminTag('Strict',
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 12),
          for (final it in _items)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(it[3] as IconData,
                      size: 20, color: AdminColors.indigo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it[0] as String,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Text(it[1] as String,
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                height: 1.35,
                                color: AppColors.textGrey)),
                        const SizedBox(height: 4),
                        Text(it[2] as String,
                            style: GoogleFonts.robotoMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AdminColors.indigo)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Text('Continuous Security Hash: #a4f169d',
                    style: GoogleFonts.inter(
                        fontSize: 10.5, color: AppColors.textGrey)),
              ),
              Text('Audit Ledger ↗',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AdminColors.indigo)),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================= Training + volume charts =======================

class _TrainingCard extends StatelessWidget {
  const _TrainingCard();

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionTitle(
            'Model Training Epochs & Convergence Telemetry',
            subtitle:
            'Cross-model loss decay & precision trajectories measured across the last 120 calibration epochs',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 18,
            runSpacing: 6,
            children: [
              _legend(AdminColors.indigo, 'Predictor'),
              _legend(AdminColors.teal, 'BKT Misconception'),
              _legend(const Color(0xFFF59E0B), 'Curricular Shadow'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(painter: _EpochPainter()),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text('24-Hour Inference Request Volume',
                    style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              Flexible(
                child: Text('Peak: 42,180 req/hr (2:00 PM EST Lab Block)',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                        fontSize: 10.5, color: AdminColors.indigo)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            width: double.infinity,
            child: CustomPaint(painter: _VolumePainter()),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color c, String t) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(t,
          style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark)),
    ],
  );
}

void _text(Canvas canvas, String s, Offset pos,
    {double size = 10, Color color = AppColors.textGrey, bool center = false}) {
  final tp = TextPainter(
    text: TextSpan(text: s, style: TextStyle(fontSize: size, color: color)),
    textDirection: TextDirection.ltr,
  )..layout();
  canvas.drawText(tp, pos, center);
}

extension on Canvas {
  void drawText(TextPainter tp, Offset pos, bool center) {
    tp.paint(this, Offset(center ? pos.dx - tp.width / 2 : pos.dx, pos.dy));
  }
}

class _EpochPainter extends CustomPainter {
  static const _a = [0.30, 0.38, 0.50, 0.62, 0.72, 0.80, 0.86, 0.90, 0.93];
  static const _b = [0.22, 0.34, 0.52, 0.66, 0.74, 0.78, 0.82, 0.85, 0.88];
  static const _c = [0.14, 0.20, 0.28, 0.38, 0.50, 0.60, 0.70, 0.78, 0.84];

  @override
  void paint(Canvas canvas, Size size) {
    const bottom = 22.0, pad = 6.0;
    final w = size.width - pad * 2;
    final h = size.height - bottom - pad;

    final grid = Paint()
      ..color = AdminColors.line
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = pad + h * i / 3;
      canvas.drawLine(Offset(pad, y), Offset(size.width - pad, y), grid);
    }

    Offset pt(List<double> d, int i) => Offset(
      pad + w * i / (d.length - 1),
      pad + h * (1 - d[i]),
    );

    Path curve(List<double> d) {
      final p = Path()..moveTo(pt(d, 0).dx, pt(d, 0).dy);
      for (var i = 1; i < d.length; i++) {
        final a = pt(d, i - 1);
        final b = pt(d, i);
        final mx = (a.dx + b.dx) / 2;
        p.cubicTo(mx, a.dy, mx, b.dy, b.dx, b.dy);
      }
      return p;
    }

    final pa = curve(_a);
    final fill = Path.from(pa)
      ..lineTo(pad + w, pad + h)
      ..lineTo(pad, pad + h)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AdminColors.indigo.withValues(alpha: 0.18),
            AdminColors.indigo.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    void stroke(Path p, Color c) => canvas.drawPath(
        p,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = c);

    stroke(pa, AdminColors.indigo);
    stroke(curve(_b), AdminColors.teal);
    stroke(curve(_c), const Color(0xFFF59E0B));
    canvas.drawCircle(pt(_a, _a.length - 1), 4, Paint()..color = AdminColors.indigo);

    const labels = [
      'Epoch 0 (Baseline)',
      'Epoch 30',
      'Epoch 60',
      'Epoch 90',
      'Epoch 120'
    ];
    for (var i = 0; i < labels.length; i++) {
      final x = pad + w * i / (labels.length - 1);
      _text(canvas, labels[i], Offset(x.clamp(40.0, size.width - 40), size.height - 14),
          size: 9.5, center: true);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _VolumePainter extends CustomPainter {
  static const _v = [
    0.12, 0.10, 0.14, 0.30, 0.95, 0.80, 1.0, 0.75, 0.85, 0.40, 0.28, 0.20
  ];
  static const _labels = [
    '02h', '04h', '06h', '08h', '10h', '12h', '14h', '16h', '18h', '20h',
    '22h', '24h'
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const bottom = 16.0;
    final h = size.height - bottom;
    final slot = size.width / _v.length;
    final barW = math.min(26.0, slot * 0.7);
    for (var i = 0; i < _v.length; i++) {
      final cx = slot * i + slot / 2;
      final bh = h * _v[i];
      final hot = _v[i] > 0.7;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - barW / 2, h - bh, barW, bh),
          const Radius.circular(4),
        ),
        Paint()
          ..color = hot
              ? AdminColors.indigo
              : AdminColors.indigo.withValues(alpha: 0.15),
      );
      _text(canvas, _labels[i], Offset(cx, h + 3), size: 9, center: true);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}