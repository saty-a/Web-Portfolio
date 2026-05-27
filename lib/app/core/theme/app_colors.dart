import 'package:flutter/material.dart';

class AppColors {
  // Primary Accent - green like reference
  static const Color accent = Color(0xFF4ADE80);
  static const Color accentMuted = Color(0xFF22C55E);

  // Primary aliases (hover / active states)
  static const Color primaryDark = Color(0xFF4ADE80);   // accent on dark bg
  static const Color primaryLight = Color(0xFF16A34A);  // darker green on light bg

  // Semantic extras
  static const Color accentSubtle = Color(0x1A4ADE80);  // 10% alpha — chip hover bg
  static const Color openToWorkBg = Color(0x1A4ADE80);  // badge background
  static const Color openToWorkText = Color(0xFF4ADE80); // badge text

  // Dark theme (default)
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF141414);
  static const Color cardDark = Color(0xFF1A1A1A);
  static const Color cardHoverDark = Color(0xFF222222);
  static const Color borderDark = Color(0xFF2A2A2A);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);

  // Light theme
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFF3F4F6);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardHoverLight = Color(0xFFF9FAFB);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);

  // Timeline
  static const Color timelineActive = Color(0xFF4ADE80);
  static const Color timelineInactive = Color(0xFF374151);
}
