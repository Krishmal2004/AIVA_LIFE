import 'package:aiva_life/widgets/Navigation-Instruction/StepPage.dart';
import 'package:flutter/material.dart';
import 'package:aiva_life/widgets/Navigation-Instruction/AnimatedNextButton.dart';
import 'package:aiva_life/widgets/Navigation-Instruction/instruction_model.dart';


class NavigationInstructionPage extends StatefulWidget {
  const NavigationInstructionPage({super.key});

  @override
  State<NavigationInstructionPage> createState() =>
      _NavigationInstructionPageState();
}

class _NavigationInstructionPageState extends State<NavigationInstructionPage>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _bgAnim;
  late final AnimationController _cardAnim;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;

  int _currentPage = 0;

  static const List<InstructionStep> _steps = [
    InstructionStep(
      icon: Icons.explore_rounded,
      gradient: [Color(0xFF00D4FF), Color(0xFF0080C8)],
      title: 'Explore Your Dashboard',
      description:
          'Your home screen gives you a personalised AI-powered overview. Swipe right to reveal the side menu at any time.',
    ),
    InstructionStep(
      icon: Icons.smart_toy_rounded,
      gradient: [Color(0xFFAA55DD), Color(0xFF6A0DAD)],
      title: 'Meet Your AI Assistant',
      description:
          'Tap the glowing orb to chat with AIVA. Ask anything — from daily tips to step-by-step tech help.',
    ),
    InstructionStep(
      icon: Icons.bar_chart_rounded,
      gradient: [Color(0xFF00C896), Color(0xFF007A5A)],
      title: 'Track Your Progress',
      description:
          'Monitor your learning streaks, completed modules and skill badges all in one beautiful place.',
    ),
    InstructionStep(
      icon: Icons.notifications_active_rounded,
      gradient: [Color(0xFFFF8C00), Color(0xFFE05CB0)],
      title: 'Stay in the Loop',
      description:
          'Enable smart notifications so AIVA can nudge you at the right moment — never miss a lesson again.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _bgAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _cardAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _cardFade = CurvedAnimation(parent: _cardAnim, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardAnim, curve: Curves.easeOut));

    _cardAnim.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgAnim.dispose();
    _cardAnim.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _cardAnim.reset();
    setState(() => _currentPage = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _cardAnim.forward();
  }

  void _next() {
    if (_currentPage < _steps.length - 1) {
      _goTo(_currentPage + 1);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final step = _steps[_currentPage];

    return Scaffold(
      backgroundColor: const Color(0xFF060C1A),
      body: AnimatedBuilder(
        animation: _bgAnim,
        builder: (context, _) {
          return Stack(
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
                top: -size.height * 0.15,
                left: size.width * 0.1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        step.gradient[0]
                            .withOpacity(0.18 + 0.06 * _bgAnim.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // Skip button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _next,
                          child: Text(
                            _currentPage < _steps.length - 1 ? 'Skip' : '',
                            style: const TextStyle(
                              color: Color(0xFF7A90AA),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // PageView
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (i) {
                          _cardAnim.reset();
                          setState(() => _currentPage = i);
                          _cardAnim.forward();
                        },
                        itemCount: _steps.length,
                        itemBuilder: (context, index) {
                          return StepPage(
                            step: _steps[index],
                            cardFade: _cardFade,
                            cardSlide: _cardSlide,
                            size: size,
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_steps.length, (i) {
                          final active = i == _currentPage;
                          return GestureDetector(
                            onTap: () => _goTo(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              width: active ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: active
                                    ? step.gradient[0]
                                    : Colors.white.withOpacity(0.18),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
                      child: AnimatedNextButton(
                        label: _currentPage < _steps.length - 1
                            ? 'Next'
                            : 'Get Started',
                        gradientColors: step.gradient,
                        onTap: _next,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
