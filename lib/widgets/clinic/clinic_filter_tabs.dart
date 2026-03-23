import 'package:flutter/material.dart';
import 'package:claimflow_africa/providers/clinic_provider.dart';

class ClinicFilterTabs extends StatelessWidget {
  final ClinicFilter selected;
  final ValueChanged<ClinicFilter> onChanged;

  const ClinicFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  String _label(ClinicFilter f) {
    switch (f) {
      case ClinicFilter.all:
        return 'All';
      case ClinicFilter.active:
        return 'Active';
      case ClinicFilter.inactive:
        return 'Inactive';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: ClinicFilter.values.map((filter) {
        final isSelected = selected == filter;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Text(
                _label(filter),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}