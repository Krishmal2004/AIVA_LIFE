import 'dart:math' as math;
import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _pulseCtrl;

  // Per-card staggered fades
  late final List<Animation<double>> _cardFades;
  late final List<Animation<Offset>> _cardSlides;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Stagger 4 cards at 0, 150, 300, 450 ms
    _cardFades = List.generate(4, (i) {
      final start = i * 0.15;
      return CurvedAnimation(
        parent: _entranceCtrl,
        curve: Interval(start, (start + 0.55).clamp(0, 1), curve: Curves.easeOut),
      );
    });

    _cardSlides = List.generate(4, (i) {
      final start = i * 0.15;
      return Tween<Offset>(
        begin: const Offset(0, 0.18),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(start, (start + 0.6).clamp(0, 1), curve: Curves.easeOut),
        ),
      );
    });

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Widget _staggered(int i, Widget child) => FadeTransition(
        opacity: _cardFades[i],
        child: SlideTransition(position: _cardSlides[i], child: child),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF060C1A),
      body: Stack(
        children: [
          // ── Background ─────────────────────────────────────────────────
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

          // ── Ambient top glow ────────────────────────────────────────────
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) => Positioned(
              top: -size.height * 0.12,
              left: size.width * 0.05,
              child: Container(
                width: size.width * 0.9,
                height: size.width * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00D4FF)
                          .withOpacity(0.10 + 0.05 * _pulseCtrl.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Scrollable content ──────────────────────────────────────────
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Good morning 👋',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7A90AA),
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Your Dashboard',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Avatar
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00D4FF), Color(0xFF0080C8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00D4FF).withOpacity(0.35),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Card Grid ──────────────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.88,
                    ),
                    delegate: SliverChildListDelegate([
                      _staggered(0, const _TasksCard()),
                      _staggered(1, const _FinanceCard()),
                      _staggered(2, const _MoodCard()),
                      _staggered(3, _ProductivityCard(pulseCtrl: _pulseCtrl)),
                    ]),
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

// ═══════════════════════════════════════════════════════════════
//  Shared glass card shell
// ═══════════════════════════════════════════════════════════════
class _GlassCard extends StatefulWidget {
  const _GlassCard({
    required this.gradient,
    required this.child,
    this.glowColor,
  });

  final List<Color> gradient;
  final Widget child;
  final Color? glowColor;

  @override
  State<_GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<_GlassCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.07),
                Colors.white.withOpacity(0.03),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: (widget.glowColor ?? widget.gradient[0])
                    .withOpacity(0.14),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // Top-left gradient accent
                Positioned(
                  top: -18,
                  left: -18,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.gradient[0].withOpacity(0.22),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Card A — Tasks
// ═══════════════════════════════════════════════════════════════
class _TasksCard extends StatefulWidget {
  const _TasksCard();

  @override
  State<_TasksCard> createState() => _TasksCardState();
}

class _TasksCardState extends State<_TasksCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _barCtrl;
  late final Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _barAnim = CurvedAnimation(parent: _barCtrl, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _barCtrl.forward();
    });
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      gradient: const [Color(0xFF00D4FF), Color(0xFF0080C8)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon chip
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0xFF00D4FF), Color(0xFF0080C8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.40),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(Icons.calendar_today_rounded,
                color: Colors.white, size: 18),
          ),
          const Spacer(),
          // Big number
          const Text(
            '5',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Pending Tasks',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFADB8CC),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          // Mini progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Progress',
                      style: TextStyle(fontSize: 10, color: Color(0xFF7A90AA))),
                  Text('60%',
                      style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF00D4FF),
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AnimatedBuilder(
                  animation: _barAnim,
                  builder: (_, __) => Stack(
                    children: [
                      Container(
                        height: 6,
                        color: Colors.white.withOpacity(0.08),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.6 * _barAnim.value,
                        child: Container(
                          height: 6,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF00D4FF), Color(0xFF0080C8)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Card B — Finance
// ═══════════════════════════════════════════════════════════════
class _FinanceCard extends StatelessWidget {
  const _FinanceCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      gradient: const [Color(0xFF00C896), Color(0xFF007A5A)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon chip
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0xFF00C896), Color(0xFF007A5A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00C896).withOpacity(0.40),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(Icons.account_balance_wallet_rounded,
                color: Colors.white, size: 18),
          ),
          const Spacer(),
          // Value
          const Text(
            'Rs. 12,500',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'left this month',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFADB8CC),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          // Trend chip
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFFF4D6D).withOpacity(0.15),
              border: Border.all(
                  color: const Color(0xFFFF4D6D).withOpacity(0.30)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.trending_down_rounded,
                    color: Color(0xFFFF4D6D), size: 14),
                SizedBox(width: 4),
                Text(
                  '8% this month',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFFF4D6D),
                    fontWeight: FontWeight.w600,
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

// ═══════════════════════════════════════════════════════════════
//  Card C — Mood
// ═══════════════════════════════════════════════════════════════
class _MoodCard extends StatefulWidget {
  const _MoodCard();

  @override
  State<_MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<_MoodCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _emojiCtrl;
  late final Animation<double> _emojiScale;

  @override
  void initState() {
    super.initState();
    _emojiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _emojiScale = Tween<double>(begin: 0.92, end: 1.08)
        .animate(CurvedAnimation(parent: _emojiCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _emojiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      gradient: const [Color(0xFFFFD166), Color(0xFFFF8C00)],
      glowColor: const Color(0xFFFFD166),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon chip
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD166), Color(0xFFFF8C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD166).withOpacity(0.45),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(Icons.psychology_rounded,
                color: Colors.white, size: 18),
          ),
          const Spacer(),
          // Animated emoji
          AnimatedBuilder(
            animation: _emojiScale,
            builder: (_, __) => Transform.scale(
              scale: _emojiScale.value,
              child: const Text('😊',
                  style: TextStyle(fontSize: 40, height: 1.0)),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Feeling Good',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Streak badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFD166).withOpacity(0.22),
                  const Color(0xFFFF8C00).withOpacity(0.12),
                ],
              ),
              border: Border.all(
                  color: const Color(0xFFFFD166).withOpacity(0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.local_fire_department_rounded,
                    color: Color(0xFFFFD166), size: 13),
                SizedBox(width: 4),
                Text(
                  '3-day streak',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFFFD166),
                    fontWeight: FontWeight.w600,
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

// ═══════════════════════════════════════════════════════════════
//  Card D — Productivity
// ═══════════════════════════════════════════════════════════════
class _ProductivityCard extends StatefulWidget {
  const _ProductivityCard({required this.pulseCtrl});
  final AnimationController pulseCtrl;

  @override
  State<_ProductivityCard> createState() => _ProductivityCardState();
}

class _ProductivityCardState extends State<_ProductivityCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ringCtrl;
  late final Animation<double> _ringAnim;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ringCtrl.forward();
    });
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      gradient: const [Color(0xFFAA55DD), Color(0xFF6A0DAD)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon chip
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0xFFAA55DD), Color(0xFF6A0DAD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFAA55DD).withOpacity(0.45),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(Icons.bolt_rounded,
                color: Colors.white, size: 20),
          ),
          const Spacer(),
          // Ring + score centered
          Center(
            child: AnimatedBuilder(
              animation: _ringAnim,
              builder: (_, __) => _RingProgress(
                progress: 0.78 * _ringAnim.value,
                size: 80,
                strokeWidth: 8,
                gradientColors: const [Color(0xFFAA55DD), Color(0xFFE05CB0)],
                label: '${(78 * _ringAnim.value).round()}%',
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Focus Score',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Today\'s productivity',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFFADB8CC),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Ring progress painter
// ═══════════════════════════════════════════════════════════════
class _RingProgress extends StatelessWidget {
  const _RingProgress({
    required this.progress,
    required this.size,
    required this.strokeWidth,
    required this.gradientColors,
    required this.label,
  });

  final double progress; // 0.0 – 1.0
  final double size;
  final double strokeWidth;
  final List<Color> gradientColors;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress,
              strokeWidth: strokeWidth,
              gradientColors: gradientColors,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradientColors,
  });

  final double progress;
  final double strokeWidth;
  final List<Color> gradientColors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Gradient arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradientPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi * progress,
        colors: gradientColors,
        tileMode: TileMode.clamp,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      gradientPaint,
    );

    // Glow dot at tip
    if (progress > 0.01) {
      final angle = -math.pi / 2 + 2 * math.pi * progress;
      final tipX = center.dx + radius * math.cos(angle);
      final tipY = center.dy + radius * math.sin(angle);
      final dotPaint = Paint()
        ..color = gradientColors.last.withOpacity(0.85)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(tipX, tipY), strokeWidth / 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress;
}
