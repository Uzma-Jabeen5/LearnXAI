import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';

class AdminColors {
  static const indigo = Color(0xFF4F46E5);
  static const teal = Color(0xFF0F766E);
  static const brown = Color(0xFF7C4A03);
  static const red = Color(0xFFE5484D);
  static const line = Color(0xFFE8E9F5);
  static const soft = Color(0xFFF3F3FF);
}

/// White rounded card used by every admin screen.
class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  const AdminCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Small rounded label.
class AdminTag extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final double fontSize;

  const AdminTag(
      this.text, {
        super.key,
        this.bg = AppColors.chip,
        this.fg = AppColors.primary,
        this.fontSize = 11,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
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

/// Primary (filled) or secondary (white) button.
class AdminButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool primary;
  final VoidCallback? onTap;

  const AdminButton(
      this.label, {
        super.key,
        this.icon,
        this.primary = false,
        this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    final fg = primary ? Colors.white : AppColors.textDark;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: primary ? AdminColors.indigo : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: primary ? null : Border.all(color: AdminColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page title, optional tag, subtitle and action buttons.
class AdminHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? tag;
  final List<Widget> actions;

  const AdminHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.tag,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= 800;
        final titleBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                if (tag != null)
                  AdminTag(tag!, bg: AppColors.mintBright, fg: AppColors.teal),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ],
        );

        final acts = Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: wide ? WrapAlignment.end : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: actions,
        );

        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: titleBlock),
              const SizedBox(width: 16),
              Flexible(child: acts),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [titleBlock, const SizedBox(height: 14), acts],
        );
      },
    );
  }
}

/// Title + subtitle row used at the top of a card.
class AdminSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const AdminSectionTitle(this.title, {super.key, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 10), trailing!],
      ],
    );
  }
}

/// Responsive grid: as many columns as fit, each at least minItemWidth.
class AdminGrid extends StatelessWidget {
  final List<Widget> children;
  final double minItemWidth;
  final double gap;

  const AdminGrid({
    super.key,
    required this.children,
    this.minItemWidth = 220,
    this.gap = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final cols = ((box.maxWidth + gap) / (minItemWidth + gap))
            .floor()
            .clamp(1, children.length)
            .toInt();
        final w = (box.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final c in children) SizedBox(width: w, child: c)],
        );
      },
    );
  }
}

/// Main column (left, wider) + side column (right). Stacks on small screens.
class AdminTwoCol extends StatelessWidget {
  final Widget main;
  final Widget side;
  final double breakpoint;

  const AdminTwoCol({
    super.key,
    required this.main,
    required this.side,
    this.breakpoint = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= breakpoint) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: main),
              const SizedBox(width: 20),
              Expanded(flex: 1, child: side),
            ],
          );
        }
        return Column(children: [main, const SizedBox(height: 20), side]);
      },
    );
  }
}