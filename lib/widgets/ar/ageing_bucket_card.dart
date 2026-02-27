import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/widgets/ar/ageing_calculator.dart';

class AgeingBucketCard extends StatelessWidget {
  final AgeingBucket bucket;

  const AgeingBucketCard({super.key, required this.bucket});

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '₦${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '₦${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '₦${amount.toStringAsFixed(0)}';
  }

  Color get _dotColor {
    if (bucket.isHighRisk) return ClaimFlowColors.error;
    if (bucket.percentageChange > 10) return Colors.orange;
    if (bucket.percentageChange > 0) return Colors.orange;
    return Colors.green;
  }

  Color get _changeColor {
    if (bucket.percentageChange > 0) return ClaimFlowColors.error;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (bucket.isHighRisk) ...[
                    Icon(Icons.warning_amber_rounded,
                        size: 13, color: ClaimFlowColors.error),
                    const SizedBox(width: 4),
                    Text(
                      'HIGH RISK',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: ClaimFlowColors.error,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              Icon(
                bucket.percentageChange > 0
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 16,
                color: _changeColor,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            bucket.label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: ClaimFlowColors.textPrimary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatAmount(bucket.totalAmount),
            style: GoogleFonts.sourceSans3(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ClaimFlowColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${bucket.claimCount} claims',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: ClaimFlowColors.textPrimary.withOpacity(0.45),
                ),
              ),
              Text(
                '${bucket.percentageChange > 0 ? '+' : ''}${bucket.percentageChange.toStringAsFixed(0)}%',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _changeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}