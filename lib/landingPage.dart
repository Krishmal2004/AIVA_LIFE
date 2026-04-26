import 'package:flutter/material.dart';
import 'package:aiva_life/screens/login.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
          ),
        );

    _buttonScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF060C1A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF060C1A),
                    Color(0xFF0A1628),
                    Color(0xFF0D1F3C),
                    Color(0xFF050D1A),
                  ],
                  stops: [0.0, 0.35, 0.6, 1.0],
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeIn,
              child: CustomPaint(
                size: Size(size.width * 0.55, size.height * 0.55),
                painter: _CircuitPainter(side: _CircuitSide.right),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.05,
            left: 0,
            child: FadeTransition(
              opacity: _fadeIn,
              child: CustomPaint(
                size: Size(size.width * 0.35, size.height * 0.45),
                painter: _CircuitPainter(side: _CircuitSide.left),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Hero image area
                Expanded(
                  flex: 55,
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: _HeroIllustration(size: size),
                  ),
                ),

                Expanded(
                  flex: 45,
                  child: SlideTransition(
                    position: _slideUp,
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),

                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Making technology\neasy for ',
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: _HighlightedWord(word: 'all'),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              'Demystifying tech, one simple step at a time. '
                              'Learn without stress or intricate jargon.',
                              style: TextStyle(
                                fontSize: 14.5,
                                color: Color(0xFFADB8CC),
                                height: 1.55,
                                letterSpacing: 0.1,
                              ),
                            ),

                            const Spacer(),

                            ScaleTransition(
                              scale: _buttonScale,
                              child: _GetStartedButton(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroIllustration extends StatefulWidget {
  final Size size;
  const _HeroIllustration({required this.size});

  @override
  State<_HeroIllustration> createState() => _HeroIllustrationState();
}

class _HeroIllustrationState extends State<_HeroIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowPulse = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowPulse,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer ambient glow
            Container(
              width: widget.size.width * 0.72,
              height: widget.size.width * 0.72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF00D4FF,
                    ).withOpacity(0.12 * _glowPulse.value),
                    blurRadius: 90,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),

            // Robot hand + globe illustration (custom painted)
            CustomPaint(
              size: Size(widget.size.width * 0.85, widget.size.height * 0.52),
              painter: _RobotHandPainter(glowIntensity: _glowPulse.value),
            ),

            // Globe overlay with "AI" text
            Positioned(
              top: widget.size.height * 0.03,
              child: _GlobeWidget(
                glowValue: _glowPulse.value,
                size: widget.size.width * 0.45,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlobeWidget extends StatelessWidget {
  final double glowValue;
  final double size;

  const _GlobeWidget({required this.glowValue, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 0.85,
          colors: [
            Colors.white.withOpacity(0.18),
            const Color(0xFF8DD8F8).withOpacity(0.22),
            const Color(0xFF00AEDB).withOpacity(0.15),
            const Color(0xFF002E4F).withOpacity(0.55),
          ],
          stops: const [0.0, 0.35, 0.65, 1.0],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.35 * glowValue),
            blurRadius: 40,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // City skyline silhouette inside globe
          Positioned(
            bottom: size * 0.12,
            child: _CitySkyline(width: size * 0.7, height: size * 0.28),
          ),

          // "AI" text
          Text(
            'AI',
            style: TextStyle(
              fontSize: size * 0.34,
              fontWeight: FontWeight.w800,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF7DE8FF), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(Rect.fromLTWH(0, 0, size * 0.5, size * 0.4)),
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.8),
                  blurRadius: 18,
                ),
              ],
            ),
          ),

          // Glass highlight (top-left lens flare)
          Positioned(
            top: size * 0.08,
            left: size * 0.1,
            child: Container(
              width: size * 0.28,
              height: size * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.35),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CitySkyline extends StatelessWidget {
  final double width;
  final double height;
  const _CitySkyline({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(width, height), painter: _SkylinePainter());
  }
}

class _SkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00AEDB).withOpacity(0.9),
          const Color(0xFF005580).withOpacity(0.5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final buildings = [
      // [x_frac, width_frac, height_frac]
      [0.0, 0.08, 0.55],
      [0.09, 0.06, 0.45],
      [0.16, 0.09, 0.75],
      [0.26, 0.06, 0.60],
      [0.33, 0.10, 0.90],
      [0.44, 0.07, 0.65],
      [0.52, 0.09, 0.50],
      [0.62, 0.08, 0.80],
      [0.71, 0.06, 0.55],
      [0.78, 0.10, 0.70],
      [0.89, 0.07, 0.50],
      [0.97, 0.06, 0.40],
    ];

    for (var b in buildings) {
      final x = b[0] * size.width;
      final w = b[1] * size.width;
      final h = b[2] * size.height;
      path.addRect(Rect.fromLTWH(x, size.height - h, w, h));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RobotHandPainter extends CustomPainter {
  final double glowIntensity;
  _RobotHandPainter({required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final palmPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF8AAFC8),
          const Color(0xFF4A7290),
          const Color(0xFF1E3A50),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = const Color(0xFF00D4FF).withOpacity(0.18 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);

    final palmPath = Path();
    final cx = size.width * 0.5;
    final py = size.height * 0.55;

    palmPath.moveTo(cx - size.width * 0.22, size.height * 0.95);
    palmPath.quadraticBezierTo(
      cx - size.width * 0.30,
      py + size.height * 0.12,
      cx - size.width * 0.24,
      py,
    );
    palmPath.quadraticBezierTo(
      cx,
      py - size.height * 0.04,
      cx + size.width * 0.24,
      py,
    );
    palmPath.quadraticBezierTo(
      cx + size.width * 0.30,
      py + size.height * 0.12,
      cx + size.width * 0.22,
      size.height * 0.95,
    );
    palmPath.close();

    canvas.drawPath(palmPath, glowPaint);
    canvas.drawPath(palmPath, palmPaint);
    canvas.drawPath(palmPath, highlightPaint);

    _drawFinger(
      canvas,
      size,
      palmPaint,
      highlightPaint,
      glowPaint,
      cx - size.width * 0.18,
      py,
      size.width * 0.065,
      size.height * 0.28,
      -8,
    );
    _drawFinger(
      canvas,
      size,
      palmPaint,
      highlightPaint,
      glowPaint,
      cx - size.width * 0.06,
      py,
      size.width * 0.065,
      size.height * 0.32,
      -3,
    );
    _drawFinger(
      canvas,
      size,
      palmPaint,
      highlightPaint,
      glowPaint,
      cx + size.width * 0.06,
      py,
      size.width * 0.065,
      size.height * 0.32,
      3,
    );
    _drawFinger(
      canvas,
      size,
      palmPaint,
      highlightPaint,
      glowPaint,
      cx + size.width * 0.18,
      py,
      size.width * 0.065,
      size.height * 0.28,
      8,
    );

    // Thumb
    _drawFinger(
      canvas,
      size,
      palmPaint,
      highlightPaint,
      glowPaint,
      cx - size.width * 0.27,
      py + size.height * 0.06,
      size.width * 0.055,
      size.height * 0.20,
      -20,
    );

    final knucklePaint = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..style = PaintingStyle.fill;

    for (double dx in [-0.18, -0.06, 0.06, 0.18]) {
      canvas.drawCircle(
        Offset(cx + dx * size.width, py),
        size.width * 0.028,
        knucklePaint,
      );
    }
  }

  void _drawFinger(
    Canvas canvas,
    Size size,
    Paint fill,
    Paint highlight,
    Paint glow,
    double x,
    double baseY,
    double w,
    double h,
    double angleDeg,
  ) {
    canvas.save();
    canvas.translate(x, baseY);
    canvas.rotate(angleDeg * 3.14159 / 180);

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-w / 2, -h, w, h),
      Radius.circular(w / 2),
    );

    canvas.drawRRect(rect, glow);
    canvas.drawRRect(rect, fill);
    canvas.drawRRect(rect, highlight);

    // Finger joint lines
    final jointPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(-w * 0.4, -h * 0.35),
      Offset(w * 0.4, -h * 0.35),
      jointPaint,
    );
    canvas.drawLine(
      Offset(-w * 0.4, -h * 0.65),
      Offset(w * 0.4, -h * 0.65),
      jointPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RobotHandPainter old) =>
      old.glowIntensity != glowIntensity;
}

enum _CircuitSide { left, right }

class _CircuitPainter extends CustomPainter {
  final _CircuitSide side;
  _CircuitPainter({required this.side});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF00D4FF).withOpacity(0.18)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF00D4FF).withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final lines = side == _CircuitSide.right
        ? [
            [0.9, 0.05, 0.9, 0.20, 0.60, 0.20],
            [0.9, 0.20, 0.90, 0.30],
            [0.75, 0.08, 0.75, 0.25, 0.50, 0.25],
            [0.60, 0.12, 0.60, 0.45, 0.40, 0.45],
            [0.95, 0.40, 0.70, 0.40, 0.70, 0.55],
            [1.0, 0.55, 0.80, 0.55, 0.80, 0.70],
          ]
        : [
            [0.05, 0.10, 0.05, 0.30, 0.35, 0.30],
            [0.20, 0.05, 0.20, 0.20, 0.50, 0.20],
            [0.10, 0.40, 0.10, 0.55, 0.40, 0.55],
            [0.0, 0.65, 0.30, 0.65, 0.30, 0.78],
          ];

    for (final seg in lines) {
      final path = Path();
      path.moveTo(seg[0] * size.width, seg[1] * size.height);
      for (int i = 2; i < seg.length; i += 2) {
        path.lineTo(seg[i] * size.width, seg[i + 1] * size.height);
      }
      canvas.drawPath(path, linePaint);
      canvas.drawCircle(
        Offset(
          seg[seg.length - 2] * size.width,
          seg[seg.length - 1] * size.height,
        ),
        2.5,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HighlightedWord extends StatelessWidget {
  final String word;
  const _HighlightedWord({required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 4),
      decoration: BoxDecoration(
        color: const Color(0xFF00C8F0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        word,
        style: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: Color(0xFF060C1A),
          height: 1.2,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatefulWidget {
  final VoidCallback onTap;
  const _GetStartedButton({required this.onTap});

  @override
  State<_GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<_GetStartedButton> {
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
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [Color(0xFF00D4F5), Color(0xFF00A8C8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D4F5).withOpacity(0.40),
                blurRadius: 22,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'Get Started',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF060C1A),
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
