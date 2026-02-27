import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';
import 'ageing_calculator.dart';

class AgeingDistributionChart extends StatelessWidget {
  final List<AgeingBucket> buckets;

  const AgeingDistributionChart({super.key, required this.buckets});

  @override
  Widget build(BuildContext context) {
    final maxAmount =
        buckets.map((b) => b.totalAmount).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClaimFlowColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ageing Distribution',
            style: GoogleFonts.sourceSans3(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ClaimFlowColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Amount (₦)',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: ClaimFlowColors.textPrimary.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: buckets.map((bucket) {
                final heightRatio =
                    maxAmount > 0 ? bucket.totalAmount / maxAmount : 0.0;
                final isFirst = bucket.range == '0-30';

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          height: 100 * heightRatio,
                          decoration: BoxDecoration(
                            color: isFirst
                                ? ClaimFlowColors.primary
                                : ClaimFlowColors.secondary,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          bucket.range,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color:
                                ClaimFlowColors.textPrimary.withOpacity(0.45),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}