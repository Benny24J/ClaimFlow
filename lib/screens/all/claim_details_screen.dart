import 'package:flutter/material.dart';
import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/riskflag_model.dart';
import 'package:claimflow_africa/utils/formatters.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'package:claimflow_africa/widgets/claims/riskflag_section.dart';
import 'package:claimflow_africa/widgets/claims/claim_info_card.dart';
import 'package:claimflow_africa/widgets/claims/claim_details_actions.dart';

class ClaimDetailsScreen extends StatelessWidget {
  final ClaimModel claim;
  final List<RiskFlag> riskFlags;

  const ClaimDetailsScreen({
    super.key,
    required this.claim,
    required this.riskFlags,
  });

  String get _overallRisk {
    if (riskFlags.any((f) => f.severity == 'URGENT')) return 'URGENT';
    if (riskFlags.any((f) => f.severity == 'HIGH')) return 'HIGH';
    if (riskFlags.any((f) => f.severity == 'MEDIUM')) return 'MEDIUM';
    if (riskFlags.isNotEmpty) return 'LOW';
    return 'NONE';
  }

  double get _totalAtRisk =>
      riskFlags.fold(0, (sum, f) => sum + f.impact);

  Color _riskColor(String severity) {
    switch (severity) {
      case 'URGENT': return const Color(0xFF7B1FA2);
      case 'HIGH': return const Color(0xFFE53935);
      case 'MEDIUM': return const Color(0xFFF57C00);
      default: return const Color(0xFF43A047);
    }
  }

  Color _riskBadgeBg(String severity) {
    switch (severity) {
      case 'URGENT': return const Color(0xFFF3E5F5);
      case 'HIGH': return const Color(0xFFFFEBEE);
      case 'MEDIUM': return const Color(0xFFFFF3E0);
      default: return const Color(0xFFE8F5E9);
    }
  }

  void _onFixIssue(BuildContext context, RiskFlag flag) {
    Navigator.pushNamed(context, '/new-claim', arguments: {
      'claim': claim,
      'initialStep': flag.stepToFix,
    });
  }

  void _onEdit(BuildContext context) {
    Navigator.pushNamed(context, '/new-claim', arguments: {
      'claim': claim,
      'initialStep': 0,
    });
  }

  Future<void> _onSubmitAnyway(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => SubmitAnywayDialog(
        riskCount: riskFlags.length,
        totalAtRisk: _totalAtRisk,
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.pushNamed(context, '/claim-success', arguments: {
        'claim': claim,
        'isSynced': false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Claim Details',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      claim.patientName,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${claim.insurer} • ID: ${claim.nhiaId}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                if (_overallRisk != 'NONE')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _riskBadgeBg(_overallRisk),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_overallRisk Risk',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _riskColor(_overallRisk),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNaira(claim.totalClaimAmount),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'TOTAL AMOUNT',
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.8,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (riskFlags.isNotEmpty) ...[
              RiskFlagsSection(
                flags: riskFlags,
                totalAtRisk: _totalAtRisk,
                onFixIssue: (flag) => _onFixIssue(context, flag),
                riskColor: _riskColor,
                riskBadgeBg: _riskBadgeBg,
              ),
              const SizedBox(height: 16),
            ],

            ClaimInfoCard(claim: claim),
            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomSheet: ClaimDetailsBottomActions(
        onEdit: () => _onEdit(context),
        onSubmitAnyway: () => _onSubmitAnyway(context),
        hasRisks: riskFlags.isNotEmpty,
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}