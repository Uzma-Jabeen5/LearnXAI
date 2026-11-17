import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

// ======================= Model =======================

class _Ann {
  final String title;
  final String meta;
  final String cohort;
  final String status;
  final String? rate;
  final String? views;
  final bool high;

  const _Ann(this.title, this.meta, this.cohort, this.status,
      {this.rate, this.views, this.high = false});
}

// ======================= Helpers =======================

Widget _label(String t) => Padding(
  padding: const EdgeInsets.only(bottom: 6),
  child: Text(t,
      style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppColors.textGrey)),
);

Widget _head(String title, {String? subtitle, Widget? trailing}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark)),
      if (subtitle != null) ...[
        const SizedBox(height: 4),
        Text(subtitle,
            style:
            GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey)),
      ],
      if (trailing != null) ...[
        const SizedBox(height: 10),
        trailing,
      ],
    ],
  );
}

Widget _segmented(List<String> labels, int selected, ValueChanged<int> onTap,
    {List<Color>? dots}) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AdminColors.soft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onTap(i),
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == selected
                      ? (dots != null ? AdminColors.indigo : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dots != null) ...[
                      Icon(Icons.circle, size: 7, color: dots[i]),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(labels[i],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: i == selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: i == selected
                                  ? (dots != null
                                  ? Colors.white
                                  : AdminColors.indigo)
                                  : AppColors.textGrey)),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

// Two columns on wide screens, stacked on phones.
class _Split extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _Split({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      if (box.maxWidth >= 860) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: left),
            const SizedBox(width: 20),
            Expanded(flex: 6, child: right),
          ],
        );
      }
      return Column(children: [left, const SizedBox(height: 20), right]);
    });
  }
}

// ======================= Screen =======================

class AdminAnnouncementsScreen extends StatefulWidget {
  const AdminAnnouncementsScreen({super.key});

  @override
  State<AdminAnnouncementsScreen> createState() =>
      _AdminAnnouncementsScreenState();
}

class _AdminAnnouncementsScreenState extends State<AdminAnnouncementsScreen> {
  static const _cohorts = [
    'All Platform Users (2,489 Enrolled)',
    'Students (1,842 Enrolled)',
    'Faculty & Teachers (32 Enrolled)',
    'Dept Chairs & Faculty',
    'Operations Staff (615 Enrolled)',
  ];
  static const _categories = [
    'System Maintenance & Examination Policies',
    'Academic Calendar Updates',
    'Accreditation & Compliance Notices',
    'Platform Feature Releases',
  ];
  static const _categoryTags = [
    'SYSTEM FREEZE',
    'ACADEMIC',
    'COMPLIANCE',
    'RELEASE',
  ];
  static const _statuses = ['All Statuses', 'Published', 'Scheduled', 'Archived'];
  static const _audiences = [
    'All Audiences',
    'Students',
    'Faculty & Teachers',
    'All Platform Users',
    'Dept Chairs & Faculty',
  ];
  static const _priorityLabels = ['High Priority', 'Medium', 'Informational'];
  static const _priorityDots = [
    Color(0xFFE5484D),
    Colors.white,
    Color(0xFF6D6FB8),
  ];
  static const _pageSize = 4;

  final _title = TextEditingController(
      text: 'Mandatory Maintenance & Fall Midterm System Freeze');
  final _body = TextEditingController(
      text:
      'Please note that on Saturday, Nov 15 from 02:00 to 05:00 UTC, LearnXAI will undergo cluster database maintenance. Autograder sandboxes and Socratic AI Tutor sessions will be temporarily suspended. Grand Test submissions will NOT be impacted.');

  String _cohort = _cohorts.first;
  String _category = _categories.first;
  int _priority = 1;
  bool _later = true;
  DateTime _date = DateTime(2025, 11, 14);
  bool _banner = true;
  bool _email = true;
  bool _push = false;

  final List<_Ann> _anns = [
    const _Ann(
        'Fall 2025 Multi-Disciplinary Grand Assessment Released',
        'Published: Nov 12, 2025 · 09:30 EST',
        'Students (CS & AI)',
        'Published',
        rate: '88.4%',
        views: '1,628 views',
        high: true),
    const _Ann(
        'Socratic Engine v4.2 Diagnostic Calibration Complete',
        'Published: Nov 10, 2025 · 14:15 EST',
        'Faculty & Teachers',
        'Published',
        rate: '100%',
        views: '32 views'),
    const _Ann(
        'Scheduled Database Cluster Maintenance (Nov 15)',
        'Release: Nov 14, 2025 · 08:00 EST',
        'All Platform Users',
        'Scheduled'),
    const _Ann(
        'ABET Criterion 3 & 5 Audit Package Submission Due',
        'Archived: Oct 28, 2025',
        'Dept Chairs & Faculty',
        'Archived',
        rate: '97.2%',
        views: '42 views'),
  ];

  String _search = '';
  String _statusFilter = _statuses.first;
  String _audienceFilter = _audiences.first;
  int _page = 1;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _fmt(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

  // ---------- derived ----------

  int get _total => 44 + _anns.length;
  int get _published =>
      10 + _anns.where((a) => a.status == 'Published').length;
  int get _scheduled =>
      5 + _anns.where((a) => a.status == 'Scheduled').length;

  List<_Ann> get _filtered {
    final q = _search.trim().toLowerCase();
    return _anns.where((a) {
      final okQ = q.isEmpty ||
          a.title.toLowerCase().contains(q) ||
          a.cohort.toLowerCase().contains(q);
      final okS = _statusFilter == _statuses.first || a.status == _statusFilter;
      final okA = _audienceFilter == _audiences.first ||
          a.cohort
              .toLowerCase()
              .contains(_audienceFilter.split(' ').first.toLowerCase());
      return okQ && okS && okA;
    }).toList();
  }

  // ---------- actions ----------

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
    );
    if (d != null) setState(() => _date = d);
  }

  void _dispatch() {
    if (_title.text.trim().isEmpty || _body.text.trim().isEmpty) {
      _snack('Add a title and message body first');
      return;
    }
    if (!_banner && !_email && !_push) {
      _snack('Select at least one distribution channel');
      return;
    }
    setState(() {
      _anns.insert(
        0,
        _Ann(
          _title.text.trim(),
          _later
              ? 'Release: ${_fmt(_date)} · 08:00 EST'
              : 'Published: just now',
          _cohort.split(' (').first,
          _later ? 'Scheduled' : 'Published',
          rate: _later ? null : '0.0%',
          views: _later ? null : '0 views',
          high: _priority == 0,
        ),
      );
      _page = 1;
    });
    _snack(_later
        ? 'Broadcast scheduled for ${_fmt(_date)}'
        : 'Broadcast published');
  }

  void _newDraft() {
    setState(() {
      _title.clear();
      _body.clear();
      _priority = 1;
    });
    _snack('New announcement draft started');
  }

  void _details(_Ann a) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(a.title,
            style: GoogleFonts.manrope(
                fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(a.meta),
            const SizedBox(height: 6),
            Text('Audience: ${a.cohort}'),
            Text('Status: ${a.status}'),
            Text(a.rate == null
                ? 'Engagement: pending trigger'
                : 'Engagement: ${a.rate} • ${a.views}'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
        ],
      ),
    );
  }

  // ======================= Build =======================

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-announcements',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Platform Announcements & Broadcast Management',
              subtitle:
              'Create, schedule, target, and audit platform-wide communications across student cohorts, faculty bodies, and administrative personnel.',
              actions: [
                AdminButton('Filter Broadcasts',
                    icon: Icons.tune,
                    onTap: () => _snack('Use the filters in the ledger below')),
                AdminButton('Create New Announcement',
                    icon: Icons.add, primary: true, onTap: _newDraft),
              ],
            ),
            const SizedBox(height: 20),
            AdminGrid(
              minItemWidth: 200,
              gap: 14,
              children: [
                _Stat('TOTAL BROADCASTS', '$_total Messages',
                    Icons.campaign_outlined, AdminColors.indigo,
                    'Recorded across Fall 2025 academic cycle',
                    '↗ +14% vs. previous term', Icons.trending_up),
                _Stat('ACTIVE PUBLISHED', '$_published Live',
                    Icons.visibility_outlined, AdminColors.teal,
                    'Visible on student & teacher dashboards',
                    'Real-time sync verified', Icons.circle),
                _Stat('SCHEDULED BROADCASTS', '$_scheduled Pending',
                    Icons.event_note_outlined, AdminColors.indigo,
                    'Automated dispatch on milestone gates',
                    'Next: Nov 14, 08:00 EST', Icons.calendar_today_outlined),
                const _Stat('TARGETED REACH', '2,489 Users',
                    Icons.people_outline, AdminColors.brown,
                    '1,842 Stu • 32 Fac • 615 Ops',
                    'Aggregate Read Rate 96.8%', Icons.circle),
              ],
            ),
            const SizedBox(height: 20),
            _Split(
              left: _draftCard(),
              right: Column(
                children: [
                  _ledgerCard(),
                  const SizedBox(height: 20),
                  _previewCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================= Draft form =======================

  Widget _drop(String value, List<String> items, ValueChanged<String> set) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark),
          items: [
            for (final i in items)
              DropdownMenuItem(
                  value: i, child: Text(i, overflow: TextOverflow.ellipsis))
          ],
          onChanged: (v) {
            if (v != null) setState(() => set(v));
          },
        ),
      ),
    );
  }

  Widget _tool(IconData icon) => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: () => _snack('Formatting applied'),
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Icon(icon, size: 18, color: AppColors.textGrey),
    ),
  );

  Widget _channel(String title, String sub, bool value, ValueChanged<bool> on) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => on(!value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AdminColors.soft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(value ? Icons.check_box : Icons.check_box_outline_blank,
                color: value ? AdminColors.indigo : AppColors.textGrey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  Text(sub,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _draftCard() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head('Draft Broadcast Message',
              subtitle:
              'Configure message scope, delivery channels, and priority.',
              trailing: const AdminTag('Live Editor', fontSize: 10)),
          const SizedBox(height: 16),
          _label('ANNOUNCEMENT TITLE'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _title,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textDark),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _label('TARGET COHORT / ROLE'),
          _drop(_cohort, _cohorts, (v) => _cohort = v),
          const SizedBox(height: 14),
          _label('BROADCAST PRIORITY'),
          _segmented(_priorityLabels, _priority,
                  (i) => setState(() => _priority = i),
              dots: _priorityDots),
          const SizedBox(height: 14),
          _label('REGULATORY / ACADEMIC CATEGORY'),
          _drop(_category, _categories, (v) => _category = v),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 10,
            children: [
              _label('MESSAGE BODY (MARKDOWN / RICH TEXT)'),
              Text('${_body.text.length} / 800 chars',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 2,
              children: [
                _tool(Icons.format_bold),
                _tool(Icons.format_italic),
                _tool(Icons.format_underlined),
                _tool(Icons.link),
                _tool(Icons.format_list_bulleted),
                _tool(Icons.code),
                Text('MD SUPPORTED',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AdminColors.line),
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            child: TextField(
              controller: _body,
              maxLines: 7,
              minLines: 5,
              inputFormatters: [LengthLimitingTextInputFormatter(800)],
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(
                  fontSize: 12.5, height: 1.5, color: AppColors.textDark),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _label('RELEASE STRATEGY'),
          _segmented(['Publish Immediately', 'Schedule for Later'],
              _later ? 1 : 0, (i) => setState(() => _later = i == 1)),
          if (_later) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 18, color: AdminColors.indigo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Scheduled Date: ${_fmt(_date)} at 08:00 EST',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textDark)),
                  ),
                  InkWell(
                    onTap: _pickDate,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text('Change',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AdminColors.indigo)),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          _label('DISTRIBUTION CHANNELS'),
          _channel('Web In-App Banner',
              'High-visibility banner across authenticated portals', _banner,
                  (v) => setState(() => _banner = v)),
          _channel('Email Digest Dispatch',
              'Broadcast to primary institutional mailboxes', _email,
                  (v) => setState(() => _email = v)),
          _channel('Mobile Push Notification',
              'Instant badge payload to iOS/Android companions', _push,
                  (v) => setState(() => _push = v)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AdminButton('Save Draft', onTap: () => _snack('Draft saved')),
              AdminButton(_later ? 'Schedule Broadcast' : 'Publish Now',
                  icon: Icons.send_outlined, primary: true, onTap: _dispatch),
            ],
          ),
        ],
      ),
    );
  }

  // ======================= Ledger =======================

  Widget _statusTag(String s) {
    switch (s) {
      case 'Published':
        return const AdminTag('Published',
            bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10);
      case 'Scheduled':
        return const AdminTag('Scheduled', fontSize: 10);
      default:
        return AdminTag('Archived',
            bg: AppColors.chip, fg: AppColors.textGrey, fontSize: 10);
    }
  }

  Widget _ledgerCard() {
    final all = _filtered;
    final rawPages = (all.length + _pageSize - 1) ~/ _pageSize;
    final int pages = rawPages < 1 ? 1 : rawPages;
    final int page = _page > pages ? pages : _page;
    final start = (page - 1) * _pageSize;
    final rows = all.skip(start).take(_pageSize).toList();

    return AdminCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(builder: (context, box) {
        final roomy = box.maxWidth >= 620;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _head('Active Announcements Ledger',
                      subtitle:
                      'System audits, delivered broadcasts, and scheduled dispatches.',
                      trailing: AdminTag('$_published Active Broadcasts',
                          bg: AppColors.mintBright,
                          fg: AppColors.teal,
                          fontSize: 10)),
                  const SizedBox(height: 14),
                  Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AdminColors.soft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            size: 18, color: AppColors.textGrey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() {
                              _search = v;
                              _page = 1;
                            }),
                            style: GoogleFonts.inter(fontSize: 13),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: 'Search by title or target cohort...',
                              hintStyle: GoogleFonts.inter(
                                  fontSize: 12.5, color: AppColors.textGrey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  AdminGrid(
                    minItemWidth: 150,
                    gap: 10,
                    children: [
                      _drop(_statusFilter, _statuses, (v) {
                        _statusFilter = v;
                        _page = 1;
                      }),
                      _drop(_audienceFilter, _audiences, (v) {
                        _audienceFilter = v;
                        _page = 1;
                      }),
                    ],
                  ),
                ],
              ),
            ),
            if (roomy)
              Container(
                color: AdminColors.soft,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    Expanded(flex: 5, child: _th('ANNOUNCEMENT')),
                    Expanded(flex: 3, child: _th('COHORT')),
                    Expanded(flex: 2, child: _th('STATUS')),
                    Expanded(flex: 2, child: _th('ENGAGEMENT')),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Text('No announcements match these filters',
                    style: GoogleFonts.inter(color: AppColors.textGrey)),
              )
            else
              for (final a in rows) _annRow(a, roomy),
            _pagination(all.length, start, rows.length, pages, page),
          ],
        );
      }),
    );
  }

  Widget _th(String t) => Text(t,
      style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppColors.textGrey));

  Widget _annRow(_Ann a, bool roomy) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(a.title,
            style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 2),
        Text(a.meta,
            style:
            GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey)),
      ],
    );
    final cohort = Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: AdminColors.soft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(a.cohort,
            style: GoogleFonts.inter(
                fontSize: 10.5, color: AppColors.textGrey)),
      ),
    );
    final status = Align(
      alignment: Alignment.centerLeft,
      child: _statusTag(a.status),
    );
    final engagement = a.rate == null
        ? Text('Pending Trigger',
        style: GoogleFonts.inter(
            fontSize: 11.5,
            fontStyle: FontStyle.italic,
            color: AppColors.textGrey))
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(a.rate!,
            style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        Text(a.views ?? '',
            style: GoogleFonts.inter(
                fontSize: 10.5, color: AppColors.textGrey)),
      ],
    );
    final eye = InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _details(a),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(Icons.visibility_outlined,
            size: 20, color: AppColors.textDark),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: const BorderSide(color: AdminColors.line),
          left: BorderSide(
              color: a.high ? AdminColors.red : Colors.transparent, width: 3),
        ),
      ),
      child: roomy
          ? Row(
        children: [
          Expanded(flex: 5, child: title),
          Expanded(flex: 3, child: cohort),
          Expanded(flex: 2, child: status),
          Expanded(flex: 2, child: engagement),
          SizedBox(width: 40, child: eye),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [cohort, status, engagement, eye],
          ),
        ],
      ),
    );
  }

  Widget _pagination(int total, int start, int shown, int pages, int page) {
    Widget btn(Widget child, int? target, {bool active = false}) {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: target == null ? null : () => setState(() => _page = target),
        child: Container(
          constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AdminColors.indigo : AppColors.chip,
            borderRadius: BorderRadius.circular(10),
          ),
          child: child,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 10,
        children: [
          Text(
              total == 0
                  ? 'Showing 0 announcements'
                  : 'Showing ${start + 1}-${start + shown} of $total announcements',
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textGrey)),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              btn(const Icon(Icons.chevron_left, size: 18),
                  page > 1 ? page - 1 : null),
              for (var p = 1; p <= pages; p++)
                btn(
                    Text('$p',
                        style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: p == page
                                ? Colors.white
                                : AppColors.textDark)),
                    p,
                    active: p == page),
              btn(const Icon(Icons.chevron_right, size: 18),
                  page < pages ? page + 1 : null),
            ],
          ),
        ],
      ),
    );
  }

  // ======================= Live preview =======================

  Widget _previewCard() {
    final catIndex = _categories.indexOf(_category);
    final tag = _categoryTags[catIndex < 0 ? 0 : catIndex];
    final bg = const [
      Color(0xFFFFE3E3),
      Color(0xFFE9DED6),
      Color(0xFFE3ECFF),
    ][_priority];

    final title = _title.text.trim().isEmpty
        ? 'Untitled announcement'
        : _title.text.trim();
    final body = _body.text.trim().isEmpty
        ? 'Your message will appear here as you type.'
        : _body.text.trim();

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head('Live Banner Preview (Student Dashboard View)',
              trailing:
              const AdminTag('Viewpoint Simulation', fontSize: 10)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    Text('● LearnXAI Student Portal • CS-402 Distributed Systems',
                        style: GoogleFonts.inter(
                            fontSize: 10.5, color: AppColors.textGrey)),
                    Text('Preview Window',
                        style: GoogleFonts.inter(
                            fontSize: 10.5, color: AppColors.textGrey)),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.campaign_outlined,
                                size: 18, color: AppColors.textDark),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(tag,
                                style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.4,
                                    color: AppColors.textDark)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(title,
                          style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark)),
                      const SizedBox(height: 6),
                      Text(body,
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              height: 1.45,
                              color: AppColors.textDark)),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _snack('Notice acknowledged (preview)'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B1B1F),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Acknowledge Notice',
                                style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 16, color: AppColors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Calibrated for delivery to ',
                      style: GoogleFonts.inter(
                          fontSize: 11.5, color: AppColors.textGrey)),
                  TextSpan(
                      text: '1,842 active students',
                      style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  TextSpan(
                      text: ' upon dispatch.  Dismissible: Enabled',
                      style: GoogleFonts.inter(
                          fontSize: 11.5, color: AppColors.textGrey)),
                ])),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================= Stat card =======================

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String sub;
  final String foot;
  final IconData footIcon;

  const _Stat(this.label, this.value, this.icon, this.color, this.sub,
      this.foot, this.footIcon);

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textGrey)),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(sub,
              style:
              GoogleFonts.inter(fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(footIcon, size: footIcon == Icons.circle ? 7 : 13,
                  color: AppColors.teal),
              const SizedBox(width: 6),
              Expanded(
                child: Text(foot,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.teal)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}