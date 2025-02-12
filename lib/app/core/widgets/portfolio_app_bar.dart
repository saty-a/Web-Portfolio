import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'responsive_layout.dart';

class PortfolioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  final VoidCallback onProjectsPressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onContactPressed;

  const PortfolioAppBar({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.onProjectsPressed,
    required this.onAboutPressed,
    required this.onContactPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return AppBar(
      title: Text(
        'Portfolio',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (isDesktop) ...[
          TextButton(
            onPressed: onAboutPressed,
            child: const Text('About'),
          ),
          SizedBox(width: AppSpacing.h16),
          TextButton(
            onPressed: onProjectsPressed,
            child: const Text('Projects'),
          ),
          SizedBox(width: AppSpacing.h16),
          TextButton(
            onPressed: onContactPressed,
            child: const Text('Contact'),
          ),
          SizedBox(width: AppSpacing.h16),
        ],
        IconButton(
          onPressed: onThemeToggle,
          icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
        ),
        if (!isDesktop) ...[
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ],
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const _NavItem({
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.r8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h16,
          vertical: AppSpacing.v8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.r8),
        ),
        child: Text(
          title,
          style: AppTypography.titleSmall(context).copyWith(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
} 