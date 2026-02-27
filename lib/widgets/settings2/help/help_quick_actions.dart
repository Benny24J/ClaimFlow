import 'package:flutter/material.dart';

class HelpQuickActions extends StatelessWidget {
  const HelpQuickActions({super.key});

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACTIONS',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            children: [
              _QuickActionTile(
                icon: Icons.play_circle_outline,
                iconColor: const Color(0xFF7C3AED),
                label: 'Watch Tutorial Videos',
                onTap: () => Navigator.pushNamed(context, '/help/tutorials'),
              ),
              Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
              _QuickActionTile(
                icon: Icons.chat_bubble_outline,
                iconColor: const Color(0xFF4CAF50),
                label: 'Contact Support',
                onTap: () => Navigator.pushNamed(context, '/help/contact'),
              ),
              Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
              _QuickActionTile(
                icon: Icons.settings_outlined,
                iconColor: const Color(0xFF9E9E9E),
                label: 'View System Status',
                onTap: () => _showComingSoon(context, 'System status'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}