import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Categories for project filtering.
enum ProjectCategory { mobile, web, openSource, productivity }

/// Data model representing a portfolio project.
class ProjectModel {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final List<String> techTags;
  final Color accentColor;
  final IconData icon;
  final String mockUrl;
  final ProjectCategory category;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.techTags,
    required this.accentColor,
    required this.icon,
    required this.mockUrl,
    required this.category,
  });
}

/// Mock project data array containing specific items for each category.
final List<ProjectModel> mockProjects = [
  const ProjectModel(
    id: 'p1',
    title: 'FloraPlanter',
    shortDescription: 'A Flutter-based plant watering tracker app using Firebase.',
    fullDescription:
        'FloraPlanter is a comprehensive plant care companion mobile application. '
        'It helps plant enthusiasts keep track of watering schedules, sun exposure, and potting history. '
        'Leveraging Firebase Cloud Firestore, it provides real-time multi-device sync, offline capabilities, '
        'and push notifications when plants need watering. Features include image-based plant health tracking, '
        'watering log histories, and botanical tips tailored to each plant species.',
    techTags: ['Flutter', 'Dart', 'Firebase', 'Firestore', 'Cloud Messaging'],
    accentColor: AppTheme.sageGreen,
    icon: Icons.local_activity_rounded,
    mockUrl: 'https://github.com/rengsosubba12-cpu/floraplanter',
    category: ProjectCategory.mobile,
  ),
  const ProjectModel(
    id: 'p2',
    title: 'Botanical Bazaar',
    shortDescription: 'A responsive e-commerce web dashboard for rare local flora.',
    fullDescription:
        'Botanical Bazaar is a premium web application built for local plant nurseries and buyers of rare species. '
        'The responsive dashboard allows vendors to list rare flora, track orders, manage stock, and view '
        'weekly sales analytics. The user-facing storefront utilizes smooth scroll animations, robust searching, '
        'and a secure checkout flow. It serves as a unified digital ecosystem connecting rare plant collectors.',
    techTags: ['React', 'Next.js', 'TailwindCSS', 'Node.js', 'PostgreSQL'],
    accentColor: AppTheme.terracotta,
    icon: Icons.dashboard_rounded,
    mockUrl: 'https://bazaar.example.com',
    category: ProjectCategory.web,
  ),
  const ProjectModel(
    id: 'p3',
    title: 'PetalUI Package',
    shortDescription: 'An open-source Dart package for organic, fluid-shaped UI components.',
    fullDescription:
        'PetalUI is an open-source Flutter package that provides a rich library of customizable, organically shaped '
        'components such as blooming menus, leaf-like cards, and wavy progress bars. Built with CustomPainters '
        'and lightweight physics-based animation controllers, this package enables developers to integrate a natural, '
        'botanical look and feel into any Flutter app without sacrificing performance.',
    techTags: ['Dart', 'Flutter Package', 'Custom Paint', 'Open Source', 'GitHub Actions'],
    accentColor: AppTheme.lavender,
    icon: Icons.inventory_2_rounded,
    mockUrl: 'https://pub.dev/packages/petal_ui',
    category: ProjectCategory.openSource,
  ),
  const ProjectModel(
    id: 'p4',
    title: 'BloomFocus',
    shortDescription: 'A pomodoro timer app styled with animated blooming growth visuals.',
    fullDescription:
        'BloomFocus is a productivity application that gamifies focus time. Based on the Pomodoro technique, '
        'users set a focus interval during which a digital flower seed begins to grow and bloom. If the session is '
        'interrupted, the bloom pauses. Successfully finished sessions earn the user rare seeds to add to their virtual '
        'botanical garden. Features include session history charts, ambient soundscapes, and customizable focus tasks.',
    techTags: ['Flutter', 'Riverpod', 'Hive', 'Audio Players', 'Custom Painter'],
    accentColor: AppTheme.blushPink,
    icon: Icons.timer_rounded,
    category: ProjectCategory.productivity,
    mockUrl: 'https://bloomfocus.example.com',
  ),
];
