import 'package:flutter/material.dart';
import 'claim_filter_tabs.dart';

class ClaimEmptyState extends StatelessWidget {
  final ClaimFilter activeFilter;

  const ClaimEmptyState({super.key, required this.activeFilter});

  String get _message {
    switch (activeFilter) {
      case ClaimFilter.atRisk:
        return 'No at risk claims found.\nAll your claims look healthy!';
      case ClaimFilter.overdue:
        return 'No overdue claims found.\nYou\'re all caught up!';
      case ClaimFilter.all:
       return 'We couldn\'t find any claims matching\nyour current filters.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.filter_alt_outlined,
              size: 32,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No claims found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}