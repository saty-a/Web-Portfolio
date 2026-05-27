import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/content.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'copy_email_button.dart';
import 'responsive_layout.dart';
import 'scroll_fade_in.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  Future<void> _launchUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Divider
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
              child: ScrollFadeIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Let\'s build something.',
                      style: AppTypography.displaySmall(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Open to full-time Flutter roles and freelance projects. Reach out directly.',
                      style: AppTypography.bodyLarge(context),
                    ),
                    const SizedBox(height: 32),
                    // Email + GitHub + LinkedIn
                    Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: [
                        const CopyEmailButton(email: AppContent.email),
                        _FooterTextLink(
                          icon: FontAwesomeIcons.github,
                          label: 'GitHub',
                          onTap: () => _launchUrl(AppContent.githubUrl),
                          isDark: isDark,
                        ),
                        _FooterTextLink(
                          icon: FontAwesomeIcons.linkedin,
                          label: 'LinkedIn',
                          onTap: () => _launchUrl(AppContent.linkedInUrl),
                          isDark: isDark,
                        ),
                      ],
                    ),
                    SizedBox(height: isMobile ? 64 : 100),
                    // Copyright - simple, small
                    Text(
                      '\u00a9 ${DateTime.now().year} ${AppContent.name}',
                      style: AppTypography.labelSmall(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterTextLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _FooterTextLink({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_FooterTextLink> createState() => _FooterTextLinkState();
}

class _FooterTextLinkState extends State<_FooterTextLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _hovered
        ? (widget.isDark ? AppColors.primaryDark : AppColors.primaryLight)
        : (widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: AppTypography.bodySmall(context).copyWith(
                color: color,
                decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
