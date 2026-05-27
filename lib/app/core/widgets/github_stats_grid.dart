import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/services/github_service.dart';
import '../theme/app_colors.dart';

// ─── helpers ─────────────────────────────────────────────────────────────────
String _ghFmt(int n) =>
    n >= 1000 ? '${(n / 1000).toStringAsFixed(n >= 10000 ? 0 : 1)}K' : '$n';

/// Scales down to [scale] on press; calls [onTap] on release.
class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  const _TapScale({required this.child, this.onTap, this.scale = 0.88});

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:  (_) => setState(() => _pressed = true),
      onTapUp:    (_) { setState(() => _pressed = false); widget.onTap?.call(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale:    _pressed ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 90),
        curve:    Curves.easeOut,
        child:    widget.child,
      ),
    );
  }
}

/// Grows to [hoverScale] on mouse-enter; shrinks back on exit.
class _HoverScale extends StatefulWidget {
  final Widget child;
  final double hoverScale;
  const _HoverScale({required this.child, this.hoverScale = 1.5});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale:    _hovered ? widget.hoverScale : 1.0,
        duration: const Duration(milliseconds: 100),
        curve:    Curves.easeOut,
        child:    widget.child,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PUBLIC ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

class GitHubStatsGrid extends StatefulWidget {
  final bool isDark;
  const GitHubStatsGrid({super.key, required this.isDark});

  @override
  State<GitHubStatsGrid> createState() => _GitHubStatsGridState();
}

class _GitHubStatsGridState extends State<GitHubStatsGrid> {
  late Future<GitHubStats> _future;

  @override
  void initState() {
    super.initState();
    _future = GitHubService.fetch();
  }

  void _refresh() {
    GitHubService.invalidateCache();
    setState(() => _future = GitHubService.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──
        Row(
          children: [
            Container(
              width: 3, height: 12,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'GITHUB STATS',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: AppColors.accent,
              ),
            ),
            const Spacer(),
            // Refresh button
            _GhIconBtn(
              icon: Icons.refresh_rounded,
              isDark: widget.isDark,
              onTap: _refresh,
              tooltip: 'Refresh',
            ),
            const SizedBox(width: 6),
            // Profile link
            _GhIconBtn(
              icon: FontAwesomeIcons.github,
              isDark: widget.isDark,
              isFa: true,
              onTap: () => launchUrl(
                Uri.parse('https://github.com/saty-a'),
                mode: LaunchMode.externalApplication,
              ),
              tooltip: 'github.com/saty-a',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Data ──
        FutureBuilder<GitHubStats>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return _LoadingSkeleton(isDark: widget.isDark);
            }
            if (snap.hasError || !snap.hasData) {
              return _ErrorState(isDark: widget.isDark, onRetry: _refresh);
            }
            return _StatsContent(stats: snap.data!, isDark: widget.isDark);
          },
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATS CONTENT (loaded state)
// ═══════════════════════════════════════════════════════════════════════════════

class _StatsContent extends StatelessWidget {
  final GitHubStats stats;
  final bool isDark;
  const _StatsContent({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: 4 number stat tiles
        _NumRow(stats: stats, isDark: isDark),
        const SizedBox(height: 8),

        // Row 2: Languages bar + this-year commits side by side
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: _LanguageCard(stats: stats, isDark: isDark),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: _CommitCard(stats: stats, isDark: isDark),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Row 3: Contribution heatmap (full width)
        if (stats.contributions.isNotEmpty)
          _HeatmapCard(
            contributions: stats.contributions,
            memberSince: stats.memberSince,
            isDark: isDark,
          ),

      ],
    );
  }
}

// ─── Row 1: 4 stat number tiles ───────────────────────────────────────────────

class _NumRow extends StatelessWidget {
  final GitHubStats stats;
  final bool isDark;
  const _NumRow({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cells = [
      ('★',  _ghFmt(stats.totalStars),           'Stars',    AppColors.accent),
      ('⑂',  '${stats.publicRepos}',             'Repos',    const Color(0xFF58A6FF)),
      ('↗',  _ghFmt(stats.totalCommitsAllTime),  'Commits',  const Color(0xFF3FB950)),
      ('◈',  '${stats.topLanguages.length}',     'Languages',const Color(0xFFFFB347)),
    ];

    return Row(
      children: List.generate(cells.length * 2 - 1, (i) {
        if (i.isOdd) return const SizedBox(width: 6);
        final c = cells[i ~/ 2];
        return Expanded(
          child: _NumTile(
            symbol: c.$1,
            value:  c.$2,
            label:  c.$3,
            color:  c.$4,
            isDark: isDark,
          ),
        );
      }),
    );
  }
}

class _NumTile extends StatefulWidget {
  final String symbol;
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _NumTile({
    required this.symbol,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  State<_NumTile> createState() => _NumTileState();
}

class _NumTileState extends State<_NumTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) => setState(() => _pressed = false),
      onTapCancel: ()  => setState(() => _pressed = false),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale:    _pressed ? 0.90 : 1.0,
          duration: const Duration(milliseconds: 80),
          curve:    Curves.easeOut,
          child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: _hovered
              ? widget.color.withValues(alpha: 0.08)
              : (widget.isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered
                ? widget.color.withValues(alpha: 0.4)
                : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1,
                color: _hovered
                    ? widget.color
                    : (widget.isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: widget.isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
            ),
          ],
        ),
      ),    // AnimatedContainer
    ),      // AnimatedScale
  ),        // MouseRegion
);          // GestureDetector
  }
}

// ─── Language card ────────────────────────────────────────────────────────────

const _langColors = {
  'Dart':       Color(0xFF40C4FF),
  'Kotlin':     Color(0xFF7F52FF),
  'Swift':      Color(0xFFFF6B35),
  'Java':       Color(0xFFED8B00),
  'JavaScript': Color(0xFFF7DF1E),
  'TypeScript': Color(0xFF3178C6),
  'Python':     Color(0xFF3776AB),
  'HTML':       Color(0xFFE34F26),
  'CSS':        Color(0xFF1572B6),
  'Ruby':       Color(0xFFCC342D),
  'Go':         Color(0xFF00ACD7),
  'Rust':       Color(0xFFDEA584),
  'C++':        Color(0xFF00599C),
  'C':          Color(0xFFA8B9CC),
  'Shell':      Color(0xFF89E051),
};

Color _langColor(String lang) =>
    _langColors[lang] ?? AppColors.accent;

class _LanguageCard extends StatelessWidget {
  final GitHubStats stats;
  final bool isDark;
  const _LanguageCard({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final langs = stats.topLanguages.entries.take(5).toList();
    if (langs.isEmpty) return const SizedBox.shrink();

    final total = langs.fold<int>(0, (s, e) => s + e.value);

    return _GhCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardLabel(label: 'LANGUAGES', isDark: isDark),
          const SizedBox(height: 10),

          // Segmented bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Row(
              children: langs.map((e) {
                final frac = e.value / total;
                return Expanded(
                  flex: (frac * 100).round().clamp(1, 100),
                  child: Container(
                    height: 5,
                    color: _langColor(e.key),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Language rows
          ...langs.map((e) {
            final pct = ((e.value / total) * 100).round();
            final color = _langColor(e.key);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      e.key,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  // Mini bar
                  SizedBox(
                    width: 50,
                    child: Stack(
                      children: [
                        Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: e.value / total,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '$pct%',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Commits this year card ───────────────────────────────────────────────────

class _CommitCard extends StatelessWidget {
  final GitHubStats stats;
  final bool isDark;
  const _CommitCard({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _GhCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CardLabel(label: 'THIS YEAR', isDark: isDark),
          const SizedBox(height: 8),
          Text(
            '${stats.totalCommitsThisYear}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'contributions',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 12),
          _CardLabel(label: 'MEMBER SINCE', isDark: isDark),
          const SizedBox(height: 4),
          Text(
            stats.memberSince,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF58A6FF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${DateTime.now().year - (int.tryParse(stats.memberSince) ?? DateTime.now().year)} yrs on GitHub',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Contribution heatmap ─────────────────────────────────────────────────────

class _HeatmapCard extends StatefulWidget {
  final List<ContributionDay> contributions;
  final String memberSince;
  final bool isDark;
  const _HeatmapCard({
    required this.contributions,
    required this.memberSince,
    required this.isDark,
  });

  @override
  State<_HeatmapCard> createState() => _HeatmapCardState();
}

class _HeatmapCardState extends State<_HeatmapCard> {
  late int _selectedYear;
  late List<int> _years;
  late ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    final start = int.tryParse(widget.memberSince) ?? DateTime.now().year;
    final end   = DateTime.now().year;
    _years = List.generate(end - start + 1, (i) => start + i);
    _selectedYear = end;
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.animateTo(
      (_scrollCtrl.offset - 104).clamp(0.0, _scrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.animateTo(
      (_scrollCtrl.offset + 104).clamp(0.0, _scrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _selectYear(int y) {
    setState(() => _selectedYear = y);
    if (_scrollCtrl.hasClients) _scrollCtrl.jumpTo(0);
  }

  // ── Calendar helpers ──────────────────────────────────────────────────────

  /// Sunday-aligned grid bounds for [year].
  ({DateTime gridStart, int totalWeeks}) _yearBounds(int year) {
    final jan1      = DateTime(year, 1, 1);
    final sunOff    = jan1.weekday % 7; // Mon=1..Sun=7 → Sun≡0
    final start     = jan1.subtract(Duration(days: sunOff));
    final dec31     = DateTime(year, 12, 31);
    final satOff    = (6 - dec31.weekday % 7) % 7;
    final end       = dec31.add(Duration(days: satOff));
    final weeks     = end.difference(start).inDays ~/ 7 + 1;
    return (gridStart: start, totalWeeks: weeks);
  }

  List<({String name, int col})> _monthCols(DateTime gridStart, int totalWeeks) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final out = <({String name, int col})>[];
    for (int m = 1; m <= 12; m++) {
      final col = DateTime(_selectedYear, m, 1).difference(gridStart).inDays ~/ 7;
      if (col >= 0 && col < totalWeeks) out.add((name: names[m - 1], col: col));
    }
    return out;
  }

  Color _cellColor(ContributionDay? day, {bool inYear = true}) {
    if (!inYear) return Colors.transparent;
    if (day == null || day.count == 0) {
      return widget.isDark ? AppColors.borderDark : const Color(0xFFEBEDF0);
    }
    final l = day.level.clamp(0, 4);
    const dark  = [Color(0xFF161B22), Color(0xFF0E4429), Color(0xFF006D32), Color(0xFF26A641), Color(0xFF39D353)];
    const light = [Color(0xFFEBEDF0), Color(0xFF9BE9A8), Color(0xFF40C463), Color(0xFF30A14E), Color(0xFF216E39)];
    return widget.isDark ? dark[l] : light[l];
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _fmtDate(DateTime d) {
    const months = ['January','February','March','April','May','June',
                    'July','August','September','October','November','December'];
    const wdays  = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return '${wdays[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final yearContribs = widget.contributions
        .where((c) => c.date.year == _selectedYear)
        .toList();
    final byDate   = {for (final c in yearContribs) _dateKey(c.date): c};
    final total    = yearContribs.fold(0, (s, c) => s + c.count);
    final (:gridStart, :totalWeeks) = _yearBounds(_selectedYear);
    final months   = _monthCols(gridStart, totalWeeks);

    const cellSz   = 11.0;
    const gap      = 2.5;
    const dayW     = 28.0;
    const dayLabels = ['', 'Mon', '', 'Wed', '', 'Fri', ''];

    return _GhCard(
      isDark: widget.isDark,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: label + year tabs ────────────────────────────────
          Row(
            children: [
              _CardLabel(label: 'CONTRIBUTIONS', isDark: widget.isDark),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _years.map((y) {
                      final sel = y == _selectedYear;
                      return _TapScale(
                        onTap: () => _selectYear(y),
                        scale: 0.88,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 140),
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.accent.withValues(alpha: 0.13)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: sel
                                    ? AppColors.accent.withValues(alpha: 0.45)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              '$y',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                fontWeight:
                                    sel ? FontWeight.w700 : FontWeight.w400,
                                color: sel
                                    ? AppColors.accent
                                    : (widget.isDark
                                        ? AppColors.textTertiaryDark
                                        : AppColors.textTertiaryLight),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Grid: fixed day labels + scrollable month/cells ──────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed day labels (offset by month-label row height)
              Padding(
                padding: const EdgeInsets.only(top: 14 + 4),
                child: SizedBox(
                  width: dayW,
                  child: Column(
                    children: List.generate(7, (i) => SizedBox(
                      height: cellSz + gap,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            dayLabels[i],
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 7,
                              color: widget.isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Scrollable: month labels + week columns
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month labels
                      SizedBox(
                        height: 14,
                        width: totalWeeks * (cellSz + gap),
                        child: Stack(
                          children: months
                              .map((ml) => Positioned(
                                    left: ml.col * (cellSz + gap),
                                    child: Text(
                                      ml.name,
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 8,
                                        color: widget.isDark
                                            ? AppColors.textTertiaryDark
                                            : AppColors.textTertiaryLight,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Week columns
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(totalWeeks, (week) {
                          return Padding(
                            padding: const EdgeInsets.only(right: gap),
                            child: Column(
                              children: List.generate(7, (day) {
                                final date = gridStart
                                    .add(Duration(days: week * 7 + day));
                                final inYear = date.year == _selectedYear;
                                final contrib = byDate[_dateKey(date)];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: gap),
                                  child: Tooltip(
                                    richMessage: TextSpan(children: [
                                      TextSpan(
                                        text: inYear
                                            ? (contrib != null &&
                                                    contrib.count > 0
                                                ? '${contrib.count} contribution${contrib.count == 1 ? '' : 's'}\n'
                                                : 'No contributions\n')
                                            : '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: 11,
                                          height: 1.5,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _fmtDate(date),
                                        style: const TextStyle(
                                          color: Color(0xFFCDD9E5),
                                          fontSize: 10,
                                          height: 1.4,
                                        ),
                                      ),
                                    ]),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2D333B),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withValues(alpha: 0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    preferBelow: false,
                                    child: _HoverScale(
                                      hoverScale: 1.55,
                                      child: Container(
                                        width: cellSz,
                                        height: cellSz,
                                        decoration: BoxDecoration(
                                          color: _cellColor(contrib,
                                              inYear: inYear),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Scroll arrow buttons ─────────────────────────────────────
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: dayW + 4),
            child: Row(
              children: [
                _GhIconBtn(
                  icon: Icons.chevron_left_rounded,
                  isDark: widget.isDark,
                  onTap: _scrollLeft,
                  tooltip: '← 8 weeks',
                ),
                const SizedBox(width: 4),
                _GhIconBtn(
                  icon: Icons.chevron_right_rounded,
                  isDark: widget.isDark,
                  onTap: _scrollRight,
                  tooltip: '8 weeks →',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Footer: count + legend ───────────────────────────────────
          Row(
            children: [
              Flexible(
                child: Text(
                  '$total contribution${total == 1 ? '' : 's'} in $_selectedYear',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: widget.isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text('Less',
                      style: GoogleFonts.jetBrainsMono(
                          fontSize: 8,
                          color: widget.isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight)),
                  ...List.generate(
                    5,
                    (i) => Container(
                      width: 9,
                      height: 9,
                      margin: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: _cellColor(i == 0
                            ? null
                            : ContributionDay(
                                date: DateTime.now(), count: i, level: i)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text('More',
                      style: GoogleFonts.jetBrainsMono(
                          fontSize: 8,
                          color: widget.isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LOADING SKELETON
// ═══════════════════════════════════════════════════════════════════════════════

class _LoadingSkeleton extends StatefulWidget {
  final bool isDark;
  const _LoadingSkeleton({required this.isDark});

  @override
  State<_LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<_LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _shimmer = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) {
        final opacity = 0.3 + _shimmer.value * 0.3;
        final base = widget.isDark ? AppColors.cardDark : AppColors.cardLight;
        final shimColor = base.withValues(alpha: opacity);

        return Column(
          children: [
            // 4 stat tiles
            Row(
              children: List.generate(7, (i) {
                if (i.isOdd) return const SizedBox(width: 6);
                return Expanded(
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: shimColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: shimColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: shimColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: shimColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ERROR STATE
// ═══════════════════════════════════════════════════════════════════════════════

class _ErrorState extends StatelessWidget {
  final bool isDark;
  final VoidCallback onRetry;
  const _ErrorState({required this.isDark, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded,
              size: 16,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Could not load GitHub stats',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ),
          GestureDetector(
            onTap: onRetry,
            child: Text(
              'Retry',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED PRIMITIVES
// ═══════════════════════════════════════════════════════════════════════════════

class _GhCard extends StatelessWidget {
  final bool isDark;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GhCard({
    required this.isDark,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: child,
    );
  }
}

class _CardLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _CardLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
      ),
    );
  }
}

class _GhIconBtn extends StatefulWidget {
  final dynamic icon;
  final bool isDark;
  final bool isFa;
  final VoidCallback onTap;
  final String tooltip;

  const _GhIconBtn({
    required this.icon,
    required this.isDark,
    required this.onTap,
    required this.tooltip,
    this.isFa = false,
  });

  @override
  State<_GhIconBtn> createState() => _GhIconBtnState();
}

class _GhIconBtnState extends State<_GhIconBtn> {
  bool _hovered  = false;
  bool _pressed  = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap:       widget.onTap,
          onTapDown:   (_) => setState(() => _pressed = true),
          onTapUp:     (_) => setState(() => _pressed = false),
          onTapCancel: ()  => setState(() => _pressed = false),
          child: AnimatedScale(
            scale:    _pressed ? 0.78 : 1.0,
            duration: const Duration(milliseconds: 80),
            curve:    Curves.easeOut,
            child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: widget.isFa
                ? FaIcon(widget.icon as IconData,
                    size: 13,
                    color: _hovered
                        ? AppColors.accent
                        : (widget.isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight))
                : Icon(widget.icon as IconData,
                    size: 15,
                    color: _hovered
                        ? AppColors.accent
                        : (widget.isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight)),
          ),        // AnimatedContainer
        ),          // AnimatedScale
      ),            // GestureDetector
    ),              // MouseRegion
  );               // Tooltip
  }
}

// ignore: unused_element
double _clamp(double v, double lo, double hi) => math.max(lo, math.min(hi, v));
