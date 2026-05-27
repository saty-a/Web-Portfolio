import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CopyEmailButton extends StatefulWidget {
  final String email;

  const CopyEmailButton({super.key, required this.email});

  @override
  State<CopyEmailButton> createState() => _CopyEmailButtonState();
}

class _CopyEmailButtonState extends State<CopyEmailButton> {
  bool _copied = false;
  bool _hovered = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _copyEmail() async {
    await Clipboard.setData(ClipboardData(text: widget.email));
    setState(() => _copied = true);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _copyEmail,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _copied
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : _hovered
                      ? (isDark ? AppColors.borderDark : AppColors.borderLight)
                      : Colors.transparent,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _copied
                ? Row(
                    key: const ValueKey('copied'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, size: 14, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Copied!',
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    key: const ValueKey('copy'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 14,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Copy email',
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
