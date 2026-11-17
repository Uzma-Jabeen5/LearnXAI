import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class _Notif {
  final String title;
  final String sub;
  final String type;
  final String recipient;
  final String time;
  String status;
  final String body;
  final String priority;
  final List<List<String>> history;

  _Notif({
    required this.title,
    required this.sub,
    required this.type,
    required this.recipient,
    required this.time,
    required this.status,
    required this.body,
    required this.priority,
    required this.history,
  });
}

IconData _typeIcon(String t) {
  switch (t) {
    case 'Security':
      return Icons.shield_outlined;
    case 'AI':
      return Icons.psychology_outlined;
    case 'User':
      return Icons.person_add_alt_1_outlined;
    case 'Course':
      return Icons.school_outlined;
    case 'Announcement':
      return Icons.campaign_outlined;
    default:
      return Icons.dns_outlined;
  }
}

Color _typeColor(String t) {
  switch (t) {
    case 'Security':
      return AdminColors.red;
    case 'AI':
    case 'User':
      return AdminColors.teal;
    case 'Announcement':
      return const Color(0xFFF59E0B);
    default:
      return AdminColors.indigo;
  }
}

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  static const _types = [
    'All Types',
    'System',
    'Security',
    'AI',
    'User',
    'Course',
    'Announcement',
  ];
  static const _statuses = ['All Status', 'Read', 'Unread', 'Important'];
  static const _ranges = ['Last 30 Days', 'Last 7 Days', 'Today'];

  static const _hist = [
    ['Notification Created', 'Apr 27, 2025 • 10:30 AM'],
    ['Notification Sent', 'Apr 27, 2025 • 10:35 AM'],
  ];

  final List<_Notif> _notifs = [
    _Notif(
      title: 'System Maintenance Scheduled',
      sub: 'Platform maintenance will occur...',
      type: 'System',
      recipient: 'All Users',
      time: 'Apr 27, 2025\n10:30 AM',
      status: 'Read',
      body:
      'Platform maintenance will occur this weekend from 2:00 AM to 4:00 AM. During this time, the platform may be temporarily unavailable.',
      priority: 'Medium',
      history: _hist,
    ),
    _Notif(
      title: 'Multiple Failed Login Attempts',
      sub: 'Suspicious activity detected...',
      type: 'Security',
      recipient: 'Admin',
      time: 'Apr 27, 2025\n09:15 AM',
      status: 'Important',
      body:
      'Five consecutive failed superuser login attempts were detected from an unverified IP address. The account was rate limited automatically.',
      priority: 'High',
      history: _hist,
    ),
    _Notif(
      title: 'Student Prediction Model Updated',
      sub: 'New AI model version deployed...',
      type: 'AI',
      recipient: 'All Users',
      time: 'Apr 26, 2025\n04:20 PM',
      status: 'Unread',
      body:
      'The Student Performance Predictor was updated to v3.2.0 with improved accuracy on early-warning flags.',
      priority: 'Medium',
      history: _hist,
    ),
    _Notif(
      title: 'New Teacher Registered',
      sub: 'Dr. Ayesha Khan joined...',
      type: 'User',
      recipient: 'Teachers',
      time: 'Apr 26, 2025\n02:45 PM',
      status: 'Read',
      body:
      'Dr. Ayesha Khan joined the Computer Science department and was granted faculty access.',
      priority: 'Low',
      history: _hist,
    ),
    _Notif(
      title: 'New Course Published',
      sub: 'Machine Learning Advanced...',
      type: 'Course',
      recipient: 'Students',
      time: 'Apr 25, 2025\n11:30 AM',
      status: 'Unread',
      body:
      'Machine Learning Advanced (CS-610) is now published and open for enrollment.',
      priority: 'Medium',
      history: _hist,
    ),
    _Notif(
      title: 'Important Announcement',
      sub: 'Exam schedule has been updated...',
      type: 'Announcement',
      recipient: 'All Users',
      time: 'Apr 25, 2025\n09:20 AM',
      status: 'Read',
      body:
      'The midterm examination schedule has been updated. Please review the new dates on your dashboard.',
      priority: 'High',
      history: _hist,
    ),
  ];

  late final int _initialLen = _notifs.length;
  late final int _initialUnread =
      _notifs.where((n) => n.status == 'Unread').length;

  String _query = '';
  String _type = _types.first;
  String _status = _statuses.first;
  String _range = _ranges.first;
  int _page = 1;
  String _perPage = '10';
  _Notif? _selected;

  @override
  void initState() {
    super.initState();
    _selected = _notifs.first;
  }

  List<_Notif> get _filtered {
    return _notifs.where((n) {
      final q = _query.trim().toLowerCase();
      final okQ = q.isEmpty ||
          n.title.toLowerCase().contains(q) ||
          n.sub.toLowerCase().contains(q);
      final okT = _type == _types.first || n.type == _type;
      final okS = _status == _statuses.first || n.status == _status;
      return okQ && okT && okS;
    }).toList();
  }

  int get _unreadNow => _notifs.where((n) => n.status == 'Unread').length;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _markAllRead() {
    setState(() {
      for (final n in _notifs) {
        n.status = 'Read';
      }
    });
    _snack('All notifications marked as read');
  }

  Future<void> _create() async {
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    var type = 'System';
    var to = 'All Users';

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text('Create Notification',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: msgCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Message'),
                  ),
                  const SizedBox(height: 16),
                  Text('Type',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textGrey)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: type,
                    items: [
                      for (final t in _types.skip(1))
                        DropdownMenuItem(value: t, child: Text(t))
                    ],
                    onChanged: (v) => setD(() => type = v ?? type),
                  ),
                  const SizedBox(height: 8),
                  Text('Recipients',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textGrey)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: to,
                    items: [
                      for (final r in const [
                        'All Users',
                        'Students',
                        'Teachers',
                        'Admin'
                      ])
                        DropdownMenuItem(value: r, child: Text(r))
                    ],
                    onChanged: (v) => setD(() => to = v ?? to),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style:
              FilledButton.styleFrom(backgroundColor: AdminColors.indigo),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );

    final title = titleCtrl.text.trim();
    final msg = msgCtrl.text.trim();
    titleCtrl.dispose();
    msgCtrl.dispose();

    if (ok == true && title.isNotEmpty && mounted) {
      final n = _Notif(
        title: title,
        sub: msg.isEmpty ? 'No message body' : msg,
        type: type,
        recipient: to,
        time: 'Just now',
        status: 'Unread',
        body: msg.isEmpty ? 'No message body provided.' : msg,
        priority: 'Medium',
        history: const [
          ['Notification Created', 'Just now'],
          ['Notification Sent', 'Just now'],
        ],
      );
      setState(() {
        _notifs.insert(0, n);
        _selected = n;
      });
      _snack('Notification sent to $to');
    } else if (ok == true && mounted) {
      _snack('Title is required');
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-notifications',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Notifications',
              subtitle: 'Manage platform alerts, updates and system activities.',
              actions: [
                AdminButton('Mark All Read',
                    icon: Icons.done_all, onTap: _markAllRead),
                AdminButton('Create Notification',
                    icon: Icons.send_outlined, primary: true, onTap: _create),
              ],
            ),
            const SizedBox(height: 20),
            AdminGrid(
              minItemWidth: 200,
              gap: 14,
              children: [
                _Stat(Icons.notifications_none, AdminColors.indigo,
                    '${248 + _notifs.length - _initialLen}',
                    'All Notifications', '+12%'),
                _Stat(Icons.mail_outline, AdminColors.teal,
                    '${72 + _unreadNow - _initialUnread}',
                    'Unread Notifications', '+8%'),
                _Stat(Icons.shield_outlined, const Color(0xFFF59E0B), '46',
                    'System Alerts', '+5%'),
                _Stat(Icons.memory_outlined, AdminColors.teal, '34',
                    'AI Updates', '+6%'),
              ],
            ),
            const SizedBox(height: 20),
            _filters(),
            const SizedBox(height: 20),
            AdminTwoCol(
              main: _listCard(),
              side: _details(),
            ),
            const SizedBox(height: 20),
            _recent(),
          ],
        ),
      ),
    );
  }

  // ---------------- Filters ----------------

  Widget _filters() {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: AdminGrid(
        minItemWidth: 170,
        gap: 12,
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AdminColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20, color: AppColors.textGrey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() {
                      _query = v;
                      _page = 1;
                    }),
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Search notifications...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 13.5, color: AppColors.textGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _drop('Type', _type, _types, (v) => _type = v),
          _drop('Status', _status, _statuses, (v) => _status = v),
          _drop('Date', _range, _ranges, (v) => _range = v),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _snack('Filters applied'),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AdminColors.indigo),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_alt_outlined,
                      size: 18, color: AdminColors.indigo),
                  const SizedBox(width: 6),
                  Text('Filter',
                      style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AdminColors.indigo)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drop(String label, String value, List<String> items,
      void Function(String) set) {
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
            if (v != null) {
              setState(() {
                set(v);
                _page = 1;
              });
            }
          },
        ),
      ),
    );
  }

  // ---------------- List ----------------

  Widget _listCard() {
    final rows = _filtered;
    return AdminCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, box) {
          final roomy = box.maxWidth >= 680;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_none,
                        size: 22, color: AdminColors.indigo),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('Notifications List',
                          style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                    ),
                    Text(
                        rows.isEmpty
                            ? 'Showing 0'
                            : 'Showing 1–${rows.length} of ${248 + _notifs.length - _initialLen}',
                        style: GoogleFonts.inter(
                            fontSize: 11.5, color: AppColors.textGrey)),
                  ],
                ),
              ),
              if (roomy)
                Container(
                  color: AdminColors.soft,
                  padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: _th('NOTIFICATION')),
                      Expanded(flex: 3, child: _th('TYPE')),
                      Expanded(flex: 2, child: _th('RECIPIENT')),
                      Expanded(flex: 3, child: _th('DATE & TIME')),
                      Expanded(flex: 2, child: _th('STATUS')),
                      Expanded(flex: 3, child: _th('ACTIONS')),
                    ],
                  ),
                ),
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text('No notifications match these filters',
                      style: GoogleFonts.inter(color: AppColors.textGrey)),
                )
              else
                for (final n in rows) _row(n, roomy),
              _pagination(),
            ],
          );
        },
      ),
    );
  }

  Widget _th(String t) => Text(
    t,
    style: GoogleFonts.inter(
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      color: AppColors.textGrey,
    ),
  );

  Widget _typeTag(_Notif n) {
    final c = _typeColor(n.type);
    return AdminTag(n.type, bg: c.withValues(alpha: 0.12), fg: c, fontSize: 10);
  }

  Widget _statusTag(_Notif n) {
    switch (n.status) {
      case 'Read':
        return const AdminTag('Read',
            bg: AppColors.mintBright, fg: AppColors.teal, fontSize: 10);
      case 'Important':
        return const AdminTag('Important',
            bg: Color(0xFFFFE9CF), fg: Color(0xFF8A4B00), fontSize: 10);
      default:
        return const AdminTag('Unread', fontSize: 10);
    }
  }

  Widget _box(IconData icon) => Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AdminColors.line),
    ),
    child: Icon(icon, size: 17, color: AppColors.textDark),
  );

  Widget _actions(_Notif n) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _selected = n),
          child: _box(Icons.visibility_outlined),
        ),
        const SizedBox(width: 6),
        PopupMenuButton<String>(
          onSelected: (v) {
            setState(() {
              if (v == 'read') n.status = 'Read';
              if (v == 'unread') n.status = 'Unread';
              if (v == 'delete') {
                _notifs.remove(n);
                if (identical(_selected, n)) _selected = null;
              }
            });
            if (v == 'delete') _snack('Notification deleted');
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'read', child: Text('Mark as read')),
            PopupMenuItem(value: 'unread', child: Text('Mark as unread')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          child: _box(Icons.more_horiz),
        ),
      ],
    );
  }

  Widget _row(_Notif n, bool roomy) {
    final isSel = identical(n, _selected);
    final c = _typeColor(n.type);

    final title = Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: c.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_typeIcon(n.type), size: 19, color: c),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(n.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              Text(n.sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ),
      ],
    );

    final recipient = Text(n.recipient,
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textDark));
    final time = Text(n.time,
        style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textGrey));

    return InkWell(
      onTap: () => setState(() => _selected = n),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSel ? AdminColors.soft : Colors.transparent,
          border: const Border(bottom: BorderSide(color: AdminColors.line)),
        ),
        child: roomy
            ? Row(
          children: [
            Expanded(flex: 5, child: title),
            Expanded(
                flex: 3,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: _typeTag(n))),
            Expanded(flex: 2, child: recipient),
            Expanded(flex: 3, child: time),
            Expanded(
                flex: 2,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: _statusTag(n))),
            Expanded(
                flex: 3,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: _actions(n))),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _typeTag(n),
                recipient,
                _statusTag(n),
                _actions(n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pagination() {
    Widget btn(Widget child, int? page, {bool active = false}) {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: page == null ? null : () => setState(() => _page = page),
        child: Container(
          constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AdminColors.indigo : AppColors.chip,
            borderRadius: BorderRadius.circular(10),
          ),
          child: child,
        ),
      );
    }

    Widget num(String s, int p) => btn(
      Text(s,
          style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: _page == p ? Colors.white : AppColors.textDark)),
      p,
      active: _page == p,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        spacing: 16,
        children: [
          Wrap(
            spacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              btn(const Icon(Icons.chevron_left, size: 18),
                  _page > 1 ? _page - 1 : null),
              num('1', 1),
              num('2', 2),
              num('3', 3),
              Text('...', style: GoogleFonts.inter(color: AppColors.textGrey)),
              num('25', 25),
              btn(const Icon(Icons.chevron_right, size: 18),
                  _page < 25 ? _page + 1 : null),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Items per page:',
                  style: GoogleFonts.inter(
                      fontSize: 11.5, color: AppColors.textGrey)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AdminColors.line),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _perPage,
                    style: GoogleFonts.inter(
                        fontSize: 12.5, color: AppColors.textDark),
                    items: [
                      for (final p in const ['10', '25', '50'])
                        DropdownMenuItem(value: p, child: Text(p))
                    ],
                    onChanged: (v) => setState(() => _perPage = v ?? _perPage),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Details ----------------

  Widget _details() {
    final n = _selected;
    return AdminCard(
      child: n == null
          ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text('Select a notification to see its details',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textGrey)),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle,
                  size: 10, color: AdminColors.indigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Notification Details',
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => setState(() => _selected = null),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close,
                      size: 20, color: AppColors.textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _typeColor(n.type).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_typeIcon(n.type),
                    color: _typeColor(n.type)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(n.title,
                        style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    _typeTag(n),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(n.body,
              style: GoogleFonts.inter(
                  fontSize: 12.5,
                  height: 1.45,
                  color: AppColors.textGrey)),
          const SizedBox(height: 14),
          _meta(Icons.calendar_month_outlined, 'Created',
              n.time.replaceAll('\n', ' • ')),
          _meta(Icons.groups_outlined, 'Recipients', n.recipient),
          _meta(Icons.priority_high, 'Priority', n.priority,
              valueColor: n.priority == 'High'
                  ? AdminColors.red
                  : const Color(0xFFF59E0B)),
          const Divider(height: 28, color: AdminColors.line),
          Text('Action History',
              style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 10),
          for (final h in n.history)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle,
                        size: 10, color: AdminColors.indigo),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h[0],
                            style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        Text(h[1],
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: n.status == 'Read'
                  ? null
                  : () {
                setState(() => n.status = 'Read');
                _snack('Marked as read');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: n.status == 'Read'
                      ? AppColors.chip
                      : AdminColors.indigo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done,
                        size: 16,
                        color: n.status == 'Read'
                            ? AppColors.textGrey
                            : Colors.white),
                    const SizedBox(width: 6),
                    Text(
                        n.status == 'Read'
                            ? 'Already Read'
                            : 'Mark as Read',
                        style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: n.status == 'Read'
                                ? AppColors.textGrey
                                : Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AdminColors.indigo),
          const SizedBox(width: 8),
          Text('$label: ',
              style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          Expanded(
            child: Text(value,
                style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: valueColor == null
                        ? FontWeight.w400
                        : FontWeight.w700,
                    color: valueColor ?? AppColors.textDark)),
          ),
        ],
      ),
    );
  }

  // ---------------- Recent activity ----------------

  Widget _recent() {
    const items = [
      ['Admin updated AI model settings', '2 hours ago', Icons.settings_outlined,
        AdminColors.indigo],
      ['New teacher account approved', '3 hours ago',
        Icons.person_add_alt_1_outlined, AdminColors.teal],
      ['Course published', '4 hours ago', Icons.description_outlined,
        AdminColors.indigo],
      ['Permission changed', '5 hours ago', Icons.shield_outlined,
        AdminColors.teal],
      ['Security alert resolved', '1 day ago', Icons.verified_outlined,
        AdminColors.teal],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_outlined,
                  size: 20, color: AdminColors.indigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Recent Activity',
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              InkWell(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/admin-logs'),
                child: Text('View All →',
                    style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.indigo)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AdminGrid(
            minItemWidth: 190,
            gap: 14,
            children: [
              for (final it in items)
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (it[3] as Color).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(it[2] as IconData,
                          size: 19, color: it[3] as Color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it[0] as String,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark)),
                          Text(it[1] as String,
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final String trend;

  const _Stat(this.icon, this.color, this.value, this.label, this.trend);

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.manrope(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark)),
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textGrey)),
                Text('↑ $trend',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}