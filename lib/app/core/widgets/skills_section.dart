import 'package:flutter/material.dart';
import '../constants/content.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class SkillsSection extends StatelessWidget {
  final bool shrinkWrap;
  const SkillsSection({super.key, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SKILLS',
          style: AppTypography.labelSmall(context).copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          ),
        ),
        const SizedBox(height: 20),
        ...AppContent.skillCategories.entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: AppTypography.labelSmall(context).copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: entry.value
                    .map((skill) => _SkillChip(skill: skill, isDark: isDark))
                    .toList(),
              ),
            ],
          ),
        )),
      ],
    );

    if (shrinkWrap) return content;
    return SingleChildScrollView(child: content);
  }
}

class _SkillChip extends StatefulWidget {
  final String skill;
  final bool isDark;
  const _SkillChip({required this.skill, required this.isDark});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.accentSubtle
              : (widget.isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.4)
                : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          widget.skill,
          style: AppTypography.monoSmall(context).copyWith(
            color: _hovered
                ? AppColors.accent
                : (widget.isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight),
          ),
        ),
      ),
    );
  }
}
