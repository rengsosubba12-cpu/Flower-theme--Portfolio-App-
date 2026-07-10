import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Prefer immersive full-screen portrait experience.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Use a transparent system overlay so the hero gradients bleed edge-to-edge.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PersonalPortfolioApp());
}

/// Root application widget.
class PersonalPortfolioApp extends StatelessWidget {
  const PersonalPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rengso Subba — Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,

      // The app begins with the animated splash screen.
      home: const SplashScreen(),

      // Global scroll behaviour: softer overscroll glow.
      scrollBehavior: const _SmoothScrollBehavior(),
    );
  }
}

/// Custom scroll behaviour that removes the default stretch/glow overscroll
/// indicator in favour of the platform-default, giving a cleaner look.
class _SmoothScrollBehavior extends ScrollBehavior {
  const _SmoothScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // No overscroll indicator
  }
}
