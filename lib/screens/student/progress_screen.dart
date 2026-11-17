import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/progress',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final tileW = wide ? (inner - 36) / 4 : (inner - 12) / 2;
          final halfW = wide ? (inner - 16) / 2 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: tileW,
                      child: _tile('Overall Mastery', '82%', '+4.2% this week',
                          Icons.trending_up, AppColors.teal),
                    ),
                    SizedBox(
                      width: tileW,
                      child: _tile('Study Streak', '12 days', 'Best: 18 days',
                          Icons.local_fire_department_outlined,
                          AppColors.primary),
                    ),
                    SizedBox(
                      width: tileW,
                      child: _tile('Hours This Week', '11.9 h', 'Goal: 14 h',
                          Icons.timer_outlined, AppColors.primaryLight),
                    ),
                    SizedBox(
                      width: tileW,
                      child: _tile('Lessons Done', '49', 'of 91 total',
                          Icons.check_circle_outline, AppColors.teal),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(width: halfW, child: _courseMastery()),
                    SizedBox(width: halfW, child: _weeklyHours()),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(width: halfW, child: _concepts(context)),
                    SizedBox(width: halfW, child: _milestones()),
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
        Text(
          'Progress',
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'See how your mastery, study time and concepts are trending.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  // ---------- Summary tile ----------
  Widget _tile(
      String label, String value, String sub, IconData icon, Color color) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTitle(String title, {String? pill}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        if (pill != null) ...[
          const SizedBox(width: 8),
          Pill(pill, fontSize: 10),
        ],
      ],
    );
  }

  // ---------- Course mastery ----------
  Widget _courseMastery() {
    Widget row(String name, int percent, Color color) {
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
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
          _cardTitle('Mastery by Course', pill: 'Fall 2025'),
          const SizedBox(height: 16),
          row('AI Fundamentals', 72, AppColors.primaryLight),
          row('Data Structures & Algorithms', 45, AppColors.teal),
          row('Intro to Python', 100, AppColors.teal),
          row('Operating Systems', 12, AppColors.primaryLight),
        ],
      ),
    );
  }

  // ---------- Weekly study hours ----------
  Widget _weeklyHours() {
    const hours = [1.5, 2.2, 1.0, 3.1, 1.8, 2.4, 0.9];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const maxH = 4.0;
    const chartH = 120.0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Study Hours', pill: 'Last 7 Days'),
          const SizedBox(height: 16),
          SizedBox(
            height: chartH + 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < 7; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 22,
                          height: chartH * hours[i] / maxH,
                          decoration: BoxDecoration(
                            color: i == 3
                                ? AppColors.primaryLight
                                : const Color(0xFFD9DBF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[i],
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          Row(
            children: [
              const Icon(Icons.insights, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Peak day: Thursday • 3.1 hours',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
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

  // ---------- Strong / weak concepts ----------
  Widget _concepts(BuildContext context) {
    Widget chip(String t, Color bg, Color fg) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        t,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );

    Widget label(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        t,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textGrey,
        ),
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Concept Strength'),
          const SizedBox(height: 14),
          label('STRONG'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              chip('Graph Traversal', AppColors.mint, AppColors.teal),
              chip('Sorting', AppColors.mint, AppColors.teal),
              chip('Python Basics', AppColors.mint, AppColors.teal),
            ],
          ),
          const SizedBox(height: 16),
          label('NEEDS REINFORCEMENT'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              chip('Recursion Base', const Color(0xFFFFE9CF),
                  const Color(0xFF6B3A00)),
              chip('Balanced Trees', const Color(0xFFFFE9CF),
                  const Color(0xFF6B3A00)),
              chip('DP Memoization', const Color(0xFFFFE9CF),
                  const Color(0xFF6B3A00)),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/weak-topics'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View all weak topics',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward,
                    size: 14, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Milestones ----------
  Widget _milestones() {
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
          _cardTitle('Milestones'),
          const SizedBox(height: 14),
          item(Icons.emoji_events_outlined, AppColors.teal,
              'Completed Intro to Python', 'Final score 94%'),
          item(Icons.local_fire_department_outlined, AppColors.primary,
              '12-day study streak', '6 days to your best streak'),
          item(Icons.flag_outlined, AppColors.primaryLight,
              'AI Fundamentals: Unit 4 Test', 'Unlocks at 75% completion'),
        ],
      ),
    );
  }
}