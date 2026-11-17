import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class _Lesson {
  final String title;
  final String type; // Video, Reading, Lab, Quiz
  final int minutes;
  final String state; // done, current, locked

  const _Lesson(this.title, this.type, this.minutes, this.state);
}

class _Module {
  final String title;
  final String summary;
  final List<_Lesson> lessons;

  const _Module(this.title, this.summary, this.lessons);
}

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  int _open = 3; // module 4 expanded by default

  static const _modules = [
    _Module('Module 1: Foundations of AI', 'History, agents and problem framing', [
      _Lesson('What is Artificial Intelligence?', 'Video', 18, 'done'),
      _Lesson('Intelligent Agents', 'Reading', 25, 'done'),
      _Lesson('Problem Formulation', 'Video', 20, 'done'),
      _Lesson('Foundations Quiz', 'Quiz', 15, 'done'),
    ]),
    _Module('Module 2: Search & Optimization', 'Uninformed and heuristic search', [
      _Lesson('Breadth-First and Depth-First Search', 'Video', 22, 'done'),
      _Lesson('A* and Heuristics', 'Video', 28, 'done'),
      _Lesson('Search Lab', 'Lab', 45, 'done'),
    ]),
    _Module('Module 3: Machine Learning Basics', 'Regression, classification, validation', [
      _Lesson('Linear Regression', 'Video', 24, 'done'),
      _Lesson('Classification and Perceptrons', 'Video', 26, 'done'),
      _Lesson('Validation and Overfitting', 'Reading', 20, 'done'),
    ]),
    _Module('Module 4: Deep Learning Foundations', 'Neural networks and training', [
      _Lesson('Neural Network Architectures', 'Video', 30, 'current'),
      _Lesson('Backpropagation Explained', 'Video', 32, 'locked'),
      _Lesson('Training Lab', 'Lab', 50, 'locked'),
      _Lesson('Unit 4 Test', 'Quiz', 30, 'locked'),
    ]),
    _Module('Module 5: Reasoning & Explainability', 'Transparent, step-by-step models', [
      _Lesson('Explainable AI Methods', 'Reading', 25, 'locked'),
      _Lesson('Proof-Style Reasoning', 'Video', 28, 'locked'),
      _Lesson('Final Assessment', 'Quiz', 45, 'locked'),
    ]),
  ];

  int get _totalLessons =>
      _modules.fold(0, (s, m) => s + m.lessons.length);

  int get _doneLessons => _modules.fold(
      0, (s, m) => s + m.lessons.where((l) => l.state == 'done').length);

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/courses', // keeps My Courses highlighted
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _back(context),
                const SizedBox(height: 12),
                _header(),
                const SizedBox(height: 16),
                _progress(),
                const SizedBox(height: 16),
                for (int i = 0; i < _modules.length; i++) ...[
                  _moduleCard(context, i),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back, size: 18, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            'Back to Course',
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

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Syllabus',
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'CS 482 • AI Fundamentals • Dr. Ahmed Khan',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _progress() {
    final pct = _doneLessons / _totalLessons;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$_doneLessons of $_totalLessons lessons completed',
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
                '${(pct * 100).round()}%',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: AppColors.chip,
              valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
            ),
          ),
        ],
      ),
    );
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'Video':
        return Icons.play_circle_outline;
      case 'Reading':
        return Icons.article_outlined;
      case 'Lab':
        return Icons.terminal;
      default:
        return Icons.quiz_outlined;
    }
  }

  Widget _moduleCard(BuildContext context, int index) {
    final m = _modules[index];
    final open = _open == index;
    final done = m.lessons.where((l) => l.state == 'done').length;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => setState(() => _open = open ? -1 : index),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${m.summary} • $done/${m.lessons.length} done',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    open ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textGrey,
                  ),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  for (final l in m.lessons) _lessonRow(context, l),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _lessonRow(BuildContext context, _Lesson l) {
    final done = l.state == 'done';
    final current = l.state == 'current';
    final locked = l.state == 'locked';

    final Color c = done
        ? AppColors.teal
        : current
        ? AppColors.primaryLight
        : AppColors.textGrey;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: locked ? null : () => Navigator.pushNamed(context, '/lesson'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: current ? const Color(0xFFF1F1FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.chip),
        ),
        child: Row(
          children: [
            Icon(
              done
                  ? Icons.check_circle
                  : locked
                  ? Icons.lock_outline
                  : _typeIcon(l.type),
              size: 20,
              color: c,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: locked ? AppColors.textGrey : AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${l.type} • ${l.minutes} min',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (current) ...[
              const SizedBox(width: 8),
              const Pill('Up next', fontSize: 10),
            ],
          ],
        ),
      ),
    );
  }
}