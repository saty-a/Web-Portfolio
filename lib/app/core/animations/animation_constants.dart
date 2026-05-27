import 'package:flutter/material.dart';

class AnimationConstants {
  // Durations
  static const Duration fadeInDuration = Duration(milliseconds: 600);
  static const Duration staggerDelay = Duration(milliseconds: 100);
  static const Duration hoverDuration = Duration(milliseconds: 200);
  static const Duration copyFeedbackDuration = Duration(seconds: 2);
  static const Duration heroStaggerDelay = Duration(milliseconds: 200);

  // Curves
  static const Curve fadeInCurve = Curves.easeOut;
  static const Curve hoverCurve = Curves.easeInOut;

  // Offsets
  static const double slideUpOffset = 20.0;

  // Hover
  static const double hoverScale = 1.02;
  static const double hoverElevation = 8.0;

  // Visibility threshold (trigger when 30% visible)
  static const double visibilityThreshold = 0.3;
}
