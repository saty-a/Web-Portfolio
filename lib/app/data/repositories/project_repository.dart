import '../../core/constants/content.dart';
import '../models/career_milestone.dart';
import '../models/project_model.dart';

class ProjectRepository {
  List<Project> getFeaturedProjects() => AppContent.featuredProjects
      .where((p) => p.category == ProjectCategory.featured || p.category == ProjectCategory.openSource)
      .toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<Project> getSideProjects() => AppContent.sideProjects
      .where((p) => p.category == ProjectCategory.sideProject)
      .toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<CareerMilestone> getCareerMilestones() =>
      AppContent.careerMilestones.toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
}
