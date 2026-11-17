import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class _Course {
  final String code;
  final String title;
  final String instructor;
  final String nextLesson;
  final String status; // In Progress, Completed, Not Started
  final int percent;
  final int done;
  final int total;
  final Color color;
  final IconData icon;

  const _Course({
    required this.code,
    required this.title,
    required this.instructor,
    required this.nextLesson,
    required this.status,
    required this.percent,
    required this.done,
    required this.total,
    required this.color,
    required this.icon,
  });
}

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  String _filter = 'All';

  static const _courses = [
    _Course(
      code: 'CS 482',
      title: 'AI Fundamentals',
      instructor: 'Dr. Ahmed Khan',
      nextLesson: 'Neural Network Architectures',
      status: 'In Progress',
      percent: 72,
      done: 18,
      total: 25,
      color: AppColors.primaryLight,
      icon: Icons.psychology_alt_outlined,
    ),
    _Course(
      code: 'CS 204',
      title: 'Data Structures & Algorithms',
      instructor: 'Prof. Usman',
      nextLesson: 'Binary Search Traversal',
      status: 'In Progress',
      percent: 45,
      done: 11,
      total: 24,
      color: AppColors.teal,
      icon: Icons.data_object,
    ),
    _Course(
      code: 'CS 101',
      title: 'Intro to Python',
      instructor: 'Dr. Tariq',
      nextLesson: 'Course completed',
      status: 'Completed',
      percent: 100,
      done: 20,
      total: 20,
      color: AppColors.teal,
      icon: Icons.code,
    ),
    _Course(
      code: 'CS 330',
      title: 'Operating Systems',
      instructor: 'Prof. Sara Malik',
      nextLesson: 'Memory Paging Basics',
      status: 'Not Started',
      percent: 0,
      done: 0,
      total: 22,
      color: AppColors.primaryLight,
      icon: Icons.memory,
    ),
  ];

  int _count(String s) => _courses.where((c) => c.status == s).length;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/courses', // matches sidebar + main.dart
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final cardW = wide ? (inner - 16) / 2 : inner;

          final list = _filter == 'All'
              ? _courses
              : _courses.where((x) => x.status == _filter).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                _summary(),
                const SizedBox(height: 16),
                _filters(),
                const SizedBox(height: 16),
                if (list.isEmpty)
                  _empty()
                else
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final course in list)
                        SizedBox(
                          width: cardW,
                          child: _courseCard(context, course),
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

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Courses',
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Track your enrolled courses, progress, and next lessons.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _summary() {
    Widget tile(String label, int value, IconData icon, Color color) {
      return Expanded(
        child: AppCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 8),
              Text(
                '$value',
                style: GoogleFonts.manrope(
                  fontSize: 22,
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
        tile('Enrolled', _courses.length, Icons.menu_book_outlined,
            AppColors.primary),
        const SizedBox(width: 10),
        tile('In Progress', _count('In Progress'), Icons.timelapse,
            AppColors.primaryLight),
        const SizedBox(width: 10),
        tile('Completed', _count('Completed'), Icons.check_circle_outline,
            AppColors.teal),
      ],
    );
  }

  Widget _filters() {
    const options = ['All', 'In Progress', 'Completed', 'Not Started'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          ChoiceChip(
            label: Text(
              o,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _filter == o ? Colors.white : AppColors.textDark,
              ),
            ),
            selected: _filter == o,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.chip,
            showCheckmark: false,
            onSelected: (_) => setState(() => _filter = o),
          ),
      ],
    );
  }

  Widget _empty() {
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No courses in this category yet.',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
          ),
        ),
      ),
    );
  }

  Widget _courseCard(BuildContext context, _Course c) {
    final completed = c.status == 'Completed';
    final notStarted = c.status == 'Not Started';
    final buttonText =
    completed ? 'Review' : (notStarted ? 'Start Course' : 'Resume');
    final buttonIcon = completed
        ? Icons.replay
        : (notStarted ? Icons.rocket_launch_outlined : Icons.play_arrow);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(c.icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${c.code} • ${c.instructor}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${c.percent}%',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: c.percent / 100,
              minHeight: 6,
              backgroundColor: AppColors.chip,
              valueColor: AlwaysStoppedAnimation<Color>(c.color),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${c.done}/${c.total} lessons',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Pill(
                c.status,
                bg: completed ? AppColors.mint : AppColors.chip,
                fg: completed ? AppColors.teal : AppColors.primary,
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Next: ${c.nextLesson}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/course-details'),
              icon: Icon(buttonIcon, size: 18),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.color,
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
          ),
        ],
      ),
    );
  }
}