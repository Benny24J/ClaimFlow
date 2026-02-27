import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';

class AgeingEmptyState extends StatelessWidget {
  final VoidCallback onViewClosedClaims;

  const AgeingEmptyState({
    super.key,
    required this.onViewClosedClaims,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon circle
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: ClaimFlowColors.textPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.insert_drive_file_outlined,
                  size: 32,
                  color: ClaimFlowColors.textPrimary.withOpacity(0.35),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'No Outstanding Receivables',
                style: GoogleFonts.sourceSans3(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ClaimFlowColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Revenue cycle is healthy. All claims have been processed and paid.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: ClaimFlowColors.textPrimary.withOpacity(0.45),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 28),

             
              ElevatedButton.icon(
                onPressed: onViewClosedClaims,
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  'View Closed Claims',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}