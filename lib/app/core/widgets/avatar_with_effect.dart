import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Dark-tech avatar — designed for this portfolio's aesthetic:
///
/// Photo layer:
///  • True luma grayscale (removes colour noise)
///  • Accent-green tint overlay → photo adopts site colour language
///  • CRT scanlines (subtle horizontal bands)
///  • Film grain
///
/// Frame layer:
///  • Slowly-rotating dashed ring (8 s / revolution) in accent colour
///  • Counter-rotating 4-segment inner arc (12 s, dimmer)
///  • Deep shadow + soft accent glow
class AvatarWithEffect extends StatefulWidget {
  final double size;
  const AvatarWithEffect({super.key, this.size = 130});

  @override
  State<AvatarWithEffect> createState() => _AvatarWithEffectState();
}

class _AvatarWithEffectState extends State<AvatarWithEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    // Total canvas = photo + ring gap + ring stroke clearance
    final total = s + 24.0;

    return SizedBox(
      width: total,
      height: total,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Rings (behind shadow but drawn first so shadow clips over them) ─
          AnimatedBuilder(
            animation: _spin,
            builder: (_, __) => CustomPaint(
              size: Size(total, total),
              painter: _RingsPainter(progress: _spin.value),
            ),
          ),

          // ── Photo with effects ────────────────────────────────────────────
          Container(
            width: s,
            height: s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.60),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.18),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Grayscale
                  ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0,      0,      0,      1, 0,
                    ]),
                    child: Image.asset(
                      'assets/images/avatar.jpg',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, err, __) {
                        debugPrint('Avatar error: $err');
                        return ColoredBox(
                          color: AppColors.surfaceDark,
                          child: Center(
                            child: Text(
                              'SP',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                                fontSize: s * 0.25,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 2. Accent-green tint — photo speaks the site's language
                  ColoredBox(
                    color: AppColors.accent.withValues(alpha: 0.18),
                  ),

                  // 3. CRT scanlines
                  const CustomPaint(painter: _ScanlinePainter()),

                  // 4. Film grain
                  const CustomPaint(painter: _GrainPainter(opacity: 0.22)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rings painter
// Outer: 18 short dashes, clockwise, 8 s
// Inner: 4 long segments, counter-clockwise, 12 s  (derived from same controller)
// ─────────────────────────────────────────────────────────────────────────────
class _RingsPainter extends CustomPainter {
  final double progress; // 0 → 1 from AnimationController

  const _RingsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);

    // ── Outer dashed ring ────────────────────────────────────────────────────
    final outerR = size.width / 2 - 2;
    final outerRect = Rect.fromCircle(center: center, radius: outerR);
    final outerPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const outerDashes = 18;
    const outerDashFrac = 0.45;
    const outerSeg = (math.pi * 2) / outerDashes;
    final outerOffset = progress * math.pi * 2;

    for (int i = 0; i < outerDashes; i++) {
      final start = -math.pi / 2 + i * outerSeg + outerOffset;
      canvas.drawArc(outerRect, start, outerSeg * outerDashFrac, false, outerPaint);
    }

    // ── Inner 4-segment arc (counter-clockwise, slower) ──────────────────────
    final innerR = outerR - 6;
    final innerRect = Rect.fromCircle(center: center, radius: innerR);
    final innerPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    const innerSegs = 4;
    const innerDashFrac = 0.60;
    const innerSeg = (math.pi * 2) / innerSegs;
    // counter-rotate at 12/8 = 1.5× slower
    final innerOffset = -progress * (8 / 12) * math.pi * 2;

    for (int i = 0; i < innerSegs; i++) {
      final start = -math.pi / 2 + i * innerSeg + innerOffset;
      canvas.drawArc(innerRect, start, innerSeg * innerDashFrac, false, innerPaint);
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// CRT scanlines — every 3 px, 12 % opacity
// ─────────────────────────────────────────────────────────────────────────────
class _ScanlinePainter extends CustomPainter {
  const _ScanlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..strokeWidth = 1.0;
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Film grain — fixed seed, accent-toned specks
// ─────────────────────────────────────────────────────────────────────────────
class _GrainPainter extends CustomPainter {
  final double opacity;
  const _GrainPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(0xc0ffee42);
    final paint = Paint();
    final count = (size.width * size.height * 0.045).toInt();
    for (int i = 0; i < count; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final a = (rng.nextDouble() * opacity * 255).round().clamp(0, 255);
      // Mostly neutral-white grain with occasional accent-green speck
      final isAccent = rng.nextInt(10) == 0;
      paint.color = isAccent
          ? Color.fromARGB(a ~/ 2, 74, 222, 128)   // #4ADE80 accent
          : (rng.nextBool()
              ? Color.fromARGB(a, 220, 255, 220)    // cool-white
              : Color.fromARGB(a ~/ 2, 0, 10, 0));  // near-black
      canvas.drawCircle(
        Offset(x, y),
        rng.nextDouble() * 0.6 + 0.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GrainPainter old) => old.opacity != opacity;
}
