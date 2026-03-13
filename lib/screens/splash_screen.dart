import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── existing controllers ──────────────────────────────────────────────────
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _particleController;

  // ── new controllers ───────────────────────────────────────────────────────
  late AnimationController _rippleController;
  late AnimationController _typingController;
  late AnimationController _cursorController;

  // ── existing animations ───────────────────────────────────────────────────
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineFade;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  // ── new animations ────────────────────────────────────────────────────────
  late Animation<int> _typingAnimation;
  late Animation<double> _cursorAnimation;

  static const _taglineText = 'Rent anything, anywhere.';

  @override
  void initState() {
    super.initState();

    // existing
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // new
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _typingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _taglineText.length * 52),
    );
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _setupAnimations();

    _mainController.forward();

    // looping animations
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
        _shimmerController.repeat();
        _particleController.repeat();
        _rippleController.repeat();
      }
    });

    // typing starts just as the tagline container fades in (~1400 ms)
    Future.delayed(const Duration(milliseconds: 1450), () {
      if (mounted) {
        _typingController.forward();
        _cursorController.repeat(reverse: true);
      }
    });

    _navigateToHome();
  }

  void _setupAnimations() {
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );
    _logoRotation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );
    _ringScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _ringOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // typing
    _typingAnimation = IntTween(begin: 0, end: _taglineText.length).animate(
      CurvedAnimation(parent: _typingController, curve: Curves.linear),
    );
    _cursorAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOut),
    );
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3800));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved =
                CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 900),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    _rippleController.dispose();
    _typingController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _pulseController,
          _shimmerController,
          _particleController,
          _rippleController,
          _typingController,
          _cursorController,
        ]),
        builder: (context, _) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B6E6B),
                  Color(0xFF094D4B),
                  Color(0xFF073A39),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
            child: Stack(
              children: [
                ..._buildParticles(),
                _buildDecorativeCircles(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 40),
                      _buildAppName(),
                      const SizedBox(height: 12),
                      _buildTypingTagline(),
                    ],
                  ),
                ),
                _buildBouncingDotsLoader(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Logo with ripple rings ────────────────────────────────────────────────

  Widget _buildLogo() {
    return FadeTransition(
      opacity: _logoFade,
      child: ScaleTransition(
        scale: _logoScale,
        child: Transform.rotate(
          angle: _logoRotation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ripple rings (3 expanding, staggered)
              ..._buildRippleRings(),

              // One-shot entry ring
              Transform.scale(
                scale: _ringScale.value * 1.8,
                child: Opacity(
                  opacity: _ringOpacity.value,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),

              // Pulsing glow
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2DD4BF).withAlpha(60),
                        blurRadius: 40,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                ),
              ),

              // Main logo container
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: const Color(0xFF2DD4BF).withAlpha(30),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Shimmer overlay
                    ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment(_shimmerAnimation.value - 1, 0),
                            end: Alignment(_shimmerAnimation.value, 0),
                            colors: const [
                              Colors.transparent,
                              Color(0x28FFFFFF),
                              Colors.transparent,
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Container(
                          width: 130,
                          height: 130,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Gradient icon
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0B6E6B), Color(0xFF2DD4BF)],
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.home_work_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRippleRings() {
    return List.generate(3, (i) {
      final phase = i / 3;
      final t = (_rippleController.value + phase) % 1.0;
      final scale = 1.0 + t * 1.2;
      final opacity = (1.0 - t) * 0.35 * _logoFade.value;
      return Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF2DD4BF),
                width: 1.5,
              ),
            ),
          ),
        ),
      );
    });
  }

  // ── App name ──────────────────────────────────────────────────────────────

  Widget _buildAppName() {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textFade,
        child: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Colors.white, Color(0xFFB2F5EA)],
            ).createShader(bounds);
          },
          child: Text(
            'RentNear',
            style: GoogleFonts.outfit(
              fontSize: 46,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  // ── Typing tagline ────────────────────────────────────────────────────────

  Widget _buildTypingTagline() {
    return SlideTransition(
      position: _taglineSlide,
      child: FadeTransition(
        opacity: _taglineFade,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withAlpha(40),
              width: 1,
            ),
            color: Colors.white.withAlpha(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _taglineText.substring(0, _typingAnimation.value),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withAlpha(200),
                  letterSpacing: 0.8,
                ),
              ),
              // Blinking cursor — hidden once fully typed
              if (_typingAnimation.value < _taglineText.length ||
                  _cursorAnimation.value > 0.4)
                Opacity(
                  opacity: _cursorAnimation.value,
                  child: Text(
                    '|',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withAlpha(180),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bouncing dots loader ──────────────────────────────────────────────────

  Widget _buildBouncingDotsLoader() {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _taglineFade,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final phase = i / 3;
                final t = (_particleController.value + phase) % 1.0;
                final bounce = math.sin(t * math.pi * 2);
                // only move upward (negative y = up in Flutter)
                final yOffset = bounce < 0 ? bounce * 8.0 : 0.0;
                final alpha =
                    (140 + (bounce * 115).abs()).toInt().clamp(80, 255);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Transform.translate(
                    offset: Offset(0, yOffset),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(alpha),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              'Finding rentals near you...',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.white.withAlpha(100),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Particles ─────────────────────────────────────────────────────────────

  List<Widget> _buildParticles() {
    final particles = <_ParticleData>[
      _ParticleData(0.1, 0.2, 6, 0.0),
      _ParticleData(0.85, 0.15, 4, 0.3),
      _ParticleData(0.15, 0.75, 5, 0.5),
      _ParticleData(0.9, 0.7, 7, 0.2),
      _ParticleData(0.5, 0.1, 3, 0.7),
      _ParticleData(0.7, 0.85, 5, 0.4),
      _ParticleData(0.3, 0.9, 4, 0.6),
      _ParticleData(0.05, 0.5, 6, 0.1),
    ];

    return particles.map((p) {
      final progress = (_particleController.value + p.offset) % 1.0;
      final yOffset = math.sin(progress * math.pi * 2) * 20;
      final xOffset = math.cos(progress * math.pi * 2) * 10;
      final opacity = (math.sin(progress * math.pi) * 0.4).clamp(0.0, 1.0);

      return Positioned(
        left: MediaQuery.of(context).size.width * p.x + xOffset,
        top: MediaQuery.of(context).size.height * p.y + yOffset,
        child: Opacity(
          opacity: _logoFade.value * opacity,
          child: Container(
            width: p.size,
            height: p.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(60),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // ── Decorative circles ────────────────────────────────────────────────────

  Widget _buildDecorativeCircles() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -60,
          child: Opacity(
            opacity: _logoFade.value * 0.08,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -80,
          child: Opacity(
            opacity: _logoFade.value * 0.06,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          right: -40,
          child: Opacity(
            opacity: _logoFade.value * 0.05,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ParticleData {
  final double x, y, size, offset;
  const _ParticleData(this.x, this.y, this.size, this.offset);
}
