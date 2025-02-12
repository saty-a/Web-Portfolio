import 'package:flutter/material.dart';

class Project {
  final String title;
  final String description;
  final String imageUrl;
  final String? liveUrl;
  final String? githubUrl;
  final List<String> technologies;
  final bool isFeatured;

  const Project({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.liveUrl,
    this.githubUrl,
    required this.technologies,
    this.isFeatured = false,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      liveUrl: json['liveUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      technologies: List<String>.from(json['technologies'] as List),
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'liveUrl': liveUrl,
      'githubUrl': githubUrl,
      'technologies': technologies,
      'isFeatured': isFeatured,
    };
  }
} 