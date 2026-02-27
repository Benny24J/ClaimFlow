import 'package:flutter/material.dart';
import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  final int claimsSubmitted;
  final int pendingReview;
  final int riskAlerts;
  final VoidCallback? onRiskAlertsTap;

  const StatsRow({
    super.key,
    required this.claimsSubmitted,
    required this.pendingReview,
    required this.riskAlerts,
    this.onRiskAlertsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.filter_list_rounded,
            value: claimsSubmitted,
            label: 'CLAIMS\nSUBMITTED',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            icon: Icons.grid_view_rounded,
            value: pendingReview,
            label: 'PENDING\nREVIEW',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onRiskAlertsTap,
            child: StatCard(
              icon: Icons.warning_amber_rounded,
              value: riskAlerts,
              label: 'RISK\nALERTS',
              isAlert: true,
            ),
          ),
        ),
      ],
    );
  }
}