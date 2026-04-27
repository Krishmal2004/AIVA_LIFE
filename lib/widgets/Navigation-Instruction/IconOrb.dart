import 'package:flutter/material.dart';
import 'instruction_model.dart';

class IconOrb extends StatefulWidget {
  const IconOrb({super.key, required this.step, required this.size});
  final InstructionStep step;
  final Size size;

  @override 
  State<IconOrb> createState() => _IconOrbState();
} 

class _IconOrbState extends State<IconOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.93, end: 1.0)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orbSize = widget.size.width * 0.45;
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: child,
      ),
      child: Container(
        width: orbSize,
        height: orbSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.step.gradient,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.step.gradient[0].withOpacity(0.38),
              blurRadius: 50,
              spreadRadius: 6,
            ),
          ],
        ),
        child: Icon(
          widget.step.icon,
          size: orbSize * 0.48,
          color: Colors.white,
        ),
      ),
    );
  }
}