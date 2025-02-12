import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/project_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Image.asset(
              project.imageUrl,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: AppTypography.titleLarge(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  project.description,
                  style: AppTypography.bodyMedium(context),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: project.technologies
                      .map((tech) => Chip(
                            label: Text(
                              tech,
                              style: AppTypography.labelSmall(context),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          ))
                      .toList(),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (project.githubUrl != null)
                      IconButton(
                        icon: const Icon(Icons.code),
                        onPressed: () {
                          // TODO: Implement URL launcher
                        },
                      ),
                    if (project.liveUrl != null)
                      IconButton(
                        icon: const Icon(Icons.launch),
                        onPressed: () {
                          // TODO: Implement URL launcher
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 