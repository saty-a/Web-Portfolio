import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../../data/models/project_model.dart';
import '../constants/content.dart';
import '../theme/app_colors.dart';
import '../../modules/home/controllers/home_controller.dart';
import 'store_badge.dart';

// ════════════════════════════════════════════════════════════════════════════
// HERO PANEL — left slot (slot 0)
// ════════════════════════════════════════════════════════════════════════════

class CaseStudyHeroPanel extends StatelessWidget {
  final Project project;
  final bool isDark;
  final VoidCallback onClose;
  const CaseStudyHeroPanel(
      {super.key,
      required this.project,
      required this.isDark,
      required this.onClose});

  Future<void> _launch(String url) async =>
      launcher.launchUrl(Uri.parse(url),
          mode: launcher.LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroBanner(project: project, isDark: isDark, onClose: onClose),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category + role pills
                Wrap(spacing: 8, runSpacing: 6, children: [
                  _Pill(
                    label: project.category == ProjectCategory.openSource
                        ? 'Open Source'
                        : project.category == ProjectCategory.sideProject
                            ? 'Side Project'
                            : 'Featured',
                    accent: true,
                    isDark: isDark,
                  ),
                  if (project.role != null)
                    _Pill(label: project.role!, accent: false, isDark: isDark),
                ]),
                const SizedBox(height: 14),
                // Title
                Text(
                  project.title,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    height: 1.1,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                if (project.tagline != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    project.tagline!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.55,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Tech chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: project.technologies
                      .take(5)
                      .map((t) => _TechChip(label: t, isDark: isDark))
                      .toList(),
                ),
                const SizedBox(height: 20),
                // Store badges
                if (project.playStoreUrl != null ||
                    project.appStoreUrl != null ||
                    project.githubUrl != null ||
                    project.liveUrl != null)
                  StoreBadgeRow(
                    githubUrl: project.githubUrl,
                    playStoreUrl: project.playStoreUrl,
                    appStoreUrl: project.appStoreUrl,
                    windowsStoreUrl: project.windowsStoreUrl,
                    macStoreUrl: project.macStoreUrl,
                    liveUrl: project.liveUrl,
                    isDark: isDark,
                    launchUrl: _launch,
                  ),
                // Metrics
                if (project.metrics.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _PanelLabel(label: 'IMPACT & RESULTS', isDark: isDark),
                  const SizedBox(height: 12),
                  _MetricsGrid(metrics: project.metrics, isDark: isDark),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero banner ──────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final Project project;
  final bool isDark;
  final VoidCallback onClose;
  const _HeroBanner(
      {required this.project, required this.isDark, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final imgUrl = project.screenshotUrls.isNotEmpty
        ? project.screenshotUrls.first
        : project.imageUrls.isNotEmpty
            ? project.imageUrls.first
            : null;

    return Container(
      height: 172,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.accent.withValues(alpha: 0.18),
                  AppColors.accent.withValues(alpha: 0.04),
                ]
              : [
                  AppColors.accent.withValues(alpha: 0.12),
                  AppColors.accent.withValues(alpha: 0.02),
                ],
        ),
        border: Border(
          bottom: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: Stack(
        children: [
          // Blurred bg screenshot
          if (imgUrl != null)
            Positioned.fill(
              child: Opacity(
                opacity: 0.12,
                child: _csImg(imgUrl, isDark, fit: BoxFit.cover),
              ),
            ),
          // Bottom gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
                        .withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),
          // Back button
          Positioned(
              top: 14,
              left: 14,
              child: _BackBtn(onClose: onClose, isDark: isDark)),
          // CASE STUDY badge
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.4)),
              ),
              child: Text(
                'CASE STUDY',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
          // Logo + short title bottom-left
          Positioned(
            bottom: 14,
            left: 14,
            right: 14,
            child: Row(
              children: [
                if (project.logoUrl != null) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 10)
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _csImg(project.logoUrl!, isDark,
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    project.title.split('—').first.trim(),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackBtn extends StatefulWidget {
  final VoidCallback onClose;
  final bool isDark;
  const _BackBtn({required this.onClose, required this.isDark});
  @override
  State<_BackBtn> createState() => _BackBtnState();
}

class _BackBtnState extends State<_BackBtn> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onClose,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _hov
                ? AppColors.accent.withValues(alpha: 0.15)
                : (widget.isDark
                    ? AppColors.cardDark.withValues(alpha: 0.85)
                    : AppColors.cardLight.withValues(alpha: 0.85)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hov
                  ? AppColors.accent.withValues(alpha: 0.45)
                  : (widget.isDark
                      ? AppColors.borderDark
                      : AppColors.borderLight),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_rounded,
                  size: 12,
                  color: _hov
                      ? AppColors.accent
                      : (widget.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight)),
              const SizedBox(width: 5),
              Text('Back',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _hov
                        ? AppColors.accent
                        : (widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Metrics mini grid ────────────────────────────────────────────────────────

class _MetricsGrid extends StatelessWidget {
  final List<CaseStudyMetric> metrics;
  final bool isDark;
  const _MetricsGrid({required this.metrics, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final count = metrics.length.clamp(1, 4);
      final cols = count >= 4 ? 2 : count;
      final itemW = (constraints.maxWidth - (cols - 1) * 8.0) / cols;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: metrics
            .take(4)
            .map((m) => SizedBox(
                  width: itemW,
                  child: _MiniMetric(metric: m, isDark: isDark),
                ))
            .toList(),
      );
    });
  }
}

class _MiniMetric extends StatelessWidget {
  final CaseStudyMetric metric;
  final bool isDark;
  const _MiniMetric({required this.metric, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(metric.icon, size: 14, color: AppColors.accent),
        const SizedBox(height: 6),
        Text(
          metric.value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          metric.label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            height: 1.3,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// OVERVIEW PANEL — mid slot (slot 1)
// ════════════════════════════════════════════════════════════════════════════

class CaseStudyOverviewPanel extends StatelessWidget {
  final Project project;
  final bool isDark;
  const CaseStudyOverviewPanel(
      {super.key, required this.project, required this.isDark});

  String get _catLabel {
    switch (project.category) {
      case ProjectCategory.openSource:
        return 'Open Source';
      case ProjectCategory.sideProject:
        return 'Side Project';
      default:
        return 'Mobile App';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _PanelLabel(label: 'ABOUT THE PROJECT', isDark: isDark),
        const SizedBox(height: 12),
        Text(
          'What is ${project.title.split("—").first.trim()}?',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.2,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          project.longDescription.isNotEmpty
              ? project.longDescription
              : project.shortDescription,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.7,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        if (project.problem != null || project.solution != null) ...[
          const SizedBox(height: 24),
          _PanelLabel(label: 'WHAT WE BUILT', isDark: isDark),
          const SizedBox(height: 14),
          if (project.problem != null)
            _NarrCard(
              number: '01',
              heading: 'THE CHALLENGE',
              body: project.problem!,
              isDark: isDark,
              accent: const Color(0xFFFF6B6B),
            ),
          if (project.solution != null) ...[
            const SizedBox(height: 10),
            _NarrCard(
              number: '02',
              heading: 'THE SOLUTION',
              body: project.solution!,
              isDark: isDark,
              accent: AppColors.accent,
            ),
          ],
        ],
        const SizedBox(height: 24),
        _PanelLabel(label: 'PROJECT DETAILS', isDark: isDark),
        const SizedBox(height: 14),
        _MetaCard(project: project, isDark: isDark, catLabel: _catLabel),
        const SizedBox(height: 24),
      ]),
    );
  }
}

class _NarrCard extends StatelessWidget {
  final String number, heading, body;
  final bool isDark;
  final Color accent;
  const _NarrCard(
      {required this.number,
      required this.heading,
      required this.body,
      required this.isDark,
      required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(number,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1,
                color: accent.withValues(alpha: 0.2),
              )),
          const SizedBox(width: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(heading,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: accent,
                )),
          ),
        ]),
        const SizedBox(height: 10),
        Text(body,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              height: 1.65,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            )),
      ]),
    );
  }
}

class _MetaCard extends StatelessWidget {
  final Project project;
  final bool isDark;
  final String catLabel;
  const _MetaCard(
      {required this.project,
      required this.isDark,
      required this.catLabel});

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(
            height: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      );

  Widget _row(String label, String value) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 68,
            child: Text(label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                )),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(value,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ))),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _row('Category', catLabel),
        if (project.role != null) ...[_divider(), _row('Role', project.role!)],
        _divider(),
        _row('Services', 'Flutter · Mobile Development'),
        _divider(),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tech Stack',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: project.technologies
                .map((t) => _TechChip(label: t, isDark: isDark))
                .toList(),
          ),
        ]),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// FEATURES PANEL — right slot (slot 2)
// ════════════════════════════════════════════════════════════════════════════

class CaseStudyFeaturesPanel extends StatelessWidget {
  final Project project;
  final bool isDark;
  const CaseStudyFeaturesPanel(
      {super.key, required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (project.features.isNotEmpty) ...[
          _PanelLabel(label: 'KEY FEATURES', isDark: isDark),
          const SizedBox(height: 8),
          Text(
            'What we built',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              height: 1.2,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          _FeaturesGrid(features: project.features, isDark: isDark),
          const SizedBox(height: 24),
        ],
        if (project.screenshotUrls.isNotEmpty) ...[
          _PanelLabel(label: 'SCREENSHOTS', isDark: isDark),
          const SizedBox(height: 14),
          _ScreenshotShowcase(urls: project.screenshotUrls, isDark: isDark),
          const SizedBox(height: 24),
        ],
        _RelatedStudies(current: project, isDark: isDark),
        const SizedBox(height: 20),
      ]),
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  final List<CaseStudyFeature> features;
  final bool isDark;
  const _FeaturesGrid({required this.features, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final cols = constraints.maxWidth >= 340 ? 2 : 1;
      final itemW =
          cols > 1 ? (constraints.maxWidth - 8) / 2 : constraints.maxWidth;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: features
            .map((f) => SizedBox(
                  width: itemW,
                  child: _FeatChip(feature: f, isDark: isDark),
                ))
            .toList(),
      );
    });
  }
}

class _FeatChip extends StatefulWidget {
  final CaseStudyFeature feature;
  final bool isDark;
  const _FeatChip({required this.feature, required this.isDark});
  @override
  State<_FeatChip> createState() => _FeatChipState();
}

class _FeatChipState extends State<_FeatChip> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _hov
              ? AppColors.accent.withValues(alpha: 0.08)
              : (widget.isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hov
                ? AppColors.accent.withValues(alpha: 0.3)
                : (widget.isDark
                    ? AppColors.borderDark
                    : AppColors.borderLight),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _hov
                  ? AppColors.accent.withValues(alpha: 0.15)
                  : (widget.isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(widget.feature.icon,
                size: 14,
                color: _hov
                    ? AppColors.accent
                    : (widget.isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight)),
          ),
          const SizedBox(height: 10),
          Text(widget.feature.name,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: widget.isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              )),
          const SizedBox(height: 4),
          Text(widget.feature.description,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: widget.isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}

class _ScreenshotShowcase extends StatefulWidget {
  final List<String> urls;
  final bool isDark;
  const _ScreenshotShowcase({required this.urls, required this.isDark});
  @override
  State<_ScreenshotShowcase> createState() => _ScreenshotShowcaseState();
}

class _ScreenshotShowcaseState extends State<_ScreenshotShowcase> {
  int _sel = 0;
  @override
  Widget build(BuildContext context) {
    final urls = widget.urls;
    return Column(children: [
      Center(child: _CsPhoFrame(url: urls[_sel], isDark: widget.isDark)),
      if (urls.length > 1) ...[
        const SizedBox(height: 12),
        Center(
          child: Wrap(
              spacing: 8,
              children: List.generate(urls.length, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _sel = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: i == _sel
                            ? AppColors.accent
                            : (widget.isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                        width: i == _sel ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: _csImg(urls[i], widget.isDark),
                    ),
                  ),
                );
              })),
        ),
      ],
    ]);
  }
}

class _CsPhoFrame extends StatelessWidget {
  final String url;
  final bool isDark;
  const _CsPhoFrame({required this.url, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 260,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1C1E)
            : const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? const Color(0xFF3A3A3C)
              : const Color(0xFFD1D1D6),
          width: 6,
        ),
        boxShadow: [
          BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 12)),
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 6)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: _csImg(url, isDark),
      ),
    );
  }
}

class _RelatedStudies extends StatelessWidget {
  final Project current;
  final bool isDark;
  const _RelatedStudies({required this.current, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final related = AppContent.featuredProjects
        .where((p) => p.title != current.title && p.hasCaseStudy)
        .take(3)
        .toList();
    if (related.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _PanelLabel(label: 'MORE CASE STUDIES', isDark: isDark),
      const SizedBox(height: 14),
      ...related.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RelatedCard(project: p, isDark: isDark),
          )),
    ]);
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
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: () => ctrl.requestOpenCaseStudy(widget.project),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _hov
                ? (widget.isDark
                    ? AppColors.cardHoverDark
                    : AppColors.cardHoverLight)
                : (widget.isDark ? AppColors.cardDark : AppColors.cardLight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hov
                  ? AppColors.accent.withValues(alpha: 0.3)
                  : (widget.isDark
                      ? AppColors.borderDark
                      : AppColors.borderLight),
            ),
          ),
          child: Row(children: [
            if (widget.project.logoUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: _csImg(widget.project.logoUrl!, widget.isDark,
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(widget.project.title,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: widget.isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(
                      widget.project.tagline ??
                          widget.project.shortDescription,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ])),
            const SizedBox(width: 8),
            AnimatedSlide(
              offset: _hov ? const Offset(0.3, 0) : Offset.zero,
              duration: const Duration(milliseconds: 180),
              child: const Icon(Icons.arrow_forward_rounded,
                  size: 13, color: AppColors.accent),
            ),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SHARED PRIMITIVES
// ════════════════════════════════════════════════════════════════════════════

class _PanelLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _PanelLabel({required this.label, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 3,
        height: 12,
        decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 7),
      Text(label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.accent,
          )),
    ]);
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool accent, isDark;
  const _Pill(
      {required this.label, required this.accent, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accent
            ? AppColors.accent.withValues(alpha: 0.12)
            : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent
              ? AppColors.accent.withValues(alpha: 0.4)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: accent
                ? AppColors.accent
                : (isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight),
          )),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Text(label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          )),
    );
  }
}

// ─── Image helper ─────────────────────────────────────────────────────────────

Widget _csImg(String url, bool isDark, {BoxFit fit = BoxFit.cover}) {
  final ph = Container(
    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
    child: Center(
        child: Icon(Icons.image_outlined,
            size: 18,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight)),
  );
  if (!url.startsWith('http')) {
    return Image.asset(url, fit: fit, errorBuilder: (_, __, ___) => ph);
  }
  return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (_, __) => ph,
      errorWidget: (_, __, ___) => ph);
}
