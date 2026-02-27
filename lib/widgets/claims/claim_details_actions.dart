import 'package:flutter/material.dart';

class ClaimDetailsBottomActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onSubmitAnyway;
  final bool hasRisks;

  const ClaimDetailsBottomActions({
    super.key,
    required this.onEdit,
    required this.onSubmitAnyway,
    required this.hasRisks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onSubmitAnyway,
              icon: Icon(
                hasRisks ? Icons.info_outline : Icons.send_outlined,
                size: 16,
              ),
              label: Text(hasRisks ? 'Submit Anyway' : 'Submit Claim'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubmitAnywayDialog extends StatelessWidget {
  final int riskCount;
  final double totalAtRisk;

  const SubmitAnywayDialog({
    super.key,
    required this.riskCount,
    required this.totalAtRisk,
  });

  String _fmt(double amount) => amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFE53935), size: 22),
          const SizedBox(width: 8),
          const Text('Submit With Risks?'),
        ],
      ),
      content: Text(
        'This claim has $riskCount unresolved issue${riskCount > 1 ? 's' : ''} '
        'with ₦${_fmt(totalAtRisk)} at risk. Submitting without fixing these '
        'issues may result in claim denial.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Go Back'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935)),
          child: const Text('Submit Anyway'),
        ),
      ],
    );
  }
}