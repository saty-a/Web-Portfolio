import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_spacing.dart';
import '../../data/repositories/project_repository.dart';
import 'project_card.dart';
import 'section_container.dart';

class ProjectsSection extends StatelessWidget {
  final ProjectRepository _projectRepository = ProjectRepository();

  ProjectsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projects = _projectRepository.getFeaturedProjects();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 3 : (screenWidth > 800 ? 2 : 1);

    return SectionContainer(
      title: 'Featured Projects',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.medium,
          mainAxisSpacing: AppSpacing.medium,
          childAspectRatio: 0.8,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) => ProjectCard(
          project: projects[index],
        ),
      ),
    );
  }
} 