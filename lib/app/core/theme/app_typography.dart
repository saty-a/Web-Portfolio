import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 57.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle displayMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 45.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.15,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle displaySmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 36.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle headlineLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 32.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle headlineMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 28.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.28,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle headlineSmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 24.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle titleLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle titleMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle titleSmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.42,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle labelLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.42,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark,
      );

  static TextStyle labelMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark,
      );

  static TextStyle labelSmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark,
      );

  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.42,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark,
      );
} 