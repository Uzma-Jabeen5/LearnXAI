import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final double fontSize;

  const Pill(
      this.text, {
        super.key,
        this.bg = AppColors.chip,
        this.fg = AppColors.primary,
        this.fontSize = 11,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

/// Side by side on wide screens, stacked on narrow screens.
Widget responsiveRow({
  required bool wide,
  required List<Widget> children,
  List<int>? flex,
  double gap = 16,
}) {
  if (!wide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (int i = 0; i < children.length; i++) ...[
        if (i > 0) SizedBox(width: gap),
        Expanded(flex: flex != null ? flex[i] : 1, child: children[i]),
      ],
    ],
  );
}