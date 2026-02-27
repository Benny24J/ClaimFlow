import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/riskflag_model.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';

class RiskAlerts extends StatelessWidget {
  const RiskAlerts({super.key});

  
  List<RiskFlag> _evaluateRisks(ClaimModel claim) {
    final List<RiskFlag> flags = [];

    if (claim.nhiaId.isEmpty) {
      flags.add(RiskFlag(
        title: 'Missing NHIA ID',
        description: 'This claim has no NHIA ID assigned.',
        severity: 'URGENT',
        impact: claim.totalClaimAmount,
        stepToFix: 1,
      ));
    }

    if (claim.diagnosisCode.isEmpty) {
      flags.add(RiskFlag(
        title: 'Missing Clinical Data',
        description: 'Diagnosis code is missing.',
        severity: 'HIGH',
        impact: claim.totalClaimAmount,
        stepToFix: 2,
      ));
    }

    if (claim.procedureCode.isEmpty) {
      flags.add(RiskFlag(
        title: 'Invalid Provider Code',
        description: 'Procedure code is missing or invalid.',
        severity: 'HIGH',
        impact: claim.totalClaimAmount,
        stepToFix: 3,
      ));
    }

    if (claim.totalClaimAmount > 100000) {
      flags.add(RiskFlag(
        title: 'High Value Claim',
        description: 'Claim amount exceeds ₦100,000 threshold.',
        severity: 'MEDIUM',
        impact: claim.totalClaimAmount,
        stepToFix: 4,
      ));
    }

    if (claim.diagnosisCode.isNotEmpty &&
        claim.procedureCode.isNotEmpty &&
        claim.diagnosisCode == claim.procedureCode) {
      flags.add(RiskFlag(
        title: 'Mismatched Codes',
        description: 'Diagnosis and procedure codes are identical.',
        severity: 'MEDIUM',
        impact: claim.totalClaimAmount,
        stepToFix: 2,
      ));
    }

    return flags;
  }

 
  List<Map<String, dynamic>> _buildRiskItems(List<ClaimModel> claims) {
    final List<Map<String, dynamic>> items = [];
    for (final claim in claims) {
      for (final flag in _evaluateRisks(claim)) {
        items.add({'flag': flag, 'claim': claim});
      }
    }
    return items;
  }

  List<Map<String, dynamic>> _filterBySeverity(
      List<Map<String, dynamic>> items, String severity) {
    return items
        .where((item) =>
            (item['flag'] as RiskFlag).severity.toUpperCase() == severity)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClaimFlowColors.background,
      appBar: AppBar(
        backgroundColor: ClaimFlowColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: ClaimFlowColors.textPrimary,
          ),
        ),
        title: Text(
          'Risk Alerts',
          style: GoogleFonts.sourceSans3(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ClaimFlowColors.textPrimary,
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ClaimModel>('claims').listenable(),
        builder: (context, Box<ClaimModel> box, _) {
          final claims = box.values.toList();
          final allRisks = _buildRiskItems(claims);

          final urgentRisks = _filterBySeverity(allRisks, 'URGENT');
          final highRisks = _filterBySeverity(allRisks, 'HIGH');
          final mediumRisks = _filterBySeverity(allRisks, 'MEDIUM');
          final totalIssues =
              urgentRisks.length + highRisks.length + mediumRisks.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Risks',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ClaimFlowColors.textPrimary,
                      ),
                    ),
                    if (totalIssues > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: ClaimFlowColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$totalIssues Issues Found',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ClaimFlowColors.error,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                if (totalIssues == 0)
                  const _EmptyState()
                else ...[
                  if (urgentRisks.isNotEmpty) ...[
                    const _SectionLabel(label: 'URGENT RISKS', isUrgent: true),
                    const SizedBox(height: 10),
                    ...urgentRisks.map((item) => _RiskCard(
                          flag: item['flag'] as RiskFlag,
                          claim: item['claim'] as ClaimModel,
                          severity: 'URGENT',
                        )),
                    const SizedBox(height: 20),
                  ],
                  if (highRisks.isNotEmpty) ...[
                    const _SectionLabel(label: 'HIGH RISKS', isUrgent: false),
                    const SizedBox(height: 10),
                    ...highRisks.map((item) => _RiskCard(
                          flag: item['flag'] as RiskFlag,
                          claim: item['claim'] as ClaimModel,
                          severity: 'HIGH',
                        )),
                    const SizedBox(height: 20),
                  ],
                  if (mediumRisks.isNotEmpty) ...[
                    const _SectionLabel(
                        label: 'MEDIUM RISKS', isUrgent: false),
                    const SizedBox(height: 10),
                    ...mediumRisks.map((item) => _RiskCard(
                          flag: item['flag'] as RiskFlag,
                          claim: item['claim'] as ClaimModel,
                          severity: 'MEDIUM',
                        )),
                  ],
                ],

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}


class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isUrgent;

  const _SectionLabel({required this.label, required this.isUrgent});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isUrgent
            ? ClaimFlowColors.error
            : ClaimFlowColors.textPrimary.withOpacity(0.5),
      ),
    );
  }
}


class _RiskCard extends StatelessWidget {
  final RiskFlag flag;
  final ClaimModel claim;
  final String severity;

  const _RiskCard({
    required this.flag,
    required this.claim,
    required this.severity,
  });

  Color get _iconColor {
    if (severity == 'URGENT') return ClaimFlowColors.error;
    return ClaimFlowColors.textPrimary.withOpacity(0.4);
  }

  Color get _iconBg {
    if (severity == 'URGENT') return ClaimFlowColors.error.withOpacity(0.1);
    return ClaimFlowColors.textPrimary.withOpacity(0.07);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: ClaimFlowColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              severity == 'URGENT'
                  ? Icons.shield_outlined
                  : Icons.info_outline,
              color: _iconColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flag.title,
                  style: GoogleFonts.sourceSans3(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ClaimFlowColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  claim.patientName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ClaimFlowColors.textPrimary.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),

          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦${flag.impact.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                style: GoogleFonts.sourceSans3(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: ClaimFlowColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/claim-details',
                    arguments: {
                      'claim': claim,
                      'riskFlags': [flag],
                    },
                  );
                },
                child: Text(
                  'Resolve ›',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ClaimFlowColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              Icons.shield_outlined,
              size: 56,
              color: ClaimFlowColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Active Risks',
              style: GoogleFonts.sourceSans3(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ClaimFlowColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'All your claims are looking clean.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: ClaimFlowColors.textPrimary.withOpacity(0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}