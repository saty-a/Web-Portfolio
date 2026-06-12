import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/about_column.dart';
import '../../../core/widgets/career_timeline.dart';
import '../../../core/widgets/work_column.dart';
import '../../../core/widgets/bento_grid.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/case_study_panels.dart';
import '../../../data/models/project_model.dart';
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
// Geometry-true flip threshold
// Progress at which the flock visually passes [centerPx] along the sweep axis
// of length [extent].  Mirrors the painter's travel math exactly, so panels
// flip in sync with the birds regardless of curve, duration, or panel resize.
// ─────────────────────────────────────────────────────────────────────────────

double _passThreshold(double centerPx, double extent, bool forward) {
  final travel = extent * 1.15 + 320;
  // Formation trails the lead bird by ~248px → flock center lags ~124px.
  // Flip when the flock center crosses the panel center: color changes in the
  // flock's wake, right as the birds pass over.
  const flockLag = 124.0;
  final p = forward
      ? (centerPx + flockLag + 0.15 * extent) / travel
      : (extent * 1.15 - centerPx + flockLag) / travel;
  return p.clamp(0.05, 0.92);
}

// ─────────────────────────────────────────────────────────────────────────────
// Panel content type
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

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _revealCtrl;
  bool _showOverlay = false;
  bool _overlayTargetDark = false;
  bool _isLTR = true;

  // ── Case study state ───────────────────────────────────────────────────────
  bool _isCaseStudyActive = false;
  bool? _caseStudyTransitionTarget; // null=no CS anim, true=opening, false=closing
  final List<Worker> _workers = [];

  @override
  void initState() {
    super.initState();
    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctrl = Get.find<HomeController>();
      _workers
        ..add(ever(ctrl.caseStudyOpenVersion, (_) => _triggerCaseStudyOpen()))
        ..add(ever(ctrl.caseStudyCloseVersion, (_) => _triggerCaseStudyClose()));
    });
  }

  @override
  void dispose() {
    for (final w in _workers) {
      w.dispose();
    }
    _revealCtrl.dispose();
    super.dispose();
  }

  // ── Theme toggle ───────────────────────────────────────────────────────────

  void _onThemeToggle() {
    if (_showOverlay) return;
    final ctrl = Get.find<HomeController>();
    _overlayTargetDark = !ctrl.isDarkMode.value;
    _isLTR = ctrl.isDarkMode.value; // dark→LTR (white), light→RTL (green)
    _caseStudyTransitionTarget = null;
    _revealCtrl.duration = const Duration(milliseconds: 5600);
    setState(() => _showOverlay = true);
    _revealCtrl.forward(from: 0.0).then((_) {
      ctrl.toggleTheme();
      _revealCtrl.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _showOverlay = false);
      });
    });
  }

  // ── Case study open: RTL birds, right→mid→left fills CS panels ─────────────

  void _triggerCaseStudyOpen() {
    if (_showOverlay) return;
    // Already showing CS → just let activeCaseStudy change propagate (project switch)
    if (_isCaseStudyActive) return;

    final ctrl = Get.find<HomeController>();
    _isLTR = false; // RTL: birds right→left
    _overlayTargetDark = ctrl.isDarkMode.value; // no theme change
    _caseStudyTransitionTarget = true;
    _revealCtrl.duration = const Duration(milliseconds: 4400);
    setState(() => _showOverlay = true);
    _revealCtrl.forward(from: 0.0).then((_) {
      _isCaseStudyActive = true;
      _caseStudyTransitionTarget = null;
      _revealCtrl.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _showOverlay = false);
      });
    });
  }

  // ── Case study close: LTR birds, left→mid→right restores home panels ────────

  void _triggerCaseStudyClose() {
    if (_showOverlay) return;
    final ctrl = Get.find<HomeController>();
    _isLTR = true; // LTR: birds left→right
    _overlayTargetDark = ctrl.isDarkMode.value; // no theme change
    _caseStudyTransitionTarget = false;
    _revealCtrl.duration = const Duration(milliseconds: 4000);
    setState(() => _showOverlay = true);
    _revealCtrl.forward(from: 0.0).then((_) {
      _isCaseStudyActive = false;
      _caseStudyTransitionTarget = null;
      ctrl.activeCaseStudy.value = null;
      _revealCtrl.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _showOverlay = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();

    // Scaffold is inside Obx so its backgroundColor tracks isDark reactively.
    // This prevents any transparent-scaffold flash revealing system canvas.
    return Obx(() {
      final isDark = homeCtrl.isDarkMode.value;
      final activeProject = homeCtrl.activeCaseStudy.value;
      final scaffoldBg =
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

      return Scaffold(
        backgroundColor: scaffoldBg,
        body: AnimatedBuilder(
          animation: _revealCtrl,
          builder: (ctx, _) {
            final rawP = _showOverlay ? _revealCtrl.value : null;
            // easeInOutSine: gentle takeoff/landing with a calm cruise —
            // lowest peak velocity of the smooth S-curves, so the flock
            // never rushes mid-screen.
            final p =
                rawP != null ? Curves.easeInOutSine.transform(rawP) : null;
            final size = MediaQuery.of(ctx).size;
            final isMobile = size.width < 640;

            final base =
                isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
            final tgt = _overlayTargetDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight;
            final sweepActive = _showOverlay && base != tgt;

            return Stack(
              children: [
                // ── Sweep bg — sits BEHIND content, only in gap areas ─────────
                // Cards are opaque → block painter. Gaps (padding) are
                // transparent → painter shows through → background sweeps.
                if (sweepActive)
                  IgnorePointer(
                    child: CustomPaint(
                      painter: _SweepBgPainter(
                        progress: p ?? 0.0,
                        isLTR: _isLTR,
                        base: base,
                        tgt: tgt,
                        isVertical: isMobile,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ResponsiveLayout(
                  mobile: _MobileLayout(
                    isDark: isDark,
                    onThemeToggle: _onThemeToggle,
                    animProgress: p,
                    targetDark: _overlayTargetDark,
                    isLTR: _isLTR,
                    isCaseStudyActive: _isCaseStudyActive,
                    caseStudyTransitionTarget: _caseStudyTransitionTarget,
                    caseStudyProject: activeProject,
                  ),
                  tablet: _TabletLayout(
                    isDark: isDark,
                    onThemeToggle: _onThemeToggle,
                    animProgress: p,
                    targetDark: _overlayTargetDark,
                    isLTR: _isLTR,
                    isCaseStudyActive: _isCaseStudyActive,
                    caseStudyTransitionTarget: _caseStudyTransitionTarget,
                    caseStudyProject: activeProject,
                  ),
                  desktop: _DesktopLayout(
                    isDark: isDark,
                    onThemeToggle: _onThemeToggle,
                    animProgress: p,
                    targetDark: _overlayTargetDark,
                    isLTR: _isLTR,
                    isCaseStudyActive: _isCaseStudyActive,
                    caseStudyTransitionTarget: _caseStudyTransitionTarget,
                    caseStudyProject: activeProject,
                  ),
                ),
                // ── Bird flock (isolated repaint boundary) ───────────────────
                if (_showOverlay)
                  RepaintBoundary(
                    child: IgnorePointer(
                      child: CustomPaint(
                        isComplex: true,
                        willChange: true,
                        painter: _BirdFlockPainter(
                          progress: p ?? 0.0,
                          rawProgress: rawP ?? 0.0,
                          isLTR: _isLTR,
                          isDark: isDark,
                          isVertical: isMobile,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sweep background painter
// Paints gap areas (transparent in layout) with a gradient that tracks the
// bird lead position.  Cards are opaque → block painter → only gaps sweep.
//
// Edge-condition semantics (prevents immediate flash at click / flicker at end):
//   LTR  enters from LEFT  (frac starts -0.15) → off-left=NOT YET, off-right=DONE
//   RTL  enters from RIGHT (frac starts  1.15) → off-right=NOT YET, off-left=DONE
//   goingDown enters from TOP    → off-top=NOT YET, off-bot=DONE
//   goingUp   enters from BOTTOM → off-bot=NOT YET, off-top=DONE
// ─────────────────────────────────────────────────────────────────────────────

class _SweepBgPainter extends CustomPainter {
  final double progress;
  final bool isLTR;
  final Color base;
  final Color tgt;
  final bool isVertical;

  const _SweepBgPainter({
    required this.progress,
    required this.isLTR,
    required this.base,
    required this.tgt,
    required this.isVertical,
  });

  static final Paint _p = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    if (!isVertical) {
      final travel = size.width * 1.15 + 320;
      final leadX = isLTR
          ? -size.width * 0.15 + travel * progress
          : size.width * 1.15 - travel * progress;
      final frac = leadX / size.width;

      if (isLTR) {
        if (frac <= 0.0) { _p.color = base; canvas.drawRect(rect, _p); return; }
        if (frac >= 1.0) { _p.color = tgt;  canvas.drawRect(rect, _p); return; }
      } else {
        if (frac >= 1.0) { _p.color = base; canvas.drawRect(rect, _p); return; }
        if (frac <= 0.0) { _p.color = tgt;  canvas.drawRect(rect, _p); return; }
      }
      final f = (60.0 / size.width).clamp(0.02, 0.15);
      final s0 = (frac - f).clamp(0.0, 1.0);
      final s1 = ((frac + f).clamp(0.0, 1.0)).clamp(s0 + 0.002, 1.0);
      _p.shader = LinearGradient(
        begin: Alignment.centerLeft, end: Alignment.centerRight,
        colors: [tgt, base], stops: [s0, s1],
      ).createShader(rect);
      canvas.drawRect(rect, _p);
      _p.shader = null;
    } else {
      final travel = size.height * 1.15 + 320;
      final goingDown = !isLTR;
      final leadY = goingDown
          ? -size.height * 0.15 + travel * progress
          : size.height * 1.15 - travel * progress;
      final frac = leadY / size.height;
      final f = (60.0 / size.height).clamp(0.02, 0.15);
      final s0 = (frac - f).clamp(0.0, 1.0);
      final s1 = ((frac + f).clamp(0.0, 1.0)).clamp(s0 + 0.002, 1.0);

      if (goingDown) {
        if (frac <= 0.0) { _p.color = base; canvas.drawRect(rect, _p); return; }
        if (frac >= 1.0) { _p.color = tgt;  canvas.drawRect(rect, _p); return; }
        _p.shader = LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [tgt, base], stops: [s0, s1],
        ).createShader(rect);
      } else {
        if (frac >= 1.0) { _p.color = base; canvas.drawRect(rect, _p); return; }
        if (frac <= 0.0) { _p.color = tgt;  canvas.drawRect(rect, _p); return; }
        _p.shader = LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [base, tgt], stops: [s0, s1],
        ).createShader(rect);
      }
      canvas.drawRect(rect, _p);
      _p.shader = null;
    }
  }

  @override
  bool shouldRepaint(_SweepBgPainter old) =>
      old.progress != progress || old.isLTR != isLTR ||
      old.base != base || old.tgt != tgt || old.isVertical != isVertical;
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
  final bool isCaseStudyActive;
  final bool? caseStudyTransitionTarget;
  final Project? caseStudyProject;

  const _DesktopLayout({
    required this.isDark,
    required this.onThemeToggle,
    this.animProgress,
    this.targetDark = false,
    this.isLTR = true,
    this.isCaseStudyActive = false,
    this.caseStudyTransitionTarget,
    this.caseStudyProject,
  });

  @override
  State<_DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<_DesktopLayout> {
  double _f1 = 0.28;
  double _f2 = 0.50;

  final List<_PanelContent> _slots = [
    _PanelContent.about,
    _PanelContent.career,
    _PanelContent.work
  ];

  static const double _minF1 = 0.18;
  static const double _maxF1 = 0.52;
  static const double _minF2 = 0.25;
  static const double _maxF2 = 0.75;
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

  void _reset() => setState(() {
        _f1 = 0.28;
        _f2 = 0.50;
      });

  void _swap(int a, int b) => setState(() {
        final t = _slots[a];
        _slots[a] = _slots[b];
        _slots[b] = t;
      });

  // ── Should this slot show case study content right now? ───────────────────
  // [threshold] is geometry-derived: the progress at which the flock passes
  // this slot's center (RTL when opening, LTR when closing).

  bool _slotShowsCS(int slotIndex, double threshold) {
    final p = widget.animProgress;
    final cst = widget.caseStudyTransitionTarget;
    if (p == null || cst == null) return widget.isCaseStudyActive;
    return p >= threshold ? (cst == true) : widget.isCaseStudyActive;
  }

  // ── Build slot content (home OR case study) ───────────────────────────────

  Widget _buildSlot(int slotIndex, bool isDark, double csThreshold) {
    final showCS = _slotShowsCS(slotIndex, csThreshold);
    final project = widget.caseStudyProject;
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

    if (showCS && project != null) {
      final ctrl = Get.find<HomeController>();
      Widget panel;
      switch (slotIndex) {
        case 0:
          panel = CaseStudyHeroPanel(
            project: project,
            isDark: isDark,
            onClose: ctrl.requestCloseCaseStudy,
          );
          break;
        case 1:
          panel =
              CaseStudyOverviewPanel(project: project, isDark: isDark);
          break;
        case 2:
          panel =
              CaseStudyFeaturesPanel(project: project, isDark: isDark);
          break;
        default:
          return const SizedBox.shrink();
      }
      return Theme(data: theme, child: panel);
    }

    // Home content
    switch (_slots[slotIndex]) {
      case _PanelContent.about:
        return Theme(
            data: theme, child: const AboutColumn());
      case _PanelContent.career:
        return Theme(
            data: theme, child: const CareerTimeline());
      case _PanelContent.work:
        return Theme(
            data: theme, child: const WorkColumn());
    }
  }

  Widget _animated(int slotIndex, bool isDark, double csThreshold) {
    final showCS = _slotShowsCS(slotIndex, csThreshold);
    final projKey =
        showCS ? (widget.caseStudyProject?.title ?? '') : '';
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0).animate(anim),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(
            '$slotIndex-${_slots[slotIndex]}-cs:$showCS-$projKey'),
        child: _buildSlot(slotIndex, isDark, csThreshold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.animProgress;
    final base = widget.isDark;
    final target = widget.targetDark;
    final ltr = widget.isLTR;
    // Painter sweeps the full window — thresholds must be in screen space.
    final screenW = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(_edgePad),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final totalW = constraints.maxWidth - _handleW;
          final w1 = (totalW * _f1).clamp(0.0, totalW);

          // ── Panel centers in screen coords (track live drag fractions) ──
          final innerW =
              (constraints.maxWidth - w1 - _handleW) - _handleW;
          final wMidNow = (innerW * _f2).clamp(0.0, innerW);
          final leftC = _edgePad + w1 / 2;
          final midC = _edgePad + w1 + _handleW + wMidNow / 2;
          final rightC =
              _edgePad + w1 + _handleW + wMidNow + _handleW +
                  (innerW - wMidNow) / 2;

          // ── Theme flip: when flock passes each panel ─────────────────────
          final leftDark = p == null
              ? base
              : _panelIsDark(
                  baseDark: base,
                  targetDark: target,
                  progress: p,
                  threshold: _passThreshold(leftC, screenW, ltr));
          final midDark = p == null
              ? base
              : _panelIsDark(
                  baseDark: base,
                  targetDark: target,
                  progress: p,
                  threshold: _passThreshold(midC, screenW, ltr));
          final rightDark = p == null
              ? base
              : _panelIsDark(
                  baseDark: base,
                  targetDark: target,
                  progress: p,
                  threshold: _passThreshold(rightC, screenW, ltr));

          // ── Case-study flip: open flies RTL, close flies LTR ─────────────
          final csForward = widget.caseStudyTransitionTarget != true;
          final csThLeft = _passThreshold(leftC, screenW, csForward);
          final csThMid = _passThreshold(midC, screenW, csForward);
          final csThRight = _passThreshold(rightC, screenW, csForward);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left slot ─────────────────────────────────────────────────
              SizedBox(
                width: w1,
                child: _card(leftDark, _animated(0, leftDark, csThLeft)),
              ),
              _DragHandle(
                isDark: leftDark,
                onDrag: (dx) => _drag1(dx, totalW),
                onDoubleTap: _reset,
                // Disable swap while case study is active
                onSwap: widget.isCaseStudyActive ? null : () => _swap(0, 1),
              ),
              // ── Right panel: Bento + mid + right ──────────────────────────
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 64,
                      child: BentoGrid(
                          isDark: midDark,
                          onThemeToggle: widget.onThemeToggle),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (ctx2, inner) {
                          final innerW = inner.maxWidth - _handleW;
                          final wMid =
                              (innerW * _f2).clamp(0.0, innerW);
                          final wRight =
                              (innerW * (1.0 - _f2)).clamp(0.0, innerW);
                          return Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: wMid,
                                child: _card(midDark,
                                    _animated(1, midDark, csThMid)),
                              ),
                              _DragHandle(
                                isDark: midDark,
                                onDrag: (dx) => _drag2(dx, innerW),
                                onDoubleTap: _reset,
                                onSwap: widget.isCaseStudyActive
                                    ? null
                                    : () => _swap(1, 2),
                              ),
                              SizedBox(
                                width: wRight,
                                child: _card(rightDark,
                                    _animated(2, rightDark, csThRight)),
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
  final bool isCaseStudyActive;
  final bool? caseStudyTransitionTarget;
  final Project? caseStudyProject;

  const _TabletLayout({
    required this.isDark,
    required this.onThemeToggle,
    this.animProgress,
    this.targetDark = false,
    this.isLTR = true,
    this.isCaseStudyActive = false,
    this.caseStudyTransitionTarget,
    this.caseStudyProject,
  });

  @override
  State<_TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<_TabletLayout> {
  double _f1 = 0.40;

  final List<_PanelContent> _slots = [
    _PanelContent.about,
    _PanelContent.career,
    _PanelContent.work
  ];

  static const double _minF1 = 0.22;
  static const double _maxF1 = 0.68;
  static const double _handleW = 20.0;
  static const double _edgePad = 16.0;

  void _drag(double dx, double usableW) {
    if (usableW <= 0) return;
    setState(() => _f1 = (_f1 + dx / usableW).clamp(_minF1, _maxF1));
  }

  void _reset() => setState(() => _f1 = 0.40);

  void _swap(int a, int b) => setState(() {
        final t = _slots[a];
        _slots[a] = _slots[b];
        _slots[b] = t;
      });

  bool _slotShowsCS(int slotIndex, double threshold) {
    final p = widget.animProgress;
    final cst = widget.caseStudyTransitionTarget;
    if (p == null || cst == null) return widget.isCaseStudyActive;
    return p >= threshold ? (cst == true) : widget.isCaseStudyActive;
  }

  Widget _buildSlot(int slotIndex, bool isDark, double csThreshold) {
    final showCS = _slotShowsCS(slotIndex, csThreshold);
    final project = widget.caseStudyProject;
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

    if (showCS && project != null) {
      final ctrl = Get.find<HomeController>();
      Widget panel;
      switch (slotIndex) {
        case 0:
          panel = CaseStudyHeroPanel(
              project: project,
              isDark: isDark,
              onClose: ctrl.requestCloseCaseStudy);
          break;
        case 1:
          panel =
              CaseStudyOverviewPanel(project: project, isDark: isDark);
          break;
        case 2:
          panel =
              CaseStudyFeaturesPanel(project: project, isDark: isDark);
          break;
        default:
          return const SizedBox.shrink();
      }
      return Theme(data: theme, child: panel);
    }

    switch (_slots[slotIndex]) {
      case _PanelContent.about:
        return Theme(data: theme, child: const AboutColumn());
      case _PanelContent.career:
        return Theme(data: theme, child: const CareerTimeline());
      case _PanelContent.work:
        return Theme(data: theme, child: const WorkColumn());
    }
  }

  Widget _animated(int slotIndex, bool isDark, double csThreshold) {
    final showCS = _slotShowsCS(slotIndex, csThreshold);
    final projKey =
        showCS ? (widget.caseStudyProject?.title ?? '') : '';
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0).animate(anim),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(
            '$slotIndex-${_slots[slotIndex]}-cs:$showCS-$projKey'),
        child: _buildSlot(slotIndex, isDark, csThreshold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.animProgress;
    final base = widget.isDark;
    final target = widget.targetDark;
    final ltr = widget.isLTR;
    final screenW = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(_edgePad),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final usableW = constraints.maxWidth - _handleW;
          final w1 = usableW * _f1;

          // ── Panel centers in screen coords (right column = slots 1 & 2) ──
          final leftC = _edgePad + w1 / 2;
          final rightC = _edgePad + w1 + _handleW +
              (constraints.maxWidth - w1 - _handleW) / 2;

          final leftDark = p == null
              ? base
              : _panelIsDark(
                  baseDark: base,
                  targetDark: target,
                  progress: p,
                  threshold: _passThreshold(leftC, screenW, ltr));
          final rightDark = p == null
              ? base
              : _panelIsDark(
                  baseDark: base,
                  targetDark: target,
                  progress: p,
                  threshold: _passThreshold(rightC, screenW, ltr));

          final csForward = widget.caseStudyTransitionTarget != true;
          final csThLeft = _passThreshold(leftC, screenW, csForward);
          final csThRight = _passThreshold(rightC, screenW, csForward);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: w1,
                child: _card(leftDark, _animated(0, leftDark, csThLeft)),
              ),
              _DragHandle(
                isDark: leftDark,
                onDrag: (dx) => _drag(dx, usableW),
                onDoubleTap: _reset,
                onSwap: widget.isCaseStudyActive ? null : () => _swap(0, 1),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      child: BentoGrid(
                          isDark: rightDark,
                          onThemeToggle: widget.onThemeToggle),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                        child: _card(rightDark,
                            _animated(1, rightDark, csThRight))),
                    _VerticalSwapSeparator(
                      isDark: rightDark,
                      onSwap: widget.isCaseStudyActive
                          ? null
                          : () => _swap(1, 2),
                    ),
                    Expanded(
                        child: _card(rightDark,
                            _animated(2, rightDark, csThRight))),
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
  final bool isCaseStudyActive;
  final bool? caseStudyTransitionTarget;
  final Project? caseStudyProject;

  const _MobileLayout({
    required this.isDark,
    required this.onThemeToggle,
    this.animProgress,
    this.targetDark = false,
    this.isLTR = true,
    this.isCaseStudyActive = false,
    this.caseStudyTransitionTarget,
    this.caseStudyProject,
  });

  bool _showsCS(double? p, bool? cst) {
    if (p == null || cst == null) return isCaseStudyActive;
    return p >= 0.50 ? (cst == true) : isCaseStudyActive;
  }

  @override
  Widget build(BuildContext context) {
    final p = animProgress;
    final panelDark = p == null
        ? isDark
        : _panelIsDark(
            baseDark: isDark,
            targetDark: targetDark,
            progress: p,
            threshold: 0.50);
    final showCS = _showsCS(p, caseStudyTransitionTarget);
    final project = caseStudyProject;
    final theme =
        panelDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    final ctrl = Get.find<HomeController>();

    Widget body;
    if (showCS && project != null) {
      body = Column(children: [
        _card(
            panelDark,
            CaseStudyHeroPanel(
                project: project,
                isDark: panelDark,
                onClose: ctrl.requestCloseCaseStudy)),
        const SizedBox(height: 12),
        _card(panelDark,
            CaseStudyOverviewPanel(project: project, isDark: panelDark)),
        const SizedBox(height: 12),
        _card(panelDark,
            CaseStudyFeaturesPanel(project: project, isDark: panelDark)),
      ]);
    } else {
      body = Column(children: [
        _card(panelDark, const AboutColumn(shrinkWrap: true)),
        const SizedBox(height: 12),
        _card(panelDark, const CareerTimeline(shrinkWrap: true)),
        const SizedBox(height: 12),
        _card(panelDark, const WorkColumn(shrinkWrap: true)),
      ]);
    }

    return Theme(
      data: theme,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: KeyedSubtree(
          key: ValueKey(
              'mob-cs:$showCS-${showCS ? project?.title ?? '' : ''}'),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              BentoGrid(
                  isDark: panelDark, onThemeToggle: onThemeToggle),
              const SizedBox(height: 12),
              body,
            ]),
          ),
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
  bool _hovered = false;
  bool _dragging = false;
  bool _badgeHover = false;
  bool _badgePressed = false;

  bool get _active => _hovered || _dragging;

  @override
  Widget build(BuildContext context) {
    final lineColor = _active
        ? AppColors.accent
        : (widget.isDark ? AppColors.borderDark : AppColors.borderLight);

    final baseBg =
        widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final badgeBg = _badgeHover
        ? Color.alphaBlend(
            AppColors.accent.withValues(alpha: 0.18), baseBg)
        : baseBg;
    final badgeBorder = _badgeHover
        ? AppColors.accent.withValues(alpha: 0.70)
        : (widget.isDark ? AppColors.borderDark : AppColors.borderLight);
    final iconColor = _badgeHover
        ? AppColors.accent
        : (widget.isDark
            ? AppColors.textTertiaryDark
            : AppColors.textTertiaryLight);

    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: _active ? 2.0 : 1.0,
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                if (_active && widget.onSwap == null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        3,
                        (_) => Container(
                              width: 4,
                              height: 4,
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accent,
                              ),
                            )),
                  ),
                if (widget.onSwap != null)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _badgeHover = true),
                    onExit: (_) => setState(() => _badgeHover = false),
                    child: GestureDetector(
                      onTap: widget.onSwap,
                      onTapDown: (_) =>
                          setState(() => _badgePressed = true),
                      onTapUp: (_) =>
                          setState(() => _badgePressed = false),
                      onTapCancel: () =>
                          setState(() => _badgePressed = false),
                      child: Tooltip(
                        message: 'Swap panels',
                        child: AnimatedScale(
                          scale: _badgePressed ? 0.82 : 1.0,
                          duration: const Duration(milliseconds: 90),
                          curve: Curves.easeOut,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: _badgeHover ? 26 : 22,
                            height: _badgeHover ? 26 : 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _badgePressed
                                  ? Color.alphaBlend(
                                      AppColors.accent
                                          .withValues(alpha: 0.35),
                                      baseBg)
                                  : badgeBg,
                              border: Border.all(
                                color: badgeBorder,
                                width: _badgeHover ? 1.5 : 1.0,
                              ),
                              boxShadow: _badgeHover && !_badgePressed
                                  ? [
                                      BoxShadow(
                                        color: AppColors.accent
                                            .withValues(alpha: 0.30),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Icon(Icons.swap_horiz,
                                  size: 13, color: iconColor),
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
  final VoidCallback? onSwap;

  const _VerticalSwapSeparator({
    required this.isDark,
    this.onSwap,
  });

  @override
  State<_VerticalSwapSeparator> createState() =>
      _VerticalSwapSeparatorState();
}

class _VerticalSwapSeparatorState extends State<_VerticalSwapSeparator> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final lineColor = _hovered
        ? AppColors.accent.withValues(alpha: 0.50)
        : (widget.isDark ? AppColors.borderDark : AppColors.borderLight);
    final baseBg =
        widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final badgeBg = _hovered
        ? Color.alphaBlend(
            AppColors.accent.withValues(alpha: 0.18), baseBg)
        : baseBg;
    final badgeBorder = _hovered
        ? AppColors.accent.withValues(alpha: 0.70)
        : (widget.isDark ? AppColors.borderDark : AppColors.borderLight);
    final iconColor = _hovered
        ? AppColors.accent
        : (widget.isDark
            ? AppColors.textTertiaryDark
            : AppColors.textTertiaryLight);

    return MouseRegion(
      cursor: widget.onSwap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onSwap,
        onTapDown:
            widget.onSwap != null ? (_) => setState(() => _pressed = true) : null,
        onTapUp: widget.onSwap != null
            ? (_) => setState(() => _pressed = false)
            : null,
        onTapCancel: widget.onSwap != null
            ? () => setState(() => _pressed = false)
            : null,
        child: Tooltip(
          message: widget.onSwap != null ? 'Swap panels' : '',
          waitDuration: const Duration(milliseconds: 400),
          child: SizedBox(
            height: 28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: _hovered ? 2.0 : 1.0,
                  color: lineColor,
                ),
                AnimatedScale(
                  scale: _pressed ? 0.82 : 1.0,
                  duration: const Duration(milliseconds: 90),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: _hovered ? 26 : 22,
                    height: _hovered ? 26 : 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _pressed
                          ? Color.alphaBlend(
                              AppColors.accent.withValues(alpha: 0.35),
                              baseBg)
                          : badgeBg,
                      border: Border.all(
                        color: badgeBorder,
                        width: _hovered ? 1.5 : 1.0,
                      ),
                      boxShadow: _hovered && !_pressed
                          ? [
                              BoxShadow(
                                color: AppColors.accent
                                    .withValues(alpha: 0.30),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child:
                          Icon(Icons.swap_vert, size: 13, color: iconColor),
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
// Shared card shell
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
  final double progress; // eased — drives position/sweep sync
  final double rawProgress; // linear — drives wingbeats/drift at constant rate
  final bool isLTR;
  final bool isDark;
  final bool isVertical;

  const _BirdFlockPainter({
    required this.progress,
    required this.rawProgress,
    required this.isLTR,
    required this.isDark,
    required this.isVertical,
  });

  // ── Formation offsets ────────────────────────────────────────────────────
  static const List<Offset> _hOffsets = [
    Offset(0, 0),
    Offset(-52, -45), Offset(-52, 45),
    Offset(-104, -95), Offset(-104, 95),
    Offset(-156, -148), Offset(-156, 148),
    Offset(-205, -198), Offset(-205, 198),
    Offset(-248, -245), Offset(-248, 245),
    Offset(-70, -28),  Offset(-70, 28),
    Offset(-168, -120),
  ];

  static const List<Offset> _vOffsets = [
    Offset(0, 0),
    Offset(-45, -52),  Offset(45, -52),
    Offset(-95, -104), Offset(95, -104),
    Offset(-148, -156),Offset(148, -156),
    Offset(-198, -205),Offset(198, -205),
    Offset(-245, -248),Offset(245, -248),
    Offset(-28, -70),  Offset(28, -70),
    Offset(-120, -168),
  ];

  static const List<double> _fontSizes = [
    30, 25, 25, 22, 22, 19, 19, 17, 17, 15, 15, 23, 23, 20,
  ];

  // ── Pre-cached ui.Paragraph per (fontSize, char) — layout runs ONCE ever ──
  // White color baked in; per-frame tinting done via saveLayer ColorFilter.
  // Two caches: close brace `}` (even index, right-wing/lead) and
  //             open  brace `{` (odd  index, left-wing).
  static final Map<double, (ui.Paragraph, double, double)> _paraClose = {}; // }
  static final Map<double, (ui.Paragraph, double, double)> _paraOpen  = {}; // {

  static (ui.Paragraph, double, double) _getPara(double fs, {bool open = false}) {
    final cache = open ? _paraOpen : _paraClose;
    final cached = cache[fs];
    if (cached != null) return cached;
    final para = (ui.ParagraphBuilder(
      ui.ParagraphStyle(textDirection: TextDirection.ltr),
    )
      ..pushStyle(ui.TextStyle(
        color: const Color(0xFFFFFFFF), // white; tinted per-frame via saveLayer
        fontSize: fs,
        fontWeight: FontWeight.w200,
        height: 1.0,
      ))
      ..addText(open ? '{' : '}'))
        .build()
      ..layout(const ui.ParagraphConstraints(width: 100));
    final entry = (para, para.width / 2, para.height / 2);
    cache[fs] = entry;
    return entry;
  }

  // ── Paint entry ──────────────────────────────────────────────────────────
  @override
  void paint(Canvas canvas, Size size) {
    // Fade in over first 8%, hold, fade out over last 15% — no pop at entry.
    final fadeIn = (progress / 0.08).clamp(0.0, 1.0);
    final fadeOut = progress > 0.85
        ? ((1.0 - progress) / 0.15).clamp(0.0, 1.0)
        : 1.0;
    final alpha = 0.88 * Curves.easeOut.transform(fadeIn) * fadeOut;
    if (alpha <= 0.004) return;
    final baseColor =
        (isDark && isLTR && !isVertical) ? Colors.white : AppColors.accent;

    // Compute lead position for tight saveLayer bounds (avoids full-screen compositing)
    // Cross-axis margin covers formation spread (±245) + wave-lag swing + drift/bob.
    final Rect layerRect;
    if (!isVertical) {
      final travel = size.width * 1.15 + 320;
      final lx = isLTR
          ? -size.width * 0.15 + travel * progress
          : size.width * 1.15 - travel * progress;
      final ly = size.height * 0.45
          + math.sin(progress * math.pi * 2.2) * 55.0
          + math.sin(progress * math.pi * 4.7 + 1.0) * 22.0;
      final x0 = isLTR ? lx - 270.0 : lx - 30.0;
      final x1 = isLTR ? lx + 30.0  : lx + 270.0;
      layerRect = Rect.fromLTRB(
        x0.clamp(0.0, size.width), (ly - 340.0).clamp(0.0, size.height),
        x1.clamp(0.0, size.width), (ly + 340.0).clamp(0.0, size.height),
      );
    } else {
      final travel = size.height * 1.15 + 320;
      final goingDown = !isLTR;
      final ly = goingDown
          ? -size.height * 0.15 + travel * progress
          : size.height * 1.15 - travel * progress;
      final lx = size.width * 0.5
          + math.sin(progress * math.pi * 2.2) * 45.0
          + math.sin(progress * math.pi * 4.7 + 1.0) * 18.0;
      final y0 = goingDown ? ly - 30.0 : ly - 270.0;
      final y1 = goingDown ? ly + 270.0 : ly + 30.0;
      layerRect = Rect.fromLTRB(
        (lx - 320.0).clamp(0.0, size.width),  y0.clamp(0.0, size.height),
        (lx + 320.0).clamp(0.0, size.width),  y1.clamp(0.0, size.height),
      );
    }

    // Single saveLayer: tints pre-rendered white glyphs → baseColor + fade alpha.
    // ~300×580px bounds on desktop → small offscreen buffer, not full-screen.
    canvas.saveLayer(
      layerRect.isEmpty ? Offset.zero & size : layerRect,
      Paint()..colorFilter = ColorFilter.mode(
        baseColor.withValues(alpha: alpha),
        BlendMode.modulate,
      ),
    );

    if (isVertical) {
      _paintVertical(canvas, size);
    } else {
      _paintHorizontal(canvas, size);
    }

    canvas.restore();
  }

  // ── Wingbeat: constant-rate (rawProgress), asymmetric — quick downstroke,
  //    slower upstroke; slight per-bird frequency variation breaks lockstep.
  double _flap(int i) {
    final phase =
        rawProgress * 9.0 * math.pi * (1.0 + (i % 3) * 0.05) + i * 0.55;
    return math.sin(phase + 0.45 * math.sin(phase));
  }

  // ── Horizontal flock ─────────────────────────────────────────────────────
  void _paintHorizontal(Canvas canvas, Size size) {
    final travel = size.width * 1.15 + 320;
    final leadX = isLTR
        ? -size.width * 0.15 + travel * progress
        : size.width * 1.15 - travel * progress;
    final dWave1 = math.cos(progress * math.pi * 2.2) * math.pi * 2.2 * 55.0;
    final dWave2 = math.cos(progress * math.pi * 4.7 + 1.0) * math.pi * 4.7 * 22.0;
    final flightAngle = math.atan2(dWave1 + dWave2, isLTR ? travel : -travel);

    for (int i = 0; i < _hOffsets.length; i++) {
      final off = _hOffsets[i];
      // Followers trace the lead's path with a small time lag → the formation
      // undulates organically instead of translating as a rigid body.
      final lp = progress - off.dx.abs() * 0.0002;
      final waveY = math.sin(lp * math.pi * 2.2) * 55.0 +
          math.sin(lp * math.pi * 4.7 + 1.0) * 22.0;
      final drift = math.sin(rawProgress * math.pi * 5.8 + i * 1.15) * 5.0;
      final flapNorm = _flap(i);
      final center = Offset(
        leadX + (isLTR ? off.dx : -off.dx),
        size.height * 0.45 + waveY + off.dy + drift - flapNorm * 3.0,
      );
      // Even index = right-wing / lead → `}`; odd = left-wing → `{`
      _drawBird(canvas, center, flapNorm, flightAngle, _fontSizes[i], i.isOdd);
    }
  }

  // ── Vertical flock (mobile) ──────────────────────────────────────────────
  void _paintVertical(Canvas canvas, Size size) {
    final goingDown = !isLTR;
    final travel = size.height * 1.15 + 320;
    final leadY = goingDown
        ? -size.height * 0.15 + travel * progress
        : size.height * 1.15 - travel * progress;
    final dWave1 = math.cos(progress * math.pi * 2.2) * math.pi * 2.2 * 45.0;
    final dWave2 = math.cos(progress * math.pi * 4.7 + 1.0) * math.pi * 4.7 * 18.0;
    final flightAngle = math.atan2(goingDown ? travel : -travel, dWave1 + dWave2);

    for (int i = 0; i < _vOffsets.length; i++) {
      final off = _vOffsets[i];
      final lp = progress - off.dy.abs() * 0.0002;
      final waveX = math.sin(lp * math.pi * 2.2) * 45.0 +
          math.sin(lp * math.pi * 4.7 + 1.0) * 18.0;
      final drift = math.sin(rawProgress * math.pi * 5.8 + i * 1.15) * 4.0;
      final flapNorm = _flap(i);
      final center = Offset(
        size.width * 0.5 + waveX + off.dx + drift - flapNorm * 3.0,
        leadY + (goingDown ? off.dy : -off.dy),
      );
      _drawBird(canvas, center, flapNorm, flightAngle, _fontSizes[i], i.isOdd);
    }
  }

  // ── Single bird: pre-cached ui.Paragraph, zero layout() per frame ────────
  static void _drawBird(Canvas canvas, Offset c, double flapNorm,
      double flightAngle, double fontSize, bool open) {
    final (para, hw, hh) = _getPara(fontSize, open: open);
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(flightAngle + flapNorm * 0.35);
    // Subtle body pulse with the wingbeat — reads as lift.
    final pulse = 1.0 + flapNorm * 0.05;
    canvas.scale(pulse, pulse);
    canvas.drawParagraph(para, Offset(-hw, -hh));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BirdFlockPainter old) =>
      old.progress != progress ||
      old.rawProgress != rawProgress ||
      old.isLTR != isLTR ||
      old.isDark != isDark ||
      old.isVertical != isVertical;
}
