import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'responsive_layout.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool showTitle;

  const SectionContainer({
    super.key,
    required this.title,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sectionSpacing,
          ),
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(
            title,
            style: AppTypography.headlineMedium(context),
          ),
          SizedBox(height: AppSpacing.v24),
        ],
        child,
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            Text(
              title,
              style: AppTypography.headlineLarge(context),
            ),
            SizedBox(height: AppSpacing.v32),
          ],
          child,
        ],
      ),
    );
  }
} 