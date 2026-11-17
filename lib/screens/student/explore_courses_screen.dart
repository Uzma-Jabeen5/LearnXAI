import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class _Course {
  final String tag;
  final Color tagBg;
  final Color tagFg;
  final String code;
  final String rating;
  final String banner;
  final IconData bannerIcon;
  final Color bannerColor;
  final String title;
  final String instructor;
  final String role;
  final String level;
  final String weeks;
  final String credits;
  final String learners;
  final String footerNote;
  final String action;
  final int actionType; // 0 = enrolled/view, 1 = enroll now, 2 = request

  const _Course({
    required this.tag,
    required this.tagBg,
    required this.tagFg,
    required this.code,
    required this.rating,
    required this.banner,
    required this.bannerIcon,
    required this.bannerColor,
    required this.title,
    required this.instructor,
    required this.role,
    required this.level,
    required this.weeks,
    required this.credits,
    required this.learners,
    required this.footerNote,
    required this.action,
    required this.actionType,
  });
}

class ExploreCoursesScreen extends StatefulWidget {
  const ExploreCoursesScreen({super.key});

  @override
  State<ExploreCoursesScreen> createState() => _ExploreCoursesScreenState();
}

class _ExploreCoursesScreenState extends State<ExploreCoursesScreen> {
  bool _grid = true;
  final _search = TextEditingController();

  static const _courses = [
    _Course(
      tag: 'Active Track',
      tagBg: AppColors.mint,
      tagFg: AppColors.teal,
      code: 'CS-101',
      rating: '4.8',
      banner: 'Real-time cognitive model enabled',
      bannerIcon: Icons.psychology_alt_outlined,
      bannerColor: Color(0xFF1E3A5F),
      title: 'AI Fundamentals',
      instructor: 'Dr. Ahmed Khan',
      role: 'AI Lab Director',
      level: 'Beginner',
      weeks: '12 Weeks',
      credits: '4 Units Credit',
      learners: '340 Learners',
      footerNote: 'Enrolled',
      action: 'View Details',
      actionType: 0,
    ),
    _Course(
      tag: 'Fast Track',
      tagBg: AppColors.chip,
      tagFg: AppColors.primary,
      code: 'CS-204',
      rating: '4.9',
      banner: 'GPU Compute Lab Assigned',
      bannerIcon: Icons.hub_outlined,
      bannerColor: Color(0xFF3B3F8F),
      title: 'Machine Learning & Neural Networks',
      instructor: 'Dr. Sara Ali',
      role: 'Dept. of Data Science',
      level: 'Intermediate',
      weeks: '14 Weeks',
      credits: '4 Units Credit',
      learners: '420 Enrolled',
      footerNote: 'Capacity: 18 Seats Left',
      action: 'Enroll Now',
      actionType: 1,
    ),
    _Course(
      tag: 'Core Required',
      tagBg: AppColors.chip,
      tagFg: AppColors.textGrey,
      code: 'CS-201',
      rating: '4.7',
      banner: 'Socratic Complexity Verifier',
      bannerIcon: Icons.account_tree_outlined,
      bannerColor: Color(0xFF243B55),
      title: 'Data Structures & Algorithms',
      instructor: 'Prof. Usman',
      role: 'Chair of Computing',
      level: 'Intermediate',
      weeks: '10 Weeks',
      credits: '3 Units Credit',
      learners: '280 Enrolled',
      footerNote: 'Prereq: CS-101',
      action: 'Request Enrollment',
      actionType: 2,
    ),
    _Course(
      tag: 'Modern Stack',
      tagBg: AppColors.mint,
      tagFg: AppColors.teal,
      code: 'SE-110',
      rating: '4.6',
      banner: 'Edge Deployment Sandbox',
      bannerIcon: Icons.cloud_outlined,
      bannerColor: Color(0xFF1F4E5F),
      title: 'Web & Distributed Systems',
      instructor: 'Dr. Ayesha',
      role: 'Fullstack Architect',
      level: 'Beginner',
      weeks: '10 Weeks',
      credits: '3 Units Credit',
      learners: '190 Enrolled',
      footerNote: 'Project-driven',
      action: 'Request Enrollment',
      actionType: 2,
    ),
    _Course(
      tag: 'Recommended by AI',
      tagBg: AppColors.teal,
      tagFg: Colors.white,
      code: 'CS-402',
      rating: '4.95',
      banner: 'High match with your profile (94%)',
      bannerIcon: Icons.auto_awesome,
      bannerColor: Color(0xFF2A2F7F),
      title: 'Deep Learning & NLP',
      instructor: 'Dr. Tariq',
      role: 'LLM Systems Researcher',
      level: 'Advanced',
      weeks: '16 Weeks',
      credits: '3 Units Credit',
      learners: '510 Scholars',
      footerNote: 'Honors Division',
      action: 'Enroll Now',
      actionType: 1,
    ),
    _Course(
      tag: 'Lab Track',
      tagBg: AppColors.chip,
      tagFg: AppColors.textGrey,
      code: 'DB-305',
      rating: '4.5',
      banner: 'OLAP Engine Integrated',
      bannerIcon: Icons.storage_outlined,
      bannerColor: Color(0xFF2B4A6F),
      title: 'Database & SQL Optimization',
      instructor: 'Prof. Bilal',
      role: 'DB Systems Group',
      level: 'Intermediate',
      weeks: '8 Weeks',
      credits: '3 Units Credit',
      learners: '150 Enrolled',
      footerNote: 'Weekly SQL Benchmarks',
      action: 'Request Enrollment',
      actionType: 2,
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/explore',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final cols = c.maxWidth >= 1100 ? 3 : (c.maxWidth >= 700 ? 2 : 1);
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(wide),
                const SizedBox(height: 18),
                _searchAndFilters(wide),
                const SizedBox(height: 18),
                _grid ? _courseGrid(cols) : _courseList(),
                const SizedBox(height: 18),
                _diagnosticCard(wide),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------- Header ----------
  Widget _header(bool wide) {
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Pill('Curriculum Engine Active',
                bg: AppColors.mint, fg: AppColors.teal),
            Text(
              '• Undergraduate Academic Catalog 2025–2026',
              style: TextStyle(fontSize: 11, color: AppColors.textGrey),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Explore Courses',
          style: GoogleFonts.manrope(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Discover accredited AI, Computing, and Data Science curricula with adaptive learning support, real-time Socratic cognitive analysis, and faculty-led lab tracks.',
          style: GoogleFonts.inter(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );

    Widget stat(IconData icon, Color iconBg, String label, String value) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textGrey,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 18,
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

    final right = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        stat(Icons.layers_outlined, AppColors.chip, 'Credits Avail.',
            '24 Units'),
        stat(Icons.trending_up, AppColors.mint, 'Cohort Pass Rate', '98.4%'),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.blur_on, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Telemetry Mesh',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'AI v4.2 Active',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    return wide
        ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Flexible(child: right),
      ],
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [left, const SizedBox(height: 14), right],
    );
  }

  // ---------- Search + filters ----------
  Widget _searchAndFilters(bool wide) {
    final searchField = Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textGrey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: wide
                    ? 'Search by course title, code (e.g. CS-402), instructor, or topic...'
                    : 'Search courses, code, instructor...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final matcher = ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.psychology_alt_outlined, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              wide ? 'AI Curriculum Matcher' : 'AI Matcher',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.mintBright,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Beta',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.teal,
              ),
            ),
          ),
        ],
      ),
    );

    Widget toggle(IconData icon, bool selected, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: selected ? AppColors.primary : AppColors.textGrey,
          ),
        ),
      );
    }

    final viewToggle = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          toggle(Icons.grid_view_rounded, _grid,
                  () => setState(() => _grid = true)),
          toggle(Icons.view_list_rounded, !_grid,
                  () => setState(() => _grid = false)),
        ],
      ),
    );

    Widget filter(String label, String value) {
      return SizedBox(
        width: wide ? null : 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 18, color: AppColors.textDark),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final filters = [
      filter('SEMESTER', 'Fall 2025 (Regular)'),
      filter('DEPARTMENT', 'All Academic Depts'),
      filter('INSTRUCTOR', 'All Faculty Chairs'),
      filter('DIFFICULTY', 'Any Cognitive Level'),
      filter('CREDITS', 'Any Units (1-4)'),
    ];

    Widget activeChip(String t, {Color bg = Colors.white, Color fg = AppColors.textDark, bool bordered = true}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: bordered ? Border.all(color: const Color(0xFFE0E3F7)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: fg,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.close, size: 13, color: fg),
          ],
        ),
      );
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (wide)
            Row(
              children: [
                Expanded(child: searchField),
                const SizedBox(width: 12),
                matcher,
                const SizedBox(width: 12),
                viewToggle,
              ],
            )
          else ...[
            searchField,
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: matcher),
                const SizedBox(width: 10),
                viewToggle,
              ],
            ),
          ],
          const SizedBox(height: 16),
          if (wide)
            Row(
              children: [
                for (int i = 0; i < filters.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(child: filters[i]),
                ],
              ],
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < filters.length; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    filters[i],
                  ],
                ],
              ),
            ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Active Filters:',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textGrey,
                ),
              ),
              activeChip('Term: Fall 2025'),
              activeChip('Adaptive AI Socratic Track',
                  bg: AppColors.mint, fg: AppColors.teal, bordered: false),
              activeChip('Accreditation: CS & AI Board'),
              Text(
                'Reset all filters',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Grid / list ----------
  Widget _courseGrid(int cols) {
    if (cols == 1) {
      return Column(
        children: [
          for (final c in _courses) ...[
            _courseCard(c),
            const SizedBox(height: 16),
          ],
        ],
      );
    }
    final rows = <Widget>[];
    for (int i = 0; i < _courses.length; i += cols) {
      final slice = _courses.skip(i).take(cols).toList();
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int j = 0; j < cols; j++) ...[
                if (j > 0) const SizedBox(width: 16),
                Expanded(
                  child: j < slice.length
                      ? _courseCard(slice[j])
                      : const SizedBox(),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _courseList() {
    return Column(
      children: [
        for (final c in _courses) ...[
          _courseCard(c, compact: true),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  // ---------- One course card ----------
  Widget _courseCard(_Course c, {bool compact = false}) {
    Widget info(IconData icon, String text) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      );
    }

    Widget actionButton() {
      if (c.actionType == 1) {
        return ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_circle_outline, size: 16),
          label: Text(c.action),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle:
            GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        );
      }
      return ElevatedButton(
        onPressed: () {
          if (c.actionType == 0) {
            Navigator.pushNamed(context, '/course-details');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.chip,
          foregroundColor: AppColors.primary,
          elevation: 0,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle:
          GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        child: Text(c.actionType == 0 ? '${c.action}  →' : c.action),
      );
    }

    final banner = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: compact ? 110 : 130,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [c.bannerColor, c.bannerColor.withValues(alpha: 0.55)],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(c.bannerIcon,
                  size: 52, color: Colors.white.withValues(alpha: 0.35)),
            ),
            Positioned(
              left: 10,
              bottom: 8,
              right: 10,
              child: Row(
                children: [
                  const Icon(Icons.bolt, size: 13, color: Colors.white),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      c.banner,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Pill(c.tag, bg: c.tagBg, fg: c.tagFg, fontSize: 10),
              const SizedBox(width: 6),
              Pill(c.code,
                  bg: AppColors.chip, fg: AppColors.textGrey, fontSize: 10),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9CF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_border,
                        size: 13, color: Color(0xFF8A4B00)),
                    const SizedBox(width: 3),
                    Text(
                      c.rating,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8A4B00),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          banner,
          const SizedBox(height: 14),
          Text(
            c.title,
            style: GoogleFonts.manrope(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.account_circle_outlined,
                  size: 16, color: AppColors.textGrey),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '${c.instructor}  •  ${c.role}',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: info(Icons.bar_chart, 'Level: ${c.level}')),
                    const SizedBox(width: 8),
                    Expanded(child: info(Icons.schedule, c.weeks)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: info(Icons.layers_outlined, c.credits)),
                    const SizedBox(width: 8),
                    Expanded(child: info(Icons.groups_outlined, c.learners)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (c.actionType == 0)
                const Icon(Icons.check_circle_outline,
                    size: 16, color: AppColors.teal),
              if (c.actionType == 0) const SizedBox(width: 6),
              Expanded(
                child: Text(
                  c.footerNote,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: c.actionType == 0
                        ? AppColors.teal
                        : AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              actionButton(),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Bottom diagnostic card ----------
  Widget _diagnosticCard(bool wide) {
    final text = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.mintBright,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.psychology_alt_outlined,
              color: AppColors.teal),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Not sure which track best suits your velocity?',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Pill('Cognitive Pathing',
                      bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'The Socratic AI can evaluate your prior coding repositories, academic transcript, and concept mastery curves to synthesize a tailored semester plan with minimal prerequisite drag.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user_outlined,
                          size: 14, color: AppColors.teal),
                      const SizedBox(width: 4),
                      Text(
                        'FERPA Compliant Analysis',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Takes ~90 seconds',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final button = ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.auto_awesome, size: 18),
      label: const Text('Run Track Diagnostic'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );

    return AppCard(
      child: wide
          ? Row(
        children: [
          Expanded(child: text),
          const SizedBox(width: 20),
          button,
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [text, const SizedBox(height: 16), button],
      ),
    );
  }
}