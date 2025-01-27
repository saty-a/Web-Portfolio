import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class PortfolioDrawer extends StatelessWidget {
  const PortfolioDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding),
              child: Text(
                'Portfolio',
                style: AppTypography.titleLarge(context),
              ),
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.home,
              title: 'Home',
              isActive: true,
              onTap: () => Get.toNamed('/'),
            ),
            _DrawerItem(
              icon: Icons.work,
              title: 'Projects',
              onTap: () {},
            ),
            _DrawerItem(
              icon: Icons.person,
              title: 'About',
              onTap: () {},
            ),
            _DrawerItem(
              icon: Icons.mail,
              title: 'Contact',
              onTap: () {},
            ),
            const Spacer(),
            const Divider(),
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding),
              child: Text(
                '© 2025 John Doe. All rights reserved.',
                style: AppTypography.bodySmall(context),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: AppTypography.titleSmall(context).copyWith(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      onTap: onTap,
      selected: isActive,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
} 