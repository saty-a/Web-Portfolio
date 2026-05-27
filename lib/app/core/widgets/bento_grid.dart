import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'responsive_layout.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BentoGrid — public entry point
// ─────────────────────────────────────────────────────────────────────────────

class BentoGrid extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;

  const BentoGrid({super.key, required this.isDark, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= ResponsiveLayout.tabletBreakpoint) return _desktop();
    if (w >= ResponsiveLayout.mobileBreakpoint) return _tablet();
    return _mobile();
  }

  // ── Desktop ≥1024 ─────────────────────────────────────────────────────────
  Widget _desktop() {
    return SizedBox(
      height: 64,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _TimeBarCard(isDark: isDark)),
          const SizedBox(width: 12),
          SizedBox(width: 64, child: _ThemeToggleCard(isDark: isDark, onToggle: onThemeToggle)),
        ],
      ),
    );
  }

  // ── Tablet 640–1024 ───────────────────────────────────────────────────────
  Widget _tablet() {
    return SizedBox(
      height: 56,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _TimeBarCard(isDark: isDark)),
          const SizedBox(width: 10),
          SizedBox(width: 56, child: _ThemeToggleCard(isDark: isDark, onToggle: onThemeToggle)),
        ],
      ),
    );
  }

  // ── Mobile <640 ───────────────────────────────────────────────────────────
  Widget _mobile() {
    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _LiveTimeCard(isDark: isDark)),
          const SizedBox(width: 10),
          SizedBox(width: 52, child: _ThemeToggleCard(isDark: isDark, onToggle: onThemeToggle)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BentoCard — shared card shell
// ─────────────────────────────────────────────────────────────────────────────

class _BentoCard extends StatefulWidget {
  final bool isDark;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _BentoCard({
    required this.isDark,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.35)
                : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
            width: _hovered ? 1.5 : 1.0,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card 1 — Live Time (IST)
// ─────────────────────────────────────────────────────────────────────────────

class _LiveTimeCard extends StatefulWidget {
  final bool isDark;
  const _LiveTimeCard({required this.isDark});

  @override
  State<_LiveTimeCard> createState() => _LiveTimeCardState();
}

class _LiveTimeCardState extends State<_LiveTimeCard> {
  late Timer    _timer;
  late DateTime _now;

  static const _days   = ['SUN','MON','TUE','WED','THU','FRI','SAT'];
  static const _months = ['JAN','FEB','MAR','APR','MAY','JUN',
                           'JUL','AUG','SEP','OCT','NOV','DEC'];

  DateTime _ist() =>
      DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));

  String _pad(int n) => n.toString().padLeft(2, '0');

  String _timeStr(DateTime d) =>
      '${_pad(d.hour)}:${_pad(d.minute)}:${_pad(d.second)}';

  String _dateStr(DateTime d) =>
      '${_days[d.weekday % 7]}  ${d.day}  ${_months[d.month - 1]}';

  @override
  void initState() {
    super.initState();
    _now   = _ist();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) { if (mounted) setState(() => _now = _ist()); },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tertiary  = widget.isDark ? AppColors.textTertiaryDark  : AppColors.textTertiaryLight;
    final secondary = widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return _BentoCard(
      isDark: widget.isDark,
      child: LayoutBuilder(
        builder: (ctx, box) {
          final h         = box.maxHeight.isFinite ? box.maxHeight : 160.0;
          final timeSize  = (h * 0.20).clamp(14.0, 28.0);
          final labelSize = (h * 0.07).clamp(8.0, 12.0);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IST · UTC+5:30',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: labelSize,
                  letterSpacing: 1.2,
                  color: tertiary,
                ),
              ),
              SizedBox(height: h * 0.04),
              Text(
                _timeStr(_now),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: timeSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: h * 0.03),
              Text(
                _dateStr(_now),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: labelSize,
                  color: secondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TimeBarCard — full-width horizontal clock strip (desktop / tablet)
// ─────────────────────────────────────────────────────────────────────────────

class _TimeBarCard extends StatefulWidget {
  final bool isDark;
  const _TimeBarCard({required this.isDark});

  @override
  State<_TimeBarCard> createState() => _TimeBarCardState();
}

class _TimeBarCardState extends State<_TimeBarCard> {
  late Timer    _timer;
  late DateTime _now;

  static const _days   = ['SUN','MON','TUE','WED','THU','FRI','SAT'];
  static const _months = ['JAN','FEB','MAR','APR','MAY','JUN',
                           'JUL','AUG','SEP','OCT','NOV','DEC'];

  DateTime _ist() =>
      DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));

  String _pad(int n) => n.toString().padLeft(2, '0');

  String _timeStr(DateTime d) =>
      '${_pad(d.hour)}:${_pad(d.minute)}:${_pad(d.second)}';

  String _dateStr(DateTime d) =>
      '${_days[d.weekday % 7]}  ·  ${d.day}  ${_months[d.month - 1]}';

  @override
  void initState() {
    super.initState();
    _now   = _ist();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) { if (mounted) setState(() => _now = _ist()); },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tertiary  = widget.isDark ? AppColors.textTertiaryDark  : AppColors.textTertiaryLight;
    final secondary = widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return _BentoCard(
      isDark: widget.isDark,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Clock block ──────────────────────────────────────────────────
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'IST · UTC+5:30',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 8,
                  letterSpacing: 1.4,
                  color: tertiary,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                _timeStr(_now),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(width: 28),
          // ── Divider pip ──────────────────────────────────────────────────
          Container(
            width: 1,
            height: 36,
            color: widget.isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          const SizedBox(width: 28),
          // ── Date block ───────────────────────────────────────────────────
          Text(
            _dateStr(_now),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              letterSpacing: 1.5,
              color: secondary,
            ),
          ),
          const Spacer(),
          // ── Decorative monospace tagline ──────────────────────────────────
          Text(
            '{ new delhi }',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              letterSpacing: 1.2,
              color: tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ThemeToggleCard — dark / light mode toggle bento cell
// ─────────────────────────────────────────────────────────────────────────────

class _ThemeToggleCard extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;
  const _ThemeToggleCard({required this.isDark, required this.onToggle});

  @override
  State<_ThemeToggleCard> createState() => _ThemeToggleCardState();
}

class _ThemeToggleCardState extends State<_ThemeToggleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.35)
                  : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
              width: _hovered ? 1.5 : 1.0,
            ),
          ),
          child: Center(
            child: Icon(
              widget.isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              size: 18,
              color: widget.isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ),
    );
  }
}
