import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/content.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'avatar_with_effect.dart';
import 'copy_email_button.dart';
import 'skills_section.dart';

class AboutColumn extends StatelessWidget {
  final bool shrinkWrap;
  const AboutColumn({super.key, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = _buildContent(context, isDark);

    if (shrinkWrap) {
      return Padding(padding: const EdgeInsets.fromLTRB(24, 0, 24, 24), child: content);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: content,
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    final primary   = isDark ? AppColors.textPrimaryDark   : AppColors.textPrimaryLight;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final tertiary  = isDark ? AppColors.textTertiaryDark  : AppColors.textTertiaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Creative section label ─────────────────────────────────────
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              '{ }',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'engineer.dart',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                letterSpacing: 0.8,
                color: tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Avatar ────────────────────────────────────────────────────
        LayoutBuilder(
          builder: (_, constraints) {
            final size = (constraints.maxWidth * 0.32).clamp(80.0, 140.0);
            return AvatarWithEffect(size: size);
          },
        ),
        const SizedBox(height: 16),

        // ── Name ──────────────────────────────────────────────────────
        Text(
          AppContent.name,
          style: AppTypography.headlineMedium(context).copyWith(
            color: primary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),

        // ── Role chip ─────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.30),
            ),
          ),
          child: Text(
            'Flutter Developer',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: AppColors.accent,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ── Location ──────────────────────────────────────────────────
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 12, color: tertiary),
            const SizedBox(width: 4),
            Text(
              'New Delhi, India',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: tertiary,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Divider ───────────────────────────────────────────────────
        Divider(color: isDark ? AppColors.borderDark : AppColors.borderLight, height: 1),
        const SizedBox(height: 20),

        // ── Bio ───────────────────────────────────────────────────────
        Text(
          AppContent.aboutIntro,
          style: AppTypography.bodyMedium(context).copyWith(
            color: primary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppContent.aboutBio,
          style: AppTypography.bodySmall(context).copyWith(
            color: secondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),

        // ── Social links ──────────────────────────────────────────────
        Row(
          children: [
            _IconLink(
              icon: FontAwesomeIcons.github,
              onTap: () => launchUrl(Uri.parse(AppContent.githubUrl)),
              isDark: isDark,
            ),
            const SizedBox(width: 12),
            _IconLink(
              icon: FontAwesomeIcons.linkedin,
              onTap: () => launchUrl(Uri.parse(AppContent.linkedInUrl)),
              isDark: isDark,
            ),
            const SizedBox(width: 16),
            const Flexible(child: CopyEmailButton(email: AppContent.email)),
          ],
        ),
        const SizedBox(height: 32),

        // ── Role details ──────────────────────────────────────────────
        ...AppContent.roleDetails.map((detail) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel(context, detail.key, isDark),
              const SizedBox(height: 8),
              Text(
                detail.value,
                style: AppTypography.bodySmall(context).copyWith(
                  color: secondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        )),
        const SizedBox(height: 8),
        const SkillsSection(shrinkWrap: true),
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String text, bool isDark) {
    return Text(
      text,
      style: AppTypography.labelSmall(context).copyWith(
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
      ),
    );
  }
}

class _IconLink extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _IconLink({required this.icon, required this.onTap, required this.isDark});

  @override
  State<_IconLink> createState() => _IconLinkState();
}

class _IconLinkState extends State<_IconLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.cardDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? AppColors.accent.withValues(alpha: 0.5) : Colors.transparent,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }
}
