import 'package:flutter/material.dart';

class Project {
  final String title;
  final String description;
  final String imageUrl;
  final String githubUrl;
  final String liveUrl;
  final List<String> technologies;
  final bool isFeatured;

  const Project({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.githubUrl,
    required this.liveUrl,
    required this.technologies,
    this.isFeatured = false,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      githubUrl: json['githubUrl'] as String,
      liveUrl: json['liveUrl'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      'technologies': technologies,
      'isFeatured': isFeatured,
    };
  }
} 