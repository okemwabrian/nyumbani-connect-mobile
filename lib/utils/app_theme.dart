import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryTeal = Color(0xFF327A7D);
  static const Color secondarySage = Color(0xFF80A486);
  static const Color tertiaryOlive = Color(0xFFC2D19D);
  static const Color bgSurface = Color(0xFFE7EFD0);
  static const Color textDark = Color(0xFF1A3D3E);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgSurface,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textDark),
        headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppColors.textDark),
        bodyLarge: GoogleFonts.outfit(color: AppColors.textDark),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        primary: AppColors.primaryTeal,
        secondary: AppColors.secondarySage,
        tertiary: AppColors.tertiaryOlive,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.tertiaryOlive, width: 1),
        ),
      ),
    );
  }
}
