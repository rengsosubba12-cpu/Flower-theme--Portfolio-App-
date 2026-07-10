import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/skill_model.dart';
import '../theme/app_theme.dart';
import '../widgets/floral_background.dart';
import '../widgets/skill_progress_bar.dart';

/// The Skills screen displaying technical proficiencies as animated vine/flower
/// progress bars, organised by category.
///
/// Animation flows:
/// - On screen load, all vine progress bars animate from 0% to their target.
class SkillsScreen extends StatefulWidget {
  final bool isActive;

  const SkillsScreen({super.key, this.isActive = true});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    // Group skills by category
    final grouped = <SkillCategory, List<SkillModel>>{};
    for (final skill in mockSkills) {
      grouped.putIfAbsent(skill.category, () => []).add(skill);
    }

    final categoryOrder = [
      SkillCategory.frontend,
      SkillCategory.backend,
      SkillCategory.design,
      SkillCategory.tooling,
    ];
    final categoryLabels = {
      SkillCategory.frontend: ('📱  Frontend & Mobile', AppTheme.sageGreen),
      SkillCategory.backend:  ('⚙️  Backend & Cloud',    AppTheme.terracotta),
      SkillCategory.design:   ('🎨  Design & Creative',  AppTheme.lavender),
      SkillCategory.tooling:  ('🛠  Tooling & DevOps',   AppTheme.deepSage),
    };

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FloralBackground(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            slivers: [
              // ── Header ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _SkillsHeader(topPad: topPad),
              ),

              // ── Introduction card ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.sageGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.eco_rounded, color: AppTheme.sageGreen, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Skills grow like a garden — with time, care, and continuous learning. '
                            'Watch the vines bloom as my proficiencies are revealed.',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: AppTheme.darkForest.withValues(alpha: 0.8),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Skills by category ─────────────────────────────────────
              for (final cat in categoryOrder)
                if (grouped.containsKey(cat))
                  ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                        child: _CategoryHeader(
                          label: categoryLabels[cat]!.$1,
                          color: categoryLabels[cat]!.$2,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.creamWhite,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
                            ],
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: grouped[cat]!.asMap().entries.map((e) {
                              return SkillProgressBar(
                                skill: e.value,
                                delay: Duration(milliseconds: 200 + e.key * 120),
                                shouldAnimate: widget.isActive,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],

              // ── Tools grid ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: _ToolsGrid(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _SkillsHeader extends StatelessWidget {
  final double topPad;
  const _SkillsHeader({required this.topPad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 32),
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
              Text('My Skills', style: GoogleFonts.playfairDisplay(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.creamWhite,
              )),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Cultivated Over Years',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.creamWhite, height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Every skill is a seed planted with curiosity\nand grown through dedicated practice.',
            style: GoogleFonts.poppins(
              fontSize: 13, color: AppTheme.creamWhite.withValues(alpha: 0.75), height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Category header ───────────────────────────────────────────────────────────

class _CategoryHeader extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryHeader({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(label, style: GoogleFonts.poppins(
          fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.darkForest,
        )),
      ],
    );
  }
}

// ── Tools Grid ────────────────────────────────────────────────────────────────

class _ToolsGrid extends StatelessWidget {
  final _tools = const [
    ('Flutter', '🐦'), ('Dart', '🎯'), ('React', '⚛️'),  ('Next.js', '▲'),
    ('Firebase', '🔥'), ('Git', '🌿'), ('Figma', '🖌️'), ('Python', '🐍'),
    ('Node.js', '🟢'), ('TypeScript', '🔷'), ('GraphQL', '🔶'), ('Docker', '🐳'),
  ];

  const _ToolsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tools & Technologies', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: _tools.length,
          itemBuilder: (_, i) {
            final (name, emoji) = _tools[i];
            return Container(
              decoration: BoxDecoration(
                color: AppTheme.creamWhite,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3))],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(name, style: GoogleFonts.poppins(
                    fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.darkForest,
                  ), textAlign: TextAlign.center),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
