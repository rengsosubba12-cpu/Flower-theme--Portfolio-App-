import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/floral_nav_bar.dart';
import '../widgets/floral_background.dart';
import 'home_screen.dart';
import 'about_screen.dart';
import 'skills_screen.dart';
import 'projects_screen.dart';
import 'contact_screen.dart';

/// The root shell widget that owns the persistent [FloralNavBar] and
/// hosts all five primary screens via an [IndexedStack].
///
/// The shell is entered after the animated splash screen fades away.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const AboutScreen(),
      SkillsScreen(isActive: _currentIndex == 2),
      const ProjectsScreen(),
      const ContactScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: FloralNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// ── Splash Screen ─────────────────────────────────────────────────────────────

/// A full-screen animated splash/intro shown on first launch before entering
/// the [MainShell].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoCtrl;
  late final AnimationController _fadeOutCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeOutCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn);
    _fadeOut  = CurvedAnimation(parent: _fadeOutCtrl, curve: Curves.easeOut);

    _runSplashSequence();
  }

  Future<void> _runSplashSequence() async {
    await _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 900));
    await _fadeOutCtrl.forward();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const MainShell(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _fadeOutCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloralBackground(
      backgroundColor: AppTheme.darkForest,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_fadeOut),
        child: Center(
          child: FadeTransition(
            opacity: _logoFade,
            child: ScaleTransition(
              scale: _logoScale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo flower icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [AppTheme.blushPink, AppTheme.dustyRose],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.blushPink.withValues(alpha: 0.5),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_florist_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Rengso Subba',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.creamWhite,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Portfolio ✿',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppTheme.creamWhite.withValues(alpha: 0.65),
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
