import 'package:flutter/material.dart';

enum ProjectCategory { featured, sideProject, openSource }

// ─── Case study extras ────────────────────────────────────────────────────────

class CaseStudyMetric {
  final String value;
  final String label;
  final IconData icon;

  const CaseStudyMetric({
    required this.value,
    required this.label,
    this.icon = Icons.trending_up_rounded,
  });
}

class CaseStudyFeature {
  final String name;
  final String description;
  final IconData icon;

  const CaseStudyFeature({
    required this.name,
    required this.description,
    this.icon = Icons.star_rounded,
  });
}

// ─── Project model ────────────────────────────────────────────────────────────

class Project {
  final String title;
  final String shortDescription;
  final String longDescription;
  final List<String> imageUrls;
  final String? githubUrl;
  final String? liveUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? windowsStoreUrl;
  final String? macStoreUrl;
  final List<String> technologies;
  final ProjectCategory category;
  final String? role;
  final int sortOrder;

  // ── Case study fields ──
  final String? tagline;
  final String? logoUrl;
  final String? problem;
  final String? solution;
  final List<CaseStudyMetric> metrics;
  final List<CaseStudyFeature> features;
  final List<String> screenshotUrls;

  const Project({
    required this.title,
    required this.shortDescription,
    this.longDescription = '',
    this.imageUrls = const [],
    this.githubUrl,
    this.liveUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    this.windowsStoreUrl,
    this.macStoreUrl,
    required this.technologies,
    this.category = ProjectCategory.featured,
    this.role,
    this.sortOrder = 0,
    // case study
    this.tagline,
    this.logoUrl,
    this.problem,
    this.solution,
    this.metrics = const [],
    this.features = const [],
    this.screenshotUrls = const [],
  });

  bool get hasCaseStudy =>
      (problem != null && problem!.isNotEmpty) ||
      (solution != null && solution!.isNotEmpty) ||
      metrics.isNotEmpty ||
      features.isNotEmpty;
}
