import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Lecture {
  final String title;
  final String meta;
  final String duration;
  final Color c1;
  final Color c2;
  final IconData icon;

  const _Lecture(this.title, this.meta, this.duration, this.c1, this.c2,
      this.icon);
}

class TeacherLecturesScreen extends StatefulWidget {
  const TeacherLecturesScreen({super.key});

  @override
  State<TeacherLecturesScreen> createState() => _TeacherLecturesScreenState();
}

class _TeacherLecturesScreenState extends State<TeacherLecturesScreen> {
  static const _soft = Color(0xFFF4F7FF);
  static const _amber = Color(0xFF8A4B00);
  static const _red = Color(0xFFB3261E);

  final List<_Lecture> _lectures = [
    const _Lecture(
        'Lecture 3.2: Loss Surfaces, Saddle Points & Momentum',
        'Module 3 • Lesson 2 • 312 Student Views • Uploaded Oct 16',
        '24:10 mins',
        Color(0xFF3B2FCB),
        Color(0xFF14B8A6),
        Icons.terrain),
    const _Lecture(
        'Lecture 3.1: Multilayer Perceptrons & Non-Linear Activations',
        'Module 3 • Lesson 1 • 340 Views • Uploaded Oct 14',
        '18:40 mins',
        Color(0xFF1E1B4B),
        Color(0xFF4F46E5),
        Icons.hub_outlined),
    const _Lecture(
        'Lecture 2.4: Adversarial Search & Cutoff Heuristics',
        'Module 2 • Lesson 4 • 298 Views • Uploaded Oct 08',
        '28:15 mins',
        Color(0xFF475569),
        Color(0xFF94A3B8),
        Icons.account_tree_outlined),
    const _Lecture(
        'Lecture 3.3: Spatial Convolutions & Pooling Topologies',
        'Module 3 • Lesson 3 • 280 Views • Uploaded Oct 12',
        '31:05 mins',
        Color(0xFF0F172A),
        Color(0xFF0EA5E9),
        Icons.grid_view),
  ];

  int _sel = 0;
  String _query = '';
  bool _gridView = true;
  bool _encoding = true;
  String _lang = 'English (US)';
  bool _generated = false;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  ButtonStyle _btn(Color bg, Color fg) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      minimumSize: const Size(0, 42),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  Widget _grid(List<Widget> items, {double minItemWidth = 200}) {
    return LayoutBuilder(
      builder: (context, cc) {
        int cols = ((cc.maxWidth + 12) / (minItemWidth + 12)).floor();
        if (cols < 1) cols = 1;
        if (cols > items.length && items.isNotEmpty) cols = items.length;
        final w = (cc.maxWidth - 12 * (cols - 1)) / cols;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [for (final i in items) SizedBox(width: w, child: i)],
        );
      },
    );
  }

  List<int> get _visible {
    final out = <int>[];
    for (int i = 0; i < _lectures.length; i++) {
      if (_query.trim().isEmpty ||
          _lectures[i].title.toLowerCase().contains(_query.toLowerCase())) {
        out.add(i);
      }
    }
    return out;
  }

  void _addVideo() {
    setState(() {
      _lectures.insert(
        0,
        const _Lecture(
            'Lecture 3.5: New Recording (Processing)',
            'Module 3 • Lesson 5 • 0 Views • Uploaded just now',
            '12:00 mins',
            Color(0xFF6D28D9),
            Color(0xFFEC4899),
            Icons.movie_outlined),
      );
      _sel = 0;
    });
    _snack('Video added and queued for transcription');
  }

  void _delete(int i) {
    setState(() {
      _lectures.removeAt(i);
      if (_sel >= _lectures.length) _sel = _lectures.isEmpty ? 0 : _lectures.length - 1;
    });
    _snack('Lecture deleted');
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/teacher-lectures',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.62 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
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
                          _dropzone(),
                          if (_encoding) ...[
                            const SizedBox(height: 16),
                            _encodingCard(),
                          ],
                          const SizedBox(height: 16),
                          _library(),
                        ],
                      ),
                    ),
                    SizedBox(width: sideW, child: _studio()),
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
        Wrap(
          spacing: 10,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Pill('TEACHER MODULE • SCREEN 30',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
            const Pill('Studio Synced',
                bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Lecture Video Management & Socratic Studio',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Upload recorded lectures, auto-generate synchronized transcripts, configure multi-language captions, and review AI chapter segmentations.',
          style: GoogleFonts.inter(
              fontSize: 13, height: 1.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.terminal,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('CS-301: AI Fundamentals & Search',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      )),
                  const SizedBox(width: 6),
                  const Icon(Icons.unfold_more,
                      size: 16, color: AppColors.textGrey),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addVideo,
              icon: const Icon(Icons.video_call_outlined, size: 18),
              label: const Text('New Lecture'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- Stats ----------
  Widget _stats() {
    Widget s(IconData icon, String v, String l) {
      return AppCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      )),
                  Text(l,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textGrey)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return _grid([
      s(Icons.video_library_outlined, '${_lectures.length}',
          'Lectures Uploaded'),
      s(Icons.schedule, '24.5 hrs', 'Total Footage Tracked'),
      s(Icons.record_voice_over_outlined, '98.4%', 'Transcript Accuracy'),
      s(Icons.visibility_outlined, '340 Views', 'Student Replays This Week'),
    ], minItemWidth: 160);
  }

  // ---------- Dropzone + encoding ----------
  Widget _dropzone() {
    return AppCard(
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.chip,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.movie_creation_outlined,
                color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text(
            'Drag and drop high-definition lecture recordings',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 15,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Select or drop raw recordings. AI will automatically build knowledge graph anchors, extract slides, and construct Socratic checkpoints.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 11, height: 1.5, color: AppColors.textGrey),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final t in const [
                'MP4',
                'MOV',
                'MKV',
                'WEBM',
                'Up to 4K 60fps • Max 5GB per video'
              ])
                Pill(t,
                    bg: _soft, fg: AppColors.textGrey, fontSize: 9),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _addVideo,
            icon: const Icon(Icons.cloud_upload_outlined, size: 18),
            label: const Text('Select Video File'),
            style: _btn(AppColors.primary, Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _encodingCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lecture 3.4: Vanishing & Exploding Gradients in Deep Nets',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Encoding 1080p & Generating Socratic Transcript',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('64%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  )),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.64,
              minHeight: 6,
              backgroundColor: AppColors.chip,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text('Stage 3/4: Semantic Knowledge Anchor Matching',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textGrey)),
              InkWell(
                onTap: () {
                  setState(() => _encoding = false);
                  _snack('Task cancelled');
                },
                child: Text('Cancel Task',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _red,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Library ----------
  Widget _library() {
    final vis = _visible;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Video Library',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  )),
              Pill('${_lectures.length} items',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 9),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search lecture titles...',
                    hintStyle: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textGrey),
                    prefixIcon: const Icon(Icons.search,
                        size: 20, color: AppColors.textGrey),
                    filled: true,
                    fillColor: const Color(0xFFF1F1FF),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _toggle(Icons.grid_view, _gridView, () {
                setState(() => _gridView = true);
              }),
              const SizedBox(width: 4),
              _toggle(Icons.view_list, !_gridView, () {
                setState(() => _gridView = false);
              }),
            ],
          ),
          const SizedBox(height: 14),
          if (vis.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No lectures match your search.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textGrey)),
              ),
            )
          else if (_gridView)
            _grid([for (final i in vis) _videoCard(i)], minItemWidth: 230)
          else
            Column(children: [for (final i in vis) _videoRow(i)]),
        ],
      ),
    );
  }

  Widget _toggle(IconData icon, bool on, VoidCallback tap) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: tap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: on ? AppColors.chip : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon,
            size: 18, color: on ? AppColors.primary : AppColors.textGrey),
      ),
    );
  }

  Widget _thumb(_Lecture l, bool selected, {bool badges = true}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [l.c1, l.c2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(l.icon,
                  size: 44, color: Colors.white.withValues(alpha: 0.55)),
            ),
            if (badges) ...[
              Positioned(
                left: 8,
                bottom: 8,
                child: _tag(l.duration),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: _tag('1080p HD'),
              ),
              if (selected)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('SELECTED',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tag(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(t,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          )),
    );
  }

  Widget _videoCard(int i) {
    final l = _lectures[i];
    final selected = _sel == i;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => setState(() => _sel = i),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.chip,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _thumb(l, selected),
            const SizedBox(height: 10),
            Text(
              l.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l.meta,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontSize: 10, height: 1.4, color: AppColors.textGrey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 14, color: AppColors.teal),
                const SizedBox(width: 4),
                Expanded(
                  child: Text('Ready & AI Synced',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.teal,
                      )),
                ),
                InkWell(
                  onTap: () => _snack('Transcript re-synced'),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.sync,
                        size: 16, color: AppColors.textGrey),
                  ),
                ),
                InkWell(
                  onTap: () => _delete(i),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.delete_outline,
                        size: 16, color: AppColors.textGrey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoRow(int i) {
    final l = _lectures[i];
    final selected = _sel == i;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _sel = i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1F1FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? AppColors.primary : AppColors.chip),
        ),
        child: Row(
          children: [
            SizedBox(width: 96, child: _thumb(l, selected, badges: false)),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${l.duration} • 1080p HD',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => _delete(i),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.delete_outline,
                    size: 18, color: AppColors.textGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- AI studio panel ----------
  Widget _studio() {
    if (_lectures.isEmpty) {
      return AppCard(
        child: Text('Select or upload a lecture to start the AI analysis.',
            style:
            GoogleFonts.inter(fontSize: 13, color: AppColors.textGrey)),
      );
    }
    final l = _lectures[_sel.clamp(0, _lectures.length - 1)];

    Widget chapter(String time, String title, String sub,
        {String? spike}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: spike != null ? const Color(0xFFF1F1FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: spike != null ? AppColors.primary : AppColors.chip,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(time,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: spike != null ? Colors.white : AppColors.primary,
                  )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            )),
                      ),
                      if (spike != null) ...[
                        const SizedBox(width: 6),
                        Pill(spike,
                            bg: const Color(0xFFFFE9CF),
                            fg: _amber,
                            fontSize: 8),
                      ],
                    ],
                  ),
                  Text(sub,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textGrey)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget concept(String t) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome,
              size: 12, color: AppColors.teal),
          const SizedBox(width: 6),
          Flexible(
            child: Text(t,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.teal,
                )),
          ),
        ],
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Explainable AI Video Studio',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  )),
              const Pill('Socratic v4.2 Calibrated',
                  bg: AppColors.chip, fg: AppColors.primary, fontSize: 9),
              const Pill('94.8% Conf.',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ACTIVE ANALYSIS TARGET',
                          style: GoogleFonts.inter(
                              fontSize: 9, color: AppColors.textGrey)),
                      Text(
                        l.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => setState(
                          () => _sel = (_sel + 1) % _lectures.length),
                  child: Text('Change',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text('Auto-Segmented Chapters (4)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    )),
              ),
              Text('Synchronized to Transcript',
                  style: GoogleFonts.inter(
                      fontSize: 9, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 8),
          chapter('00:00', 'Introduction to Non-Convex Loss Landscapes',
              'High-dimensional parameter space overview'),
          chapter('06:15', 'Hessian Matrix Eigenvalue Decomposition',
              'Curvature analysis via eigenvalues'),
          chapter('14:32', 'Saddle Points vs. Local Minima',
              'Replay clustering identified • Correlates with Quiz 3',
              spike: 'Spike'),
          chapter('19:40', 'Momentum Accelerations across Escapes',
              'Damped harmonic oscillator formulation'),
          const SizedBox(height: 8),
          Text('Detected Core Concepts (Ontology)',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              concept('Hessian Curvature (98%)'),
              concept('Saddle Instability (94%)'),
              concept('Momentum Beta (89%)'),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology_alt_outlined,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('Explainable AI Diagnostic',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'AI detected Recursion, Stack Memory, and Saddle Points as primary concepts because they occurred consistently with high semantic weight. Student replay spikes at 14:32 correlate directly with Quiz 3 Question 6 error patterns.',
                  style: GoogleFonts.inter(
                      fontSize: 11, height: 1.5, color: AppColors.textDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text('Recommended Pedagogical Interventions',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.quiz_outlined,
                    size: 20, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('3-Question Diagnostic Check',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          )),
                      Text('Target: Negative eigenvalue direction reasoning',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textGrey)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _generated
                      ? null
                      : () {
                    setState(() => _generated = true);
                    _snack('Diagnostic check generated');
                  },
                  style: _btn(Colors.white, AppColors.primary),
                  child: Text(_generated ? 'Done' : 'Generate'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.smart_toy_outlined,
                    size: 20, color: AppColors.teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Student Socratic Copilot Sync',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          )),
                      Text('Active in Student Module Lesson 3.2',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textGrey)),
                    ],
                  ),
                ),
                const Icon(Icons.circle, size: 9, color: AppColors.teal),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text('Synchronized Captions',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    )),
              ),
              Text('3 Languages Ready',
                  style: GoogleFonts.inter(
                      fontSize: 9, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final lang in const [
                'English (US)',
                'Spanish (ES)',
                'French (FR)'
              ])
                ChoiceChip(
                  label: Text(lang,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _lang == lang
                            ? Colors.white
                            : AppColors.textDark,
                      )),
                  selected: _lang == lang,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.chip,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _lang = lang),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => _snack('Transcript editor ($_lang)'),
                icon: const Icon(Icons.edit_note, size: 16),
                label: const Text('Review & Edit Transcript'),
                style: _btn(AppColors.chip, AppColors.textDark),
              ),
              ElevatedButton.icon(
                onPressed: () => _snack('SRT downloaded ($_lang)'),
                icon: const Icon(Icons.download, size: 16),
                label: const Text('SRT'),
                style: _btn(AppColors.chip, AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}