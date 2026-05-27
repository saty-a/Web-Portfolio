enum MilestoneType { education, work, openSource, achievement }

class CareerMilestone {
  final String year;
  final String title;
  final String organization;
  final String description;
  final MilestoneType type;
  final int sortOrder;
  final String? dateRange;       // e.g. "Dec 2022 – Jun 2023 · 7 mos"
  final String? employmentType;  // e.g. "Internship", "Full-time", "B.Tech"

  const CareerMilestone({
    required this.year,
    required this.title,
    required this.organization,
    this.description = '',
    this.type = MilestoneType.work,
    this.sortOrder = 0,
    this.dateRange,
    this.employmentType,
  });
}
