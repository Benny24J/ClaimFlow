import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final bool isAlert;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        isAlert ? Colors.orange : theme.colorScheme.onSurface.withAlpha(150);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(115),
              letterSpacing: 0.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}