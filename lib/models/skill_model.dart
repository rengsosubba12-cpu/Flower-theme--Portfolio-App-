import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Skill category enum for grouping.
enum SkillCategory { frontend, backend, tooling, design }

/// Data model representing a technical skill.
class SkillModel {
  final String name;
  final double percentage; // 0.0 – 1.0
  final Color color;
  final IconData icon;
  final SkillCategory category;

  const SkillModel({
    required this.name,
    required this.percentage,
    required this.color,
    required this.icon,
    required this.category,
  });
}

/// Mock skill data array.
final List<SkillModel> mockSkills = [
  // ── Frontend / Mobile ──────────────────────────────────────────────────────
  const SkillModel(
    name: 'Flutter / Dart',
    percentage: 0.95,
    color: AppTheme.sageGreen,
    icon: Icons.phone_android_rounded,
    category: SkillCategory.frontend,
  ),
  const SkillModel(
    name: 'React / Next.js',
    percentage: 0.85,
    color: AppTheme.blushPink,
    icon: Icons.web_rounded,
    category: SkillCategory.frontend,
  ),
  const SkillModel(
    name: 'UI/UX Design',
    percentage: 0.80,
    color: AppTheme.lavender,
    icon: Icons.design_services_rounded,
    category: SkillCategory.design,
  ),
  const SkillModel(
    name: 'CSS / Animations',
    percentage: 0.88,
    color: AppTheme.petalYellow,
    icon: Icons.auto_fix_high_rounded,
    category: SkillCategory.frontend,
  ),
  // ── Backend ────────────────────────────────────────────────────────────────
  const SkillModel(
    name: 'Node.js / Express',
    percentage: 0.78,
    color: AppTheme.deepSage,
    icon: Icons.dns_rounded,
    category: SkillCategory.backend,
  ),
  const SkillModel(
    name: 'Firebase / Supabase',
    percentage: 0.82,
    color: AppTheme.terracotta,
    icon: Icons.cloud_rounded,
    category: SkillCategory.backend,
  ),
  const SkillModel(
    name: 'Python / FastAPI',
    percentage: 0.70,
    color: AppTheme.dustyRose,
    icon: Icons.terminal_rounded,
    category: SkillCategory.backend,
  ),
  const SkillModel(
    name: 'PostgreSQL / MongoDB',
    percentage: 0.72,
    color: AppTheme.mutedGray,
    icon: Icons.storage_rounded,
    category: SkillCategory.backend,
  ),
  // ── Tooling ────────────────────────────────────────────────────────────────
  const SkillModel(
    name: 'Git / GitHub Actions',
    percentage: 0.90,
    color: AppTheme.darkForest,
    icon: Icons.code_rounded,
    category: SkillCategory.tooling,
  ),
  const SkillModel(
    name: 'Figma / Adobe XD',
    percentage: 0.83,
    color: AppTheme.lavender,
    icon: Icons.brush_rounded,
    category: SkillCategory.design,
  ),
];
