import '../models/project_model.dart';

class ProjectRepository {
  static final List<Project> projects = [
    Project(
      title: 'Flutter Web Portfolio',
      description: 'A responsive portfolio website built with Flutter Web, featuring dark mode support and smooth animations.',
      imageUrl: 'assets/images/projects/portfolio.png',
      githubUrl: 'https://github.com/yourusername/flutter-web-portfolio',
      liveUrl: 'https://yourportfolio.dev',
      technologies: ['Flutter', 'Dart', 'GetX', 'Responsive Design'],
    ),
    Project(
      title: 'E-Commerce App',
      description: 'A full-featured e-commerce application with cart management, user authentication, and payment integration.',
      imageUrl: 'assets/images/projects/ecommerce.png',
      githubUrl: 'https://github.com/yourusername/flutter-ecommerce',
      technologies: ['Flutter', 'Firebase', 'Stripe', 'State Management'],
    ),
    Project(
      title: 'Social Media Dashboard',
      description: 'A comprehensive dashboard for social media analytics with real-time data visualization.',
      imageUrl: 'assets/images/projects/dashboard.png',
      liveUrl: 'https://dashboard-demo.dev',
      technologies: ['Flutter', 'REST API', 'Charts', 'Analytics'],
    ),
  ];

  List<Project> getAllProjects() => projects;
  
  List<Project> getFeaturedProjects() => projects.where((project) => project.isFeatured).toList();
} 