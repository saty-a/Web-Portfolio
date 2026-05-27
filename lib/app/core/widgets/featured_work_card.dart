import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/project_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'responsive_layout.dart';
import 'store_badge.dart';

class FeaturedWorkCard extends StatelessWidget {
  final Project project;

  const FeaturedWorkCard({super.key, required this.project});

  Future<void> _launchUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full-width image(s)
        if (project.imageUrls.isNotEmpty)
          ...project.imageUrls.map((url) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildImage(url, isDark),
              )),
        const SizedBox(height: 8),
        // Project title
        Text(
          project.title,
          style: isMobile
              ? AppTypography.headlineSmall(context)
              : AppTypography.headlineMedium(context),
        ),
        if (project.role != null) ...[
          const SizedBox(height: 4),
          Text(
            project.role!,
            style: AppTypography.bodySmall(context),
          ),
        ],
        const SizedBox(height: 12),
        // Description
        Text(
          project.longDescription.isNotEmpty
              ? project.longDescription
              : project.shortDescription,
          style: AppTypography.bodyMedium(context),
        ),
        const SizedBox(height: 16),
        // Tech stack
        Text(
          project.technologies.join(' · '),
          style: AppTypography.mono(context),
        ),
        const SizedBox(height: 20),
        // Store badges row
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
      ],
    );
  }

  Widget _buildImage(String url, bool isDark) {
    final isNetwork = url.startsWith('http');
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: isNetwork
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => _placeholder(isDark),
            )
          : Image.asset(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _placeholder(isDark),
            ),
    );
  }

  Widget _placeholder(bool isDark) {
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
        ),
      ),
    );
  }
}
