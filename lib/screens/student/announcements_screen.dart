import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class _Notice {
  final String id;
  final String title;
  final String body;
  final String author;
  final String course;
  final String category; // Faculty, Exam, System
  final String time;
  final bool pinned;

  const _Notice({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.course,
    required this.category,
    required this.time,
    this.pinned = false,
  });
}

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  String _filter = 'All';
  final Set<String> _read = {'n5'};
  final Set<String> _open = {};

  static const _items = [
    _Notice(
      id: 'n1',
      title: 'Python Midterm: Proctoring Setup Required',
      body:
      'The midterm on Nov 02 is proctored. Please test your camera and microphone from the Tests page at least one day before the exam.',
      author: 'Exam Office',
      course: 'Intro to Python',
      category: 'Exam',
      time: '2 hours ago',
      pinned: true,
    ),
    _Notice(
      id: 'n2',
      title: 'New Assignment: Advanced Heuristics Part 2',
      body:
      'Dr. Tariq has posted Part 2 of the heuristics assignment. It is due in 7 days and counts for 10% of the course grade.',
      author: 'Dr. Tariq',
      course: 'AI Fundamentals',
      category: 'Faculty',
      time: '4 hours ago',
    ),
    _Notice(
      id: 'n3',
      title: 'Office Hours Moved to 2:00 PM',
      body:
      'Tomorrow\'s office hours for CS 301 will start at 2:00 PM instead of 1:00 PM. Bring your questions on alpha-beta pruning.',
      author: 'Dr. Ahmed Khan',
      course: 'AI Fundamentals',
      category: 'Faculty',
      time: 'Yesterday',
    ),
    _Notice(
      id: 'n4',
      title: 'Socratic Engine Updated to v4.2',
      body:
      'The tutor now gives step-by-step hints and tracks your concept mastery more accurately. No action needed on your side.',
      author: 'LearnXAI Team',
      course: 'Platform',
      category: 'System',
      time: '2 days ago',
    ),
    _Notice(
      id: 'n5',
      title: 'Unit 3 Test Results Published',
      body:
      'Results for the Sorting unit test are now available on the Tests page. Review your answers to see where you can improve.',
      author: 'Prof. Usman',
      course: 'Data Structures & Algorithms',
      category: 'Exam',
      time: 'Last week',
    ),
  ];

  int get _unread => _items.where((n) => !_read.contains(n.id)).length;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/announcements',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;

          final list = _items
              .where((n) => _filter == 'All' || n.category == _filter)
              .toList()
            ..sort((a, b) {
              if (a.pinned == b.pinned) return 0;
              return a.pinned ? -1 : 1;
            });

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 16),
                    _filters(),
                    const SizedBox(height: 16),
                    if (list.isEmpty)
                      _empty()
                    else
                      for (final n in list) ...[
                        _card(n),
                        const SizedBox(height: 12),
                      ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Announcements',
                style: GoogleFonts.manrope(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _unread == 0
                    ? 'You are all caught up.'
                    : '$_unread unread from your faculty and the platform.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: _unread == 0
              ? null
              : () => setState(() => _read.addAll(_items.map((n) => n.id))),
          child: Text(
            'Mark all read',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _unread == 0 ? AppColors.textGrey : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _filters() {
    const options = ['All', 'Faculty', 'Exam', 'System'];
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
            'No announcements in this category.',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
          ),
        ),
      ),
    );
  }

  Widget _card(_Notice n) {
    final unread = !_read.contains(n.id);
    final open = _open.contains(n.id);

    Color bg;
    Color fg;
    switch (n.category) {
      case 'Exam':
        bg = const Color(0xFFFFE9CF);
        fg = const Color(0xFF8A4B00);
        break;
      case 'System':
        bg = AppColors.mint;
        fg = AppColors.teal;
        break;
      default:
        bg = AppColors.chip;
        fg = AppColors.primary;
    }

    return AppCard(
      color: unread ? const Color(0xFFF4F7FF) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() {
          _read.add(n.id);
          if (open) {
            _open.remove(n.id);
          } else {
            _open.add(n.id);
          }
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Pill(n.category, bg: bg, fg: fg, fontSize: 10),
                if (n.pinned) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.push_pin,
                      size: 14, color: AppColors.primary),
                ],
                const Spacer(),
                if (unread)
                  const Icon(Icons.circle, size: 9, color: AppColors.teal),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              n.title,
              style: GoogleFonts.manrope(
                fontSize: 16,
                height: 1.3,
                fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${n.author} • ${n.course} • ${n.time}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
              GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey),
            ),
            const SizedBox(height: 10),
            Text(
              n.body,
              maxLines: open ? null : 2,
              overflow: open ? TextOverflow.visible : TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              open ? 'Show less' : 'Read more',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}