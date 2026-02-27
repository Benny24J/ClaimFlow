import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

class ClaimFlowColors {
  static const primary = Color(0xFF0E5936); // Forest Green
  static const secondary = Color(0xFF0D4051); // Teal Blue

  static const background = Color(0xFFF2F2F2);
  static const surface = Color(0xFFFFFFFF);

  static const textPrimary = Color(0xFF433D3A);
  static const warning = Color(0xFF505912);
  static const error = Color(0xFFD4183D);
}

final ThemeData claimFlowTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: ClaimFlowColors.background,

  colorScheme: const ColorScheme.light(
    primary: ClaimFlowColors.primary,
    secondary: ClaimFlowColors.secondary,
    error: ClaimFlowColors.error,
    //background: ClaimFlowColors.background,
    surface: ClaimFlowColors.surface,
    onPrimary: Colors.white,
    onSurface: ClaimFlowColors.textPrimary,
  ),

  // 🔹 Typography
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.sourceSans3(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),
    headlineMedium: GoogleFonts.sourceSans3(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),
    titleLarge: GoogleFonts.sourceSans3(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
    ),
  ),

  // 🔹 Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ClaimFlowColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ClaimFlowColors.primary,
      side: const BorderSide(color: ClaimFlowColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  // 🔹 Inputs
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ClaimFlowColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: ClaimFlowColors.primary,
        width: 1.5,
      ),
    ),
    errorStyle: GoogleFonts.inter(
      fontSize: 12,
      color: ClaimFlowColors.error,
    ),
  ),

    //Cards
 //cardTheme: CardTheme(
   // elevation: 2,
   // color: ClaimFlowColors.surface,
    //shape: RoundedRectangleBorder(
    // borderRadius: BorderRadius.circular(16),
  //  ),
 // ),
);