import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_session.dart';
import 'app_card.dart';

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  final String? count;
  final bool activeTag;
  final bool dot;
  final bool soon;

  const _NavItem(
      this.label,
      this.icon,
      this.route, {
        this.count,
        this.activeTag = false,
        this.dot = false,
        this.soon = false,
      });
}

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  final bool inDrawer;

  const AppSidebar({
    super.key,
    required this.currentRoute,
    this.inDrawer = false,
  });

  // ---------- Student menu ----------
  static const _core = [
    _NavItem('Dashboard', Icons.dashboard_outlined, '/dashboard'),
    _NavItem('Explore Courses', Icons.explore_outlined, '/explore'),
    _NavItem('Courses', Icons.menu_book_outlined, '/courses', count: '6'),
    _NavItem('Course Details', Icons.article_outlined, '/course-details'),
    _NavItem('AI Tutor', Icons.psychology_alt_outlined, '/ai-tutor',
        activeTag: true),
  ];

  static const _assess = [
    _NavItem('Assessments', Icons.check_box_outlined, '/assessments'),
    _NavItem('Assignments', Icons.description_outlined, '/assignments'),
    _NavItem('Tests', Icons.emoji_events_outlined, '/tests'),
    _NavItem('Progress', Icons.show_chart_rounded, '/progress'),
    _NavItem('Recommendations', Icons.lightbulb_outline, '/recommendations'),
    _NavItem('Announcements', Icons.campaign_outlined, '/announcements'),
  ];

  static const _system = [
    _NavItem('Notifications', Icons.notifications_none, '/notifications',
        dot: true),
    _NavItem('Profile', Icons.person_outline, '/profile'),
    _NavItem('Settings', Icons.settings_outlined, '/settings'),
  ];

  // ---------- Teacher menu ----------
  static const _teacher = [
    _NavItem('Dashboard', Icons.dashboard_outlined, '/teacher-dashboard'),
    _NavItem('Courses', Icons.school_outlined, '/teacher-create-course'),
    _NavItem('Upload Content', Icons.cloud_upload_outlined, '/teacher-notes'),
    _NavItem('Lecture Studio', Icons.video_library_outlined,
        '/teacher-lectures'),
    _NavItem('Quiz Builder', Icons.quiz_outlined, '/teacher-quiz-builder'),
    _NavItem('Assignments', Icons.description_outlined,
        '/teacher-assignments'),
    _NavItem('Tests', Icons.fact_check_outlined, '/teacher-tests'),
    _NavItem('Announcements', Icons.campaign_outlined, '/announcements'),
    _NavItem('Student Analytics', Icons.show_chart_rounded,
        '/teacher-analytics'),
    _NavItem('Reports', Icons.assessment_outlined, '/teacher-reports'),
    _NavItem('AI Insights', Icons.auto_awesome, '/teacher-ai-insights'),
    _NavItem('Settings', Icons.tune, '/teacher-settings'),
  ];

  // ---------- Admin menu ----------
  static const _adminGov = [
    _NavItem('Dashboard', Icons.dashboard_outlined, '/admin-dashboard'),
    _NavItem('Users', Icons.people_outline, '/admin-users'),
    _NavItem('Teachers', Icons.school_outlined, '/admin-teachers'),
    _NavItem('Courses', Icons.menu_book_outlined, '/admin-courses'),
    _NavItem('Permissions', Icons.shield_outlined, '/admin-permissions'),
  ];

  static const _adminOps = [
    _NavItem('AI Model Registry', Icons.memory_outlined, '/admin-models'),
    _NavItem('Chatbot Settings', Icons.tune, '/admin-chatbot'),
    _NavItem('System Logs', Icons.terminal_outlined, '/admin-logs'),
    _NavItem('Reports', Icons.description_outlined, '/admin-reports'),
    _NavItem('Grand Test', Icons.verified_outlined, '/admin-grand-test'),
    _NavItem('Announcements', Icons.campaign_outlined,
        '/admin-announcements'),
    _NavItem('System Configuration', Icons.settings_outlined,
        '/admin-config'),
  ];

  static const _navy = Color(0xFF1E1B4B);
  static const _navyText = Color(0xFFD7D9F2);
  static const _navyMuted = Color(0xFF9CA3C7);
  static const _navyTeal = Color(0xFF5EEAD4);

  bool get _dark => AppSession.isDarkNav;

  void _go(BuildContext context, _NavItem item) {
    if (item.soon) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.label} is coming soon')),
      );
      return;
    }
    final target = AppSession.resolve(item.route);
    final current = AppSession.resolve(currentRoute);
    if (inDrawer) Navigator.pop(context);
    if (target != current) {
      Navigator.pushReplacementNamed(context, target);
    }
  }

  void _logout(BuildContext context) {
    AppSession.role = UserRole.student;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _header(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: _dark ? _navyMuted : AppColors.textGrey,
        ),
      ),
    );
  }

  Widget _item(BuildContext context, _NavItem item) {
    final selected =
        AppSession.resolve(item.route) == AppSession.resolve(currentRoute);
    final fg = selected
        ? Colors.white
        : (_dark ? _navyText : AppColors.textDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _go(context, item),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 22, color: fg),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: fg,
                  ),
                ),
              ),
              if (item.count != null)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : AppColors.chip,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.count!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              if (item.activeTag)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.mintBright,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Active',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teal,
                    ),
                  ),
                ),
              if (item.dot)
                Icon(Icons.circle,
                    size: 8,
                    color: selected ? Colors.white : AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutItem(BuildContext context) {
    const red = Color(0xFFB3261E);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _logout(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.logout, size: 22, color: red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Log Out',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _studentFooter() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E7F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'SOCRATIC ENGINE V4.2',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                'Online',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Continuous reasoning telemetry active with explainable belief trees.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  /// Footer for both teacher and admin (dark sidebar).
  Widget _staffFooter(BuildContext context) {
    final profileRoute =
    AppSession.isAdmin ? '/admin-profile' : '/teacher-profile';

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (inDrawer) Navigator.pop(context);
              if (AppSession.resolve(currentRoute) != profileRoute) {
                Navigator.pushReplacementNamed(context, profileRoute);
              }
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline,
                  size: 20, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppSession.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AppSession.userSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: _navyMuted,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _logout(context),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.logout, size: 20, color: _navyText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusStrip(String left, {String? right}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: AppColors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              left,
              style: GoogleFonts.inter(fontSize: 11, color: _navyTeal),
            ),
          ),
          if (right != null)
            Text(
              right,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _navyTeal,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teacher = AppSession.isTeacher;
    final admin = AppSession.isAdmin;
    final dark = teacher || admin;

    return Container(
      color: dark ? _navy : Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                SizedBox(
                  width: 38,
                  height: 38,
                  child: Image.asset(
                    'assets/images/logo.png',
                    errorBuilder: (_, _, _) =>
                    const Icon(Icons.school, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'LearnXAI',
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: dark ? Colors.white : AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (!admin)
                            Pill(teacher ? 'FACULTY' : 'AI-X',
                                bg: AppColors.mint,
                                fg: AppColors.teal,
                                fontSize: 10),
                        ],
                      ),
                      Text(
                        admin
                            ? 'ADMIN CONSOLE • ENTERPRISE'
                            : teacher
                            ? 'TEACHER COCKPIT'
                            : 'Cognitive Analytics Engine',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: dark ? _navyTeal : AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (teacher) _statusStrip('Engine v4.2 Faculty Sync'),
          if (admin) _statusStrip('Platform Core v4.2', right: 'HEALTHY'),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (teacher) ...[
                  for (final i in _teacher) _item(context, i),
                ] else if (admin) ...[
                  _header('ACADEMIC GOVERNANCE & USERS'),
                  for (final i in _adminGov) _item(context, i),
                  _header('AI & SYSTEM OPERATIONS'),
                  for (final i in _adminOps) _item(context, i),
                ] else ...[
                  _header('CORE TELEMETRY'),
                  for (final i in _core) _item(context, i),
                  _header('ASSESSMENT & INSIGHTS'),
                  for (final i in _assess) _item(context, i),
                  _header('SYSTEM'),
                  for (final i in _system) _item(context, i),
                  _logoutItem(context),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
          dark ? _staffFooter(context) : _studentFooter(),
        ],
      ),
    );
  }
}