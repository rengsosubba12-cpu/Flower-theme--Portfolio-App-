import 'package:flutter/material.dart';

/// A custom [PageRoute] that combines a fade and a slide-up transition
/// to preserve the floating floral aesthetic across screen navigation.
class FloralPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FloralPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Slide from slightly below (y = 0.06 → 0)
            final slideTween = Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

            // Fade in (0.0 → 1.0)
            final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

            return FadeTransition(
              opacity: fadeTween,
              child: SlideTransition(position: slideTween, child: child),
            );
          },
        );
}
