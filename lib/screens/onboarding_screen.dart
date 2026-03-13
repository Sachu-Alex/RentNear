import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/animations.dart';
import 'login_screen.dart';

// ── Page data ────────────────────────────────────────────────────────────────

class _OnboardingPage {
  final IconData mainIcon;
  final Color accent;
  final Color accentLight;
  final String badge;
  final String title;
  final String subtitle;
  final List<_FeaturePill> pills;
  final List<_FloatingCard> floatingCards;

  const _OnboardingPage({
    required this.mainIcon,
    required this.accent,
    required this.accentLight,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.pills,
    required this.floatingCards,
  });
}

class _FeaturePill {
  final IconData icon;
  final String label;
  const _FeaturePill(this.icon, this.label);
}

class _FloatingCard {
  final IconData icon;
  final String label;
  final Alignment alignment;
  const _FloatingCard(this.icon, this.label, this.alignment);
}

const _pages = [
  _OnboardingPage(
    mainIcon: Icons.search_rounded,
    accent: Color(0xFF0B6E6B),
    accentLight: Color(0xFFDBF0EF),
    badge: 'DISCOVER',
    title: 'Find Equipment\nNearby',
    subtitle:
        'Browse thousands of tools, machines, and equipment available for rent — within minutes of your location.',
    pills: [
      _FeaturePill(Icons.explore_outlined, 'Local inventory'),
      _FeaturePill(Icons.star_outline_rounded, 'Top rated'),
      _FeaturePill(Icons.filter_list_rounded, 'Smart filters'),
    ],
    floatingCards: [
      _FloatingCard(Icons.build_circle_outlined, 'Tools', Alignment(0.9, -0.7)),
      _FloatingCard(Icons.electrical_services, 'Electronics', Alignment(-1.0, 0.6)),
    ],
  ),
  _OnboardingPage(
    mainIcon: Icons.event_available_rounded,
    accent: Color(0xFF0EA5E9),
    accentLight: Color(0xFFE0F2FE),
    badge: 'BOOK',
    title: 'Reserve in\nSeconds',
    subtitle:
        'Flexible hourly, daily, or weekly plans. Instant confirmation, no paperwork, no deposits required.',
    pills: [
      _FeaturePill(Icons.flash_on_rounded, 'Instant confirm'),
      _FeaturePill(Icons.calendar_today_outlined, 'Flexible dates'),
      _FeaturePill(Icons.lock_outline_rounded, 'Secure pay'),
    ],
    floatingCards: [
      _FloatingCard(Icons.receipt_long_outlined, 'No paperwork', Alignment(0.95, -0.6)),
      _FloatingCard(Icons.credit_card_rounded, 'Secure pay', Alignment(-0.95, 0.65)),
    ],
  ),
  _OnboardingPage(
    mainIcon: Icons.local_shipping_rounded,
    accent: Color(0xFFE07B39),
    accentLight: Color(0xFFFEEDDF),
    badge: 'TRACK',
    title: 'Live Delivery\nTracking',
    subtitle:
        'Watch your rental arrive in real time. Dynamic Island and Lock Screen updates keep you in the loop.',
    pills: [
      _FeaturePill(Icons.dynamic_feed_rounded, 'Dynamic Island'),
      _FeaturePill(Icons.lock_clock_outlined, 'Lock Screen'),
      _FeaturePill(Icons.notifications_outlined, 'Push alerts'),
    ],
    floatingCards: [
      _FloatingCard(Icons.location_on_rounded, 'Live location', Alignment(0.9, -0.65)),
      _FloatingCard(Icons.timer_outlined, 'ETA updates', Alignment(-0.95, 0.6)),
    ],
  ),
];

// ── Onboarding screen ─────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  // Per-page entry animations
  late AnimationController _entryController;
  late Animation<double> _illustrationScale;
  late Animation<double> _illustrationFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;
  late Animation<double> _pillsFade;

  // Slow background blob drift
  late AnimationController _blobController;

  // Next button press feedback
  late AnimationController _btnController;
  late Animation<double> _btnScale;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    )..repeat(reverse: true);
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _setupEntryAnimations();
    _entryController.forward();

    _btnScale = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _btnController, curve: Curves.easeOut),
    );
  }

  void _setupEntryAnimations() {
    _illustrationScale = Tween<double>(begin: 0.68, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
      ),
    );
    _illustrationFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.38, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.24),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOutCubic),
    ));
    _textFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.20, 0.65, curve: Curves.easeOut),
    );
    _pillsFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.50, 1.0, curve: Curves.easeOut),
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _entryController.reset();
    _entryController.forward();
    HapticFeedback.lightImpact();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 480),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _skip() => _navigateToLogin();

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const LoginScreen(),
        transitionsBuilder: (_, animation, _, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entryController.dispose();
    _blobController.dispose();
    _btnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: AnimatedBuilder(
        animation: Listenable.merge([_blobController, _entryController, _btnController]),
        builder: (context, _) {
          return Stack(
            children: [
              _buildBlobs(page.accent, size),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    _buildTopBar(page),
                    const SizedBox(height: 4),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _pages.length,
                        itemBuilder: (context, index) =>
                            _buildPageContent(_pages[index], size),
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

  // ── Background blobs ──────────────────────────────────────────────────────

  Widget _buildBlobs(Color accent, Size size) {
    final t = _blobController.value;
    return Stack(
      children: [
        Positioned(
          top: -50 + math.sin(t * math.pi) * 18,
          right: -70 + math.cos(t * math.pi) * 12,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.32 + math.cos(t * math.pi) * 12,
          left: -90 + math.sin(t * math.pi * 1.3) * 10,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.05),
            ),
          ),
        ),
        Positioned(
          bottom: 90 + math.sin(t * math.pi * 0.8) * 8,
          right: -30 + math.cos(t * math.pi * 1.1) * 8,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.06),
            ),
          ),
        ),
      ],
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 14, 28, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(_pages.length, (i) {
              final isActive = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(right: 6),
                width: isActive ? 28 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isActive ? page.accent : AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _currentPage < _pages.length - 1 ? 1.0 : 0.0,
            child: TapScale(
              onTap: _skip,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.dividerColor, width: 1),
                ),
                child: Text(
                  'Skip',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Page layout ───────────────────────────────────────────────────────────

  Widget _buildPageContent(_OnboardingPage page, Size size) {
    return Column(
      children: [
        _buildIllustrationArea(page, size),
        const SizedBox(height: 4),
        Expanded(child: _buildContentCard(page)),
        const SizedBox(height: 20),
      ],
    );
  }

  // ── Illustration area ─────────────────────────────────────────────────────

  Widget _buildIllustrationArea(_OnboardingPage page, Size size) {
    return SizedBox(
      height: size.height * 0.36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Custom animated illustration
          ScaleTransition(
            scale: _illustrationScale,
            child: FadeTransition(
              opacity: _illustrationFade,
              child: _IllustrationWidget(
                accent: page.accent,
                accentLight: page.accentLight,
                icon: page.mainIcon,
              ),
            ),
          ),

          // Floating decorative cards
          ...page.floatingCards.asMap().entries.map((entry) {
            final i = entry.key;
            final card = entry.value;
            return Positioned(
              left: size.width * 0.5 +
                  card.alignment.x * (size.width * 0.36) -
                  40,
              top: size.height * 0.18 +
                  card.alignment.y * (size.height * 0.12),
              child: FadeTransition(
                opacity: _pillsFade,
                child: _buildFloatingCard(card, page.accent, page.accentLight, i),
              ),
            );
          }),

          // Badge chip
          Positioned(
            top: size.height * 0.025,
            right: size.width * 0.07,
            child: FadeTransition(
              opacity: _illustrationFade,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: page.accent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: page.accent.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  page.badge,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCard(
      _FloatingCard card, Color accent, Color accentLight, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: accentLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(card.icon, size: 14, color: accent),
          ),
          const SizedBox(width: 6),
          Text(
            card.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Content card ──────────────────────────────────────────────────────────

  Widget _buildContentCard(_OnboardingPage page) {
    final isLast = _currentPage == _pages.length - 1;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 26),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: page.accent.withValues(alpha: 0.07),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideTransition(
            position: _textSlide,
            child: FadeTransition(
              opacity: _textFade,
              child: Text(
                page.title,
                style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.8,
                  height: 1.15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          SlideTransition(
            position: _textSlide,
            child: FadeTransition(
              opacity: _textFade,
              child: Text(
                page.subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _pillsFade,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: page.pills
                  .map((p) => _buildPill(p, page.accent, page.accentLight))
                  .toList(),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              FadeTransition(
                opacity: _textFade,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${_currentPage + 1}',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: page.accent,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: ' / ${_pages.length}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTapDown: (_) => _btnController.forward(),
                onTapUp: (_) {
                  _btnController.reverse();
                  _nextPage();
                },
                onTapCancel: () => _btnController.reverse(),
                child: ScaleTransition(
                  scale: _btnScale,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: isLast ? 26 : 22,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: page.accent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: page.accent.withValues(alpha: 0.38),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLast ? 'Get Started' : 'Next',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isLast
                                ? Icons.rocket_launch_rounded
                                : Icons.arrow_forward_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill(_FeaturePill pill, Color accent, Color accentLight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: accentLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.18), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(pill.icon, size: 14, color: accent),
          const SizedBox(width: 5),
          Text(
            pill.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom illustration widget ────────────────────────────────────────────────
// Self-contained: manages its own ring-pulse animation controller.

class _IllustrationWidget extends StatefulWidget {
  final Color accent;
  final Color accentLight;
  final IconData icon;

  const _IllustrationWidget({
    required this.accent,
    required this.accentLight,
    required this.icon,
  });

  @override
  State<_IllustrationWidget> createState() => _IllustrationWidgetState();
}

class _IllustrationWidgetState extends State<_IllustrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ring;

  @override
  void initState() {
    super.initState();
    _ring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _ring.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ring,
      builder: (context, _) {
        return SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ring 2 — offset half a cycle
              _buildPulseRing((_ring.value + 0.5) % 1.0),
              // Ring 1
              _buildPulseRing(_ring.value),

              // Main circle — gradient from solid to slightly lighter
              Container(
                width: 168,
                height: 168,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.accent,
                      Color.lerp(widget.accent, Colors.white, 0.18)!,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accent.withValues(alpha: 0.30),
                      blurRadius: 48,
                      spreadRadius: 6,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: widget.accent.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),

              // Inner soft ring for depth
              Container(
                width: 148,
                height: 148,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                    width: 1.5,
                  ),
                ),
              ),

              // Icon
              Icon(
                widget.icon,
                size: 72,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPulseRing(double progress) {
    final easedProgress = Curves.easeOut.transform(progress);
    final scale = 1.0 + easedProgress * 0.55;
    final opacity = (1.0 - easedProgress) * 0.38;
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          width: 168,
          height: 168,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.accent,
              width: 2.5,
            ),
          ),
        ),
      ),
    );
  }
}
