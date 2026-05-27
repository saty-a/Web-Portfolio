import 'package:flutter/material.dart';
import 'responsive_layout.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const SectionContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
          child: child,
        ),
      ),
    );
  }
}
