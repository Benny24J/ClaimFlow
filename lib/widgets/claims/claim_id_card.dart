

import 'package:flutter/material.dart';

class ClaimIdCard extends StatelessWidget {
  final String claimId;
  final String timestamp;
  final bool isSynced;
  final VoidCallback onCopy;

  const ClaimIdCard({super.key, 
    required this.claimId,
    required this.timestamp,
    required this.isSynced,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CLAIM ID',
                      style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 0.8,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5))),
                  const SizedBox(height: 4),
                  Text(claimId,
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary)),
                ],
              ),
              IconButton(
                onPressed: onCopy,
                icon: Icon(Icons.copy_outlined,
                    size: 20,
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSynced ? Colors.green : Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSynced ? 'Submitted' : 'Pending Sync',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isSynced ? 'SUBMITTED' : 'SAVED',
                    style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.8,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5)),
                  ),
                  const SizedBox(height: 4),
                  Text(timestamp,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}