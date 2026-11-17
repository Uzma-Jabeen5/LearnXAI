import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/profile',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.6 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: GoogleFonts.manrope(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _header(context),
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
                          _details(),
                          const SizedBox(height: 16),
                          _preferences(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _achievements(),
                          const SizedBox(height: 16),
                          _enrolled(),
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

  Widget _title(String t) => Text(
    t,
    style: GoogleFonts.manrope(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
  );

  Widget _header(BuildContext context) {
    return AppCard(
      child: Wrap(
        spacing: 16,
        runSpacing: 14,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline,
                size: 38, color: Colors.white),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 180, maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farah Yameen',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'CS Undergraduate • Fall Semester 2025',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 8),
                const Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Pill('Student ID: CS-2023-0148', fontSize: 10),
                    Pill('Top 8th Percentile',
                        bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings_outlined, size: 18),
            label: const Text('Edit in Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle:
              GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats() {
    Widget tile(String value, String label, IconData icon, Color color) {
      return Expanded(
        child: AppCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tile('82%', 'Mastery', Icons.trending_up, AppColors.teal),
        const SizedBox(width: 10),
        tile('12 days', 'Streak', Icons.local_fire_department_outlined,
            AppColors.primary),
        const SizedBox(width: 10),
        tile('4', 'Courses', Icons.menu_book_outlined,
            AppColors.primaryLight),
      ],
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  Widget _details() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Personal Details'),
          const SizedBox(height: 14),
          _row(Icons.mail_outline, 'Email', 'farah.yameen@university.edu'),
          _row(Icons.school_outlined, 'Program', 'BS Computer Science'),
          _row(Icons.apartment_outlined, 'Department', 'Computer Science'),
          _row(Icons.person_pin_outlined, 'Faculty Mentor', 'Dr. Ahmed Khan'),
          _row(Icons.calendar_today_outlined, 'Enrolled', 'Fall 2023'),
        ],
      ),
    );
  }

  Widget _preferences() {
    Widget chip(String t) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        t,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Learning Preferences'),
          const SizedBox(height: 14),
          _row(Icons.psychology_alt_outlined, 'Tutor mode', 'Socratic'),
          _row(Icons.timer_outlined, 'Daily goal', '60 min'),
          _row(Icons.schedule, 'Best study time', 'Morning'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              chip('Visual learner'),
              chip('Practice first'),
              chip('Short sessions'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _achievements() {
    Widget item(IconData icon, Color color, String title, String sub) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 12,
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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Achievements'),
          const SizedBox(height: 14),
          item(Icons.emoji_events_outlined, AppColors.teal,
              'Python Basics Complete', 'Final score 94%'),
          item(Icons.local_fire_department_outlined, AppColors.primary,
              '12-day study streak', 'Best: 18 days'),
          item(Icons.psychology_alt_outlined, AppColors.primaryLight,
              'Socratic Explorer', '40+ tutor dialogues'),
        ],
      ),
    );
  }

  Widget _enrolled() {
    Widget course(String name, int percent, Color color) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$percent%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
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
                value: percent / 100,
                minHeight: 6,
                backgroundColor: AppColors.chip,
                valueColor: AlwaysStoppedAnimation<Color>(color),
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
          _title('Enrolled Courses'),
          const SizedBox(height: 14),
          course('AI Fundamentals', 72, AppColors.primaryLight),
          course('Data Structures & Algorithms', 45, AppColors.teal),
          course('Intro to Python', 100, AppColors.teal),
          course('Operating Systems', 12, AppColors.primaryLight),
        ],
      ),
    );
  }
}