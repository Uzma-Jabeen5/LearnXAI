import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-dashboard',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 20),
            _stats(),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: Column(
                children: const [
                  _GrowthCard(),
                  SizedBox(height: 20),
                  _WeeklyActivityCard(),
                ],
              ),
              side: Column(
                children: const [
                  _DomainCard(),
                  SizedBox(height: 20),
                  _AiStatusCard(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const AdminTwoCol(
              main: _ActivityLogCard(),
              side: _CommandCenterCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return AdminHeader(
      title: 'Welcome back, Admin 👋',
      tag: 'Cluster Live',
      subtitle:
      'Monitor LearnXAI platform performance, AI inference clusters, and institutional learning operations in real time.',
      actions: [
        const AdminTag('Fall Semester 2025 • Oct 24, 2025 Live',
            bg: Colors.white, fg: AppColors.textDark, fontSize: 12),
        const AdminButton('Audit (PDF)', icon: Icons.picture_as_pdf_outlined),
        AdminButton(
          'Add New User',
          icon: Icons.person_add_alt_1,
          primary: true,
          onTap: () => Navigator.pushReplacementNamed(context, '/admin-users'),
        ),
      ],
    );
  }

  Widget _stats() {
    return const AdminGrid(
      minItemWidth: 165,
      gap: 14,
      children: [
        _StatCard(Icons.groups_outlined, AdminColors.indigo, '+12%', '24,850',
            'Total Users', 'Students, faculty...'),
        _StatCard(Icons.school_outlined, AdminColors.teal, '+8.4%', '18,420',
            'Active Students', 'Engaged in study'),
        _StatCard(Icons.person_search_outlined, AdminColors.indigo, '+5.1%',
            '1,248', 'Active Teachers', 'Faculty courses'),
        _StatCard(Icons.menu_book_outlined, AdminColors.indigo, '+15 new',
            '342', 'Total Courses', 'Accredited...'),
        _StatCard(Icons.bolt_outlined, AdminColors.brown, 'Optimal', '87.4%',
            'Engagement Rate', 'Weekly...'),
        _StatCard(Icons.hub_outlined, AdminColors.teal, '99.98%', 'Healthy',
            'AI Inference Mesh', '4 of 4 models...'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tag;
  final String value;
  final String label;
  final String sub;

  const _StatCard(
      this.icon, this.color, this.tag, this.value, this.label, this.sub);

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const Spacer(),
              AdminTag(tag,
                  bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}

// ======================= Growth chart =======================

class _GrowthCard extends StatefulWidget {
  const _GrowthCard();

  @override
  State<_GrowthCard> createState() => _GrowthCardState();
}

class _GrowthCardState extends State<_GrowthCard> {
  int _tab = 0;

  static const _tabs = ['Users', 'Enrollments', 'Inference Calls'];

  static const _a = [
    [10.5, 11.6, 12.8, 14.2, 16.0, 18.4, 21.5, 24.85],
    [8.0, 9.2, 10.8, 12.4, 14.6, 17.0, 20.2, 23.6],
    [12.0, 14.5, 16.0, 19.5, 22.0, 25.5, 28.0, 31.0],
  ];
  static const _b = [
    [10.0, 10.5, 11.0, 11.6, 12.3, 13.2, 14.2, 15.0],
    [7.0, 7.8, 8.6, 9.4, 10.6, 12.0, 13.4, 14.6],
    [10.0, 11.0, 12.0, 13.0, 14.0, 15.5, 17.0, 18.0],
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionTitle(
            'Platform User Growth & Active Trajectory',
            subtitle: 'Validated enrollment & real-time telemetry analytics',
            trailing: _tabBar(),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 18,
            runSpacing: 6,
            children: const [
              _Legend(AdminColors.indigo, 'Students: 18,420'),
              _Legend(AdminColors.teal, 'Faculty: 1,248'),
              _Legend(AdminColors.brown, 'Peak Velocity: +1,420 / wk'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 230,
            width: double.infinity,
            child: CustomPaint(painter: _LinePainter(_a[_tab], _b[_tab])),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _tabs.length; i++)
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => setState(() => _tab = i),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: _tab == i ? AdminColors.indigo : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _tabs[i],
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: _tab == i ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;
  const _Legend(this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

void _drawText(
    Canvas canvas,
    String s,
    Offset pos, {
      double size = 10,
      Color color = AppColors.textGrey,
      bool alignRight = false,
      bool centerX = false,
      FontWeight weight = FontWeight.w400,
    }) {
  final tp = TextPainter(
    text: TextSpan(
      text: s,
      style: TextStyle(fontSize: size, color: color, fontWeight: weight),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  var dx = pos.dx;
  if (alignRight) dx -= tp.width;
  if (centerX) dx -= tp.width / 2;
  tp.paint(canvas, Offset(dx, pos.dy));
}

class _LinePainter extends CustomPainter {
  final List<double> a;
  final List<double> b;
  _LinePainter(this.a, this.b);

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const left = 36.0, bottom = 22.0, top = 8.0;
    final all = [...a, ...b];
    final lo = (all.reduce(math.min) / 5).floor() * 5.0;
    var hi = (all.reduce(math.max) / 5).ceil() * 5.0;
    if (hi <= lo) hi = lo + 5;
    final w = size.width - left;
    final h = size.height - bottom - top;

    final grid = Paint()
      ..color = AdminColors.line
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = top + h * i / 3;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), grid);
      final v = hi - (hi - lo) * i / 3;
      _drawText(canvas, '${v.round()}k', Offset(0, y - 6));
    }

    Offset pt(int i, double v) => Offset(
      left + w * i / (a.length - 1),
      top + h * (1 - (v - lo) / (hi - lo)),
    );

    Path curve(List<double> d) {
      final p = Path()..moveTo(pt(0, d[0]).dx, pt(0, d[0]).dy);
      for (var i = 1; i < d.length; i++) {
        final p0 = pt(i - 1, d[i - 1]);
        final p1 = pt(i, d[i]);
        final mx = (p0.dx + p1.dx) / 2;
        p.cubicTo(mx, p0.dy, mx, p1.dy, p1.dx, p1.dy);
      }
      return p;
    }

    final pa = curve(a);
    final fill = Path.from(pa)
      ..lineTo(left + w, top + h)
      ..lineTo(left, top + h)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AdminColors.indigo.withValues(alpha: 0.22),
            AdminColors.indigo.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, top, size.width, h)),
    );

    canvas.drawPath(
      pa,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AdminColors.indigo,
    );
    canvas.drawPath(
      curve(b),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AdminColors.teal,
    );

    final end = pt(a.length - 1, a.last);
    canvas.drawCircle(end, 4, Paint()..color = AdminColors.indigo);

    for (var i = 0; i < a.length; i++) {
      _drawText(
        canvas,
        _months[i],
        Offset(pt(i, lo).dx, size.height - 14),
        centerX: true,
        color: i == a.length - 1 ? AdminColors.indigo : AppColors.textGrey,
        weight: i == a.length - 1 ? FontWeight.w700 : FontWeight.w400,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      old.a != a || old.b != b;
}

// ======================= Weekly activity =======================

class _WeeklyActivityCard extends StatelessWidget {
  const _WeeklyActivityCard();

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionTitle(
            'Weekly Activity Distribution & Workload Density',
            subtitle:
            'Daily student interaction sessions categorized by learning mode',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 18,
            runSpacing: 6,
            children: const [
              _Legend(AdminColors.indigo, 'Exploration'),
              _Legend(AdminColors.teal, 'Quiz & Labs'),
              _Legend(AdminColors.brown, 'Socratic'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            width: double.infinity,
            child: CustomPaint(painter: _BarsPainter()),
          ),
        ],
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  // fractions of full height: [exploration, quiz, socratic]
  static const _data = [
    [0.50, 0.16, 0.05],
    [0.54, 0.16, 0.05],
    [0.60, 0.14, 0.05],
    [0.56, 0.14, 0.05],
    [0.52, 0.15, 0.04],
    [0.34, 0.14, 0.03],
    [0.38, 0.14, 0.03],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const bottom = 24.0;
    final h = size.height - bottom;
    final slot = size.width / _days.length;
    final barW = math.min(34.0, slot * 0.5);
    final colors = [AdminColors.indigo, AdminColors.teal, AdminColors.brown];

    canvas.drawLine(
      Offset(0, h),
      Offset(size.width, h),
      Paint()
        ..color = AdminColors.line
        ..strokeWidth = 1,
    );

    for (var i = 0; i < _days.length; i++) {
      final cx = slot * i + slot / 2;
      var y = h;
      for (var s = 0; s < 3; s++) {
        final seg = _data[i][s] * h * 1.25;
        final rect = Rect.fromLTWH(cx - barW / 2, y - seg, barW, seg - 1.5);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)),
          Paint()..color = colors[s],
        );
        y -= seg;
      }
      _drawText(
        canvas,
        _days[i],
        Offset(cx, h + 8),
        centerX: true,
        color: i == 2 ? AdminColors.indigo : AppColors.textGrey,
        weight: i == 2 ? FontWeight.w700 : FontWeight.w400,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ======================= Domain donut =======================

class _DomainCard extends StatelessWidget {
  const _DomainCard();

  static const _items = [
    ['Computer Science & AI', '42%', 0.42, AdminColors.indigo],
    ['Data Science & Math', '28%', 0.28, AdminColors.teal],
    ['Electrical Engineering', '18%', 0.18, AdminColors.brown],
    ['Cognitive Science', '12%', 0.12, Color(0xFF3730A3)],
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionTitle(
            'Curricular Domain Allocation',
            subtitle: 'Breakdown across 342 active accredited curricula',
          ),
          const SizedBox(height: 18),
          Center(
            child: SizedBox(
              width: 170,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(170, 170),
                    painter: _DonutPainter(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '342',
                        style: GoogleFonts.manrope(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'COURSES',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          letterSpacing: 0.6,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          for (final it in _items)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: it[3] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      it[0] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Text(
                    it[1] as String,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
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

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 24.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final fr = [0.42, 0.28, 0.18, 0.12];
    final cols = [
      AdminColors.indigo,
      AdminColors.teal,
      AdminColors.brown,
      const Color(0xFF3730A3),
    ];
    var start = -math.pi / 2;
    const gap = 0.04;
    for (var i = 0; i < fr.length; i++) {
      final sweep = 2 * math.pi * fr[i];
      canvas.drawArc(
        rect,
        start + gap / 2,
        sweep - gap,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = cols[i],
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ======================= AI status =======================

class _AiStatusCard extends StatelessWidget {
  const _AiStatusCard();

  static const _models = [
    ['Student Performance Predictor', 'v1.2.0 • 92% Accuracy', 'Healthy'],
    ['Weak Topic Detection Engine', 'v1.1.3 • 88% Precision', 'Low Latency'],
    ['Socratic Recommendation Engine', 'v2.0.1 • 94% Alignment', 'Online'],
    ['Cognitive BKT Knowledge Tracer', 'v3.4.0 • 96.4% Calibrated',
      'Calibrated'],
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionTitle(
            'AI System Status & Telemetry',
            subtitle: 'Real-time status of explainable neural evaluators',
            trailing: AdminTag('All Systems Nominal',
                bg: AppColors.mintBright, fg: AppColors.teal),
          ),
          const SizedBox(height: 14),
          for (final m in _models)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.teal),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m[0],
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          m[1],
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AdminTag(m[2],
                      bg: AppColors.mintBright,
                      fg: AppColors.teal,
                      fontSize: 10),
                ],
              ),
            ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.chip,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.speed, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Median Token Latency: 14.8 ms',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Text(
                  'Uptime 99.98%',
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
    );
  }
}

// ======================= Activity log =======================

class _ActivityLogCard extends StatelessWidget {
  const _ActivityLogCard();

  static const _rows = [
    [
      'New student batch registered',
      '5m ago',
      '140 students enrolled via University SIS Active...',
      'Success'
    ],
    [
      'Faculty course published',
      '22m ago',
      "Dr. Ahmed Khan published 'Advanced Topics in...",
      'Published'
    ],
    [
      'Permission matrix updated',
      '1h ago',
      'Superuser granted Teaching Assistant privileges to ...',
      'Audited'
    ],
    [
      'AI Model Weights Deployed',
      '3h ago',
      'Weak Topic Detection Engine v1.1.3 weights fine-...',
      'Deployed'
    ],
  ];
  static const _icons = [
    Icons.sync,
    Icons.menu_book_outlined,
    Icons.shield_outlined,
    Icons.inventory_2_outlined,
  ];
  static const _colors = [
    AdminColors.teal,
    AdminColors.indigo,
    AdminColors.brown,
    AdminColors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionTitle(
            'Recent Platform Activity & Governance Log',
            trailing: InkWell(
              onTap: () => Navigator.pushReplacementNamed(
                  context, '/admin-logs'),
              child: Text(
                'View All Logs →',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.indigo,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < _rows.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _colors[i].withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_icons[i], size: 20, color: _colors[i]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _rows[i][0],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            Text(
                              _rows[i][1],
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _rows[i][2],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  AdminTag(_rows[i][3],
                      bg: _colors[i].withValues(alpha: 0.14),
                      fg: _colors[i],
                      fontSize: 10),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Displaying last 4 audit records',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              Text(
                '● Sync with SIS: 100% synchronized',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: AppColors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================= Command center =======================

class _CommandCenterCard extends StatefulWidget {
  const _CommandCenterCard();

  @override
  State<_CommandCenterCard> createState() => _CommandCenterCardState();
}

class _CommandCenterCardState extends State<_CommandCenterCard> {
  bool _maintenance = false;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionTitle(
            'Administrative Command Center',
            subtitle:
            'High-frequency administrative triggers and cross-departmental operations.',
            trailing: Text('Root\nPrivileges',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
          ),
          const SizedBox(height: 14),
          AdminGrid(
            minItemWidth: 150,
            gap: 12,
            children: [
              _tile(context, Icons.manage_accounts_outlined,
                  AdminColors.indigo, 'Manage User Accounts',
                  'Students, faculty, and role credentials', '/admin-users'),
              _tile(context, Icons.fact_check_outlined, AdminColors.teal,
                  'Audit Faculty & Teachers',
                  'Course allocations & teacher workload', '/admin-teachers'),
              _tile(context, Icons.bar_chart_rounded, AdminColors.brown,
                  'Accreditation Reports',
                  'Export ABET & university analytics', '/admin-reports'),
              _tile(context, Icons.campaign_outlined, AdminColors.indigo,
                  'Global Announcement',
                  'Broadcast urgent notices campus-wide',
                  '/admin-announcements'),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.settings_backup_restore,
                    size: 20, color: AppColors.textDark),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Maintenance Mode',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        _maintenance
                            ? 'Maintenance Mode Active'
                            : 'Standard Operating Mode Active',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _maintenance,
                  activeThumbColor: AdminColors.indigo,
                  onChanged: (v) => setState(() => _maintenance = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, Color color,
      String title, String sub, String route) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.pushReplacementNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AdminColors.soft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 19, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                height: 1.35,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}