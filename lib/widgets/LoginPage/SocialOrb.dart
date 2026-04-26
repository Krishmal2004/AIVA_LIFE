import 'package:flutter/material.dart';


class SocialOrb extends StatelessWidget {
  final IconData icon;
  const SocialOrb({required this.icon});

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
