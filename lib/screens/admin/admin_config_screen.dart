import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_shell.dart';
import 'admin_widgets.dart';

class AdminConfigScreen extends StatefulWidget {
  const AdminConfigScreen({super.key});

  @override
  State<AdminConfigScreen> createState() => _AdminConfigScreenState();
}

class _AdminConfigScreenState extends State<AdminConfigScreen> {
  static const _tabs = [
    ['General', Icons.settings_outlined],
    ['AI Settings', Icons.auto_awesome],
    ['Notifications', Icons.notifications_none],
    ['Security', Icons.shield_outlined],
    ['Integrations', Icons.link],
  ];

  int _tab = 0;

  // ---- General ----
  final _siteCtrl = TextEditingController(text: 'LearnXAI');
  String? _simulator;
  String _timezone = 'Asia/Karachi';
  bool _maintenance = false;
  String _theme = 'Light';
  String _language = 'English';
  String _dateFormat = 'DD-MM-YYYY';
  final List<bool> _features = [true, true, true, true, false];
  static const _featureNames = [
    'AI Recommendations',
    'Secure Chats',
    'Learning Analytics',
    'Email Notifications',
    'Push Notifications',
  ];

  // ---- AI ----
  String _model = 'Socratic Engine v4.2';
  double _temperature = 0.4;
  String _hintLimit = '3 hints';
  bool _socraticLock = true;
  bool _hallucinationGuard = true;

  // ---- Notifications ----
  bool _nEmail = true;
  bool _nPush = false;
  bool _nSecurity = true;
  bool _nWeekly = true;
  String _digest = 'Daily';

  // ---- Security ----
  bool _twoFa = true;
  bool _strongPw = true;
  bool _ipAllow = false;
  String _session = '30 minutes';

  // ---- Integrations ----
  final List<List<Object>> _integrations = [
    ['University SIS', 'Student roster & enrollment sync', true],
    ['Google Workspace SSO', 'Single sign-on for faculty', true],
    ['GitHub Classroom', 'Assignment repository sync', false],
    ['Slack', 'Announcement & alert channels', false],
    ['Kafka Event Broker', 'Audit log ingestion stream', true],
  ];

  @override
  void dispose() {
    _siteCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _save() {
    if (_siteCtrl.text.trim().isEmpty) {
      setState(() => _tab = 0);
      _snack('Site name is required');
      return;
    }
    _snack('Configuration saved');
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return AppShell(
      currentRoute: '/admin-config',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 4, wide ? 24 : 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            const SizedBox(height: 20),
            _tabBar(),
            const SizedBox(height: 20),
            if (_maintenance && _tab == 0) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9CF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFF8A4B00)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          'Maintenance Mode is ON. Students and teachers will see a maintenance notice after you save.',
                          style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: const Color(0xFF8A4B00))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_tab == 0) _general(),
            if (_tab == 1) _ai(),
            if (_tab == 2) _notifications(),
            if (_tab == 3) _security(),
            if (_tab == 4) _integrationsTab(),
            if (_tab != 0) ...[
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: AdminButton('Save Changes',
                    icon: Icons.save_outlined, primary: true, onTap: _save),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------- Title + tabs ----------------

  Widget _title() {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.chip,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.settings,
              size: 30, color: AdminColors.indigo),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System Configuration',
                  style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              Text('Manage platform settings and preferences',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.textGrey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabBar() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var i = 0; i < _tabs.length; i++)
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _tab = i),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              decoration: BoxDecoration(
                color: _tab == i ? AdminColors.indigo : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: _tab == i ? AdminColors.indigo : AdminColors.line),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_tabs[i][1] as IconData,
                      size: 18,
                      color: _tab == i ? Colors.white : AppColors.textGrey),
                  const SizedBox(width: 8),
                  Text(_tabs[i][0] as String,
                      style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color:
                          _tab == i ? Colors.white : AppColors.textDark)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ---------------- Shared helpers ----------------

  Widget _cardHeader(IconData icon, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.chip,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AdminColors.indigo),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                Text(sub,
                    style: GoogleFonts.inter(
                        fontSize: 12.5, color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, Widget child, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(
                text: label,
                style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark)),
            if (required)
              TextSpan(
                  text: ' *',
                  style: GoogleFonts.inter(
                      fontSize: 13.5, color: AdminColors.red)),
          ])),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _drop(String? value, List<String> items, ValueChanged<String> onCh,
      {IconData? icon, String? hint}) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AdminColors.line),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: hint == null
              ? null
              : Text(hint,
              style: GoogleFonts.inter(
                  fontSize: 14, color: AppColors.textDark)),
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark),
          items: [
            for (final i in items)
              DropdownMenuItem(
                value: i,
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: AdminColors.indigo),
                      const SizedBox(width: 10),
                    ],
                    Flexible(
                        child: Text(i, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
          ],
          onChanged: (v) {
            if (v != null) setState(() => onCh(v));
          },
        ),
      ),
    );
  }

  Widget _switchRow(String label, bool value, ValueChanged<bool> onCh,
      {IconData? icon, String? sub}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.textGrey),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark)),
                if (sub != null)
                  Text(sub,
                      style: GoogleFonts.inter(
                          fontSize: 11.5, color: AppColors.textGrey)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AdminColors.indigo,
            onChanged: (v) => setState(() => onCh(v)),
          ),
        ],
      ),
    );
  }

  // ---------------- General tab ----------------

  Widget _general() {
    return AdminGrid(
      minItemWidth: 300,
      gap: 20,
      children: [
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(Icons.layers_outlined, 'Platform Settings',
                  'Basic platform information'),
              _field(
                'Site Name',
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AdminColors.line),
                  ),
                  child: TextField(
                    controller: _siteCtrl,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: const InputDecoration(
                        border: InputBorder.none, isDense: true),
                    expands: false,
                  ),
                ),
                required: true,
              ),
              _field(
                'Default Simulator',
                _drop(_simulator, const [
                  'Socratic Sandbox',
                  'Code Autograder',
                  'Adaptive Quiz Engine'
                ], (v) => _simulator = v, hint: 'Set Simulator'),
                required: true,
              ),
              _field(
                'Timezone',
                _drop(_timezone, const [
                  'Asia/Karachi',
                  'UTC',
                  'America/New_York',
                  'Europe/London',
                  'Asia/Dubai'
                ], (v) => _timezone = v),
                required: true,
              ),
              Row(
                children: [
                  Text('Maintenance Mode',
                      style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark)),
                  const SizedBox(width: 6),
                  const Icon(Icons.info_outline,
                      size: 16, color: AppColors.textGrey),
                  const Spacer(),
                  Switch(
                    value: _maintenance,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AdminColors.indigo,
                    onChanged: (v) => setState(() => _maintenance = v),
                  ),
                ],
              ),
            ],
          ),
        ),
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(Icons.palette_outlined, 'Appearance',
                  'Customize the look & feel'),
              _field(
                'Theme',
                _drop(_theme, const ['Light', 'Dark', 'System'],
                        (v) => _theme = v,
                    icon: Icons.dark_mode_outlined),
                required: true,
              ),
              _field(
                'Language',
                _drop(_language, const ['English', 'Urdu', 'Arabic'],
                        (v) => _language = v,
                    icon: Icons.language),
                required: true,
              ),
              _field(
                'Date Format',
                _drop(_dateFormat,
                    const ['DD-MM-YYYY', 'MM-DD-YYYY', 'YYYY-MM-DD'],
                        (v) => _dateFormat = v,
                    icon: Icons.calendar_month_outlined),
              ),
            ],
          ),
        ),
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(Icons.star_rounded, 'Features',
                  'Enable or disable features'),
              for (var i = 0; i < _featureNames.length; i++)
                _switchRow(_featureNames[i], _features[i],
                        (v) => _features[i] = v,
                    icon: Icons.blur_circular_outlined),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: AdminButton('Save Changes',
                    icon: Icons.save_outlined, primary: true, onTap: _save),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- AI tab ----------------

  Widget _ai() {
    return AdminGrid(
      minItemWidth: 340,
      gap: 20,
      children: [
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(Icons.auto_awesome, 'AI Tutor Defaults',
                  'Model and response behavior'),
              _field(
                'Default Model',
                _drop(_model, const [
                  'Socratic Engine v4.2',
                  'Socratic Engine v4.1',
                  'Cognitive BKT Tracer v3.4'
                ], (v) => _model = v),
                required: true,
              ),
              _field(
                'Response Temperature: ${_temperature.toStringAsFixed(2)}',
                Slider(
                  value: _temperature,
                  min: 0,
                  max: 1,
                  divisions: 20,
                  activeColor: AdminColors.indigo,
                  onChanged: (v) => setState(() => _temperature = v),
                ),
              ),
              _field(
                'Maximum Hints Per Problem',
                _drop(_hintLimit,
                    const ['1 hint', '2 hints', '3 hints', '5 hints'],
                        (v) => _hintLimit = v),
              ),
            ],
          ),
        ),
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(Icons.shield_outlined, 'Guardrails',
                  'Pedagogical safety rules'),
              _switchRow('Enforce Socratic Mode', _socraticLock,
                      (v) => _socraticLock = v,
                  sub: 'Never output direct solutions'),
              _switchRow('Hallucination Guard', _hallucinationGuard,
                      (v) => _hallucinationGuard = v,
                  sub: 'Anchor answers to course syllabus'),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- Notifications tab ----------------

  Widget _notifications() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.notifications_none, 'Notification Channels',
              'Choose how the platform contacts users'),
          _switchRow('Email Notifications', _nEmail, (v) => _nEmail = v,
              icon: Icons.mail_outline),
          _switchRow('Push Notifications', _nPush, (v) => _nPush = v,
              icon: Icons.phone_iphone),
          _switchRow('Security Alerts', _nSecurity, (v) => _nSecurity = v,
              icon: Icons.shield_outlined),
          _switchRow('Weekly Summary Report', _nWeekly, (v) => _nWeekly = v,
              icon: Icons.assessment_outlined),
          const SizedBox(height: 12),
          SizedBox(
            width: 320,
            child: _field(
              'Digest Frequency',
              _drop(_digest, const ['Instant', 'Daily', 'Weekly'],
                      (v) => _digest = v),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Security tab ----------------

  Widget _security() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.shield_outlined, 'Security Policy',
              'Authentication and session rules'),
          _switchRow('Require Two-Factor Authentication', _twoFa,
                  (v) => _twoFa = v,
              sub: 'Applies to all admin and faculty accounts'),
          _switchRow('Enforce Strong Passwords', _strongPw,
                  (v) => _strongPw = v,
              sub: 'Minimum 12 characters with mixed case'),
          _switchRow('IP Allow-List for Admins', _ipAllow,
                  (v) => _ipAllow = v,
              sub: 'Restrict admin sign-in to approved networks'),
          const SizedBox(height: 12),
          SizedBox(
            width: 320,
            child: _field(
              'Session Timeout',
              _drop(
                  _session,
                  const ['15 minutes', '30 minutes', '1 hour', '4 hours'],
                      (v) => _session = v),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Integrations tab ----------------

  Widget _integrationsTab() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.link, 'Connected Services',
              'External systems linked to LearnXAI'),
          for (var i = 0; i < _integrations.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_integrations[i][0] as String,
                            style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                        Text(_integrations[i][1] as String,
                            style: GoogleFonts.inter(
                                fontSize: 12, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  AdminTag(
                    (_integrations[i][2] as bool)
                        ? 'Connected'
                        : 'Not connected',
                    bg: (_integrations[i][2] as bool)
                        ? AppColors.mintBright
                        : AppColors.chip,
                    fg: (_integrations[i][2] as bool)
                        ? AppColors.teal
                        : AppColors.textGrey,
                    fontSize: 10,
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() => _integrations[i][2] =
                      !(_integrations[i][2] as bool));
                      _snack(
                          '${_integrations[i][0]} ${(_integrations[i][2] as bool) ? 'connected' : 'disconnected'}');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: (_integrations[i][2] as bool)
                            ? Colors.white
                            : AdminColors.indigo,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: (_integrations[i][2] as bool)
                                ? AdminColors.line
                                : AdminColors.indigo),
                      ),
                      child: Text(
                          (_integrations[i][2] as bool)
                              ? 'Disconnect'
                              : 'Connect',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: (_integrations[i][2] as bool)
                                  ? AppColors.textDark
                                  : Colors.white)),
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