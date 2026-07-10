import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../theme/app_theme.dart';

/// A visually rich card for displaying a portfolio project in a grid.
///
/// Tapping the card triggers [onTap] which should open the project detail
/// bottom sheet.
class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: 0.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.03)
        .animate(CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proj = widget.project;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (_, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) => _hoverCtrl.forward(),
        onTapUp: (_) {
          _hoverCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _hoverCtrl.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.creamWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: proj.accentColor.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: proj.accentColor.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Coloured header band ────────────────────────────────────
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: proj.accentColor.withValues(alpha: 0.15),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: proj.accentColor.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(proj.icon, color: proj.accentColor, size: 26),
                  ),
                ),
              ),

              // ── Content ─────────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proj.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppTheme.darkForest,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          proj.shortDescription,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11.5,
                            height: 1.5,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tech tags
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: proj.techTags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: proj.accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: proj.accentColor.withValues(alpha: 0.9),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
