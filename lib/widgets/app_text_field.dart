import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Color fillColor;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.fillColor = AppColors.inputFill,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && _hidden,
      validator: widget.validator,
      style: GoogleFonts.inter(fontSize: 16, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF8A8CA0),
        ),
        prefixIcon: Icon(widget.icon, color: AppColors.textGrey),
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () => setState(() => _hidden = !_hidden),
          icon: Icon(
            _hidden
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textGrey,
          ),
        )
            : null,
        filled: true,
        fillColor: widget.fillColor,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}