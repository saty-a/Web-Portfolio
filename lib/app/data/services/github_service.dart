import 'dart:convert';
import 'package:http/http.dart' as http;

// ─── Models ──────────────────────────────────────────────────────────────────

class GitHubRepo {
  final String name;
  final String? description;
  final int stars;
  final int forks;
  final String? language;
  final String url;
  final bool isForked;

  const GitHubRepo({
    required this.name,
    this.description,
    required this.stars,
    required this.forks,
    this.language,
    required this.url,
    this.isForked = false,
  });
}

class ContributionDay {
  final DateTime date;
  final int count;
  final int level; // 0–4

  const ContributionDay({
    required this.date,
    required this.count,
    required this.level,
  });
}

class GitHubStats {
  final int publicRepos;
  final int totalStars;
  final int totalCommitsThisYear;
  final int totalCommitsAllTime;
  final String memberSince;
  final String avatarUrl;
  final Map<String, int> topLanguages;
  final List<GitHubRepo> topRepos;
  final List<ContributionDay> contributions;

  const GitHubStats({
    required this.publicRepos,
    required this.totalStars,
    required this.totalCommitsThisYear,
    required this.totalCommitsAllTime,
    required this.memberSince,
    required this.avatarUrl,
    required this.topLanguages,
    required this.topRepos,
    required this.contributions,
  });
}

// ─── Service ─────────────────────────────────────────────────────────────────

class GitHubService {
  static const _username = 'saty-a';
  static const _base     = 'https://api.github.com';
  static const _headers  = {'Accept': 'application/vnd.github.v3+json'};

  // Cache to avoid hammering the API on hot-reloads
  static GitHubStats? _cache;
  static DateTime?    _cacheTime;
  static const _cacheTtl = Duration(minutes: 10);

  static void invalidateCache() {
    _cache     = null;
    _cacheTime = null;
  }

  static Future<GitHubStats> fetch() async {
    // Return cached data if fresh
    if (_cache != null &&
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _cacheTtl) {
      return _cache!;
    }

    // Phase 1: user + repos in parallel
    final phase1 = await Future.wait([_getUser(), _getRepos()]);
    final user  = phase1[0] as Map<String, dynamic>;
    final repos = phase1[1] as List<Map<String, dynamic>>;

    // Phase 2: all years of contributions in parallel
    final memberYear =
        (user['created_at'] as String?)?.substring(0, 4) ?? '${DateTime.now().year}';
    final contribs = await _getAllContributions(memberYear);

    // Aggregate repo data
    int totalStars  = 0;
    final langCount = <String, int>{};
    final repoList  = <GitHubRepo>[];

    for (final r in repos) {
      final stars = (r['stargazers_count'] as num?)?.toInt() ?? 0;
      final forks = (r['forks_count'] as num?)?.toInt() ?? 0;
      final lang  = r['language'] as String?;
      final fork  = r['fork'] as bool? ?? false;

      totalStars += stars;

      if (lang != null && lang.isNotEmpty) {
        langCount[lang] = (langCount[lang] ?? 0) + 1;
      }

      repoList.add(GitHubRepo(
        name: r['name'] as String? ?? '',
        description: r['description'] as String?,
        stars: stars,
        forks: forks,
        language: lang,
        url: r['html_url'] as String? ?? '',
        isForked: fork,
      ));
    }

    // Top repos by stars (own repos only)
    repoList.sort((a, b) => b.stars.compareTo(a.stars));
    final topRepos = repoList.where((r) => !r.isForked).take(5).toList();

    // Top languages (sorted by count)
    final sortedLangs = Map.fromEntries(
      langCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );

    // Commits this year from contributions
    final thisYear = DateTime.now().year.toString();
    final yearContribs = contribs
        .where((c) => c.date.year.toString() == thisYear)
        .fold<int>(0, (sum, c) => sum + c.count);

    // memberYear already declared above (used for contribution fetch)

    final allTimeContribs = contribs.fold<int>(0, (sum, c) => sum + c.count);

    _cache = GitHubStats(
      publicRepos:          (user['public_repos'] as num?)?.toInt() ?? 0,
      totalStars:           totalStars,
      totalCommitsThisYear: yearContribs,
      totalCommitsAllTime:  allTimeContribs,
      memberSince:          memberYear,
      avatarUrl:            user['avatar_url'] as String? ?? '',
      topLanguages:         sortedLangs,
      topRepos:             topRepos,
      contributions:        contribs,
    );
    _cacheTime = DateTime.now();
    return _cache!;
  }

  // ── GitHub REST API ──────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _getUser() async {
    final res = await http.get(
      Uri.parse('$_base/users/$_username'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('GitHub user fetch failed');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<List<Map<String, dynamic>>> _getRepos() async {
    final res = await http.get(
      Uri.parse('$_base/users/$_username/repos?per_page=100&sort=pushed'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('GitHub repos fetch failed');
    final list = jsonDecode(res.body) as List;
    return list.cast<Map<String, dynamic>>();
  }

  // ── Contribution graph via open-source proxy API ─────────────────────────
  // https://github-contributions-api.jogruber.de

  /// Fetch ALL years from [memberSince] to today in parallel.
  static Future<List<ContributionDay>> _getAllContributions(
      String memberSince) async {
    final start  = int.tryParse(memberSince) ?? DateTime.now().year;
    final end    = DateTime.now().year;
    final years  = List.generate(end - start + 1, (i) => start + i);
    final lists  = await Future.wait(years.map(_fetchYearContributions));
    return lists.expand((l) => l).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  static Future<List<ContributionDay>> _fetchYearContributions(int year) async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://github-contributions-api.jogruber.de/v4/$_username?y=$year'),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) return [];

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final list = data['contributions'] as List? ?? [];

      return list.map((e) {
        final m = e as Map<String, dynamic>;
        return ContributionDay(
          date:  DateTime.tryParse(m['date'] as String? ?? '') ?? DateTime.now(),
          count: (m['count'] as num?)?.toInt() ?? 0,
          level: (m['level'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
