import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class PortfolioDrawer extends StatelessWidget {
  final VoidCallback onProjectsPressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onContactPressed;

  const PortfolioDrawer({
    super.key,
    required this.onProjectsPressed,
    required this.onAboutPressed,
    required this.onContactPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Portfolio',
                  style: AppTypography.titleLarge(context).copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Satya',
                  style: AppTypography.bodyLarge(context).copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              onAboutPressed();
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Projects'),
            onTap: () {
              Navigator.pop(context);
              onProjectsPressed();
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Contact'),
            onTap: () {
              Navigator.pop(context);
              onContactPressed();
            },
          ),
        ],
      ),
    );
  }
} 