import 'package:claimflow_africa/dmodels/riskflag_model.dart';
import 'package:claimflow_africa/utils/formatters.dart';
import 'package:flutter/material.dart';

class RiskFlagsSection extends StatelessWidget {
  final List<RiskFlag> flags;
  final double totalAtRisk;
  final ValueChanged<RiskFlag> onFixIssue;
  final Color Function(String) riskColor;
  final Color Function(String) riskBadgeBg;

  const RiskFlagsSection({
    super.key,
    required this.flags,
    required this.totalAtRisk,
    required this.onFixIssue,
    required this.riskColor,
    required this.riskBadgeBg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'POTENTIAL LOSSES (${flags.length})',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 14, color: Color(0xFFE53935)),
                    const SizedBox(width: 4),
                    Text(
                      '${formatNaira(totalAtRisk)} at risk',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFFE53935),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ...flags.map((flag) => RiskFlagCard(
                flag: flag,
                onFixIssue: () => onFixIssue(flag),
                riskColor: riskColor(flag.severity),
                riskBadgeBg: riskBadgeBg(flag.severity),
              )),
        ],
      ),
    );
  }
}

class RiskFlagCard extends StatelessWidget {
  final RiskFlag flag;
  final VoidCallback onFixIssue;
  final Color riskColor;
  final Color riskBadgeBg;

  const RiskFlagCard({
    super.key,
    required this.flag,
    required this.onFixIssue,
    required this.riskColor,
    required this.riskBadgeBg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: riskColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(flag.title,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: riskBadgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  flag.severity[0] +
                      flag.severity.substring(1).toLowerCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            flag.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'IMPACT: ',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.5,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    TextSpan(
                      text: formatNaira(flag.impact),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onFixIssue,
                child: Row(
                  children: [
                    Text(
                      'Fix Issue',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward,
                        size: 14, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}