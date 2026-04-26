import 'package:aiva_life/widgets/SignUpButtonState.dart';
import 'package:flutter/material.dart';
import 'package:aiva_life/widgets/DarkField.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: Column(
              children: [
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
                          color: Colors.white.withOpacity(0.06),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white.withOpacity(0.85),
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.55),
                      width: 1.8,
                    ),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 42,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      DarkField(
                        controller: _usernameController,
                        hint: 'Create Username',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      DarkField(
                        controller: _emailController,
                        hint: 'Email',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      DarkField(
                        controller: _passwordController,
                        hint: 'Create Password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white54,
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DarkField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm Password',
                        icon: Icons.lock_reset_rounded,
                        obscure: _obscureConfirm,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white54,
                            size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SignUpButtonState(
                    onTap: () {
                      // TODO: handle sign up
                    },
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: 120,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
