import 'package:flutter/material.dart';
import 'package:aiva_life/widgets/Navigation-Instruction/IconOrb.dart';
import 'package:aiva_life/widgets/Navigation-Instruction/instruction_model.dart';

class StepPage extends StatelessWidget {
  const StepPage({
    required this.step,
    required this.cardFade,
    required this.cardSlide,
    required this.size,
  });
  final InstructionStep step;
  final Animation<double> cardFade;
  final Animation<Offset> cardSlide;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: cardFade,
      child: SlideTransition(
        position: cardSlide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconOrb(step: step, size: size),
              const SizedBox(height: 48),
              Text(
                step.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.25,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                step.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFADB8CC),
                  height: 1.6,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}