import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/hero_section.dart';
import '../../../core/widgets/portfolio_app_bar.dart';
import '../../../core/widgets/portfolio_drawer.dart';
import '../../../core/widgets/section_container.dart';
import '../../../core/widgets/works_section.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();
  final homeController = Get.find<HomeController>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToSection(GlobalKey key) async {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero);
      
      await _scrollController.animateTo(
        offset.dy - (MediaQuery.of(context).padding.top + kToolbarHeight),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PortfolioAppBar(
        onThemeToggle: homeController.toggleTheme,
        isDarkMode: homeController.isDarkMode.value,
        onProjectsPressed: () => _scrollToSection(projectsKey),
        onAboutPressed: () => _scrollToSection(aboutKey),
        onContactPressed: () => _scrollToSection(contactKey),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(
              key: aboutKey,
              name: 'Satya',
              title: 'Software Engineer | Flutter & Android Developer',
              description: 'B.Tech. (CSE) graduate from Roorkee Institute of Technology with 8.0 CGPA (2019-2023). Passionate about mobile development with expertise in Flutter and Android.',
              onContactPressed: () => _scrollToSection(contactKey),
              onResumePressed: () {},
            ),
            WorksSection(key: projectsKey),
            SectionContainer(
              title: 'Skills & Expertise',
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFF5F5F5)
                  : const Color(0xFF1E1E1E),
              child: Wrap(
                spacing: AppSpacing.h16,
                runSpacing: AppSpacing.v16,
                alignment: WrapAlignment.center,
                children: [
                  _buildSkillChip(context, 'Flutter'),
                  _buildSkillChip(context, 'Android'),
                  _buildSkillChip(context, 'Kotlin'),
                  _buildSkillChip(context, 'Java'),
                  _buildSkillChip(context, 'Dart'),
                  _buildSkillChip(context, 'Firebase'),
                  _buildSkillChip(context, 'Google Map'),
                  _buildSkillChip(context, 'Bloc'),
                  _buildSkillChip(context, 'GetX'),
                  _buildSkillChip(context, 'HealthKit'),
                  _buildSkillChip(context, 'GoogleFit'),
                  _buildSkillChip(context, 'CashFree'),
                ],
              ),
            ),
            SectionContainer(
              key: contactKey,
              title: 'Get in Touch',
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFF5F5F5)
                  : const Color(0xFF1E1E1E),
              child: Column(
                children: [
                  Text(
                    'Let\'s connect and discuss your next project!',
                    style: AppTypography.bodyLarge(context),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildContactButton(
                        context,
                        icon: Icons.email,
                        label: 'Email',
                        onTap: () => _launchUrl('mailto:satyaaa2399@gmail.com'),
                      ),
                      SizedBox(width: 16.w),
                      _buildContactButton(
                        context,
                        icon: Icons.code,
                        label: 'GitHub',
                        onTap: () => _launchUrl('https://github.com/saty-a'),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    '© ${DateTime.now().year} Satya. All rights reserved.',
                    style: AppTypography.bodySmall(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(BuildContext context, String label) {
    return Chip(
      label: Text(
        label,
        style: AppTypography.labelLarge(context).copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h16,
        vertical: AppSpacing.v8,
      ),
    );
  }

  Widget _buildContactButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24.r,
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: AppTypography.labelLarge(context).copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
