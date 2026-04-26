import 'package:flutter/material.dart';
import 'package:aiva_life/screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 0.9, curve: Curves.easeOut),
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF8C00), // orange
              Color(0xFFE05CB0), // pink-ish mid
              Color(0xFF8A2BE2), // deep violet
              Color(0xFF6A0DAD), // purple bottom
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: SlideTransition(
              position: _slideUp,
              child: Column(
                children: [
                  // ── Back button ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.2,
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Avatar ───────────────────────────────────────────────
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.92),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.35),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: Color(0xFFAA55DD),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── Fields ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      children: [
                        _OutlinedField(
                          controller: _usernameController,
                          hint: 'Username',
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 18),
                        _OutlinedField(
                          controller: _passwordController,
                          hint: 'Password',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Login button ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: _LoginButton(
                      label: 'Login',
                      onTap: () {
                        // TODO: handle login
                      },
                    ),
                  ),

                  const Spacer(),

                  // ── Social orbs ──────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialOrb(icon: Icons.g_mobiledata_rounded),
                      const SizedBox(width: 20),
                      _SocialOrb(icon: Icons.facebook_rounded),
                      const SizedBox(width: 20),
                      _SocialOrb(icon: Icons.apple_rounded),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Sign up link ─────────────────────────────────────────
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, a, __) => const SignupPage(),
                          transitionsBuilder: (_, anim, __, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration:
                              const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                          const TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Home indicator ───────────────────────────────────────
                  Container(
                    width: 120,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Outlined text field
// ─────────────────────────────────────────────────────────────────────────────
class _OutlinedField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;

  const _OutlinedField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1.5),
        color: Colors.white.withOpacity(0.08),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70, size: 20),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 15,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Login / action button
// ─────────────────────────────────────────────────────────────────────────────
class _LoginButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _LoginButton({required this.label, required this.onTap});

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border:
                Border.all(color: Colors.white.withOpacity(0.75), width: 1.5),
            color: Colors.white.withOpacity(0.12),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Social login orb
// ─────────────────────────────────────────────────────────────────────────────
class _SocialOrb extends StatelessWidget {
  final IconData icon;
  const _SocialOrb({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.92),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 14,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: const Color(0xFF8A2BE2), size: 28),
    );
  }
}
