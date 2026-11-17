import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  static const _keys = [
    'Full Name',
    'Office',
    'Email',
    'Designation',
    'Phone',
    'Employee Number',
  ];

  final Map<String, String> _saved = {
    'Full Name': 'Admin User',
    'Office': 'Head Office',
    'Email': 'admin@learnxai.com',
    'Designation': 'System Administrator',
    'Phone': '+92 300 1112222',
    'Employee Number': 'EMP001',
  };

  late final Map<String, TextEditingController> _ctrls = {
    for (final k in _keys) k: TextEditingController(text: _saved[k]),
  };

  bool _editing = false;

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _startEdit() => setState(() => _editing = true);

  void _cancel() {
    setState(() {
      for (final k in _keys) {
        _ctrls[k]!.text = _saved[k]!;
      }
      _editing = false;
    });
  }

  void _save() {
    if (_ctrls['Full Name']!.text.trim().isEmpty) {
      _snack('Full name is required');
      return;
    }
    setState(() {
      for (final k in _keys) {
        _saved[k] = _ctrls[k]!.text.trim();
      }
      _editing = false;
    });
    _snack('Profile updated');
  }

  String get _initials {
    final parts = _saved['Full Name']!
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'A';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-profile',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Profile',
                style: GoogleFonts.manrope(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 2),
            Text('Admin  /  Profile',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textGrey)),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, box) {
                final left = _profileCard();
                final mid = Column(
                  children: [
                    _personal(),
                    const SizedBox(height: 20),
                    _adminInfo(),
                    const SizedBox(height: 20),
                    _stats(),
                  ],
                );
                final right = Column(
                  children: [
                    _security(),
                    const SizedBox(height: 20),
                    _responsibilities(),
                    const SizedBox(height: 20),
                    _activity(),
                  ],
                );

                if (box.maxWidth >= 1100) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: left),
                      const SizedBox(width: 20),
                      Expanded(flex: 4, child: mid),
                      const SizedBox(width: 20),
                      Expanded(flex: 4, child: right),
                    ],
                  );
                }
                if (box.maxWidth >= 720) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: left),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            mid,
                            const SizedBox(height: 20),
                            right,
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    left,
                    const SizedBox(height: 20),
                    mid,
                    const SizedBox(height: 20),
                    right,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Shared ----------------

  Widget _title(IconData icon, String text, {Widget? trailing}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AdminColors.indigo),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _kv(String label, String value, {Widget? valueWidget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey)),
        const SizedBox(height: 4),
        valueWidget ??
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
      ],
    );
  }

  // ---------------- Left profile card ----------------

  Widget _profileCard() {
    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AdminColors.indigo.withValues(alpha: 0.25),
                  AppColors.chip,
                ],
              ),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -48),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AdminColors.indigo,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Text(_initials,
                          style: GoogleFonts.manrope(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ),
                    Positioned(
                      right: -2,
                      bottom: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _snack('Photo upload coming soon'),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AdminColors.indigo,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.photo_camera_outlined,
                              size: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(_saved['Full Name']!,
                    style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark)),
                const SizedBox(height: 6),
                const AdminTag('Super Admin'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Column(
                children: [
                  _row(Icons.badge_outlined, 'Employee ID', 'ADM001'),
                  _row(Icons.person_outline, 'Role', 'Super Admin'),
                  _row(Icons.apartment_outlined, 'Department', 'IT Department'),
                  _row(Icons.shield_outlined, 'Last Login', 'Today, 09:45 AM'),
                  const SizedBox(height: 14),
                  AdminButton(
                    _editing ? 'Editing...' : 'Edit Profile',
                    icon: Icons.edit_outlined,
                    primary: true,
                    onTap: _editing ? null : _startEdit,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Overall Activity',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                                size: const Size(96, 96),
                                painter: _RingPainter()),
                            Text('100%',
                                style: GoogleFonts.manrope(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textDark)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Account Health',
                                style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    color: AppColors.textGrey)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.circle,
                                    size: 10, color: AppColors.teal),
                                const SizedBox(width: 6),
                                Text('Excellent',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.teal)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _achievements(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AdminColors.indigo),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(label,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textGrey)),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
          ),
        ],
      ),
    );
  }

  Widget _achievements() {
    const items = [
      ['Platform\nChampion', Icons.star_rounded, AdminColors.indigo],
      ['Innovation\nLeader', Icons.workspace_premium_outlined,
        Color(0xFFF59E0B)],
      ['System\nGuardian', Icons.shield_outlined, AdminColors.teal],
    ];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_outlined,
                  size: 18, color: Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text('Admin Achievements',
                    style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              InkWell(
                onTap: () => _snack('All achievements coming soon'),
                child: Text('View All →',
                    style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.indigo)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final it in items)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (it[2] as Color).withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(it[1] as IconData,
                            size: 22, color: it[2] as Color),
                      ),
                      const SizedBox(height: 6),
                      Text(it[0] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 10.5, color: AppColors.textDark)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Personal information ----------------

  Widget _personal() {
    Widget cell(String k) {
      if (!_editing || k == 'Employee Number') {
        return _kv(k, _saved[k]!);
      }
      return _kv(
        k,
        '',
        valueWidget: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AdminColors.soft,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AdminColors.line),
          ),
          child: TextField(
            controller: _ctrls[k],
            style: GoogleFonts.inter(fontSize: 13.5),
            decoration: const InputDecoration(
                border: InputBorder.none, isDense: true),
          ),
        ),
      );
    }

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(Icons.person_outline, 'Personal Information'),
          const SizedBox(height: 16),
          AdminGrid(
            minItemWidth: 190,
            gap: 18,
            children: [for (final k in _keys) cell(k)],
          ),
          if (_editing) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                AdminButton('Save Changes',
                    icon: Icons.check, primary: true, onTap: _save),
                AdminButton('Cancel', onTap: _cancel),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ---------------- Administrator information ----------------

  Widget _adminInfo() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(Icons.shield_outlined, 'Administrator Information'),
          const SizedBox(height: 16),
          AdminGrid(
            minItemWidth: 190,
            gap: 18,
            children: [
              _kv('Access Level', 'Full Access'),
              _kv('Account Status', '',
                  valueWidget: const Align(
                    alignment: Alignment.centerLeft,
                    child: AdminTag('Active',
                        bg: AppColors.mintBright, fg: AppColors.teal),
                  )),
              _kv('Role', 'Super Admin'),
              _kv('Joined Date', 'Jan 15, 2024'),
              _kv('Assigned Modules', 'All Modules'),
              _kv('Security Level', '',
                  valueWidget: Row(
                    children: [
                      const Icon(Icons.shield,
                          size: 18, color: AdminColors.indigo),
                      const SizedBox(width: 6),
                      Text('High',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark)),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Statistics ----------------

  Widget _stats() {
    const items = [
      ['1.2K', 'Managed Users', '+12%', Icons.groups_outlined,
        AdminColors.indigo],
      ['245', 'Managed Teachers', '+8%', Icons.school_outlined,
        AdminColors.teal],
      ['12.5K', 'Reports Generated', '+15%', Icons.description_outlined,
        Color(0xFFF59E0B)],
      ['8', 'AI Models Managed', '+0%', Icons.view_in_ar_outlined,
        AdminColors.indigo],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(Icons.bar_chart_rounded, 'Administrative Statistics'),
          const SizedBox(height: 16),
          AdminGrid(
            minItemWidth: 120,
            gap: 12,
            children: [
              for (final it in items)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (it[4] as Color).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(it[3] as IconData,
                          size: 22, color: it[4] as Color),
                      const SizedBox(height: 6),
                      Text(it[0] as String,
                          style: GoogleFonts.manrope(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark)),
                      Text(it[1] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textGrey)),
                      const SizedBox(height: 4),
                      Text('↗ ${it[2]}',
                          style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.teal)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Security overview ----------------

  Widget _security() {
    Widget box(Widget child) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(Icons.shield_outlined, 'Security Overview'),
          const SizedBox(height: 16),
          AdminGrid(
            minItemWidth: 190,
            gap: 12,
            children: [
              box(Row(
                children: [
                  _circleIcon(Icons.verified_user_outlined, AppColors.teal),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Two Factor Authentication',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        Text('Enabled',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.teal)),
                      ],
                    ),
                  ),
                ],
              )),
              box(Row(
                children: [
                  _circleIcon(Icons.access_time, AdminColors.indigo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recent Login',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        Text('Today, 09:45 AM\n(192.168.1.1)',
                            style: GoogleFonts.inter(
                                fontSize: 11, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ],
              )),
              box(Row(
                children: [
                  _circleIcon(Icons.devices_outlined, AdminColors.indigo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trusted Devices',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        Text('3 Devices',
                            style: GoogleFonts.inter(
                                fontSize: 11.5, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ],
              )),
              box(Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 40,
                    child: CustomPaint(painter: _GaugePainter(0.98)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Security Score',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        Text('98%',
                            style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark)),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: 12),
          box(Row(
            children: [
              const Icon(Icons.lock_outline,
                  size: 20, color: AppColors.textGrey),
              const SizedBox(width: 10),
              Text('Password Strength',
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.85,
                    minHeight: 7,
                    backgroundColor: Colors.white,
                    color: AppColors.teal,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('Strong',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.teal)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, Color c) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: c.withValues(alpha: 0.14),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, size: 20, color: c),
  );

  // ---------------- Responsibilities ----------------

  Widget _responsibilities() {
    const items = [
      ['Users', Icons.groups_outlined, '/admin-users'],
      ['Teachers', Icons.school_outlined, '/admin-teachers'],
      ['Courses', Icons.menu_book_outlined, '/admin-courses'],
      ['Permissions', Icons.shield_outlined, '/admin-permissions'],
      ['Reports', Icons.bar_chart_rounded, '/admin-reports'],
      ['AI Models', Icons.memory_outlined, '/admin-models'],
      ['Announcements', Icons.campaign_outlined, '/admin-announcements'],
      ['System Config', Icons.settings_outlined, '/admin-config'],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(Icons.layers_outlined, 'System Responsibilities'),
          const SizedBox(height: 16),
          AdminGrid(
            minItemWidth: 100,
            gap: 10,
            children: [
              for (final it in items)
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.pushReplacementNamed(
                      context, it[2] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AdminColors.soft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Icon(it[1] as IconData,
                            size: 22, color: AdminColors.indigo),
                        const SizedBox(height: 6),
                        Text(it[0] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Activity ----------------

  Widget _activity() {
    const items = [
      ['Updated AI Model Registry', '2 hours ago'],
      ['Created New Announcement', '4 hours ago'],
      ['Modified User Permissions', '1 day ago'],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(
            Icons.history,
            'Recent Administrative Activity',
            trailing: InkWell(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/admin-logs'),
              child: Text('View All →',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AdminColors.indigo)),
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < items.length; i++)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 20,
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        const Icon(Icons.circle,
                            size: 12, color: AdminColors.indigo),
                        if (i != items.length - 1)
                          Expanded(
                            child: Container(
                                width: 2, color: AdminColors.line),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(items[i][0],
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark)),
                          Text(items[i][1],
                              style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ======================= Painters =======================

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 10.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = AppColors.chip,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * 0.97,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke
        ..color = AppColors.teal,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _GaugePainter extends CustomPainter {
  final double value;
  _GaugePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 8.0;
    final rect = Rect.fromLTWH(
        stroke / 2, stroke / 2, size.width - stroke, (size.height - stroke / 2) * 2);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke
        ..color = Colors.white,
    );
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * value,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke
        ..color = AppColors.teal,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) => old.value != value;
}