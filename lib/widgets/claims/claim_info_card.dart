import 'package:flutter/material.dart';
import 'package:claimflow_africa/dmodels/claim_model.dart';

class ClaimInfoCard extends StatelessWidget {
  final ClaimModel claim;

  const ClaimInfoCard({super.key, required this.claim});

  String _formatDate(DateTime dt) =>
      '${_monthName(dt.month)} ${dt.day}, ${dt.year}';

  String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];

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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CLAIM INFO',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InfoField(
                  label: 'SERVICE DATE',
                  value: _formatDate(claim.serviceDate),
                ),
              ),
              Expanded(
                child: _InfoField(
                  label: 'DIAGNOSIS',
                  value: claim.diagnosisCode,
                ),
              ),
            ],
          ),
          if (claim.notes.isNotEmpty) ...[
            const SizedBox(height: 14),
            _InfoField(label: 'NOTES', value: claim.notes),
          ],
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;

  const _InfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 0.5,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}