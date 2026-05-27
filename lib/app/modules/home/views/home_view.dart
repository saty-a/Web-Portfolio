import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/about_column.dart';
import '../../../core/widgets/career_timeline.dart';
import '../../../core/widgets/work_column.dart';
import '../../../core/widgets/bento_grid.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../controllers/home_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Per-panel isDark helper — pure, no state
// ─────────────────────────────────────────────────────────────────────────────

bool _panelIsDark({
  required bool baseDark,
  required bool targetDark,
  required double progress,
  required double threshold,
}) =>
    progress >= threshold ? targetDark : baseDark;

// ─────────────────────────────────────────────────────────────────────────────
// Panel content type — tracks which section lives in which layout slot
// ─────────────────────────────────────────────────────────────────────────────

enum _PanelContent { about, career, work }

// ─────────────────────────────────────────────────────────────────────────────
// HomeView
// ─────────────────────────────────────────────────────────────────────────────

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late final AnimationController _revealCtrl;
  bool _showOverlay = false;
  bool _overlayTargetDark = false;
  bool _isLTR = true; // dark mode → LTR (white birds), light mode → RTL (green birds)

  @override
  void initState() {
    super.initState();
    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
  }

  @override
  void dispose() {
    _revealCtrl.dispose();
    super.dispose();
  }

  void _onThemeToggle() {
    if (_showOverlay) return; // guard double-tap
    final ctrl = Get.find<HomeController>();
    _overlayTargetDark = !ctrl.isDarkMode.value;
    _isLTR = ctrl.isDarkMode.value; // dark→LTR (white), light→RTL (green)
    setState(() => _showOverlay = true);
    _revealCtrl.forward(from: 0.0).then((_) {
      // 1. Commit global theme — Obx will rebuild with correct isDark next frame
      ctrl.toggleTheme();
      _revealCtrl.reset();
      // 2. Defer overlay removal to AFTER Obx processes the new isDark value.
      //    Without this, the non-animating branch renders one frame with stale isDark → flicker.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _showOverlay = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();

    return Scaffold(
      body: Obx(() {
        final isDark = homeCtrl.isDarkMode.value;

        // Always use AnimatedBuilder so tree structure never changes.
        // When not animating, animProgress=null → layouts use static isDark.
        // Consistent tree = Flutter never destroys layout State → _slots preserved.
        return AnimatedBuilder(
          animation: _revealCtrl,
          builder: (ctx, _) {
            final rawP = _showOverlay ? _revealCtrl.value : null;
            final p    = rawP != null ? Curves.easeOut.transform(rawP) : null;
            return Stack(
              children: [
                ResponsiveLayout(
                  mobile: _MobileLayout(
                    isDark: isDark,
                    onThemeToggle: _onThemeToggle,
                    animProgress: p,
                    targetDark: _overlayTargetDark,
                    isLTR: _isLTR,
                  ),
                  tablet: _TabletLayout(
                    isDark: isDark,
                    onThemeToggle: _onThemeToggle,
                    animProgress: p,
                    targetDark: _overlayTargetDark,
                    isLTR: _isLTR,
                  ),
                  desktop: _DesktopLayout(
                    isDark: isDark,
                    onThemeToggle: _onThemeToggle,
                    animProgress: p,
                    targetDark: _overlayTargetDark,
                    isLTR: _isLTR,
                  ),
                ),
                // ── Bird flock overlay (only during animation) ─────────
                if (_showOverlay)
                  IgnorePointer(
                    child: CustomPaint(
                      painter: _BirdFlockPainter(progress: p ?? 0.0, isLTR: _isLTR),
                      child: const SizedBox.expand(),
                    ),
                  ),
              ],
            );
          },
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop — 3 resizable columns
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopLayout extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final double? animProgress;
  final bool targetDark;
  final bool isLTR;

  const _DesktopLayout({
    required this.isDark,
    required this.onThemeToggle,
    this.animProgress,
    this.targetDark = false,
    this.isLTR = true,
  });

  @override
  State<_DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<_DesktopLayout> {
  double _f1 = 0.28;
  double _f2 = 0.50;

  /// Which content lives in each slot: [left, mid, right]
  final List<_PanelContent> _slots = [_PanelContent.about, _PanelContent.career, _PanelContent.work];

  static const double _minF1   = 0.18;
  static const double _maxF1   = 0.52; // cap so right panels never starve
  static const double _minF2   = 0.25;
  static const double _maxF2   = 0.75;
  static const double _handleW = 28.0;
  static const double _edgePad = 16.0;

  void _drag1(double dx, double totalW) {
    if (totalW <= 0) return;
    setState(() => _f1 = (_f1 + dx / totalW).clamp(_minF1, _maxF1));
  }

  void _drag2(double dx, double innerW) {
    if (innerW <= 0) return;
    setState(() => _f2 = (_f2 + dx / innerW).clamp(_minF2, _maxF2));
  }

  void _reset() => setState(() { _f1 = 0.28; _f2 = 0.50; });

  void _swap(int a, int b) => setState(() {
    final t = _slots[a]; _slots[a] = _slots[b]; _slots[b] = t;
  });

  Widget _panelChild(_PanelContent c, bool isDark) {
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    switch (c) {
      case _PanelContent.about:
        return Theme(data: theme, child: const AboutColumn());
      case _PanelContent.career:
        return Theme(data: theme, child: const CareerTimeline());
      case _PanelContent.work:
        return Theme(data: theme, child: const WorkColumn());
    }
  }

  Widget _animated(int slot, bool isDark) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 150),
    transitionBuilder: (child, anim) => FadeTransition(
      opacity: anim,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.97, end: 1.0).animate(anim),
        child: child,
      ),
    ),
    child: KeyedSubtree(
      key: ValueKey(_slots[slot]),
      child: _panelChild(_slots[slot], isDark),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final p      = widget.animProgress;
    final base   = widget.isDark;
    final target = widget.targetDark;
    final ltr    = widget.isLTR;

    // LTR: birds enter left → left slot flips first, right slot last
    // RTL: birds enter right → right slot flips first, left slot last
    final leftDark  = p == null ? base : _panelIsDark(baseDark: base, targetDark: target, progress: p, threshold: ltr ? 0.28 : 0.88);
    final midDark   = p == null ? base : _panelIsDark(baseDark: base, targetDark: target, progress: p, threshold: 0.60);
    final rightDark = p == null ? base : _panelIsDark(baseDark: base, targetDark: target, progress: p, threshold: ltr ? 0.88 : 0.28);

    return Padding(
      padding: const EdgeInsets.all(_edgePad),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final totalW = constraints.maxWidth - _handleW;
          final w1 = (totalW * _f1).clamp(0.0, totalW);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left slot ─────────────────────────────────────────────────
              SizedBox(
                width: w1,
                child: _card(leftDark, _animated(0, leftDark)),
              ),
              _DragHandle(
                isDark: leftDark,
                onDrag: (dx) => _drag1(dx, totalW),
                onDoubleTap: _reset,
                onSwap: () => _swap(0, 1),
              ),
              // ── Right panel: Bento + mid slot + right slot ─────────────────
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 64,
                      child: BentoGrid(isDark: midDark, onThemeToggle: widget.onThemeToggle),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (ctx2, inner) {
                          final innerW = inner.maxWidth - _handleW;
                          final wMid   = (innerW * _f2).clamp(0.0, innerW);
                          final wRight = (innerW * (1.0 - _f2)).clamp(0.0, innerW);
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: wMid,
                                child: _card(midDark, _animated(1, midDark)),
                              ),
                              _DragHandle(
                                isDark: midDark,
                                onDrag: (dx) => _drag2(dx, innerW),
                                onDoubleTap: _reset,
                                onSwap: () => _swap(1, 2),
                              ),
                              SizedBox(
                                width: wRight,
                                child: _card(rightDark, _animated(2, rightDark)),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
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
// Tablet — 2 resizable columns
// ─────────────────────────────────────────────────────────────────────────────

class _TabletLayout extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final double? animProgress;
  final bool targetDark;
  final bool isLTR;

  const _TabletLayout({
    required this.isDark,
    required this.onThemeToggle,
    this.animProgress,
    this.targetDark = false,
    this.isLTR = true,
  });

  @override
  State<_TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<_TabletLayout> {
  double _f1 = 0.40;

  /// [left, right-top, right-bottom]
  final List<_PanelContent> _slots = [_PanelContent.about, _PanelContent.career, _PanelContent.work];

  static const double _minF1   = 0.22;
  static const double _maxF1   = 0.68;
  static const double _handleW = 20.0;
  static const double _edgePad = 16.0;

  void _drag(double dx, double usableW) {
    if (usableW <= 0) return;
    setState(() => _f1 = (_f1 + dx / usableW).clamp(_minF1, _maxF1));
  }

  void _reset() => setState(() => _f1 = 0.40);

  void _swap(int a, int b) => setState(() {
    final t = _slots[a]; _slots[a] = _slots[b]; _slots[b] = t;
  });

  Widget _panelChild(_PanelContent c, bool isDark) {
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    switch (c) {
      case _PanelContent.about:
        return Theme(data: theme, child: const AboutColumn());
      case _PanelContent.career:
        return Theme(data: theme, child: const CareerTimeline());
      case _PanelContent.work:
        return Theme(data: theme, child: const WorkColumn());
    }
  }

  Widget _animated(int slot, bool isDark) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 150),
    transitionBuilder: (child, anim) => FadeTransition(
      opacity: anim,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.97, end: 1.0).animate(anim),
        child: child,
      ),
    ),
    child: KeyedSubtree(
      key: ValueKey(_slots[slot]),
      child: _panelChild(_slots[slot], isDark),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final p      = widget.animProgress;
    final base   = widget.isDark;
    final target = widget.targetDark;
    final ltr    = widget.isLTR;

    final leftDark  = p == null ? base : _panelIsDark(baseDark: base, targetDark: target, progress: p, threshold: ltr ? 0.42 : 0.85);
    final rightDark = p == null ? base : _panelIsDark(baseDark: base, targetDark: target, progress: p, threshold: ltr ? 0.85 : 0.42);

    return Padding(
      padding: const EdgeInsets.all(_edgePad),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final usableW = constraints.maxWidth - _handleW;
          final w1 = usableW * _f1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left slot ─────────────────────────────────────────────────
              SizedBox(
                width: w1,
                child: _card(leftDark, _animated(0, leftDark)),
              ),
              _DragHandle(
                isDark: leftDark,
                onDrag: (dx) => _drag(dx, usableW),
                onDoubleTap: _reset,
                onSwap: () => _swap(0, 1),
              ),
              // ── Right: Bento + two swappable stacked panels ────────────────
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      child: BentoGrid(isDark: rightDark, onThemeToggle: widget.onThemeToggle),
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: _card(rightDark, _animated(1, rightDark))),
                    _VerticalSwapSeparator(
                      isDark: rightDark,
                      onSwap: () => _swap(1, 2),
                    ),
                    Expanded(child: _card(rightDark, _animated(2, rightDark))),
                  ],
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
// Mobile — single scroll, stacked (no drag)
// ─────────────────────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final double? animProgress;
  final bool targetDark;
  final bool isLTR;

  const _MobileLayout({
    required this.isDark,
    required this.onThemeToggle,
    this.animProgress,
    this.targetDark = false,
    this.isLTR = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = animProgress;
    final panelDark = p == null
        ? isDark
        : _panelIsDark(baseDark: isDark, targetDark: targetDark, progress: p, threshold: 0.50);

    return Theme(
      data: panelDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BentoGrid(isDark: panelDark, onThemeToggle: onThemeToggle),
            const SizedBox(height: 12),
            _card(panelDark, const AboutColumn(shrinkWrap: true)),
            const SizedBox(height: 12),
            _card(panelDark, const CareerTimeline(shrinkWrap: true)),
            const SizedBox(height: 12),
            _card(panelDark, const WorkColumn(shrinkWrap: true)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Drag handle between columns
// ─────────────────────────────────────────────────────────────────────────────

class _DragHandle extends StatefulWidget {
  final bool isDark;
  final void Function(double deltaX) onDrag;
  final VoidCallback onDoubleTap;
  final VoidCallback? onSwap;

  const _DragHandle({
    required this.isDark,
    required this.onDrag,
    required this.onDoubleTap,
    this.onSwap,
  });

  @override
  State<_DragHandle> createState() => _DragHandleState();
}

class _DragHandleState extends State<_DragHandle> {
  bool _hovered      = false;
  bool _dragging     = false;
  bool _badgeHover   = false;
  bool _badgePressed = false;

  bool get _active => _hovered || _dragging;

  @override
  Widget build(BuildContext context) {
    final lineColor = _active
        ? AppColors.accent
        : (widget.isDark ? AppColors.borderDark : AppColors.borderLight);

    // Badge is always visible — opaque background so line never bleeds through
    final baseBg  = widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final badgeBg = _badgeHover
        ? Color.alphaBlend(AppColors.accent.withValues(alpha: 0.18), baseBg)
        : baseBg;
    final badgeBorder = _badgeHover
        ? AppColors.accent.withValues(alpha: 0.70)
        : (widget.isDark ? AppColors.borderDark : AppColors.borderLight);
    final iconColor = _badgeHover
        ? AppColors.accent
        : (widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight);

    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onHorizontalDragStart: (_) => setState(() => _dragging = true),
        onHorizontalDragUpdate: (d) => widget.onDrag(d.delta.dx),
        onHorizontalDragEnd: (_) => setState(() => _dragging = false),
        onDoubleTap: widget.onDoubleTap,
        child: Tooltip(
          message: 'Drag to resize · Double-tap to reset',
          waitDuration: const Duration(milliseconds: 600),
          child: SizedBox(
            width: 28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ── Full-height resize line ─────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: _active ? 2.0 : 1.0,
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // ── Drag dots (only when no swap badge) ─────────────────────
                if (_active && widget.onSwap == null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (_) => Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                    )),
                  ),
                // ── Always-visible swap badge ───────────────────────────────
                if (widget.onSwap != null)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _badgeHover = true),
                    onExit:  (_) => setState(() => _badgeHover = false),
                    child: GestureDetector(
                      onTap: widget.onSwap,
                      onTapDown:   (_) => setState(() => _badgePressed = true),
                      onTapUp:     (_) => setState(() => _badgePressed = false),
                      onTapCancel: ()  => setState(() => _badgePressed = false),
                      child: Tooltip(
                        message: 'Swap panels',
                        child: AnimatedScale(
                          scale: _badgePressed ? 0.82 : 1.0,
                          duration: const Duration(milliseconds: 90),
                          curve: Curves.easeOut,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width:  _badgeHover ? 26 : 22,
                            height: _badgeHover ? 26 : 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _badgePressed
                                  ? Color.alphaBlend(AppColors.accent.withValues(alpha: 0.35), baseBg)
                                  : badgeBg,
                              border: Border.all(
                                color: badgeBorder,
                                width: _badgeHover ? 1.5 : 1.0,
                              ),
                              boxShadow: _badgeHover && !_badgePressed
                                  ? [BoxShadow(
                                      color: AppColors.accent.withValues(alpha: 0.30),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    )]
                                  : null,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.swap_horiz,
                                size: 13,
                                color: iconColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vertical swap separator — always-visible badge between stacked panels (tablet)
// ─────────────────────────────────────────────────────────────────────────────

class _VerticalSwapSeparator extends StatefulWidget {
  final bool isDark;
  final VoidCallback onSwap;

  const _VerticalSwapSeparator({
    required this.isDark,
    required this.onSwap,
  });

  @override
  State<_VerticalSwapSeparator> createState() => _VerticalSwapSeparatorState();
}

class _VerticalSwapSeparatorState extends State<_VerticalSwapSeparator> {
  bool _hovered  = false;
  bool _pressed  = false;

  @override
  Widget build(BuildContext context) {
    final lineColor = _hovered
        ? AppColors.accent.withValues(alpha: 0.50)
        : (widget.isDark ? AppColors.borderDark : AppColors.borderLight);
    final baseBg  = widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final badgeBg = _hovered
        ? Color.alphaBlend(AppColors.accent.withValues(alpha: 0.18), baseBg)
        : baseBg;
    final badgeBorder = _hovered
        ? AppColors.accent.withValues(alpha: 0.70)
        : (widget.isDark ? AppColors.borderDark : AppColors.borderLight);
    final iconColor = _hovered
        ? AppColors.accent
        : (widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap:       widget.onSwap,
        onTapDown:   (_) => setState(() => _pressed = true),
        onTapUp:     (_) => setState(() => _pressed = false),
        onTapCancel: ()  => setState(() => _pressed = false),
        child: Tooltip(
          message: 'Swap panels',
          waitDuration: const Duration(milliseconds: 400),
          child: SizedBox(
            height: 28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ── Full-width divider line ─────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: _hovered ? 2.0 : 1.0,
                  color: lineColor,
                ),
                // ── Always-visible swap badge ───────────────────────────────
                AnimatedScale(
                  scale: _pressed ? 0.82 : 1.0,
                  duration: const Duration(milliseconds: 90),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width:  _hovered ? 26 : 22,
                    height: _hovered ? 26 : 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _pressed
                          ? Color.alphaBlend(AppColors.accent.withValues(alpha: 0.35), baseBg)
                          : badgeBg,
                      border: Border.all(
                        color: badgeBorder,
                        width: _hovered ? 1.5 : 1.0,
                      ),
                      boxShadow: _hovered && !_pressed
                          ? [BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.30),
                              blurRadius: 10,
                              spreadRadius: 1,
                            )]
                          : null,
                    ),
                    child: Center(
                      child: Icon(Icons.swap_vert, size: 13, color: iconColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared card shell (plain — used by mobile)
// ─────────────────────────────────────────────────────────────────────────────

Widget _card(bool isDark, Widget child) {
  return Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Bird flock painter
// ─────────────────────────────────────────────────────────────────────────────

class _BirdFlockPainter extends CustomPainter {
  final double progress; // already curve-transformed, 0.0→1.0
  final bool isLTR;      // true = left→right (dark mode, white birds)
                         // false = right→left (light mode, green birds)

  const _BirdFlockPainter({required this.progress, required this.isLTR});

  // 14 birds — wide V-formation spanning full screen height
  static const List<Offset> _flockOffsets = [
    Offset(    0,    0),  // lead bird
    Offset(  -52,  -45),  Offset(  -52,   45),  // row 2
    Offset( -104,  -95),  Offset( -104,   95),  // row 3
    Offset( -156, -148),  Offset( -156,  148),  // row 4
    Offset( -205, -198),  Offset( -205,  198),  // row 5
    Offset( -248, -245),  Offset( -248,  245),  // row 6
    Offset(  -70,  -28),  Offset(  -70,   28),  // mid-V stragglers
    Offset( -168, -120),                          // rear straggler
  ];

  // Font size per bird — lead largest, rear smallest
  static const List<double> _fontSizes = [
    30, 25, 25, 22, 22, 19, 19, 17, 17, 15, 15, 23, 23, 20,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Always use } — at tiltAngle≈π (RTL) it rotates to appear as { facing left
    const birdChar = '}';
    final birdColor = isLTR
        ? Colors.white.withValues(alpha: 0.88)
        : AppColors.accent.withValues(alpha: 0.88);

    // LTR: enters left off-screen, exits right
    // RTL: enters right off-screen, exits left
    final leadX = isLTR
        ? -size.width * 0.15 + size.width * 1.25 * progress
        :  size.width * 1.15 - size.width * 1.25 * progress;

    // Undulating Y centered on screen — larger wave spans top→bottom
    final wave1 = math.sin(progress * math.pi * 2.2) * 55.0;
    final wave2 = math.sin(progress * math.pi * 4.7 + 1.0) * 22.0;
    final leadY = size.height * 0.45 + wave1 + wave2;

    // Derivative of Y → base tilt (nose up/down with the curve)
    final dWave1 = math.cos(progress * math.pi * 2.2) * math.pi * 2.2 * 55.0;
    final dWave2 = math.cos(progress * math.pi * 4.7 + 1.0) * math.pi * 4.7 * 22.0;
    final speedX = isLTR ? size.width * 1.25 : -size.width * 1.25;
    final flightAngle = math.atan2(dWave1 + dWave2, speedX);

    for (int i = 0; i < _flockOffsets.length; i++) {
      final off = _flockOffsets[i];
      final dx  = isLTR ? off.dx : -off.dx; // mirror for RTL

      final birdDrift = math.sin(progress * math.pi * 5.8 + i * 1.15) * 5.0;
      final center = Offset(leadX + dx, leadY + off.dy + birdDrift);

      // Flap — 3 cycles, staggered per bird so motion ripples through flock
      final flapNorm = math.sin(progress * 3.0 * 2 * math.pi + i * 0.45);

      _drawBird(canvas, center, flapNorm, flightAngle, _fontSizes[i], birdChar, birdColor);
    }
  }

  // Draws one bird as a } or { glyph.
  // flapNorm adds a subtle rock on top of flightAngle, simulating wingbeat.
  void _drawBird(
    Canvas canvas,
    Offset c,
    double flapNorm,
    double flightAngle,
    double fontSize,
    String char,
    Color color,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: char,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.w200,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Larger amplitude so bracket tips visibly swing (feels alive)
    final tiltAngle = flightAngle + flapNorm * 0.35;

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(tiltAngle);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BirdFlockPainter old) =>
      old.progress != progress || old.isLTR != isLTR;
}
