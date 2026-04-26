import 'package:flutter/material.dart';

class SignUpButtonState extends StatefulWidget {
  final VoidCallback onTap;
  const SignUpButtonState({super.key, required this.onTap});

  @override
  State<SignUpButtonState> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButtonState> {
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
            color: Colors.white.withOpacity(0.92),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.12),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
