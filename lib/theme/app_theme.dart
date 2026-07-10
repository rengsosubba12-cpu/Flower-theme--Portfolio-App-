import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central app theme configuration with a soft botanical / floral palette.
class AppTheme {
  AppTheme._();

  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color sageGreen     = Color(0xFF7DAA92);
  static const Color deepSage      = Color(0xFF4E7A63);
  static const Color creamWhite    = Color(0xFFF9F5EE);
  static const Color warmCream     = Color(0xFFF2EAD3);
  static const Color blushPink     = Color(0xFFF0B8C0);
  static const Color dustyRose     = Color(0xFFD97B8A);
  static const Color petalYellow   = Color(0xFFF6D78C);
  static const Color lavender      = Color(0xFFB8A9D9);
  static const Color terracotta    = Color(0xFFD4856A);
  static const Color darkForest    = Color(0xFF2C3E35);
  static const Color mutedGray     = Color(0xFF8A9A90);

  // ── Nav Bar ───────────────────────────────────────────────────────────────
  static const Color navBackground = Color(0xFFF0EBE0);
  static const Color navActive     = Color(0xFF4E7A63);
  static const Color navInactive   = Color(0xFFA8C4B0);

  // ── Gradient backgrounds ──────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF9F5EE), Color(0xFFE8F0EC), Color(0xFFF5ECE8)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C3E35), Color(0xFF4E7A63)],
  );

  // ── Typography ────────────────────────────────────────────────────────────
  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 36, fontWeight: FontWeight.w700, color: darkForest, height: 1.2,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 28, fontWeight: FontWeight.w600, color: darkForest, height: 1.3,
    ),
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 24, fontWeight: FontWeight.w600, color: darkForest,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20, fontWeight: FontWeight.w600, color: darkForest,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w600, color: darkForest,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 16, fontWeight: FontWeight.w500, color: darkForest,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 15, fontWeight: FontWeight.w400, color: darkForest, height: 1.6,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w400, color: mutedGray, height: 1.6,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w600, color: creamWhite, letterSpacing: 0.5,
    ),
  );

  // ── ThemeData ─────────────────────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: sageGreen,
      secondary: dustyRose,
      tertiary: lavender,
      surface: creamWhite,
      onPrimary: creamWhite,
      onSecondary: creamWhite,
      onSurface: darkForest,
    ),
    textTheme: textTheme,
    scaffoldBackgroundColor: creamWhite,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 22, fontWeight: FontWeight.w700, color: darkForest,
      ),
      iconTheme: const IconThemeData(color: darkForest),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: deepSage,
        foregroundColor: creamWhite,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        elevation: 4,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: deepSage,
        side: const BorderSide(color: deepSage, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardThemeData(
      color: creamWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: darkForest,
      contentTextStyle: GoogleFonts.poppins(color: creamWhite, fontSize: 13),
    ),
  );
}
