import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

// ─── Store types ────────────────────────────────────────────────────────────

enum StoreType {
  github,
  playStore,
  appStore,
  windowsStore,
  macStore,
  pubDev,
  live,
}

// ─── Per-store metadata ──────────────────────────────────────────────────────

class _StoreConfig {
  final dynamic icon; // IconData (Material or FontAwesome)
  final bool isFaIcon;
  final String action; // small top line
  final String name; // bold bottom line
  final Color brandColor;

  const _StoreConfig({
    required this.icon,
    this.isFaIcon = false,
    required this.action,
    required this.name,
    required this.brandColor,
  });
}

const _configs = {
  StoreType.github: _StoreConfig(
    icon: FontAwesomeIcons.github,
    isFaIcon: true,
    action: 'View on',
    name: 'GitHub',
    brandColor: Color(0xFF58A6FF),
  ),
  StoreType.playStore: _StoreConfig(
    icon: FontAwesomeIcons.googlePlay,
    isFaIcon: true,
    action: 'Get it on',
    name: 'Google Play',
    brandColor: Color(0xFF01875F),
  ),
  StoreType.appStore: _StoreConfig(
    icon: FontAwesomeIcons.appStoreIos,
    isFaIcon: true,
    action: 'Download on the',
    name: 'App Store',
    brandColor: Color(0xFF1C8EF9),
  ),
  StoreType.windowsStore: _StoreConfig(
    icon: FontAwesomeIcons.windows,
    isFaIcon: true,
    action: 'Get it from',
    name: 'Microsoft',
    brandColor: Color(0xFF0078D4),
  ),
  StoreType.macStore: _StoreConfig(
    icon: FontAwesomeIcons.apple,
    isFaIcon: true,
    action: 'Download on the',
    name: 'Mac App Store',
    brandColor: Color(0xFF636366),
  ),
  StoreType.pubDev: _StoreConfig(
    icon: FontAwesomeIcons.cube,
    isFaIcon: true,
    action: 'Available on',
    name: 'pub.dev',
    brandColor: Color(0xFF0175C2),
  ),
  StoreType.live: _StoreConfig(
    icon: FontAwesomeIcons.arrowUpRightFromSquare,
    isFaIcon: true,
    action: 'Open',
    name: 'Live Site',
    brandColor: Color(0xFF4ADE80),
  ),
};

// ─── Badge widget ────────────────────────────────────────────────────────────

class StoreBadge extends StatefulWidget {
  final StoreType type;
  final VoidCallback onTap;
  final bool isDark;

  const StoreBadge({
    super.key,
    required this.type,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<StoreBadge> createState() => _StoreBadgeState();
}

class _StoreBadgeState extends State<StoreBadge>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _ctrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onEnter(_) {
    setState(() => _hovered = true);
    _ctrl.forward();
  }

  void _onExit(_) {
    setState(() => _hovered = false);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _configs[widget.type]!;
    final defaultIconColor = widget.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final defaultBorder = widget.isDark
        ? AppColors.borderDark
        : AppColors.borderLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, _) {
            final t = _progress.value;
            final iconColor =
                Color.lerp(defaultIconColor, cfg.brandColor, t)!;
            final borderColor =
                Color.lerp(defaultBorder, cfg.brandColor, t)!;
            final bgColor = cfg.brandColor.withValues(alpha: t * 0.10);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: _hovered ? 14 : 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: cfg.brandColor.withValues(alpha: 0.15),
                          blurRadius: 12,
                          spreadRadius: 0,
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  cfg.isFaIcon
                      ? FaIcon(
                          cfg.icon as IconData,
                          size: 15,
                          color: iconColor,
                        )
                      : Icon(
                          cfg.icon as IconData,
                          size: 17,
                          color: iconColor,
                        ),

                  // Expanding text section
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: _hovered
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 9),
                              Opacity(
                                opacity: t.clamp(0.0, 1.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cfg.action,
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.2,
                                        height: 1.2,
                                        color: iconColor.withValues(alpha: 0.75),
                                      ),
                                    ),
                                    Text(
                                      cfg.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.2,
                                        height: 1.2,
                                        color: iconColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Helper builder for a project's link row ────────────────────────────────

class StoreBadgeRow extends StatelessWidget {
  final String? githubUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? windowsStoreUrl;
  final String? macStoreUrl;
  final String? liveUrl;
  final bool isDark;
  final Future<void> Function(String) launchUrl;

  const StoreBadgeRow({
    super.key,
    this.githubUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    this.windowsStoreUrl,
    this.macStoreUrl,
    this.liveUrl,
    required this.isDark,
    required this.launchUrl,
  });

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];

    void add(StoreType type, String url) => badges.add(
          StoreBadge(
            type: type,
            isDark: isDark,
            onTap: () => launchUrl(url),
          ),
        );

    if (githubUrl != null) add(StoreType.github, githubUrl!);
    if (playStoreUrl != null) add(StoreType.playStore, playStoreUrl!);
    if (appStoreUrl != null) add(StoreType.appStore, appStoreUrl!);
    if (windowsStoreUrl != null) add(StoreType.windowsStore, windowsStoreUrl!);
    if (macStoreUrl != null) add(StoreType.macStore, macStoreUrl!);
    if (liveUrl != null) {
      final isPub = liveUrl!.contains('pub.dev');
      add(isPub ? StoreType.pubDev : StoreType.live, liveUrl!);
    }

    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: badges,
    );
  }
}
