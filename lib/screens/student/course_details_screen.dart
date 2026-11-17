import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/courses', // keeps My Courses highlighted
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.62 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _back(context),
                const SizedBox(height: 12),
                _hero(context),
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
                          _about(),
                          const SizedBox(height: 16),
                          _weakTopics(context),
                          const SizedBox(height: 16),
                          _modules(context),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _instructor(),
                          const SizedBox(height: 16),
                          _info(),
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

  // ---------- Back to My Courses (fixed) ----------
  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/courses'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back, size: 18, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            'Back to My Courses',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Pill('ACTIVE COHORT',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
              Text(
                'CS 482 • Fall 2025',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'AI Fundamentals',
            style: GoogleFonts.manrope(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Neural networks, search, learning theory and reasoning, taught with an adaptive Socratic tutor.',
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.72,
                    minHeight: 8,
                    backgroundColor: AppColors.chip,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '72%',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/lesson'),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Resume Lesson'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/syllabus'),
                icon: const Icon(Icons.list_alt_outlined, size: 18),
                label: const Text('View Syllabus'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chip,
                  foregroundColor: AppColors.textDark,
                  elevation: 0,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _title(String t) {
    return Text(
      t,
      style: GoogleFonts.manrope(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _about() {
    Widget bullet(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.check_circle_outline,
                size: 16, color: AppColors.teal),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('What You Will Learn'),
          const SizedBox(height: 12),
          bullet('Build and train simple neural networks from first principles'),
          bullet('Apply search and optimization to reasoning problems'),
          bullet('Evaluate models with proper validation and error analysis'),
          bullet('Explain model decisions using transparent, step-by-step proofs'),
        ],
      ),
    );
  }

  // ---------- Weak topics in this course ----------
  Widget _weakTopics(BuildContext context) {
    Widget gap(String name, String reason, int mastery, String severity) {
      final high = severity == 'High';
      final Color bg =
      high ? const Color(0xFFFFE3E0) : const Color(0xFFFFE9CF);
      final Color fg =
      high ? const Color(0xFFB3261E) : const Color(0xFF8A4B00);

      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FF),
          borderRadius: BorderRadius.circular(14),
        ),
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
                Pill('$severity priority', bg: bg, fg: fg, fontSize: 10),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              reason,
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: mastery / 100,
                      minHeight: 6,
                      backgroundColor: AppColors.chip,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$mastery%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: fg,
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
          Row(
            children: [
              Expanded(child: _title('Weak Topics in This Course')),
              const SizedBox(width: 8),
              const Pill('2 gaps',
                  bg: Color(0xFFFFE9CF), fg: Color(0xFF8A4B00), fontSize: 10),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Diagnosed from your quizzes, labs and tutor sessions.',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 14),
          gap('Backpropagation',
              'Chain rule steps were skipped in two answers.', 58, 'High'),
          gap('Activation Functions',
              'Mixed up ReLU and sigmoid behavior on test vectors.', 66,
              'Medium'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/weak-topics'),
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: const Text('View All Weak Topics'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/ai-tutor'),
                icon: const Icon(Icons.psychology_alt_outlined, size: 18),
                label: const Text('Ask Socratic AI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chip,
                  foregroundColor: AppColors.textDark,
                  elevation: 0,
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _modules(BuildContext context) {
    Widget module(String name, String sub, String state) {
      final done = state == 'done';
      final current = state == 'current';
      final Color c = done
          ? AppColors.teal
          : current
          ? AppColors.primaryLight
          : AppColors.textGrey;
      final IconData icon = done
          ? Icons.check_circle
          : current
          ? Icons.play_circle_fill
          : Icons.lock_outline;

      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: current ? const Color(0xFFF1F1FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.chip),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: c),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    sub,
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
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _title('Modules')),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/syllabus'),
                child: Text(
                  'Full syllabus',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          module('Module 1: Foundations of AI', '6 lessons • Completed', 'done'),
          module('Module 2: Search & Optimization', '5 lessons • Completed',
              'done'),
          module('Module 3: Machine Learning Basics', '6 lessons • Completed',
              'done'),
          module('Module 4: Deep Learning Foundations',
              '5 lessons • 1 remaining', 'current'),
          module('Module 5: Reasoning & Explainability', '3 lessons • Locked',
              'locked'),
        ],
      ),
    );
  }

  Widget _instructor() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Instructor'),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.chip,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Ahmed Khan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Dept. of Computer Science',
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _info() {
    Widget row(IconData icon, String label, String value) {
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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Course Info'),
          const SizedBox(height: 14),
          row(Icons.menu_book_outlined, 'Lessons', '18 / 25'),
          row(Icons.timer_outlined, 'Time left', '6 h 20 min'),
          row(Icons.quiz_outlined, 'Assessments', '3 upcoming'),
          row(Icons.workspace_premium_outlined, 'Credits', '3 units'),
        ],
      ),
    );
  }
}