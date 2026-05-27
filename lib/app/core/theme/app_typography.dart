import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Hero heading - large, bold
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.1,
        color: _textPrimary(context),
      );

  // Section heading
  static TextStyle displayMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.2,
        color: _textPrimary(context),
      );

  // Sub-section heading
  static TextStyle displaySmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.25,
        color: _textPrimary(context),
      );

  // Card/project title
  static TextStyle headlineLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.3,
        color: _textPrimary(context),
      );

  static TextStyle headlineMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.3,
        color: _textPrimary(context),
      );

  static TextStyle headlineSmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.35,
        color: _textPrimary(context),
      );

  // Title styles
  static TextStyle titleLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: _textPrimary(context),
      );

  static TextStyle titleMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
        color: _textPrimary(context),
      );

  static TextStyle titleSmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.45,
        color: _textPrimary(context),
      );

  // Body text - bigger for readability
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.65,
        color: _textSecondary(context),
      );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.6,
        color: _textSecondary(context),
      );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
        color: _textSecondary(context),
      );

  // Labels
  static TextStyle labelLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.45,
        color: _textSecondary(context),
      );

  static TextStyle labelMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.35,
        color: _textSecondary(context),
      );

  static TextStyle labelSmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
        color: _textTertiary(context),
      );

  // Mono style for tech tags / code
  static TextStyle mono(BuildContext context) => GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.4,
        color: _textSecondary(context),
      );

  static TextStyle monoSmall(BuildContext context) => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.35,
        color: _textTertiary(context),
      );

  // Helpers
  static Color _textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? AppColors.textPrimaryLight
          : AppColors.textPrimaryDark;

  static Color _textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? AppColors.textSecondaryLight
          : AppColors.textSecondaryDark;

  static Color _textTertiary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? AppColors.textTertiaryLight
          : AppColors.textTertiaryDark;
}
