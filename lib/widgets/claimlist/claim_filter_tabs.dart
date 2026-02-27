import 'package:flutter/material.dart';

enum ClaimFilter { all, atRisk, overdue }

class ClaimFilterTabs extends StatelessWidget {
  final ClaimFilter selected;
  final ValueChanged<ClaimFilter> onChanged;

  const ClaimFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: ClaimFilter.values.map((filter) {
          final isSelected = selected == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.surface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.shadow
                                .withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  _label(filter),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(ClaimFilter f) {
    switch (f) {
      case ClaimFilter.all: return 'All';
      case ClaimFilter.atRisk: return 'At Risk';
      case ClaimFilter.overdue: return 'Overdue';
    }
  }
}