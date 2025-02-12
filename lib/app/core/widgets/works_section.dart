import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'section_container.dart';

class WorksSection extends StatelessWidget {
  const WorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'Featured Works',
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF5F5F5)
          : const Color(0xFF1E1E1E),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final crossAxisCount = screenWidth > 1200 ? 3 : (screenWidth > 800 ? 2 : 1);
          
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.h24,
              mainAxisSpacing: AppSpacing.v24,
              childAspectRatio: 1.2,
            ),
            itemCount: works.length,
            itemBuilder: (context, index) {
              final work = works[index];
              return _WorkCard(work: work);
            },
          );
        },
      ),
    );
  }
}

class _WorkCard extends StatelessWidget {
  final Work work;

  const _WorkCard({required this.work});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: work.imageUrl.startsWith('http')
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: work.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.work,
                            size: 64.r,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.work,
                        size: 64.r,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
            ),
            Text(
              work.title,
              style: AppTypography.titleLarge(context),
            ),
            SizedBox(height: 8.h),
            Text(
              work.description,
              style: AppTypography.bodyMedium(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                if (work.playStoreUrl == null) 
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (work.demoUrl != null) {
                          _launchUrl(work.demoUrl!);
                        }
                      },
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('View Project'),
                    ),
                  ),
                if (work.playStoreUrl != null || work.appStoreUrl != null) ...[
                  if (work.playStoreUrl != null)
                    Expanded(
                      child: InkWell(
                        onTap: () => _launchUrl(work.playStoreUrl!),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: 'https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png',
                            height: 40.r,
                            placeholder: (context, url) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20.r,
                                  width: 20.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            errorWidget: (context, url, error) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_circle,
                                  size: 24.r,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Play Store',
                                  style: AppTypography.labelMedium(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (work.appStoreUrl != null) ...[
                    if (work.playStoreUrl != null) SizedBox(width: 12.w),
                    Expanded(
                      child: InkWell(
                        onTap: () => _launchUrl(work.appStoreUrl!),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: 'https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.png',
                            height: 40.r,
                            placeholder: (context, url) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20.r,
                                  width: 20.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            errorWidget: (context, url, error) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.apple,
                                  size: 24.r,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'App Store',
                                  style: AppTypography.labelMedium(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Work {
  final String title;
  final String description;
  final String imageUrl;
  final String? demoUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;

  const Work({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.demoUrl,
    this.playStoreUrl,
    this.appStoreUrl,
  });
}

final List<Work> works = [
  Work(
    title: 'E-commerce',
    description: 'Flutter e-commerce app with dashboard, wishlist, and product management. Built using Flutter, Dart, Firebase, Google Map, and Bloc/Cubit with freezed.',
    imageUrl: 'assets/images/works/ecommerce.jpg',
    demoUrl: 'https://github.com/saty-a/e-commerce',
  ),
  Work(
    title: 'PAWPULAR-Walk to Earn',
    description: 'Pet walking app with Google Fit API, HealthKit integration, and geolocation services. Available on both Play Store and App Store.',
    imageUrl: 'https://play-lh.googleusercontent.com/VoajiqefzfF-C-ElZXmxcqcuOHL1FCqUicYkWjXJrBMHQZKQEXuewuaaGaChL4ceNsM=w480-h960-rw',
    demoUrl: 'https://github.com/saty-a/Advocate-App',
    playStoreUrl: 'https://play.google.com/store/apps/details?id=com.pawpular.pawpular',
    appStoreUrl: 'https://apps.apple.com/in/app/pawpular-walk-to-earn-rewards/id6447305426',
  ),
  Work(
    title: 'Laathi',
    description: 'Healthcare app with chat, file sharing, Aadhaar verification via Cashfree, and medication management. Available on Play Store.',
    imageUrl: 'https://play-lh.googleusercontent.com/gRtr338QpO0H2m7j7IGhvK-5tAqjnnOp1TgDYlO_zeNFFQ1S0rs6LRZj06rzgP-8cQo=w480-h960-rw',
    demoUrl: 'https://github.com/saty-a/laathi',
    playStoreUrl: 'https://play.google.com/store/apps/details?id=org.techshy.laathi',
  ),
  Work(
    title: 'ImageKit Android SDK',
    description: 'Revamped open-source SDK with enhanced functionality, URL constructors via builder pattern, and comprehensive testing.',
    imageUrl: 'assets/images/works/imagekit.jpg',
    demoUrl: 'https://github.com/imagekit-developer/imagekit-android',
  ),
]; 