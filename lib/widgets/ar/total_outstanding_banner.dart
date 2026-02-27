import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';

class TotalOutstandingBanner extends StatelessWidget {
  final double totalAmount;
  final double monthlyChangePercent;

  const TotalOutstandingBanner({
    super.key,
    required this.totalAmount,
    required this.monthlyChangePercent,
  });

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '₦${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '₦${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '₦${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final isReduced = monthlyChangePercent < 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ClaimFlowColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Watermark clock icon
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.access_time_rounded,
              size: 100,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL OUTSTANDING',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatAmount(totalAmount),
                style: GoogleFonts.sourceSans3(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isReduced
                          ? Icons.trending_down_rounded
                          : Icons.trending_up_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isReduced ? 'Reduced' : 'Increased'} by ${monthlyChangePercent.abs().toStringAsFixed(0)}% this month',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
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