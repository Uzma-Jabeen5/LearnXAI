import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'app_card.dart';
import '../core/app_session.dart';
import 'app_sidebar.dart';

class AppShell extends StatelessWidget {
  /// Which sidebar item is highlighted.
  final String currentRoute;
  final Widget child;

  const AppShell({
    super.key,
    required this.currentRoute,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        return Scaffold(
          drawer: wide
              ? null
              : Drawer(
            child: SafeArea(
              child: AppSidebar(
                currentRoute: currentRoute,
                inDrawer: true,
              ),
            ),
          ),
          body: SafeArea(
            child: Row(
              children: [
                if (wide)
                  SizedBox(
                    width: 270,
                    child: AppSidebar(currentRoute: currentRoute),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(wide: wide),
                      Expanded(child: child),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool wide;
  const _TopBar({required this.wide});

  /// Opens a route, unless that screen is already showing.
  void _go(BuildContext context, String route) {
    final target = AppSession.resolve(route);
    if (ModalRoute.of(context)?.settings.name == target) return;
    Navigator.pushNamed(context, target);
  }

  Widget _bell(BuildContext context) {
    final admin = AppSession.isAdmin;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _go(context, '/notifications'),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.notifications_none,
                color: AppColors.textDark),
          ),
          Positioned(
            top: admin ? 4 : -2,
            right: admin ? 4 : -2,
            child: Container(
              width: admin ? 10 : 18,
              height: admin ? 10 : 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: admin ? const Color(0xFFE5484D) : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: admin
                  ? null
                  : Text(
                '3',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => _go(context, '/profile'),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person_outline, color: Colors.white),
      ),
    );
  }

  Widget _searchBar(bool admin) {
    return Expanded(
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20, color: AppColors.textGrey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                admin
                    ? 'Search governance, telemetry, credentials...'
                    : 'Search courses, concepts, or cognitive telemetry',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
            ),
            if (admin)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '⌘K',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final admin = AppSession.isAdmin;
    final roomy = MediaQuery.of(context).size.width >= 1200;

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(wide ? 24 : 8, 12, wide ? 24 : 12, 12),
      child: Row(
        children: [
          if (!wide)
            IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, color: AppColors.textDark),
            ),
          if (wide)
            _searchBar(admin)
          else
            Expanded(
              child: Text(
                admin ? 'LearnXAI Admin' : 'LearnXAI',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          if (wide && admin) ...[
            const SizedBox(width: 12),
            const Pill('4 Models Active',
                bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 12),
            const SizedBox(width: 12),
          ],
          if (wide && !admin) ...[
            const SizedBox(width: 12),
            const Pill('Fall Semester 2025 • CS Dept',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 12),
            const SizedBox(width: 8),
            const Pill('12 Days Streak',
                bg: Color(0xFFFFE9CF), fg: Color(0xFF8A4B00), fontSize: 12),
            const SizedBox(width: 8),
            const Pill('3/4 Modules Done',
                bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 12),
            const SizedBox(width: 12),
          ],
          _bell(context),
          const SizedBox(width: 10),
          if (wide && (!admin || roomy))
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppSession.userName,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    AppSession.userSubtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          _avatar(context),
        ],
      ),
    );
  }
}