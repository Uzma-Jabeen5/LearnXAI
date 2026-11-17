import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class AuthTopBar extends StatelessWidget {
  const AuthTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              'assets/images/logo.png',
              errorBuilder: (_, _, _) =>
              const Icon(Icons.school, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'LearnXAI',
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }
}