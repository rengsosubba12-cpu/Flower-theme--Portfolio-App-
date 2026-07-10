import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_model.dart';
import '../theme/app_theme.dart';
import '../widgets/floral_background.dart';
import '../widgets/project_card.dart';

/// The Projects screen showcasing portfolio projects in a 2-column grid.
///
/// Navigation flows:
/// - Tapping any project card → opens a modal bottom sheet with full details
///   and a mock "Launch Project" button.
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _openProjectDetail(ProjectModel project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProjectDetailSheet(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    // Filter projects based on selected index
    final filteredProjects = _selectedCategoryIndex == 0
        ? mockProjects
        : mockProjects.where((p) {
            switch (_selectedCategoryIndex) {
              case 1:
                return p.category == ProjectCategory.mobile;
              case 2:
                return p.category == ProjectCategory.web;
              case 3:
                return p.category == ProjectCategory.openSource;
              case 4:
                return p.category == ProjectCategory.productivity;
              default:
                return true;
            }
          }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FloralBackground(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            slivers: [
              // ── Header ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _ProjectsHeader(
                  topPad: topPad,
                  projectCount: filteredProjects.length,
                ),
              ),

              // ── Filter row (functional) ─────────────────────────────────
              SliverToBoxAdapter(
                child: _FilterRow(
                  selectedIndex: _selectedCategoryIndex,
                  onSelected: (idx) {
                    setState(() {
                      _selectedCategoryIndex = idx;
                    });
                  },
                ),
              ),

              // ── Projects Grid ──────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                sliver: filteredProjects.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Text(
                              'No projects in this category.',
                              style: TextStyle(
                                color: AppTheme.mutedGray,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SliverGrid.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: filteredProjects.length,
                        itemBuilder: (_, i) {
                          final project = filteredProjects[i];
                          return ProjectCard(
                            project: project,
                            onTap: () => _openProjectDetail(project),
                          );
                        },
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

class _ProjectsHeader extends StatelessWidget {
  final double topPad;
  final int projectCount;

  const _ProjectsHeader({
    required this.topPad,
    required this.projectCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 28),
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
              Text('My Work', style: GoogleFonts.playfairDisplay(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.creamWhite,
              )),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Projects in Full\nBloom 🌸',
            style: GoogleFonts.playfairDisplay(
              fontSize: 30, fontWeight: FontWeight.w800, color: AppTheme.creamWhite, height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap any card to explore the full story.',
            style: GoogleFonts.poppins(
              fontSize: 13, color: AppTheme.creamWhite.withValues(alpha: 0.75),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Text(
              '$projectCount Project${projectCount == 1 ? "" : "s"}',
              style: GoogleFonts.poppins(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.creamWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter Row (functional category chips) ────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _FilterRow({
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _filters = ['All', 'Mobile', 'Web', 'Open Source', 'Productivity'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        itemCount: _filters.length,
        itemBuilder: (_, i) {
          final isSelected = selectedIndex == i;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.deepSage : AppTheme.creamWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.deepSage : AppTheme.sageGreen.withValues(alpha: 0.3),
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: AppTheme.sageGreen.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))]
                    : [],
              ),
              child: Text(
                _filters[i],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppTheme.creamWhite : AppTheme.darkForest,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Project Detail Bottom Sheet ───────────────────────────────────────────────

class _ProjectDetailSheet extends StatelessWidget {
  final ProjectModel project;
  const _ProjectDetailSheet({required this.project});

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.sizeOf(context).height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: const BoxDecoration(
        color: AppTheme.creamWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppTheme.mutedGray.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon header
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: project.accentColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(project.icon, color: project.accentColor, size: 34),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Center(
                    child: Text(project.title, style: GoogleFonts.playfairDisplay(
                      fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.darkForest,
                    ), textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 8),

                  // Short description
                  Center(
                    child: Text(project.shortDescription, style: GoogleFonts.poppins(
                      fontSize: 13, color: AppTheme.mutedGray, height: 1.5,
                    ), textAlign: TextAlign.center),
                  ),

                  const SizedBox(height: 20),

                  // Divider with label
                  Row(children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Full Story', style: GoogleFonts.poppins(
                        fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.mutedGray,
                      )),
                    ),
                    const Expanded(child: Divider()),
                  ]),

                  const SizedBox(height: 16),

                  // Full description
                  Text(project.fullDescription, style: GoogleFonts.poppins(
                    fontSize: 13.5, color: AppTheme.darkForest.withValues(alpha: 0.85), height: 1.7,
                  )),

                  const SizedBox(height: 24),

                  // Tech tags
                  Text('Tech Stack', style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.darkForest,
                  )),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.techTags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: project.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: project.accentColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(tag, style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: project.accentColor, fontFamily: 'Poppins',
                      )),
                    )).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Launch button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🚀 Launching ${project.title}...'),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              textColor: AppTheme.petalYellow,
                              onPressed: () {},
                            ),
                          ),
                        );
                        debugPrint('🚀 Launching project: ${project.title} → ${project.mockUrl}');
                      },
                      icon: const Icon(Icons.rocket_launch_rounded),
                      label: const Text('Launch Project'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: project.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close', style: GoogleFonts.poppins(
                        color: AppTheme.mutedGray, fontSize: 14,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
