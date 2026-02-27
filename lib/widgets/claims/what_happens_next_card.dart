import 'package:flutter/material.dart';

class WhatHappensNext extends StatelessWidget {
  final bool isSynced;
  const WhatHappensNext({super.key, required this.isSynced});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSynced ? Icons.schedule_outlined : Icons.wifi_off_outlined,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What happens next?',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  isSynced
                      ? "The payer typically reviews claims within 24-48 hours. You'll be notified of any updates or required actions."
                      : "This claim is saved on your device. It will automatically sync to the server once you're back online.",
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}