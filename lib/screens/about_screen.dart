import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/floral_background.dart';
import '../widgets/custom_page_route.dart';
import 'skills_screen.dart';

/// The About Me screen with personal bio, experience timeline, and a link
/// to the Skills screen.
///
/// Navigation flows:
/// - "View My Skillset" text link → Skills Screen
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _navigateToSkills() {
    Navigator.of(context).push(FloralPageRoute(page: const SkillsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FloralBackground(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            slivers: [
              // ── App Bar ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _AboutHeader(topPad: topPad),
              ),

              // ── Bio Section ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: _BioSection(),
                ),
              ),

              // ── Journey Timeline ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: _JourneyTimeline(),
                ),
              ),

              // ── Values Section ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: _ValuesSection(),
                ),
              ),

              // ── "View My Skillset" link ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 100),
                  child: Center(
                    child: _SkillsetLink(onTap: _navigateToSkills),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _AboutHeader extends StatelessWidget {
  final double topPad;
  const _AboutHeader({required this.topPad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.darkForest, AppTheme.deepSage],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.creamWhite, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              Text(
                'About Me',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.creamWhite,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 24),
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.blushPink, AppTheme.petalYellow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: AppTheme.blushPink.withValues(alpha: 0.5), blurRadius: 20),
              ],
            ),
            child: Center(
              child: Text('RS', style: GoogleFonts.poppins(
                fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.darkForest,
              )),
            ),
          ),
          const SizedBox(height: 14),
          Text('Rengso Subba', style: GoogleFonts.playfairDisplay(
            fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.creamWhite,
          )),
          const SizedBox(height: 4),
          Text('Full-Stack Developer & UI/UX Designer', style: GoogleFonts.poppins(
            fontSize: 13, color: AppTheme.creamWhite.withValues(alpha: 0.75),
          )),
          const SizedBox(height: 16),
          // Social badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Badge(label: '📍 Bangalore, India'),
              const SizedBox(width: 10),
              _Badge(label: '💼 Open to Work'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(label, style: GoogleFonts.poppins(
        fontSize: 11, color: AppTheme.creamWhite, fontWeight: FontWeight.w500,
      )),
    );
  }
}

// ── Bio ───────────────────────────────────────────────────────────────────────

class _BioSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Story', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 14),
        _BioCard(
          content:
              'I\'m a passionate full-stack developer with 6+ years of experience building beautiful, '
              'performant applications. My journey started with a deep love for visual design before '
              'discovering the power of code to bring ideas to life.\n\n'
              'I specialise in Flutter for mobile development and React/Next.js for the web, '
              'always focusing on creating interfaces that feel intuitive, accessible, and a little bit magical. '
              'When I\'m not coding, you\'ll find me tending to my actual garden or exploring '
              'the intersection of nature and digital art.',
        ),
      ],
    );
  }
}

class _BioCard extends StatelessWidget {
  final String content;
  const _BioCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.creamWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: AppTheme.sageGreen.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Text(content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14)),
    );
  }
}

// ── Timeline ──────────────────────────────────────────────────────────────────

class _JourneyTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final milestones = [
      ('2019', 'Computer Science Degree', 'Jalpaiguri Govt. Engineering College', AppTheme.lavender),
      ('2020', 'Junior Developer', 'StartupXYZ — first Flutter app shipped', AppTheme.sageGreen),
      ('2021', 'UI/UX Certification', 'Google UX Design Professional Certificate', AppTheme.blushPink),
      ('2022', 'Mid-Level Engineer', 'TechCorp — Led mobile team of 5', AppTheme.petalYellow),
      ('2024', 'Senior Developer', 'Freelance — 40+ projects worldwide', AppTheme.terracotta),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Journey', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 20),
        ...milestones.asMap().entries.map((e) {
          final idx = e.key;
          final (year, title, subtitle, color) = e.value;
          final isLast = idx == milestones.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline rail
                Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 2),
                      ),
                      child: Center(
                        child: Text(year.substring(2), style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w800, color: color,
                          fontFamily: 'Poppins',
                        )),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: color.withValues(alpha: 0.2),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(year, style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: color, fontFamily: 'Poppins',
                        )),
                        const SizedBox(height: 2),
                        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ── Values ────────────────────────────────────────────────────────────────────

class _ValuesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final values = [
      (Icons.spa_rounded,          'Thoughtful Design',    AppTheme.sageGreen),
      (Icons.bolt_rounded,         'Performance First',    AppTheme.petalYellow),
      (Icons.accessibility_rounded,'Accessibility',         AppTheme.lavender),
      (Icons.diversity_3_rounded,  'Collaboration',         AppTheme.blushPink),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Values', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: values.map((v) {
            final (icon, label, color) = v;
            return Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Flexible(child: Text(label, style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: AppTheme.darkForest, fontFamily: 'Poppins',
                  ))),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Skillset link ─────────────────────────────────────────────────────────────

class _SkillsetLink extends StatefulWidget {
  final VoidCallback onTap;
  const _SkillsetLink({required this.onTap});

  @override
  State<_SkillsetLink> createState() => _SkillsetLinkState();
}

class _SkillsetLinkState extends State<_SkillsetLink>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _arrowAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _arrowAnim = Tween<Offset>(begin: Offset.zero, end: const Offset(0.3, 0))
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.sageGreen, AppTheme.deepSage],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: AppTheme.sageGreen.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_florist_rounded, color: AppTheme.creamWhite, size: 20),
            const SizedBox(width: 10),
            Text(
              'View My Skillset',
              style: GoogleFonts.poppins(
                fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.creamWhite,
              ),
            ),
            const SizedBox(width: 10),
            SlideTransition(
              position: _arrowAnim,
              child: const Icon(Icons.arrow_forward_rounded, color: AppTheme.creamWhite, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
