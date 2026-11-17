import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  bool _playing = false;
  double _position = 0.35; // 0..1
  String _tab = 'Overview';

  static const _totalMinutes = 30;

  String _time(double p) {
    final secs = (p * _totalMinutes * 60).round();
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/courses', // keeps My Courses highlighted
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.64 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _back(context),
                const SizedBox(height: 12),
                _titleBlock(),
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
                          _player(),
                          const SizedBox(height: 16),
                          _tabs(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _actions(context),
                          const SizedBox(height: 16),
                          _upNext(),
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

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back, size: 18, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            'Back to Syllabus',
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

  Widget _titleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Module 4 • Lesson 1',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Neural Network Architectures',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'CS 482 • AI Fundamentals • 30 min video',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textGrey),
        ),
      ],
    );
  }

  Widget _player() {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: const Color(0xFF1E1B4B),
                child: Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _playing = !_playing),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _playing = !_playing),
                  icon: Icon(
                    _playing ? Icons.pause : Icons.play_arrow,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  _time(_position),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _position,
                    activeColor: AppColors.primaryLight,
                    inactiveColor: AppColors.chip,
                    onChanged: (v) => setState(() => _position = v),
                  ),
                ),
                Text(
                  '$_totalMinutes:00',
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

  Widget _tabs() {
    const names = ['Overview', 'Notes', 'Resources'];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final n in names)
                ChoiceChip(
                  label: Text(
                    n,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _tab == n ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  selected: _tab == n,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.chip,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _tab = n),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (_tab == 'Overview') _overview(),
          if (_tab == 'Notes') _notes(),
          if (_tab == 'Resources') _resources(),
        ],
      ),
    );
  }

  Widget _body(String t) => Text(
    t,
    style: GoogleFonts.inter(
      fontSize: 13,
      height: 1.6,
      color: AppColors.textDark,
    ),
  );

  Widget _overview() {
    Widget point(String t) => Padding(
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
          Expanded(child: _body(t)),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(
            'This lesson introduces the main neural network architectures and how layers, weights and activations fit together.'),
        const SizedBox(height: 12),
        point('Feed-forward networks and the role of hidden layers'),
        point('Activation functions: ReLU, sigmoid and tanh'),
        point('Convolutional and recurrent networks at a high level'),
      ],
    );
  }

  Widget _notes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body('Your notes for this lesson'),
        const SizedBox(height: 10),
        TextField(
          maxLines: 5,
          style: GoogleFonts.inter(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Write a note about what you just learned...',
            hintStyle:
            GoogleFonts.inter(fontSize: 13, color: AppColors.textGrey),
            filled: true,
            fillColor: AppColors.chip,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _resources() {
    Widget item(IconData icon, String name, String sub) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.chip,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
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
          const Icon(Icons.download_outlined,
              size: 18, color: AppColors.textGrey),
        ],
      ),
    );

    return Column(
      children: [
        item(Icons.picture_as_pdf_outlined, 'Lecture Slides', 'PDF • 2.4 MB'),
        item(Icons.article_outlined, 'Reading: Deep Learning Ch. 6',
            'Article • 25 min'),
        item(Icons.code, 'Starter Notebook', 'Python • 18 KB'),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/ai-tutor'),
            icon: const Icon(Icons.psychology_alt_outlined, size: 18),
            label: const Text('Ask the AI Tutor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              minimumSize: const Size(0, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Mark as Complete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              minimumSize: const Size(0, 46),
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
    );
  }

  Widget _upNext() {
    Widget row(String name, String sub, bool locked) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            locked ? Icons.lock_outline : Icons.play_circle_outline,
            size: 20,
            color: locked ? AppColors.textGrey : AppColors.primaryLight,
          ),
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
                    color:
                    locked ? AppColors.textGrey : AppColors.textDark,
                  ),
                ),
                Text(
                  sub,
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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Up Next',
            style: GoogleFonts.manrope(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          row('Backpropagation Explained', 'Video • 32 min', true),
          row('Training Lab', 'Lab • 50 min', true),
          row('Unit 4 Test', 'Quiz • 30 min', true),
        ],
      ),
    );
  }
}