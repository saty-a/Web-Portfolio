import 'package:flutter/material.dart';
import '../constants/content.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'featured_work_card.dart';
import 'responsive_layout.dart';
import 'scroll_fade_in.dart';

class FeaturedWorkSection extends StatelessWidget {
  const FeaturedWorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const projects = AppContent.featuredProjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section divider
        Divider(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          height: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.screenPaddingMobile : 40,
            vertical: isMobile ? AppSpacing.sectionSpacingMobile : AppSpacing.sectionSpacing,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScrollFadeIn(
                    child: Text(
                      'Featured Work',
                      style: AppTypography.displayMedium(context),
                    ),
                  ),
                  SizedBox(height: isMobile ? 48 : 80),
                  ...List.generate(projects.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < projects.length - 1
                            ? (isMobile ? 64 : 100)
                            : 0,
                      ),
                      child: ScrollFadeIn(
                        staggerIndex: index + 1,
                        child: FeaturedWorkCard(project: projects[index]),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
