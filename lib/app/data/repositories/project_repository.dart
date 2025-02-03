import '../models/project_model.dart';

class ProjectRepository {
  final List<Project> _projects = [
    Project(
      title: 'Flutter E-commerce App',
      description: 'A modern e-commerce application built with Flutter, featuring a clean architecture with GetX pattern, responsive design, and seamless shopping experience.',
      imageUrl: 'assets/images/projects/ecommerce.png',
      githubUrl: 'https://github.com/saty-a/e-commerce',
      liveUrl: 'https://saty-a.github.io/e-commerce',
      technologies: ['Flutter', 'GetX', 'Clean Architecture', 'Responsive Design'],
      isFeatured: true,
    ),
    Project(
      title: 'Portfolio Website',
      description: 'A modern, responsive portfolio website built with Flutter Web, showcasing projects and skills with smooth animations and dark mode support.',
      imageUrl: 'assets/images/projects/portfolio.png',
      githubUrl: 'https://github.com/saty-a/portfolio',
      liveUrl: 'https://saty-a.github.io/portfolio',
      technologies: ['Flutter Web', 'GetX', 'Responsive Design', 'Animations'],
      isFeatured: true,
    ),
    Project(
      title: 'Flutter Weather App',
      description: 'A beautiful weather application built with Flutter, featuring real-time weather updates, location-based forecasts, and stunning UI animations.',
      imageUrl: 'assets/images/projects/weather.png',
      githubUrl: 'https://github.com/saty-a/weather-app',
      liveUrl: 'https://saty-a.github.io/weather-app',
      technologies: ['Flutter', 'Weather API', 'Animations', 'GetX'],
      isFeatured: true,
    ),
  ];

  List<Project> getAllProjects() => _projects;
  
  List<Project> getFeaturedProjects() => _projects.where((project) => project.isFeatured).toList();
} 