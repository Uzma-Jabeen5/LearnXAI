import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class _Note {
  final String id;
  final String title;
  final String sub;
  final String time;
  final String group; // Today, Earlier
  final String type; // grade, deadline, tutor, message
  final String route;

  const _Note({
    required this.id,
    required this.title,
    required this.sub,
    required this.time,
    required this.group,
    required this.type,
    required this.route,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Note> _notes = [
    const _Note(
      id: 'a1',
      title: 'Quiz Results Posted: Graph Traversal',
      sub: 'You scored 88%, above your predicted curve.',
      time: '1 hour ago',
      group: 'Today',
      type: 'grade',
      route: '/quiz-result',
    ),
    const _Note(
      id: 'a2',
      title: 'Assignment due in 3 days',
      sub: 'Lab 3: Backprop DAG & Gradient Verification',
      time: '3 hours ago',
      group: 'Today',
      type: 'deadline',
      route: '/assignments',
    ),
    const _Note(
      id: 'a3',
      title: 'Socratic tutor insight',
      sub: 'Your recursion accuracy improved by 18% this week.',
      time: '5 hours ago',
      group: 'Today',
      type: 'tutor',
      route: '/ai-tutor',
    ),
    const _Note(
      id: 'a4',
      title: 'New message from Dr. Ahmed Khan',
      sub: 'Office hours are tomorrow at 2:00 PM.',
      time: 'Yesterday',
      group: 'Earlier',
      type: 'message',
      route: '/announcements',
    ),
    const _Note(
      id: 'a5',
      title: 'Python Midterm scheduled',
      sub: 'Nov 02 at 2:00 PM. Proctoring check required.',
      time: '2 days ago',
      group: 'Earlier',
      type: 'deadline',
      route: '/tests',
    ),
    const _Note(
      id: 'a6',
      title: 'New recommendation ready',
      sub: 'Review Backpropagation with the Socratic Tutor.',
      time: 'Last week',
      group: 'Earlier',
      type: 'tutor',
      route: '/recommendations',
    ),
  ];

  final Set<String> _read = {'a4', 'a5', 'a6'};

  int get _unread => _notes.where((n) => !_read.contains(n.id)).length;

  IconData _icon(String t) {
    switch (t) {
      case 'grade':
        return Icons.check_circle_outline;
      case 'deadline':
        return Icons.event_outlined;
      case 'tutor':
        return Icons.psychology_alt_outlined;
      default:
        return Icons.mail_outline;
    }
  }

  Color _color(String t) {
    switch (t) {
      case 'grade':
        return AppColors.teal;
      case 'deadline':
        return const Color(0xFF8A4B00);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/notifications',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;

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
                    if (_notes.isEmpty)
                      _empty()
                    else ...[
                      _group('Today'),
                      _group('Earlier'),
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
                'Notifications',
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
                    : '$_unread unread notifications.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _unread == 0
                  ? null
                  : () => setState(
                      () => _read.addAll(_notes.map((n) => n.id))),
              child: Text(
                'Mark all read',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                  _unread == 0 ? AppColors.textGrey : AppColors.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: _notes.isEmpty
                  ? null
                  : () => setState(() => _notes.clear()),
              child: Text(
                'Clear all',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _empty() {
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Column(
            children: [
              const Icon(Icons.notifications_none,
                  size: 36, color: AppColors.textGrey),
              const SizedBox(height: 8),
              Text(
                'No notifications',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _group(String name) {
    final items = _notes.where((n) => n.group == name).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              name.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppColors.textGrey,
              ),
            ),
          ),
          for (final n in items) ...[
            _tile(n),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _tile(_Note n) {
    final unread = !_read.contains(n.id);
    final color = _color(n.type);

    return Dismissible(
      key: ValueKey(n.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => setState(() => _notes.removeWhere((x) => x.id == n.id)),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE3E0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Color(0xFFB3261E)),
      ),
      child: AppCard(
        color: unread ? const Color(0xFFF4F7FF) : Colors.white,
        padding: const EdgeInsets.all(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() => _read.add(n.id));
            Navigator.pushNamed(context, n.route);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon(n.type), size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight:
                        unread ? FontWeight.w700 : FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      n.sub,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.4,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      n.time,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              if (unread) ...[
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.circle, size: 9, color: AppColors.teal),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}