import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/project_model.dart';
import '../constants/content.dart';
import '../theme/app_colors.dart';
import 'github_stats_grid.dart';
import 'store_badge.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// COLUMN SHELL
// ═══════════════════════════════════════════════════════════════════════════════

class WorkColumn extends StatelessWidget {
  final bool shrinkWrap;
  const WorkColumn({super.key, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = _buildContent(context, isDark);
    if (shrinkWrap) {
      return Padding(padding: const EdgeInsets.all(20), child: content);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: content,
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── GitHub stats bento grid ──
        GitHubStatsGrid(isDark: isDark),
        const SizedBox(height: 28),

        // Section label
        Row(
          children: [
            Container(
              width: 3,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'HIGHLIGHTED WORK',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...AppContent.featuredProjects.map((project) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _WorkCard(project: project, isDark: isDark),
            )),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WORK CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _WorkCard extends StatefulWidget {
  final Project project;
  final bool isDark;
  const _WorkCard({required this.project, required this.isDark});

  @override
  State<_WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<_WorkCard> {
  bool _hovered = false;

  Future<void> _launchUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _openCaseStudy() {
    Get.delete<dynamic>(tag: 'CaseStudyController', force: true);
    Get.toNamed('/case-study', arguments: widget.project);
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final isDark = widget.isDark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.35)
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.06),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Smart preview area ──
            _CardPreview(project: project, isDark: isDark, hovered: _hovered),

            // ── Content ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (project.logoUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: _projectImg(project.logoUrl!, 28, 28,
                              BoxFit.cover, isDark),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          project.title,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Category badge
                      _CategoryBadge(project: project),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Short description
                  Text(
                    project.shortDescription,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Tech chips
                  _TechRow(project: project, isDark: isDark),
                  const SizedBox(height: 12),

                  // Store badges (compact)
                  StoreBadgeRow(
                    githubUrl: project.githubUrl,
                    playStoreUrl: project.playStoreUrl,
                    appStoreUrl: project.appStoreUrl,
                    windowsStoreUrl: project.windowsStoreUrl,
                    macStoreUrl: project.macStoreUrl,
                    liveUrl: project.liveUrl,
                    isDark: isDark,
                    launchUrl: _launchUrl,
                  ),

                  // Case study CTA
                  if (project.hasCaseStudy) ...[
                    const SizedBox(height: 10),
                    _CaseStudyCta(
                      hovered: _hovered,
                      onTap: _openCaseStudy,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SMART PREVIEW — portrait fan / cover strip / code aesthetic
// ═══════════════════════════════════════════════════════════════════════════════

class _CardPreview extends StatelessWidget {
  final Project project;
  final bool isDark;
  final bool hovered;
  const _CardPreview(
      {required this.project, required this.isDark, required this.hovered});

  // Has portrait phone mockups (local asset screenshots)
  bool get _hasPhoneMockups =>
      project.screenshotUrls.isNotEmpty &&
      project.screenshotUrls.first.startsWith('assets/');

  // Has wide/network thumbnail
  bool get _hasWideCover => project.imageUrls.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (_hasPhoneMockups) return _PhoneFanPreview(project: project, isDark: isDark, hovered: hovered);
    if (_hasWideCover) return _CoverStripPreview(project: project, isDark: isDark);
    return _CodeAestheticPreview(project: project, isDark: isDark);
  }
}

// ── Phone fan: 3 portrait frames side by side, fanned ────────────────────────

class _PhoneFanPreview extends StatelessWidget {
  final Project project;
  final bool isDark;
  final bool hovered;
  const _PhoneFanPreview(
      {required this.project, required this.isDark, required this.hovered});

  @override
  Widget build(BuildContext context) {
    final shots = project.screenshotUrls.take(3).toList();

    return Container(
      height: 148,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF111111), const Color(0xFF0D0D0D)]
              : [const Color(0xFFF0F0F0), const Color(0xFFE8E8E8)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle glow behind phones
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: hovered ? 120 : 80,
            height: hovered ? 80 : 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: hovered ? 0.15 : 0.08),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Fan of phone frames
          SizedBox(
            width: double.infinity,
            height: 148,
            child: shots.isEmpty
                ? Center(
                    child: Icon(Icons.smartphone_rounded,
                        size: 40,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight),
                  )
                : _buildFan(shots),
          ),
          // Logo badge bottom-right
          if (project.logoUrl != null)
            Positioned(
              bottom: 10,
              right: 12,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    project.logoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFan(List<String> shots) {
    // angles and offsets for left, center, right phones
    const configs = [
      (angle: -0.18, dx: -52.0, scale: 0.88),
      (angle: 0.0, dx: 0.0, scale: 1.0),
      (angle: 0.18, dx: 52.0, scale: 0.88),
    ];

    return Stack(
      alignment: Alignment.center,
      children: List.generate(math.min(shots.length, 3), (i) {
        final cfg = configs[i];
        return Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..translateByDouble(cfg.dx, 0.0, 0.0, 0.0)
            ..rotateZ(cfg.angle)
            ..scaleByDouble(cfg.scale, cfg.scale, 1.0, 1.0),
          child: _MiniPhoneFrame(url: shots[i]),
        );
      }),
    );
  }
}

class _MiniPhoneFrame extends StatelessWidget {
  final String url;
  const _MiniPhoneFrame({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 108,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3C), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.5),
        child: Image.asset(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2C2C2E)),
        ),
      ),
    );
  }
}

// ── Cover strip: wide image with gradient overlay ─────────────────────────────

class _CoverStripPreview extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _CoverStripPreview({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final url = project.imageUrls.first;
    final isNetwork = url.startsWith('http');

    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          isNetwork
              ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _shimmer(isDark),
                  errorWidget: (_, __, ___) => _shimmer(isDark),
                )
              : Image.asset(url, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _shimmer(isDark)),
          // Bottom gradient for readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (isDark ? AppColors.cardDark : AppColors.cardLight)
                        .withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer(bool isDark) => Container(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      );
}

// ── Code aesthetic: OSS / no-image projects ───────────────────────────────────

class _CodeAestheticPreview extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _CodeAestheticPreview({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isOSS = project.category == ProjectCategory.openSource;
    final IconData icon = isOSS ? FontAwesomeIcons.cube : Icons.code_rounded;
    final isFa = isOSS;

    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF111111), const Color(0xFF141414)]
              : [const Color(0xFFF5F5F5), const Color(0xFFEEEEEE)],
        ),
      ),
      child: Stack(
        children: [
          // Dotted grid pattern
          CustomPaint(
            size: Size.infinite,
            painter: _DotGridPainter(
              color: isDark
                  ? AppColors.borderDark.withValues(alpha: 0.6)
                  : AppColors.borderLight,
            ),
          ),
          // Center: category label + icon
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isFa
                    ? FaIcon(icon, size: 22,
                        color: AppColors.accent.withValues(alpha: 0.7))
                    : Icon(icon, size: 24,
                        color: AppColors.accent.withValues(alpha: 0.7)),
                const SizedBox(height: 6),
                Text(
                  isOSS ? 'OPEN SOURCE' : 'PROJECT',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
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

class _DotGridPainter extends CustomPainter {
  final Color color;
  _DotGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 18.0;
    const radius = 1.0;
    final paint = Paint()..color = color;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.color != color;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SMALL HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

class _CategoryBadge extends StatelessWidget {
  final Project project;
  const _CategoryBadge({required this.project});

  @override
  Widget build(BuildContext context) {
    final isOSS = project.category == ProjectCategory.openSource;
    final label = isOSS ? 'OSS' : 'App';
    final color = isOSS ? const Color(0xFF58A6FF) : AppColors.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}

class _TechRow extends StatelessWidget {
  final Project project;
  final bool isDark;
  const _TechRow({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final techs = project.technologies.take(3).toList();
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: techs.map((t) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Text(
            t,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CaseStudyCta extends StatelessWidget {
  final bool hovered;
  final VoidCallback onTap;
  const _CaseStudyCta({required this.hovered, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: hovered
              ? AppColors.accent.withValues(alpha: 0.14)
              : AppColors.accent.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hovered
                ? AppColors.accent.withValues(alpha: 0.55)
                : AppColors.accent.withValues(alpha: 0.22),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Case Study',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 5),
            AnimatedSlide(
              offset: hovered ? const Offset(0.35, 0) : Offset.zero,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.arrow_forward_rounded,
                  size: 12, color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared image helper ──────────────────────────────────────────────────────

Widget _projectImg(
    String url, double w, double h, BoxFit fit, bool isDark) {
  if (!url.startsWith('http')) {
    return Image.asset(url,
        width: w,
        height: h,
        fit: fit,
        errorBuilder: (_, __, ___) => SizedBox(width: w, height: h));
  }
  return CachedNetworkImage(
    imageUrl: url,
    width: w,
    height: h,
    fit: fit,
    placeholder: (_, __) => SizedBox(width: w, height: h),
    errorWidget: (_, __, ___) => SizedBox(width: w, height: h),
  );
}
