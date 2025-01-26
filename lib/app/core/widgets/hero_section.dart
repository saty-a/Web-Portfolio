import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'responsive_layout.dart';

class HeroSection extends StatelessWidget {
  final String name;
  final String title;
  final String description;
  final VoidCallback onContactPressed;
  final VoidCallback onResumePressed;

  const HeroSection({
    super.key,
    required this.name,
    required this.title,
    required this.description,
    required this.onContactPressed,
    required this.onResumePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.light
              ? AppColors.surfaceGradientLight
              : AppColors.surfaceGradientDark,
        ),
      ),
      child: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.pageSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, I\'m $name 👋',
            style: AppTypography.displaySmall(context),
          ),
          SizedBox(height: AppSpacing.v16),
          Text(
            title,
            style: AppTypography.headlineMedium(context).copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: AppSpacing.v24),
          Text(
            description,
            style: AppTypography.bodyLarge(context),
          ),
          SizedBox(height: AppSpacing.v32),
          Row(
            children: [
              ElevatedButton(
                onPressed: onContactPressed,
                child: const Text('Contact Me'),
              ),
              SizedBox(width: AppSpacing.h16),
              OutlinedButton(
                onPressed: onResumePressed,
                child: const Text('View Resume'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.pageSpacing,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, I\'m $name 👋',
                  style: AppTypography.displayLarge(context),
                ),
                SizedBox(height: AppSpacing.v16),
                Text(
                  title,
                  style: AppTypography.headlineLarge(context).copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: AppSpacing.v24),
                Text(
                  description,
                  style: AppTypography.bodyLarge(context),
                ),
                SizedBox(height: AppSpacing.v32),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: onContactPressed,
                      child: const Text('Contact Me'),
                    ),
                    SizedBox(width: AppSpacing.h16),
                    OutlinedButton(
                      onPressed: onResumePressed,
                      child: const Text('View Resume'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.h48),
          Expanded(
            child: Container(
              height: 400.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.r32),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 200.r,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 