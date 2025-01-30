import '../models/project_model.dart';

class ProjectRepository {
  final List<Project> _projects = [
    Project(
      title: 'Flutter E-commerce App',
      description: 'A full-featured e-commerce application built with Flutter and Firebase, featuring real-time updates, cart management, and secure payments.',
      imageUrl: 'assets/images/projects/ecommerce.png',
      githubUrl: 'https://github.com/yourusername/flutter-ecommerce',
      liveUrl: 'https://flutter-ecommerce-demo.web.app',
      technologies: ['Flutter', 'Firebase', 'Stripe', 'GetX'],
      isFeatured: true,
    ),
    Project(
      title: 'Task Management Platform',
      description: 'A collaborative task management platform with real-time updates, team chat, and project analytics.',
      imageUrl: 'assets/images/projects/taskmanager.png',
      githubUrl: 'https://github.com/yourusername/task-manager',
      liveUrl: 'https://task-manager-demo.web.app',
      technologies: ['Flutter', 'Node.js', 'MongoDB', 'WebSocket'],
      isFeatured: true,
    ),
    Project(
      title: 'AI Image Generator',
      description: 'An AI-powered image generation app that creates unique artwork using deep learning models.',
      imageUrl: 'assets/images/projects/ai-generator.png',
      githubUrl: 'https://github.com/yourusername/ai-image-generator',
      liveUrl: 'https://ai-image-gen-demo.web.app',
      technologies: ['Flutter', 'Python', 'TensorFlow', 'Flask'],
      isFeatured: true,
    ),
  ];

  List<Project> getAllProjects() => _projects;
  
  List<Project> getFeaturedProjects() => _projects.where((project) => project.isFeatured).toList();
} 