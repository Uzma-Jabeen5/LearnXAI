import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  static const _amber = Color(0xFF8A4B00);

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  ButtonStyle _btn(Color bg, Color fg) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
    );
  }

  // Responsive grid that never overflows: picks the column count from width.
  Widget _grid(List<Widget> items, {double minItemWidth = 200}) {
    return LayoutBuilder(
      builder: (context, cc) {
        int cols = ((cc.maxWidth + 12) / (minItemWidth + 12)).floor();
        if (cols < 1) cols = 1;
        if (cols > items.length) cols = items.length;
        final w = (cc.maxWidth - 12 * (cols - 1)) / cols;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [for (final i in items) SizedBox(width: w, child: i)],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/profile',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final leftW = wide ? inner * 0.34 : inner;
          final rightW = wide ? inner - leftW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Academic Operations  >  Faculty Directory & Credentials  >  Faculty Portfolio',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey),
                ),
                const SizedBox(height: 8),
                _header(context),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SizedBox(
                      width: leftW,
                      child: Column(
                        children: [
                          _identity(context),
                          const SizedBox(height: 16),
                          _impact(),
                          const SizedBox(height: 16),
                          _specialties(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: rightW,
                      child: Column(
                        children: [
                          _bio(),
                          const SizedBox(height: 16),
                          _teaching(context),
                          const SizedBox(height: 16),
                          _honors(),
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

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Faculty Profile & Academic Portfolio',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage professional credentials, active teaching duties, ABET accreditation milestones, and empirical research contributions under the Socratic XAI curriculum framework.',
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
            const Pill('ABET Cycle 2023-2029 Valid',
                bg: AppColors.mint, fg: AppColors.teal, fontSize: 11),
            ElevatedButton.icon(
              onPressed: () => _snack(context, 'Dossier exported'),
              icon: const Icon(Icons.ios_share, size: 18),
              label: const Text('Export Dossier'),
              style: _btn(AppColors.chip, AppColors.textDark),
            ),
          ],
        ),
      ],
    );
  }

  Widget _title(String t, {IconData? icon, String? sub, Widget? trailing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
            ],
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
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ],
          ],
        ),
        if (sub != null) ...[
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.4,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ],
    );
  }

  // ---------- Left column ----------
  Widget _identity(BuildContext context) {
    Widget contact(IconData icon, String text) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              'AK',
              style: GoogleFonts.manrope(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Dr. Ahmed Khan, Ph.D.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Associate Professor & Faculty Advisor',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Computer Science & Artificial Intelligence\nSchool of Electrical Engineering & Computer Science',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              height: 1.4,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Pill('ABET Auditor',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
              Pill('IEEE Senior',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
              Pill('Socratic Lead',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
            ],
          ),
          const SizedBox(height: 16),
          contact(Icons.mail_outline, 'ahmed.khan@university.edu'),
          contact(Icons.apartment_outlined, 'Turing Hall, Suite 408'),
          contact(Icons.phone_outlined, '+1 (555) 019-4821 (Ext. 482)'),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _snack(context, 'Edit faculty profile'),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Faculty Profile'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/syllabus'),
              icon: const Icon(Icons.menu_book_outlined, size: 18),
              label: const Text('View Public Syllabus'),
              style: _btn(AppColors.chip, AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _impact() {
    Widget stat(String label, String value, String sub, Color color) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              sub,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      );
    }

    const bars = [0.3, 0.35, 0.32, 0.45, 0.5, 0.48, 0.62, 0.7, 0.85];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Teaching Impact',
              icon: Icons.bar_chart_rounded,
              trailing: const Pill('Fall 2025',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 9)),
          const SizedBox(height: 14),
          _grid([
            stat('Active Curricula', '12', '+2 Sem', AppColors.textDark),
            stat('Mentored Total', '1,420', 'Enrolled scholars',
                AppColors.textDark),
            stat('Eval Score', '4.85', '/ 5.0 • Top 2% in Dept', _amber),
            stat('Cohort Mastery', '94.2%', 'ABET benchmark met',
                AppColors.teal),
          ], minItemWidth: 130),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Cognitive Mastery Trajectory',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                '+8.4% vs 2024',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 44,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final b in bars)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        height: 44 * b,
                        decoration: BoxDecoration(
                          color: b == bars.last
                              ? AppColors.primaryLight
                              : const Color(0xFFD9DBF5),
                          borderRadius: BorderRadius.circular(4),
                        ),
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

  Widget _specialties() {
    Widget chip(String t, {bool green = false}) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: green ? AppColors.mint : AppColors.chip,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        t,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: green ? AppColors.teal : AppColors.primary,
        ),
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Focus Specialties',
              icon: Icons.hub_outlined,
              sub:
              'Core pedagogical domains catalogued by the Socratic AI knowledge index.'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              chip('Deep Neural Architectures'),
              chip('Explainable AI (XAI)'),
              chip('Reinforcement Learning'),
              chip('Automated Deductive Reasoning', green: true),
              chip('Bayesian Knowledge Tracing'),
              chip('Algorithmic Safety'),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Right column ----------
  Widget _bio() {
    Widget degree(String school, String degree, String detail, String year) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              school,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              degree,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              detail,
              style: GoogleFonts.inter(
                fontSize: 11,
                height: 1.4,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Conferred',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
                Text(
                  year,
                  style: GoogleFonts.inter(
                    fontSize: 11,
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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Institutional Biography',
              icon: Icons.badge_outlined,
              sub: 'Faculty Registry ID: CS-FAC-882109',
              trailing: const Pill('Verified Academic',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 9)),
          const SizedBox(height: 14),
          Text(
            'Dr. Ahmed Khan leads the Explainable AI & Socratic Curriculum Initiative at the Department of Computer Science. His laboratory focuses on neural algorithmic reasoning, provable safety boundaries in reinforcement learning systems, and automated pedagogical diagnostics designed to elevate collegiate student outcomes.',
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.6,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.school_outlined,
                  size: 18, color: AppColors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Education & Academic Pedigree',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _grid([
            degree('STANFORD UNIVERSITY', 'Ph.D. in Computer Science',
                'Dissertation: Safe Exploration via Neural Proof Assistants',
                '2018'),
            degree('CARNEGIE MELLON', 'M.S. in Machine Learning',
                'Focus on Bayesian Inference & Dynamic Systems', '2014'),
            degree('UC BERKELEY', 'B.S. Computer Science & Math',
                'Summa Cum Laude • Regents Scholar', '2012'),
          ], minItemWidth: 170),
        ],
      ),
    );
  }

  Widget _teaching(BuildContext context) {
    Widget course(String num, Color badge, Color badgeFg, String code,
        String level, String name, String students, String when,
        String where) {
      Widget meta(IconData icon, String t) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textGrey),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                t,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ],
        ),
      );

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badge,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    num,
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: badgeFg,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$code  •  $level',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      meta(Icons.groups_outlined, students),
                      meta(Icons.schedule, when),
                      meta(Icons.place_outlined, where),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                      context, '/teacher-recommendations'),
                  style: _btn(Colors.white, AppColors.textDark),
                  child: const Text('Course Desk'),
                ),
                ElevatedButton(
                  onPressed: () => _snack(context, 'More options for $code'),
                  style: _btn(Colors.white, AppColors.textDark),
                  child: const Icon(Icons.more_vert, size: 18),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Current Teaching Assignments',
              icon: Icons.menu_book_outlined,
              sub: 'Fall Semester 2025 instructional cohorts & lecture rosters',
              trailing: const Pill('3 Active Sections',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 9)),
          const SizedBox(height: 14),
          course(
              '301',
              AppColors.primary,
              Colors.white,
              'CS-301',
              'Undergraduate Core',
              'Artificial Intelligence Fundamentals & Heuristic Search',
              '140 Students',
              'Mon & Wed 10:00-11:30 AM',
              'Turing Aud A'),
          const SizedBox(height: 12),
          course(
              '402',
              AppColors.chip,
              AppColors.primary,
              'CS-402',
              'Upper Division Elective',
              'Deep Neural Networks & Loss Surface Dynamics',
              '85 Students',
              'Tue & Thu 02:00-03:30 PM',
              'Ada Lovelace Hall 204'),
          const SizedBox(height: 12),
          course(
              '610',
              AppColors.mint,
              AppColors.teal,
              'CS-610',
              'Graduate Research Seminar',
              'Advanced Topics in Explainable AI & Causal Inference',
              '25 Students',
              'Friday 09:00 AM-12:00 PM',
              'Turing Grad Lab 102'),
        ],
      ),
    );
  }

  Widget _honors() {
    Widget item(IconData icon, String title, String body, String foot,
        Color footColor) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: GoogleFonts.inter(
                fontSize: 11,
                height: 1.5,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              foot,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: footColor,
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
          _title('Honors, Grants & Accreditation Dossier',
              icon: Icons.emoji_events_outlined,
              sub:
              'Formal departmental recognition and research governance'),
          const SizedBox(height: 14),
          _grid([
            item(
                Icons.workspace_premium_outlined,
                '2024 University Teaching Excellence Award',
                'Provost Commendation for pioneering Socratic AI diagnostic integration across core computing pipelines.',
                'Office of Academic Affairs • May 2024',
                AppColors.textGrey),
            item(
                Icons.science_outlined,
                'NSF Award #2148910 - Principal Investigator',
                'Transparent Learning Analytics via Bayesian Knowledge Tracing (\$740,000 multi-year grant).',
                'Active Grant • 2023-2026',
                AppColors.primary),
            item(
                Icons.fact_check_outlined,
                'Certified ABET Assessment Auditor',
                'Authorized program reviewer for Student Learning Outcome (SLO) benchmarks cycle 2023-2029.',
                'Accreditation Board Certified',
                AppColors.teal),
            item(
                Icons.article_outlined,
                '24 Peer-Reviewed Publications',
                'First & senior author papers published in NeurIPS, ICML, AAAI, and ACM SIGCSE technical symposia.',
                'h-index: 18 • i10-index: 22',
                AppColors.teal),
          ], minItemWidth: 220),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_outlined,
                    size: 18, color: AppColors.teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Profile cryptographic seal authenticated by Dean of Engineering Office. Last synced: Oct 24, 2025 09:42 UTC',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      height: 1.4,
                      color: AppColors.textGrey,
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
}