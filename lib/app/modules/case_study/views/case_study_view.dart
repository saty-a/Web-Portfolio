import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../../../core/constants/content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/project_model.dart';
import '../bindings/case_study_binding.dart';
import '../controllers/case_study_controller.dart';

class CaseStudyView extends StatelessWidget {
  const CaseStudyView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CaseStudyController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CaseStudyHero(project: ctrl.project, isDark: isDark),
            _StoreBadgesSection(project: ctrl.project, isDark: isDark, onOpen: ctrl.openUrl),
            _OverviewSection(project: ctrl.project, isDark: isDark),
            if (ctrl.project.metrics.isNotEmpty)
              _MetricsSection(project: ctrl.project, isDark: isDark),
            if (ctrl.project.problem != null || ctrl.project.solution != null)
              _ProblemSolutionSection(project: ctrl.project, isDark: isDark),
            if (ctrl.project.features.isNotEmpty)
              _FeaturesSection(project: ctrl.project, isDark: isDark),
            if (ctrl.project.screenshotUrls.isNotEmpty ||
                ctrl.project.imageUrls.isNotEmpty)
              _ScreenshotsSection(project: ctrl.project, isDark: isDark),
            _RelatedProjectsSection(
                current: ctrl.project, isDark: isDark, onOpen: ctrl.openUrl),
            _CaseStudyFooter(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HERO
// ═══════════════════════════════════════════════════════════════════════════════

class _CaseStudyHero extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _CaseStudyHero({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1024;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Back nav ──
          Padding(
            padding: EdgeInsets.fromLTRB(isDesktop ? 64 : 24, 20, 24, 0),
            child: _BackButton(isDark: isDark),
          ),
          // ── Content ──
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 64 : 24,
              vertical: isDesktop ? 56 : 40,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: _HeroText(project: project, isDark: isDark, isDesktop: true)),
                      const SizedBox(width: 64),
                      Expanded(flex: 4, child: _HeroImage(project: project, isDark: isDark)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroText(project: project, isDark: isDark, isDesktop: false),
                      const SizedBox(height: 40),
                      _HeroImage(project: project, isDark: isDark),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatefulWidget {
  final bool isDark;
  const _BackButton({required this.isDark});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.3)
                  : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_rounded,
                  size: 14,
                  color: _hovered
                      ? AppColors.accent
                      : (widget.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight)),
              const SizedBox(width: 6),
              Text(
                'Portfolio',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _hovered
                      ? AppColors.accent
                      : (widget.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final Project project;
  final bool isDark;
  final bool isDesktop;
  const _HeroText(
      {required this.project, required this.isDark, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final categoryLabel = project.category == ProjectCategory.openSource
        ? 'Open Source'
        : project.category == ProjectCategory.sideProject
            ? 'Side Project'
            : 'Featured';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App logo + category/role badges
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (project.logoUrl != null) ...[
              _AppLogo(logoUrl: project.logoUrl!, isDark: isDark),
              const SizedBox(width: 16),
            ],
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Pill(label: categoryLabel, accent: true),
                if (project.role != null) _Pill(label: project.role!, accent: false),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Title
        Text(
          project.title,
          style: GoogleFonts.poppins(
            fontSize: isDesktop ? 52 : 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.5,
            height: 1.08,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        if (project.tagline != null) ...[
          const SizedBox(height: 16),
          Text(
            project.tagline!,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 20 : 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
        const SizedBox(height: 24),
        // Tech row
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: project.technologies
              .take(5)
              .map((t) => _TechChip(label: t, isDark: isDark))
              .toList(),
        ),
      ],
    );
  }
}

// ─── App logo badge shown in hero ────────────────────────────────────────────

class _AppLogo extends StatelessWidget {
  final String logoUrl;
  final bool isDark;
  const _AppLogo({required this.logoUrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.2),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: _projectImage(logoUrl, isDark, fit: BoxFit.cover),
      ),
    );
  }
}

// ─── Hero screenshot ─────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _HeroImage({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final imgs = project.imageUrls.isNotEmpty ? project.imageUrls : project.screenshotUrls;
    if (imgs.isEmpty) return const SizedBox.shrink();

    final isAsset = !imgs.first.startsWith('http');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.12),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: isAsset
            ? Image.asset(imgs.first, fit: BoxFit.cover)
            : CachedNetworkImage(
                imageUrl: imgs.first,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 320,
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(Icons.image_outlined,
                        size: 48,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight),
                  ),
                ),
              ),
      ),
    );
  }
}

// ─── Shared helper: local asset OR network image ──────────────────────────────

Widget _projectImage(String url, bool isDark,
    {BoxFit fit = BoxFit.cover, double? height}) {
  final isAsset = !url.startsWith('http');
  if (isAsset) {
    return Image.asset(url, fit: fit, height: height,
        errorBuilder: (_, __, ___) => _imgPlaceholder(isDark, height));
  }
  return CachedNetworkImage(
    imageUrl: url,
    fit: fit,
    height: height,
    placeholder: (_, __) => _imgPlaceholder(isDark, height),
    errorWidget: (_, __, ___) => _imgPlaceholder(isDark, height),
  );
}

Widget _imgPlaceholder(bool isDark, double? height) => Container(
      height: height ?? 200,
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Center(
        child: Icon(Icons.image_outlined,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
      ),
    );

// ═══════════════════════════════════════════════════════════════════════════════
// STORE BADGES — prominent section just below hero
// ═══════════════════════════════════════════════════════════════════════════════

class _StoreBadgesSection extends StatelessWidget {
  final Project project;
  final bool isDark;
  final Future<void> Function(String) onOpen;

  const _StoreBadgesSection(
      {required this.project, required this.isDark, required this.onOpen});

  bool get _hasAnyLink =>
      project.playStoreUrl != null ||
      project.appStoreUrl != null ||
      project.githubUrl != null ||
      project.liveUrl != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasAnyLink) return const SizedBox.shrink();

    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1024;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.accent.withValues(alpha: 0.06),
                  AppColors.accent.withValues(alpha: 0.02),
                ]
              : [
                  AppColors.accent.withValues(alpha: 0.04),
                  AppColors.accent.withValues(alpha: 0.01),
                ],
        ),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 32,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'AVAILABLE ON',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Download the app',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          // Right: large badges
          _LargeBadgeRow(project: project, isDark: isDark, onOpen: onOpen),
        ],
      ),
    );
  }
}

class _LargeBadgeRow extends StatelessWidget {
  final Project project;
  final bool isDark;
  final Future<void> Function(String) onOpen;

  const _LargeBadgeRow(
      {required this.project, required this.isDark, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];

    if (project.playStoreUrl != null) {
      badges.add(_LargeStoreBadge(
        icon: FontAwesomeIcons.googlePlay,
        topLine: 'GET IT ON',
        bottomLine: 'Google Play',
        color: const Color(0xFF01875F),
        isDark: isDark,
        onTap: () => onOpen(project.playStoreUrl!),
      ));
    }
    if (project.appStoreUrl != null) {
      badges.add(_LargeStoreBadge(
        icon: FontAwesomeIcons.appStoreIos,
        topLine: 'DOWNLOAD ON THE',
        bottomLine: 'App Store',
        color: const Color(0xFF1C8EF9),
        isDark: isDark,
        onTap: () => onOpen(project.appStoreUrl!),
      ));
    }
    if (project.githubUrl != null) {
      badges.add(_LargeStoreBadge(
        icon: FontAwesomeIcons.github,
        topLine: 'VIEW ON',
        bottomLine: 'GitHub',
        color: const Color(0xFF58A6FF),
        isDark: isDark,
        onTap: () => onOpen(project.githubUrl!),
      ));
    }
    if (project.liveUrl != null) {
      final isPub = project.liveUrl!.contains('pub.dev');
      badges.add(_LargeStoreBadge(
        icon: isPub ? FontAwesomeIcons.cube : FontAwesomeIcons.arrowUpRightFromSquare,
        topLine: isPub ? 'AVAILABLE ON' : 'OPEN',
        bottomLine: isPub ? 'pub.dev' : 'Live Site',
        color: isPub ? const Color(0xFF0175C2) : AppColors.accent,
        isDark: isDark,
        onTap: () => onOpen(project.liveUrl!),
      ));
    }

    return Wrap(spacing: 12, runSpacing: 12, children: badges);
  }
}

class _LargeStoreBadge extends StatefulWidget {
  final IconData icon;
  final String topLine;
  final String bottomLine;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _LargeStoreBadge({
    required this.icon,
    required this.topLine,
    required this.bottomLine,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_LargeStoreBadge> createState() => _LargeStoreBadgeState();
}

class _LargeStoreBadgeState extends State<_LargeStoreBadge>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _ctrl.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.color.withValues(alpha: 0.12)
                  : (widget.isDark
                      ? AppColors.cardDark
                      : AppColors.cardLight),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hovered
                    ? widget.color.withValues(alpha: 0.6)
                    : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
                width: 1.5,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.2),
                        blurRadius: 16,
                        spreadRadius: 0,
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(widget.icon,
                    size: 22,
                    color: _hovered
                        ? widget.color
                        : (widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.topLine,
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        color: _hovered
                            ? widget.color.withValues(alpha: 0.8)
                            : (widget.isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight),
                      ),
                    ),
                    Text(
                      widget.bottomLine,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        height: 1.2,
                        color: _hovered
                            ? widget.color
                            : (widget.isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// OVERVIEW
// ═══════════════════════════════════════════════════════════════════════════════

class _OverviewSection extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _OverviewSection({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1024;

    return _SectionWrapper(
      isDark: isDark,
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _OverviewLeft(project: project, isDark: isDark)),
                const SizedBox(width: 64),
                Expanded(flex: 4, child: _OverviewRight(project: project, isDark: isDark)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OverviewLeft(project: project, isDark: isDark),
                const SizedBox(height: 40),
                _OverviewRight(project: project, isDark: isDark),
              ],
            ),
    );
  }
}

class _OverviewLeft extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _OverviewLeft({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: 'ABOUT THE PROJECT', isDark: isDark),
        const SizedBox(height: 16),
        Text(
          'What is ${project.title.split('—').first.trim()}?',
          style: AppTypography.displaySmall(context),
        ),
        const SizedBox(height: 20),
        Text(
          project.longDescription.isNotEmpty
              ? project.longDescription
              : project.shortDescription,
          style: AppTypography.bodyLarge(context),
        ),
      ],
    );
  }
}

class _OverviewRight extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _OverviewRight({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final categoryLabel = project.category == ProjectCategory.openSource
        ? 'Open Source'
        : project.category == ProjectCategory.sideProject
            ? 'Side Project'
            : 'Mobile App';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaRow(
            label: 'Category',
            value: categoryLabel,
            isDark: isDark,
          ),
          _divider(isDark),
          if (project.role != null) ...[
            _MetaRow(label: 'Role', value: project.role!, isDark: isDark),
            _divider(isDark),
          ],
          _MetaRow(
            label: 'Services',
            value: 'Flutter Development · Mobile',
            isDark: isDark,
          ),
          _divider(isDark),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tech Stack',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.technologies
                    .map((t) => _TechChip(label: t, isDark: isDark))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Divider(
          height: 1,
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      );
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _MetaRow(
      {required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// METRICS
// ═══════════════════════════════════════════════════════════════════════════════

class _MetricsSection extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _MetricsSection({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: _SectionWrapper(
        isDark: isDark,
        useSurface: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel(label: 'IMPACT & RESULTS', isDark: isDark),
            const SizedBox(height: 32),
            LayoutBuilder(builder: (context, constraints) {
              final cols = constraints.maxWidth >= 800
                  ? 4
                  : constraints.maxWidth >= 500
                      ? 2
                      : 2;
              final metrics = project.metrics;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(metrics.length, (i) {
                  final itemWidth =
                      (constraints.maxWidth - (cols - 1) * 16) / cols;
                  return SizedBox(
                    width: itemWidth,
                    child: _MetricCard(
                        metric: metrics[i], isDark: isDark, index: i),
                  );
                }),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatefulWidget {
  final CaseStudyMetric metric;
  final bool isDark;
  final int index;
  const _MetricCard(
      {required this.metric, required this.isDark, required this.index});

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.accent.withValues(alpha: 0.08)
              : (widget.isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.4)
                : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              widget.metric.icon,
              size: 20,
              color: _hovered
                  ? AppColors.accent
                  : (widget.isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight),
            ),
            const SizedBox(height: 12),
            Text(
              widget.metric.value,
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
                height: 1,
                color: _hovered
                    ? AppColors.accent
                    : (widget.isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.metric.label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: widget.isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROBLEM / SOLUTION
// ═══════════════════════════════════════════════════════════════════════════════

class _ProblemSolutionSection extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _ProblemSolutionSection(
      {required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1024;

    return _SectionWrapper(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label: 'WHAT WE BUILT', isDark: isDark),
          const SizedBox(height: 32),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (project.problem != null)
                      Expanded(
                        child: _NarrativeBlock(
                          number: '01',
                          heading: 'The Challenge',
                          body: project.problem!,
                          isDark: isDark,
                          isLeft: true,
                        ),
                      ),
                    if (project.problem != null && project.solution != null)
                      const SizedBox(width: 24),
                    if (project.solution != null)
                      Expanded(
                        child: _NarrativeBlock(
                          number: '02',
                          heading: 'The Solution',
                          body: project.solution!,
                          isDark: isDark,
                          isLeft: false,
                        ),
                      ),
                  ],
                )
              : Column(
                  children: [
                    if (project.problem != null)
                      _NarrativeBlock(
                        number: '01',
                        heading: 'The Challenge',
                        body: project.problem!,
                        isDark: isDark,
                        isLeft: true,
                      ),
                    if (project.problem != null && project.solution != null)
                      const SizedBox(height: 20),
                    if (project.solution != null)
                      _NarrativeBlock(
                        number: '02',
                        heading: 'The Solution',
                        body: project.solution!,
                        isDark: isDark,
                        isLeft: false,
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _NarrativeBlock extends StatelessWidget {
  final String number;
  final String heading;
  final String body;
  final bool isDark;
  final bool isLeft;

  const _NarrativeBlock({
    required this.number,
    required this.heading,
    required this.body,
    required this.isDark,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isLeft ? const Color(0xFFFF6B6B) : AppColors.accent;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                number,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  height: 1,
                  color: accentColor.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  heading.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(body, style: AppTypography.bodyMedium(context)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FEATURES GRID
// ═══════════════════════════════════════════════════════════════════════════════

class _FeaturesSection extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _FeaturesSection({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: _SectionWrapper(
        isDark: isDark,
        useSurface: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel(label: 'KEY FEATURES', isDark: isDark),
            const SizedBox(height: 12),
            Text('What we built', style: AppTypography.displaySmall(context)),
            const SizedBox(height: 40),
            LayoutBuilder(builder: (context, constraints) {
              final cols = constraints.maxWidth >= 900
                  ? 3
                  : constraints.maxWidth >= 580
                      ? 2
                      : 1;
              final features = project.features;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(features.length, (i) {
                  final w = (constraints.maxWidth - (cols - 1) * 16) / cols;
                  return SizedBox(
                    width: w,
                    child: _FeatureCard(
                      feature: features[i],
                      index: i,
                      isDark: isDark,
                    ),
                  );
                }),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final CaseStudyFeature feature;
  final int index;
  final bool isDark;

  const _FeatureCard(
      {required this.feature, required this.index, required this.isDark});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final num = (widget.index + 1).toString().padLeft(2, '0');

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hovered
              ? (widget.isDark ? AppColors.cardHoverDark : AppColors.cardHoverLight)
              : (widget.isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.3)
                : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Number badge
                Text(
                  num,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: _hovered
                        ? AppColors.accent.withValues(alpha: 0.6)
                        : (widget.isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight),
                  ),
                ),
                const Spacer(),
                // Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _hovered
                        ? AppColors.accent.withValues(alpha: 0.12)
                        : (widget.isDark
                            ? AppColors.surfaceDark
                            : AppColors.surfaceLight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.feature.icon,
                    size: 18,
                    color: _hovered
                        ? AppColors.accent
                        : (widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.feature.name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.feature.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.6,
                color: widget.isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREENSHOTS
// ═══════════════════════════════════════════════════════════════════════════════

class _ScreenshotsSection extends StatefulWidget {
  final Project project;
  final bool isDark;
  const _ScreenshotsSection({required this.project, required this.isDark});

  @override
  State<_ScreenshotsSection> createState() => _ScreenshotsSectionState();
}

class _ScreenshotsSectionState extends State<_ScreenshotsSection> {
  int _selected = 0;

  List<String> get _urls {
    final all = [
      ...widget.project.screenshotUrls,
      ...widget.project.imageUrls,
    ];
    return all.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final urls = _urls;
    if (urls.isEmpty) return const SizedBox.shrink();

    return _SectionWrapper(
      isDark: widget.isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label: 'SCREENSHOTS', isDark: widget.isDark),
          const SizedBox(height: 16),
          Text('In action', style: AppTypography.displaySmall(context)),
          const SizedBox(height: 40),
          // Main image
          Center(
            child: _PhoneFrame(
              url: urls[_selected],
              isDark: widget.isDark,
            ),
          ),
          if (urls.length > 1) ...[
            const SizedBox(height: 24),
            // Thumbnail row
            Center(
              child: Wrap(
                spacing: 12,
                children: List.generate(urls.length, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: i == _selected
                              ? AppColors.accent
                              : (widget.isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight),
                          width: i == _selected ? 2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: _projectImage(urls[i], widget.isDark),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  final String url;
  final bool isDark;
  const _PhoneFrame({required this.url, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 480,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFD1D1D6),
          width: 10,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: _projectImage(url, isDark),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// RELATED PROJECTS
// ═══════════════════════════════════════════════════════════════════════════════

class _RelatedProjectsSection extends StatelessWidget {
  final Project current;
  final bool isDark;
  final Future<void> Function(String) onOpen;

  const _RelatedProjectsSection(
      {required this.current, required this.isDark, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final related = AppContent.featuredProjects
        .where((p) => p.title != current.title && p.hasCaseStudy)
        .take(3)
        .toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: _SectionWrapper(
        isDark: isDark,
        useSurface: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel(label: 'MORE CASE STUDIES', isDark: isDark),
            const SizedBox(height: 16),
            Text('Similar work', style: AppTypography.headlineMedium(context)),
            const SizedBox(height: 32),
            LayoutBuilder(builder: (context, constraints) {
              final cols = constraints.maxWidth >= 800 ? related.length : 1;
              final itemW = cols > 1
                  ? (constraints.maxWidth - (cols - 1) * 16) / cols
                  : constraints.maxWidth;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: related.map((p) {
                  return SizedBox(
                    width: itemW,
                    child: _RelatedCard(project: p, isDark: isDark),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _RelatedCard extends StatefulWidget {
  final Project project;
  final bool isDark;
  const _RelatedCard({required this.project, required this.isDark});

  @override
  State<_RelatedCard> createState() => _RelatedCardState();
}

class _RelatedCardState extends State<_RelatedCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Get.off(
          () => const CaseStudyView(),
          arguments: widget.project,
          binding: CaseStudyBinding(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 280),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered
                ? (widget.isDark ? AppColors.cardHoverDark : AppColors.cardHoverLight)
                : (widget.isDark ? AppColors.cardDark : AppColors.cardLight),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.3)
                  : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.project.imageUrls.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _projectImage(
                      widget.project.imageUrls.first,
                      widget.isDark,
                    ),
                  ),
                ),
              if (widget.project.imageUrls.isNotEmpty) const SizedBox(height: 16),
              Text(
                widget.project.title,
                style: AppTypography.titleLarge(context),
              ),
              const SizedBox(height: 6),
              Text(
                widget.project.tagline ?? widget.project.shortDescription,
                style: AppTypography.bodySmall(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Read Case Study',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedSlide(
                    offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(Icons.arrow_forward_rounded,
                        size: 14, color: AppColors.accent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FOOTER
// ═══════════════════════════════════════════════════════════════════════════════

class _CaseStudyFooter extends StatelessWidget {
  final bool isDark;
  const _CaseStudyFooter({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Want to build something like this?',
            style: AppTypography.displaySmall(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Flutter developer available for new projects.',
            style: AppTypography.bodyLarge(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterCta(
                label: 'Get in touch',
                icon: Icons.mail_outline_rounded,
                onTap: () async {
                  final uri = Uri.parse(
                      'mailto:${AppContent.email}?subject=Project%20Enquiry');
                  if (await launcher.canLaunchUrl(uri)) {
                    await launcher.launchUrl(uri);
                  }
                },
                accent: true,
              ),
              const SizedBox(width: 12),
              _FooterCta(
                label: 'Back to Portfolio',
                icon: Icons.arrow_back_rounded,
                onTap: () => Get.back(),
                accent: false,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterCta extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool accent;
  final bool isDark;

  const _FooterCta({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.accent,
    this.isDark = true,
  });

  @override
  State<_FooterCta> createState() => _FooterCtaState();
}

class _FooterCtaState extends State<_FooterCta> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: widget.accent
                ? (_hovered ? AppColors.accentMuted : AppColors.accent)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.accent
                  ? AppColors.accent
                  : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.accent
                    ? Colors.black
                    : (widget.isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.accent
                      ? Colors.black
                      : (widget.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED PRIMITIVES
// ═══════════════════════════════════════════════════════════════════════════════

class _SectionWrapper extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final bool useSurface;

  const _SectionWrapper({
    required this.child,
    required this.isDark,
    this.useSurface = false,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1024;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: isDesktop ? 64 : 48,
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool accent;
  const _Pill({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: accent
            ? AppColors.accent.withValues(alpha: 0.12)
            : (isDark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent
              ? AppColors.accent.withValues(alpha: 0.4)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: accent
              ? AppColors.accent
              : (isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight),
        ),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  final bool isDark;
  const _TechChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}
