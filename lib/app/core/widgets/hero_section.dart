import 'package:flutter/material.dart';
import '../constants/content.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'responsive_layout.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimations = List.generate(4, (i) {
      final start = i * 0.2;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _slideAnimations = List.generate(4, (i) {
      final start = i * 0.2;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 16),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animated(int index, Widget child) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Transform.translate(
        offset: _slideAnimations[index].value,
        child: Opacity(opacity: _fadeAnimations[index].value, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(
        left: isMobile ? AppSpacing.screenPaddingMobile : 40,
        right: isMobile ? AppSpacing.screenPaddingMobile : 40,
        top: isMobile ? 40 : 80,
        bottom: isMobile ? AppSpacing.sectionSpacingMobile : AppSpacing.sectionSpacing,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              _animated(
                0,
                Text(
                  AppContent.heroGreeting,
                  style: isMobile
                      ? AppTypography.displaySmall(context)
                      : AppTypography.displayLarge(context),
                ),
              ),
              SizedBox(height: isMobile ? 20 : 32),
              // Bio paragraph
              _animated(
                1,
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Text(
                    AppContent.heroBio,
                    style: AppTypography.bodyLarge(context),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 32 : 48),
              // Impact stats
              _animated(
                2,
                _buildStats(context, isMobile),
              ),
              SizedBox(height: isMobile ? 32 : 48),
              // Key details as simple label-value list
              _animated(
                3,
                _buildDetails(context, isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context, bool isMobile) {
    return Wrap(
      spacing: isMobile ? 32 : 56,
      runSpacing: 20,
      children: AppContent.heroStats.map((stat) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.key,
            style: (isMobile
                ? AppTypography.displaySmall(context)
                : AppTypography.displayMedium(context)
            ).copyWith(color: AppColors.accent, fontWeight: FontWeight.w700),
          ),
          Text(stat.value, style: AppTypography.bodySmall(context)),
        ],
      )).toList(),
    );
  }

  Widget _buildDetails(BuildContext context, bool isMobile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AppContent.heroDetails.map((d) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _detailRow(context, d.key, d.value, isDark),
        )).toList(),
      );
    }

    // Desktop: 2-column grid
    return Wrap(
      spacing: 80,
      runSpacing: 20,
      children: AppContent.heroDetails.map((d) => SizedBox(
        width: 240,
        child: _detailRow(context, d.key, d.value, isDark),
      )).toList(),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodyMedium(context).copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
