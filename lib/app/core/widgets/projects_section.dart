import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';
import 'project_card.dart';
import 'section_container.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = ProjectRepository.projects;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 3 : (screenWidth > 800 ? 2 : 1);
    final childAspectRatio = screenWidth > 1200 ? 1.3 : (screenWidth > 800 ? 1.2 : 1.1);

    return SectionContainer(
      title: 'Featured Projects',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 24.w,
          mainAxisSpacing: 24.h,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) => ProjectCard(
          project: projects[index],
        ),
      ),
    );
  }
} 