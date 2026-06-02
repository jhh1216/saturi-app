import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _dotsController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            // 로고 영역
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) => Opacity(
                opacity: _logoOpacity.value,
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: const _AppLogo(),
                ),
              ),
            ),
            const SizedBox(height: 36),
            // 앱 이름 + 태그라인
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) => FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      const Text(
                        '사투리',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: 6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeTransition(
                        opacity: _taglineFade,
                        child: const Text(
                          '방방곡곡 우리말 여행',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF888888),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(flex: 3),
            // 로딩 점 애니메이션
            AnimatedBuilder(
              animation: _dotsController,
              builder: (context, child) => _BouncingDots(progress: _dotsController.value),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── 앱 로고 ────────────────────────────────────────────────────────────────────

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 원들 (지역 색상)
          ..._buildOrbitDots(),
          // 중앙 메인 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B8DEF), Color(0xFF3DB4E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x305B8DEF),
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text('🗣️', style: TextStyle(fontSize: 36)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrbitDots() {
    const positions = [
      (dx: -52.0, dy: -32.0, color: Color(0xFFFF6B6B), emoji: '🏙️'),
      (dx: 52.0,  dy: -32.0, color: Color(0xFF48C774), emoji: '🌊'),
      (dx: -52.0, dy: 32.0,  color: Color(0xFFFFB347), emoji: '⛰️'),
      (dx: 52.0,  dy: 32.0,  color: Color(0xFFAB7CEA), emoji: '🌺'),
    ];

    return positions
        .map(
          (p) => Transform.translate(
            offset: Offset(p.dx, p.dy),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: p.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: p.color.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Center(
                child: Text(p.emoji, style: const TextStyle(fontSize: 14)),
              ),
            ),
          ),
        )
        .toList();
  }
}

// ── 바운싱 로딩 점 ─────────────────────────────────────────────────────────────

class _BouncingDots extends StatelessWidget {
  final double progress;

  const _BouncingDots({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final phase = (progress - i * 0.2).clamp(0.0, 1.0);
        final bounce = (phase < 0.5 ? phase * 2 : (1 - phase) * 2);
        final color = kRegionColors[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Transform.translate(
            offset: Offset(0, -8 * bounce),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}
