import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/floral_background.dart';
import '../widgets/custom_page_route.dart';
import 'about_screen.dart';
import 'projects_screen.dart';
import 'contact_screen.dart';

/// The Hero / landing screen of the portfolio.
///
/// Navigation flows:
/// - "Explore My Journey" → About Screen
/// - "View My Work"       → Projects Screen
/// - Floating rose FAB   → Contact Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _navigateToAbout() {
    Navigator.of(context).push(FloralPageRoute(page: const AboutScreen()));
  }

  void _navigateToProjects() {
    Navigator.of(context).push(FloralPageRoute(page: const ProjectsScreen()));
  }

  void _navigateToContact() {
    Navigator.of(context).push(FloralPageRoute(page: const ContactScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: _FloralFAB(onTap: _navigateToContact),
      body: FloralBackground(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Hero section ───────────────────────────────────────
                  _HeroSection(
                    topPad: topPad,
                    screenHeight: size.height,
                    onExplore: _navigateToAbout,
                    onViewWork: _navigateToProjects,
                  ),

                  const SizedBox(height: 32),

                  // ── Stats row ──────────────────────────────────────────
                  const _StatsRow(),

                  const SizedBox(height: 32),

                  // ── Featured highlights ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What I Do',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Crafting digital experiences with passion and precision.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        ..._highlightCards(context),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _highlightCards(BuildContext context) {
    final items = [
      (Icons.phone_android_rounded, 'Mobile Development', 'Beautiful Flutter apps for iOS & Android with smooth animations.', AppTheme.sageGreen),
      (Icons.web_rounded,           'Web Development',    'Modern, responsive web apps using React, Next.js, and more.',     AppTheme.blushPink),
      (Icons.design_services_rounded,'UI/UX Design',      'Thoughtful interfaces crafted in Figma that delight users.',       AppTheme.lavender),
    ];

    return items.map((item) {
      final (icon, title, subtitle, color) = item;
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.creamWhite,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color.withValues(alpha: 0.6)),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// ── Hero section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final double topPad;
  final double screenHeight;
  final VoidCallback onExplore;
  final VoidCallback onViewWork;

  const _HeroSection({
    required this.topPad,
    required this.screenHeight,
    required this.onExplore,
    required this.onViewWork,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(28, topPad + 20, 28, 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.darkForest,
            AppTheme.deepSage,
            AppTheme.sageGreen.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + greeting
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.blushPink, AppTheme.petalYellow],
                  ),
                  boxShadow: [
                    BoxShadow(color: AppTheme.blushPink.withValues(alpha: 0.4), blurRadius: 12),
                  ],
                ),
                child: Center(
                  child: Text('RS', style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.darkForest,
                  )),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, I\'m 👋',
                    style: GoogleFonts.poppins(
                      fontSize: 14, color: AppTheme.creamWhite.withValues(alpha: 0.75),
                    ),
                  ),
                  Text(
                    'Rengso Subba',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.creamWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          Text(
            'Building Digital\nExperiences that\nBloom ✿',
            style: GoogleFonts.playfairDisplay(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppTheme.creamWhite,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Full-Stack Developer & UI/UX Designer crafting\nbeautiful, performant apps with Flutter, React,\nand a touch of botanical magic.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppTheme.creamWhite.withValues(alpha: 0.78),
              height: 1.6,
            ),
          ),

          const SizedBox(height: 32),

          // CTA buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onExplore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blushPink,
                    foregroundColor: AppTheme.darkForest,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 6,
                  ),
                  child: Text('Explore My Journey',
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewWork,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.creamWhite,
                    side: const BorderSide(color: AppTheme.creamWhite, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('View My Work',
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700),
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

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('6+', 'Years Exp.'),
      ('40+', 'Projects'),
      ('15K+', 'Downloads'),
      ('99%', 'Satisfaction'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: stats.map((s) {
          final (value, label) = s;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.creamWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
              ),
              child: Column(
                children: [
                  Text(value, style: GoogleFonts.playfairDisplay(
                    fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.deepSage,
                  )),
                  const SizedBox(height: 2),
                  Text(label, style: GoogleFonts.poppins(
                    fontSize: 10, color: AppTheme.mutedGray, fontWeight: FontWeight.w500,
                  )),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Floating rose FAB ─────────────────────────────────────────────────────────

class _FloralFAB extends StatefulWidget {
  final VoidCallback onTap;
  const _FloralFAB({required this.onTap});

  @override
  State<_FloralFAB> createState() => _FloralFABState();
}

class _FloralFABState extends State<_FloralFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double>   _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) => Transform.scale(scale: _pulseAnim.value, child: child),
      child: FloatingActionButton(
        onPressed: widget.onTap,
        backgroundColor: AppTheme.dustyRose,
        elevation: 10,
        tooltip: 'Contact Me',
        child: const Icon(Icons.local_florist_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
