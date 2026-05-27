import 'package:flutter/material.dart';
import '../../data/models/career_milestone.dart';
import '../constants/content.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CareerTimeline extends StatelessWidget {
  final bool shrinkWrap;
  const CareerTimeline({super.key, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final milestones = AppContent.careerMilestones.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    final content = _buildContent(context, isDark, milestones);
    if (shrinkWrap) {
      return Padding(padding: const EdgeInsets.all(24), child: content);
    }
    return SizedBox.expand(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: content,
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, bool isDark, List<CareerMilestone> milestones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ────────────────────────────────────────────────────
        Text(
          'CAREER JOURNEY',
          style: AppTypography.labelSmall(context).copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(
          milestones.length,
          (i) => _TimelineEntry(
            milestone: milestones[i],
            isLast: i == milestones.length - 1,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single timeline entry
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineEntry extends StatefulWidget {
  final CareerMilestone milestone;
  final bool isLast;
  final bool isDark;

  const _TimelineEntry({
    required this.milestone,
    required this.isLast,
    required this.isDark,
  });

  @override
  State<_TimelineEntry> createState() => _TimelineEntryState();
}

class _TimelineEntryState extends State<_TimelineEntry> {
  bool _hovered = false;

  Color get _typeColor {
    switch (widget.milestone.type) {
      case MilestoneType.work:        return AppColors.timelineActive;
      case MilestoneType.education:   return const Color(0xFF60A5FA);
      case MilestoneType.openSource:  return const Color(0xFFA78BFA);
      case MilestoneType.achievement: return const Color(0xFFFBBF24);
    }
  }

  IconData get _typeIcon {
    switch (widget.milestone.type) {
      case MilestoneType.work:        return Icons.work_rounded;
      case MilestoneType.education:   return Icons.school_rounded;
      case MilestoneType.openSource:  return Icons.code_rounded;
      case MilestoneType.achievement: return Icons.emoji_events_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tc       = _typeColor;
    final cardBg   = widget.isDark ? AppColors.cardDark  : AppColors.cardLight;
    final hoverBg  = widget.isDark ? AppColors.cardHoverDark : AppColors.cardHoverLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Year label ────────────────────────────────────────────────────
          SizedBox(
            width: 36,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: AppTypography.monoSmall(context).copyWith(
                  color: _hovered
                      ? tc
                      : (widget.isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight),
                  fontWeight:
                      _hovered ? FontWeight.w700 : FontWeight.w400,
                ),
                child: Text(widget.milestone.year, overflow: TextOverflow.clip),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // ── Icon badge + connector ─────────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _hovered
                      ? tc
                      : tc.withValues(alpha: 0.13),
                  border: Border.all(
                    color: tc.withValues(alpha: _hovered ? 1.0 : 0.45),
                    width: _hovered ? 1.5 : 1.0,
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: tc.withValues(alpha: 0.35),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: Icon(
                  _typeIcon,
                  size: 13,
                  color: _hovered ? Colors.white : tc,
                ),
              ),
              // Gradient connector line
              if (!widget.isLast)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 1.5,
                  height: 72,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _hovered
                            ? tc.withValues(alpha: 0.55)
                            : (widget.isDark
                                ? AppColors.timelineInactive
                                : AppColors.borderLight),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),

          // ── Card ──────────────────────────────────────────────────────────
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 12),
              // Outer layer = accent color (visible as left border strip)
              decoration: BoxDecoration(
                color: _hovered
                    ? tc
                    : tc.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: tc.withValues(alpha: 0.10),
                          blurRadius: 14,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              // Inner layer = card background (offset left to reveal strip)
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: EdgeInsets.only(left: _hovered ? 3.0 : 2.0),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: _hovered ? hoverBg : cardBg,
                  borderRadius: const BorderRadius.only(
                    topRight:    Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + employment type chip
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.milestone.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppTypography.titleSmall(context).copyWith(
                              color: widget.isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (widget.milestone.employmentType != null) ...[
                          const SizedBox(width: 6),
                          _TypeChip(
                            label: widget.milestone.employmentType!,
                            color: tc,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    // Organization
                    Text(
                      widget.milestone.organization,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    // Date range
                    if (widget.milestone.dateRange != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 10,
                            color: widget.isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            widget.milestone.dateRange!,
                            style: AppTypography.monoSmall(context).copyWith(
                              fontSize: 10,
                              color: widget.isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                    // Description
                    if (widget.milestone.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.milestone.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: AppTypography.labelSmall(context).copyWith(
                          color: widget.isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Employment type pill chip
// ─────────────────────────────────────────────────────────────────────────────

class _TypeChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TypeChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.30), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.labelSmall(context).copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
