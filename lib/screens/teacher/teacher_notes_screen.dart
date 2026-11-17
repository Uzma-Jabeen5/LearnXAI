import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_shell.dart';

class _Doc {
  final String name;
  final String meta;
  final String module;
  final int moduleNo; // 0 = general
  final String type; // PDF, Slides, Docs
  final String by;
  final IconData icon;
  final Color color;

  const _Doc(this.name, this.meta, this.module, this.moduleNo, this.type,
      this.by, this.icon, this.color);
}

class TeacherNotesScreen extends StatefulWidget {
  const TeacherNotesScreen({super.key});

  @override
  State<TeacherNotesScreen> createState() => _TeacherNotesScreenState();
}

class _TeacherNotesScreenState extends State<TeacherNotesScreen> {
  static const _soft = Color(0xFFF4F7FF);
  static const _amber = Color(0xFF8A4B00);
  static const _red = Color(0xFFB3261E);
  static const _pageSize = 4;

  final List<_Doc> _docs = [
    const _Doc(
        'Chapter 3 - Backpropagation & Loss Surfaces.pdf',
        '18.4 MB • 42 Pages • 18 Diagrams',
        'Module 3.2',
        3,
        'PDF',
        'Oct 16 • Dr. Khan',
        Icons.picture_as_pdf_outlined,
        _red),
    const _Doc(
        'Lecture 2 - Heuristic Search Invariants.pptx',
        '34.2 MB • 56 Slides • 8 Code Snippets',
        'Module 2.1',
        2,
        'Slides',
        'Oct 12 • Dr. Khan',
        Icons.slideshow_outlined,
        _amber),
    const _Doc(
        'Problem_Set_4_Solution_Key.pdf',
        '4.8 MB • 12 Pages • TeX Math Engine',
        'Module 3.4',
        3,
        'PDF',
        'Oct 10 • TA Imran',
        Icons.picture_as_pdf_outlined,
        _red),
    const _Doc(
        'Syllabus_Fall2025_Academic_Charter.pdf',
        '2.1 MB • Policy Charter & Rubrics',
        'General Course',
        0,
        'Docs',
        'Sep 02 • Dr. Khan',
        Icons.description_outlined,
        AppColors.primary),
    const _Doc(
        'Lecture 1 - Foundations of AI.pptx',
        '22.0 MB • 40 Slides',
        'Module 1.1',
        1,
        'Slides',
        'Sep 05 • Dr. Khan',
        Icons.slideshow_outlined,
        _amber),
    const _Doc(
        'Ethics_Reading_Pack.docx',
        '3.3 MB • 18 Pages',
        'Module 4.1',
        4,
        'Docs',
        'Oct 18 • Dr. Khan',
        Icons.description_outlined,
        AppColors.primary),
  ];

  int _module = -1; // -1 = all
  String _query = '';
  String _type = 'All Types';
  String _sort = 'Newest';
  int _page = 0;
  int _sel = 0;
  final Set<int> _checked = {0};
  bool _pipeline = true;

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

  List<_Doc> get _visible {
    var list = _docs.where((d) {
      if (_module != -1 && d.moduleNo != _module) return false;
      if (_type != 'All Types' && d.type != _type) return false;
      if (_query.trim().isNotEmpty &&
          !d.name.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
    if (_sort == 'Name') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sort == 'Oldest') {
      list = list.reversed.toList();
    }
    return list;
  }

  int _count(int m) =>
      m == -1 ? _docs.length : _docs.where((d) => d.moduleNo == m).length;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/teacher-notes',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          final pad = c.maxWidth >= 700 ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.66 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                _moduleChips(),
                const SizedBox(height: 16),
                _grid([_dropzone(), if (_pipeline) _pipelineCard()],
                    minItemWidth: 300),
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
                          _library(),
                          const SizedBox(height: 16),
                          _stats(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _inspector(),
                          const SizedBox(height: 16),
                          _privacy(),
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
            const Pill('Teacher Cockpit • Screen 29',
                bg: AppColors.chip, fg: AppColors.primary, fontSize: 10),
            Text('Indexing Engine Active',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Course Lecture Notes & Documents Repository',
          style: GoogleFonts.manrope(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Upload, organize, and inspect pedagogical lecture slides, problem sets, and reading materials with AI conceptual indexing.',
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
                  const Icon(Icons.school_outlined,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('CS-301: AI Fundamentals',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      )),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _snack('Re-indexing all documents'),
              icon: const Icon(Icons.sync, size: 18),
              label: const Text('Re-index All'),
              style: _btn(Colors.white, AppColors.textDark),
            ),
            ElevatedButton.icon(
              onPressed: _upload,
              icon: const Icon(Icons.cloud_upload_outlined, size: 18),
              label: const Text('Upload Notes'),
              style: _btn(AppColors.primaryLight, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  void _upload() {
    setState(() {
      _docs.insert(
        0,
        const _Doc(
            'New_Lecture_Notes.pdf',
            '1.2 MB • 10 Pages • Indexing...',
            'Module 3.5',
            3,
            'PDF',
            'Just now • Dr. Khan',
            Icons.picture_as_pdf_outlined,
            _red),
      );
      _sel = 0;
      _checked
        ..clear()
        ..add(0);
      _page = 0;
    });
    _snack('Notes uploaded and queued for indexing');
  }

  // ---------- Module chips ----------
  Widget _moduleChips() {
    final items = <MapEntry<int, String>>[
      const MapEntry(-1, 'All Modules'),
      const MapEntry(1, 'Module 1: Foundations'),
      const MapEntry(2, 'Module 2: Heuristics'),
      const MapEntry(3, 'Module 3: Neural Nets & DAGs'),
      const MapEntry(4, 'Module 4: Ethics'),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final e in items)
          ChoiceChip(
            label: Text(
              '${e.value} (${_count(e.key)})',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _module == e.key ? Colors.white : AppColors.textDark,
              ),
            ),
            selected: _module == e.key,
            selectedColor: AppColors.primary,
            backgroundColor: Colors.white,
            showCheckmark: false,
            onSelected: (_) => setState(() {
              _module = e.key;
              _page = 0;
            }),
          ),
      ],
    );
  }

  // ---------- Dropzone ----------
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
            child: const Icon(Icons.drive_folder_upload_outlined,
                color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text(
            'Drag and drop course notes here or click to browse',
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
            'Files are automatically parsed by Socratic Indexer to extract formula trees, slide hierarchy, and practice flashcards.',
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
                'PDF (Slide Decks)',
                'DOCX',
                'PPTX',
                'LaTeX / TEX',
                'ZIP (Jupyter Notebooks)',
                'Max 100MB'
              ])
                Pill(t,
                    bg: Colors.white, fg: AppColors.textGrey, fontSize: 9),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: _upload,
                icon: const Icon(Icons.folder_open, size: 16),
                label: const Text('Browse Local Drive'),
                style: _btn(AppColors.primary, Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: () => _snack('Google Drive / Canvas import'),
                icon: const Icon(Icons.cloud_download_outlined, size: 16),
                label: const Text('Import Drive / Canvas'),
                style: _btn(Colors.white, AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pipelineCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.teal),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'ACTIVE STREAMING PIPELINE',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text('1 of 1 File',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_outlined,
                        size: 22, color: _red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lecture_04_Backprop_Calculus.pdf',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            '14.2 MB / 18.0 MB • 4s remaining',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() => _pipeline = false);
                        _snack('Upload cancelled');
                      },
                      child: const Icon(Icons.cancel_outlined,
                          size: 20, color: AppColors.textGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.78,
                    minHeight: 6,
                    backgroundColor: AppColors.chip,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text('Stage 2/3: PDF Parser & OCR',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textGrey)),
                    ),
                    Text('78%',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.bolt, size: 14, color: AppColors.textGrey),
              const SizedBox(width: 6),
              Expanded(
                child: Text('Accelerated Vector DB Upsert',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textGrey)),
              ),
              Text('Logs',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Document library ----------
  Widget _library() {
    final list = _visible;
    final pages = (list.length / _pageSize).ceil().clamp(1, 99);
    if (_page >= pages) _page = pages - 1;
    final shown = list.skip(_page * _pageSize).take(_pageSize).toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (v) => setState(() {
              _query = v;
              _page = 0;
            }),
            style: GoogleFonts.inter(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Filter notes by keyword, topic, or tag',
              hintStyle:
              GoogleFonts.inter(fontSize: 13, color: AppColors.textGrey),
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
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _menu('Type', _type, const ['All Types', 'PDF', 'Slides', 'Docs'],
                      (v) => setState(() {
                    _type = v;
                    _page = 0;
                  })),
              _menu('Sort', _sort, const ['Newest', 'Oldest', 'Name'],
                      (v) => setState(() => _sort = v)),
              ElevatedButton.icon(
                onPressed: () => _snack('Exported ${_checked.length} item(s) as ZIP'),
                icon: const Icon(Icons.archive_outlined, size: 16),
                label: const Text('Export ZIP'),
                style: _btn(Colors.white, AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'DOCUMENT & FILE DETAILS',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 6),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No documents match your filters.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textGrey)),
              ),
            )
          else
            for (final d in shown) _row(d),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                list.isEmpty
                    ? 'Showing 0 of ${_docs.length}'
                    : 'Showing ${_page * _pageSize + 1} - ${_page * _pageSize + shown.length} of ${list.length} uploaded note bundles',
                style: GoogleFonts.inter(
                    fontSize: 10, color: AppColors.textGrey),
              ),
              Wrap(
                spacing: 6,
                children: [
                  _pageBtn('Previous', _page > 0,
                          () => setState(() => _page--)),
                  for (int i = 0; i < pages; i++)
                    _pageNum(i + 1, i == _page,
                            () => setState(() => _page = i)),
                  _pageBtn('Next', _page < pages - 1,
                          () => setState(() => _page++)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menu(String label, String value, List<String> options,
      ValueChanged<String> on) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.chip),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox.shrink(),
        items: [
          for (final o in options)
            DropdownMenuItem(
              value: o,
              child: Text(
                label == 'Sort' ? 'Sort: $o' : o,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textDark),
              ),
            ),
        ],
        onChanged: (v) => on(v ?? value),
      ),
    );
  }

  Widget _pageNum(int n, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.chip),
        ),
        child: Text('$n',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : AppColors.textDark,
            )),
      ),
    );
  }

  Widget _pageBtn(String label, bool enabled, VoidCallback onTap) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.chip),
        ),
        child: Text(label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: enabled ? AppColors.textDark : AppColors.textGrey,
            )),
      ),
    );
  }

  Widget _row(_Doc d) {
    final idx = _docs.indexOf(d);
    final selected = _sel == idx;
    final checked = _checked.contains(idx);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _sel = idx),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1F1FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Checkbox(
                value: checked,
                activeColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
                onChanged: (v) => setState(() {
                  if (v ?? false) {
                    _checked.add(idx);
                    _sel = idx;
                  } else {
                    _checked.remove(idx);
                  }
                }),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: d.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(d.icon, size: 20, color: d.color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.primary : AppColors.textDark,
                    ),
                  ),
                  Text(d.meta,
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textGrey)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Pill(d.module,
                          bg: AppColors.chip,
                          fg: AppColors.textDark,
                          fontSize: 9),
                      Text(d.by,
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.textGrey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stats() {
    Widget s(IconData icon, Color color, String v, String l) {
      return AppCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v,
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
      s(Icons.auto_graph, AppColors.teal, '100%', 'Curriculum Indexed'),
      s(Icons.functions, AppColors.primary, '142', 'Extracted Formulas'),
      s(Icons.forum_outlined, _amber, '850+', 'Socratic AI Citations'),
    ], minItemWidth: 150);
  }

  // ---------- Inspector ----------
  Widget _inspector() {
    final d = _docs[_sel.clamp(0, _docs.length - 1)];

    Widget concept(String name, String match, double v, Color color,
        String note) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _soft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(name,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      )),
                ),
                const SizedBox(width: 6),
                Text(match,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                    )),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 4,
                backgroundColor: AppColors.chip,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 4),
            Text(note,
                style: GoogleFonts.inter(
                    fontSize: 10, height: 1.4, color: AppColors.textGrey)),
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
              const Icon(Icons.auto_awesome,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('COGNITIVE ENGINE',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: AppColors.textGrey,
                    )),
              ),
              const Pill('96.2% Confidence',
                  bg: AppColors.mint, fg: AppColors.teal, fontSize: 9),
            ],
          ),
          const SizedBox(height: 6),
          Text('Explainable AI Inspector',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(d.icon, size: 22, color: d.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INSPECTING TARGET',
                          style: GoogleFonts.inter(
                              fontSize: 9, color: AppColors.textGrey)),
                      Text(
                        d.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text('Key Extracted Concepts',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    )),
              ),
              Text('Semantic Salience',
                  style: GoogleFonts.inter(
                      fontSize: 9, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 8),
          concept('Multivariable Chain Rule', '98% Match', 0.98,
              AppColors.primary,
              'Detected in Lemma 3.1 & Eq (4.2); connects to Computational Graphs.'),
          concept('Reverse-Mode Auto-Diff DAGs', '92% Match', 0.92,
              AppColors.teal,
              'Visual dependency graph matched with Slide 14-22 flowcharts.'),
          concept('Vanishing Gradient Horizon', '86% Match', 0.86, _amber,
              'Cross-referenced with Sigmoid vs ReLU activation curve comparisons.'),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Cognitive Complexity',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          )),
                    ),
                    const Pill('Grade 14+ Advanced',
                        bg: AppColors.chip,
                        fg: AppColors.primary,
                        fontSize: 9),
                  ],
                ),
                const SizedBox(height: 8),
                _kv('Est. Deep Reading Time', '45 Mins'),
                _kv('Math Density Score', '8.4 / 10 (High Rigor)'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Why did AI prioritize this content?',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    )),
                const SizedBox(height: 6),
                Text(
                  'Mathematical lemmas 3.1 through 3.4 directly correspond to upcoming Quiz 3 Learning Objectives. Socratic Tutor recommends linking this note to Video Lecture 3.2 to remediate anticipated student pitfalls around Hessian inversion.',
                  style: GoogleFonts.inter(
                      fontSize: 11, height: 1.5, color: AppColors.textGrey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.trending_up,
                        size: 14, color: AppColors.teal),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('Expected +22% conceptual retention',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.teal,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _snack('Synced with Socratic Tutor Bot'),
              icon: const Icon(Icons.smart_toy_outlined, size: 16),
              label: const Text('Sync with Socratic Tutor Bot',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              style: _btn(AppColors.primary, Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _snack('Edit tags'),
                  icon: const Icon(Icons.sell_outlined, size: 14),
                  label: const Text('Edit Tags',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  style: _btn(AppColors.chip, AppColors.textDark),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _snack('Version history (3)'),
                  icon: const Icon(Icons.history, size: 14),
                  label: const Text('History (3)',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  style: _btn(AppColors.chip, AppColors.textDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(k,
                style: GoogleFonts.inter(
                    fontSize: 10, color: AppColors.textGrey)),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(v,
                textAlign: TextAlign.right,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                )),
          ),
        ],
      ),
    );
  }

  Widget _privacy() {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student Privacy Shield',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    )),
                const SizedBox(height: 4),
                Text(
                  'Uploaded materials are securely embedded into your dedicated campus tenant and never shared across outside foundation models.',
                  style: GoogleFonts.inter(
                      fontSize: 11, height: 1.5, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}