import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_shell.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  /// Sidebar item to highlight.
  final String route;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: route,
      child: Center(
        child: Text(
          '$title\n(coming next)',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}