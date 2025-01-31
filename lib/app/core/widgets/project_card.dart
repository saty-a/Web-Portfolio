import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../../data/models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    Key? key,
    required this.project,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              project.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: AppTypography.h3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.small),
                Text(
                  project.description,
                  style: AppTypography.body2,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.medium),
                Wrap(
                  spacing: AppSpacing.small,
                  runSpacing: AppSpacing.small,
                  children: project.technologies
                      .map((tech) => Chip(
                            label: Text(tech),
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            labelStyle: AppTypography.caption.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: AppSpacing.medium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.code),
                      onPressed: () => _launchUrl(project.githubUrl),
                      tooltip: 'View Code',
                    ),
                    IconButton(
                      icon: const Icon(Icons.launch),
                      onPressed: () => _launchUrl(project.liveUrl),
                      tooltip: 'Live Demo',
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