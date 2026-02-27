import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';
import 'ageing_calculator.dart';

class AgeingClaimRow extends StatelessWidget {
  final AgeingClaimItem item;
  final VoidCallback onTap;

  const AgeingClaimRow({super.key, required this.item, required this.onTap});

  Color get _daysPillColor {
    if (item.daysOverdue > 90) return ClaimFlowColors.error;
    if (item.daysOverdue > 60) return Colors.orange;
    if (item.daysOverdue > 30) return Colors.amber;
    return Colors.green;
  }

  Color get _riskBarColor {
    if (item.riskScore >= 70) return ClaimFlowColors.error;
    if (item.riskScore >= 40) return Colors.orange;
    return Colors.green;
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) return '₦${(amount / 1000).toStringAsFixed(0)}K';
    return '₦${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ClaimFlowColors.surface,
          border: Border(
            bottom: BorderSide(
              color: ClaimFlowColors.textPrimary.withOpacity(0.07),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Claim info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Claim ID
                  Text(
                    item.claim.displayId,
                    style: GoogleFonts.sourceSans3(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ClaimFlowColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.claim.patientName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: ClaimFlowColors.textPrimary.withOpacity(0.55),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Insurer + Days pill
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ClaimFlowColors.textPrimary.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.claim.insurer,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: ClaimFlowColors.textPrimary.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _daysPillColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${item.daysOverdue} days',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _daysPillColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Risk Score
                  Row(
                    children: [
                      Text(
                        'Risk Score  ',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: ClaimFlowColors.textPrimary.withOpacity(0.45),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: item.riskScore / 100,
                            minHeight: 5,
                            backgroundColor:
                                ClaimFlowColors.textPrimary.withOpacity(0.08),
                            valueColor: AlwaysStoppedAnimation(_riskBarColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${item.riskScore}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: ClaimFlowColors.textPrimary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right: Amount + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatAmount(item.claim.totalClaimAmount),
                  style: GoogleFonts.sourceSans3(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: ClaimFlowColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: ClaimFlowColors.textPrimary.withOpacity(0.3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}