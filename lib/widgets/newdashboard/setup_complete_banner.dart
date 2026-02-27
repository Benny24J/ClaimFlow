import 'package:flutter/material.dart';

class SetupCompleteBanner extends StatelessWidget {
  final VoidCallback onDismiss;

  const SetupCompleteBanner({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(64)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organization Setup Complete',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You can now submit and manage healthcare claims with full risk validation.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(150),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close,
                size: 18, color: theme.colorScheme.onSurface.withAlpha(100)),
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}