import 'package:flutter/material.dart';
import '../constants/content.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class MinimalHeader extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const MinimalHeader({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: Row(
        children: [
          Text(
            AppContent.name,
            style: AppTypography.titleLarge(context).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // Theme toggle
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onThemeToggle,
              child: Icon(
                isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                size: 20,
                color: isDarkMode
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
