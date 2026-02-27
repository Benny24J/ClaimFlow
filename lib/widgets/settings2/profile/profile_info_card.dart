import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String sectionTitle;
  final List<ProfileInfoRow> rows;

  const ProfileInfoCard({
    super.key,
    required this.sectionTitle,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
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
            children: rows.map((row) {
              final index = rows.indexOf(row);
              final isLast = index == rows.length - 1;
              return Column(
                children: [
                  _ProfileInfoRowWidget(row: row),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: theme.colorScheme.outline
                          .withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class ProfileInfoRow {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _ProfileInfoRowWidget extends StatelessWidget {
  final ProfileInfoRow row;

  const _ProfileInfoRowWidget({required this.row});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              row.icon,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                row.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.5,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                row.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}