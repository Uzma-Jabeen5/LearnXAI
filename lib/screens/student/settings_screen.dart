import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notifications
  bool _push = true;
  bool _email = true;
  bool _deadlines = true;
  bool _tutorInsights = false;

  // Learning
  bool _socratic = true;
  bool _hints = true;
  double _dailyGoal = 60;
  String _studyTime = 'Morning';

  // Appearance
  String _language = 'English';
  bool _reduceMotion = false;

  // Privacy
  bool _shareTelemetry = true;
  bool _proctorCamera = true;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/settings',
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
                    Text(
                      'Settings',
                      style: GoogleFonts.manrope(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Manage notifications, learning preferences and privacy.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _notifications(),
                    const SizedBox(height: 16),
                    _learning(),
                    const SizedBox(height: 16),
                    _appearance(),
                    const SizedBox(height: 16),
                    _privacy(),
                    const SizedBox(height: 16),
                    _account(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _title(String t, IconData icon) => Row(
    children: [
      Icon(icon, size: 20, color: AppColors.primary),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          t,
          style: GoogleFonts.manrope(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ),
    ],
  );

  Widget _switch(
      String title, String sub, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            activeColor: AppColors.primaryLight,
            onChanged: (v) => setState(() => onChanged(v)),
          ),
        ],
      ),
    );
  }

  Widget _notifications() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Notifications', Icons.notifications_none),
          _switch('Push notifications', 'Alerts on this device', _push,
                  (v) => _push = v),
          _switch('Email summaries', 'A weekly digest of your progress',
              _email, (v) => _email = v),
          _switch('Deadline reminders', 'Assignments, quizzes and tests',
              _deadlines, (v) => _deadlines = v),
          _switch('Tutor insights', 'Tips from the Socratic engine',
              _tutorInsights, (v) => _tutorInsights = v),
        ],
      ),
    );
  }

  Widget _learning() {
    const times = ['Morning', 'Afternoon', 'Evening', 'Night'];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Learning', Icons.psychology_alt_outlined),
          _switch('Socratic mode', 'Tutor replies with guiding questions',
              _socratic, (v) => _socratic = v),
          _switch('Allow hints', 'Show up to three hints per problem',
              _hints, (v) => _hints = v),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Daily goal',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                '${_dailyGoal.round()} min',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: _dailyGoal,
            min: 15,
            max: 180,
            divisions: 11,
            activeColor: AppColors.primaryLight,
            inactiveColor: AppColors.chip,
            onChanged: (v) => setState(() => _dailyGoal = v),
          ),
          Text(
            'Best study time',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in times)
                ChoiceChip(
                  label: Text(
                    t,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                      _studyTime == t ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  selected: _studyTime == t,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.chip,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _studyTime = t),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _appearance() {
    const languages = ['English', 'Urdu', 'Arabic'];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Appearance & Language', Icons.palette_outlined),
          const SizedBox(height: 14),
          Text(
            'Language',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final l in languages)
                ChoiceChip(
                  label: Text(
                    l,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                      _language == l ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  selected: _language == l,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.chip,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _language = l),
                ),
            ],
          ),
          _switch('Reduce motion', 'Limit animations across the app',
              _reduceMotion, (v) => _reduceMotion = v),
        ],
      ),
    );
  }

  Widget _privacy() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Privacy & Proctoring', Icons.verified_user_outlined),
          _switch('Share learning telemetry',
              'Helps the engine personalize recommendations',
              _shareTelemetry, (v) => _shareTelemetry = v),
          _switch('Camera for proctored tests',
              'Required to start proctored exams', _proctorCamera,
                  (v) => _proctorCamera = v),
        ],
      ),
    );
  }

  Widget _account(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Account', Icons.person_outline),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings saved')),
                ),
                icon: const Icon(Icons.save_outlined, size: 18),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/profile'),
                icon: const Icon(Icons.person_outline, size: 18),
                label: const Text('View Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chip,
                  foregroundColor: AppColors.textDark,
                  elevation: 0,
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE3E0),
                  foregroundColor: const Color(0xFFB3261E),
                  elevation: 0,
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}