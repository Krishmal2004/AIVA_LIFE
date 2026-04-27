import 'package:flutter/material.dart';

class InstructionStep {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String description;

  const InstructionStep({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.description,
  });
}