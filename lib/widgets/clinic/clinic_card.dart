import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/dmodels/clinic_model.dart';
import 'package:claimflow_africa/theme.dart';
import 'license_warning_banner.dart';

class ClinicCard extends StatelessWidget {
  final ClinicModel clinic;
  final VoidCallback onTap;

  const ClinicCard({
    super.key,
    required this.clinic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showWarning =
        clinic.licenseExpiryDate != null && clinic.isLicenseExpiringSoon;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showWarning)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: LicenseWarningBanner(
                    expiryDate: clinic.licenseExpiryDate!),
              ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          clinic.name,
                          style: GoogleFonts.sourceSans3(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: ClaimFlowColors.textPrimary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: clinic.isActive
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              clinic.isActive ? 'ACTIVE' : 'INACTIVE',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: clinic.isActive
                                    ? ClaimFlowColors.primary
                                    : ClaimFlowColors.textPrimary
                                        .withOpacity(0.4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: ClaimFlowColors.textPrimary.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text(
                    clinic.providerId,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: ClaimFlowColors.textPrimary.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: ClaimFlowColors.textPrimary.withOpacity(0.4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        clinic.location,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: ClaimFlowColors.textPrimary.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(
                        Icons.show_chart,
                        size: 14,
                        color: ClaimFlowColors.textPrimary.withOpacity(0.4),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'CLAIMS VOLUME',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: ClaimFlowColors.textPrimary.withOpacity(0.45),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${clinic.claimsVolume}',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: ClaimFlowColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: clinic.claimsVolume > 0
                          ? (clinic.claimsVolume / 300).clamp(0.0, 1.0)
                          : 0.0,
                      minHeight: 5,
                      backgroundColor:
                          ClaimFlowColors.textPrimary.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation(
                        clinic.isActive
                            ? ClaimFlowColors.primary
                            : ClaimFlowColors.textPrimary.withOpacity(0.3),
                      ),
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