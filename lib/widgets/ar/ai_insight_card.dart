import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';
import 'ageing_calculator.dart';

class AiInsightCard extends StatelessWidget {
  final List<AgeingClaimItem> highRiskClaims;
  final VoidCallback onTap;

  const AiInsightCard({
    super.key,
    required this.highRiskClaims,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final count = highRiskClaims.length;
    final total = highRiskClaims.fold(
        0.0, (sum, item) => sum + item.claim.totalClaimAmount);

    final formattedTotal = total >= 1000
        ? '₦${(total / 1000).toStringAsFixed(0)},000'
        : '₦${total.toStringAsFixed(0)}';

    if (count == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ClaimFlowColors.error.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ClaimFlowColors.error.withOpacity(0.15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ClaimFlowColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: ClaimFlowColors.error,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'High-Risk Claims Detected',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ClaimFlowColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: ClaimFlowColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '✦ AI',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Claims over 90 days show high denial likelihood. Immediate follow-up recommended for $count claims totaling $formattedTotal.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: ClaimFlowColors.textPrimary.withOpacity(0.6),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Auto-Prioritize Claims',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ClaimFlowColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}