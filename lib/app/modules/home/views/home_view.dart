import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/hero_section.dart';
import '../../../core/widgets/portfolio_app_bar.dart';
import '../../../core/widgets/portfolio_drawer.dart';
import '../../../core/widgets/section_container.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: PortfolioAppBar(
        onThemeToggle: controller.toggleTheme,
        isDarkMode: controller.isDarkMode.value,
      ),
      drawer: const PortfolioDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(
              name: 'John Doe',
              title: 'Flutter Developer & UI/UX Designer',
              description:
                  'I create beautiful and functional mobile and web applications using Flutter. With a passion for clean code and pixel-perfect design, I bring ideas to life through elegant solutions.',
              onContactPressed: () {},
              onResumePressed: () {},
            ),
            SectionContainer(
              title: 'Featured Projects',
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 1100 ? 3 : 1,
                  crossAxisSpacing: AppSpacing.h24,
                  mainAxisSpacing: AppSpacing.v24,
                  mainAxisExtent: 400.h,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.cardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.r12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 64.r,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.v16),
                          Text(
                            'Project ${index + 1}',
                            style: AppTypography.titleLarge(context),
                          ),
                          SizedBox(height: AppSpacing.v8),
                          Text(
                            'A brief description of the project and its key features.',
                            style: AppTypography.bodyMedium(context),
                          ),
                          SizedBox(height: AppSpacing.v16),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('View Project'),
                              ),
                              SizedBox(width: AppSpacing.h8),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.code),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SectionContainer(
              title: 'Skills & Expertise',
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFF5F5F5)
                  : const Color(0xFF1E1E1E),
              child: Wrap(
                spacing: AppSpacing.h16,
                runSpacing: AppSpacing.v16,
                children: [
                  _buildSkillChip(context, 'Flutter'),
                  _buildSkillChip(context, 'Dart'),
                  _buildSkillChip(context, 'UI/UX Design'),
                  _buildSkillChip(context, 'Firebase'),
                  _buildSkillChip(context, 'REST APIs'),
                  _buildSkillChip(context, 'Git'),
                  _buildSkillChip(context, 'Clean Architecture'),
                  _buildSkillChip(context, 'State Management'),
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
}
