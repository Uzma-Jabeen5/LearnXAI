import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_top_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _role = 'Student';
  bool _agreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Service & Privacy Policy'),
        ),
      );
      return;
    }
    // Backend sign-up goes here later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account created as $_role (demo)')),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _roleCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _role == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _role = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.chip,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
              if (selected)
                Positioned(
                  top: -6,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String label, Widget icon) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label sign-up coming soon')),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AuthTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.school,
                            size: 38,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Create Your Account',
                        style: GoogleFonts.manrope(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Join LearnXAI and start your personalized\nlearning journey',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          height: 1.4,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                        fillColor: Colors.white,
                        controller: _nameController,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter your full name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        hint: 'Email Address',
                        icon: Icons.mail_outline,
                        fillColor: Colors.white,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(v.trim());
                          return ok ? null : 'Enter a valid email address';
                        },
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        hint: 'Create Password',
                        icon: Icons.lock_outline,
                        fillColor: Colors.white,
                        isPassword: true,
                        controller: _passwordController,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please create a password';
                          }
                          if (v.length < 8) {
                            return 'Use at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SELECT YOUR ROLE',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              color: AppColors.textDark,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  size: 16, color: AppColors.teal),
                              const SizedBox(width: 4),
                              Text(
                                'Adaptive mode',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _roleCard(
                            title: 'Student',
                            subtitle: 'Learn & Grow',
                            icon: Icons.school_outlined,
                          ),
                          const SizedBox(width: 10),
                          _roleCard(
                            title: 'Teacher',
                            subtitle: 'Teach & Guide',
                            icon: Icons.psychology_alt_outlined,
                          ),
                          const SizedBox(width: 10),
                          _roleCard(
                            title: 'Admin',
                            subtitle: 'Manage\nSystem',
                            icon: Icons.admin_panel_settings_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreed,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              onChanged: (v) =>
                                  setState(() => _agreed = v ?? false),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppColors.textGrey,
                                ),
                                children: const [
                                  TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                  TextSpan(text: ' & '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _signUp,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sign Up'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'OR CONTINUE WITH',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _socialButton(
                            'Google',
                            Text(
                              'G',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFEA4335),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _socialButton(
                            'GitHub',
                            const Icon(Icons.code, color: AppColors.textDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.textGrey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, '/login'),
                            child: Text(
                              'Login',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}