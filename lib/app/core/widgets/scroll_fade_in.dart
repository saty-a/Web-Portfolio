import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../animations/animation_constants.dart';

class ScrollFadeIn extends StatefulWidget {
  final Widget child;
  final int staggerIndex;
  final Duration? duration;
  final double slideOffset;

  const ScrollFadeIn({
    super.key,
    required this.child,
    this.staggerIndex = 0,
    this.duration,
    this.slideOffset = AnimationConstants.slideUpOffset,
  });

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

class _ScrollFadeInState extends State<ScrollFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? AnimationConstants.fadeInDuration,
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AnimationConstants.fadeInCurve),
    );
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: AnimationConstants.fadeInCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_hasAnimated) return;
    if (info.visibleFraction >= AnimationConstants.visibilityThreshold) {
      _hasAnimated = true;
      final delay = AnimationConstants.staggerDelay * widget.staggerIndex;
      Future.delayed(delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('scroll_fade_${widget.key ?? identityHashCode(this)}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _slide.value,
            child: Opacity(
              opacity: _opacity.value,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
