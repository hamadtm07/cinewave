import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Color primary = Color(0xFFD4AF37);
  static const Color primaryLight = Color(0xFFF3D279);
  static const Color secondary = Color(0xFFFFB703);
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkCard = Color(0xFF141A26);
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color systemMatch = Color(0xFF10B981);
  static const Color translucentButton = Color(0x26FFFFFF);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: secondary,
      surface: darkCard,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarThemeData(
      centerTitle: true,
      backgroundColor: darkBackground,
      foregroundColor: textPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: primary),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      color: darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x2AD4AF37), width: 1),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarThemeData(
      centerTitle: true,
      backgroundColor: primary,
      foregroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: GoogleFonts.outfitTextTheme(),
  );
}
