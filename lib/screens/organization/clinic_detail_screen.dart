import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/dmodels/clinic_model.dart';
import 'package:claimflow_africa/providers/clinic_provider.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';

class ClinicDetailScreen extends ConsumerWidget {
  final ClinicModel clinic;

  const ClinicDetailScreen({super.key, required this.clinic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ClaimFlowColors.background,
      appBar: AppBar(
        backgroundColor: ClaimFlowColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: ClaimFlowColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              clinic.name,
              style: GoogleFonts.sourceSans3(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ClaimFlowColors.primary,
              ),
            ),
            Text(
              clinic.providerId,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: ClaimFlowColors.textPrimary.withOpacity(0.5),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ClaimFlowColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: ClaimFlowColors.primary,
              size: 18,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
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
                          : ClaimFlowColors.textPrimary.withOpacity(0.4),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.description_outlined,
                        size: 14,
                        color: ClaimFlowColors.textPrimary),
                    const SizedBox(width: 4),
                    Text(
                      '${clinic.claimsVolume} Claims',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ClaimFlowColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            _SectionLabel(label: 'BASIC INFORMATION'),
            const SizedBox(height: 10),
            _InfoCard(
              rows: [
                _InfoRow(
                  icon: Icons.business_outlined,
                  label: 'LICENSE NUMBER',
                  value: clinic.licenseNumber,
                ),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'ADDRESS',
                  value: clinic.address,
                ),
                _InfoRow(
                  icon: Icons.email_outlined,
                  label: 'EMAIL',
                  value: clinic.email,
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'PHONE',
                  value: clinic.phone,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _SectionLabel(label: 'BILLING CONFIGURATION'),
            const SizedBox(height: 10),
            _InfoCard(
              rows: [
                _InfoRow(
                  icon: Icons.credit_card_outlined,
                  label: 'BILLING CONTACT',
                  value: clinic.billingContact.isNotEmpty
                      ? clinic.billingContact
                      : 'Not set',
                ),
                _InfoRow(
                  icon: Icons.description_outlined,
                  label: 'SUBMISSION PREFERENCE',
                  value: clinic.submissionPreference,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _SectionLabel(label: 'AI MONITORING SUMMARY'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ClaimFlowColors.secondary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _AiStat(
                          icon: Icons.warning_amber_rounded,
                          label: 'DENIAL RISK',
                          value: '15%',
                        ),
                      ),
                      Expanded(
                        child: _AiStat(
                          icon: Icons.description_outlined,
                          label: 'VOLUME',
                          value: '${clinic.claimsVolume}',
                          subtitle: '+22%',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            size: 16, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attention Required',
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFF59E0B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '3 claims over 90 days require immediate attention',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'View Detailed Analytics',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _SectionLabel(label: 'DANGER ZONE'),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Deactivate Clinic?'),
                    content: const Text(
                      'This clinic will no longer be able to submit or manage claims.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935)),
                        child: const Text('Deactivate'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await ref
                      .read(clinicProvider.notifier)
                      .toggleActive(clinic);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  clinic.isActive ? 'Deactivate Clinic' : 'Activate Clinic',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ClaimFlowColors.textPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Archive Clinic?'),
                    content: const Text(
                      'This clinic and its data will be archived. This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935)),
                        child: const Text('Archive'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await ref
                      .read(clinicProvider.notifier)
                      .deleteClinic(clinic);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(
                'Archive Clinic',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: ClaimFlowColors.textPrimary.withOpacity(0.5),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> rows;

  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: rows.map((row) {
          final index = rows.indexOf(row);
          final isLast = index == rows.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: ClaimFlowColors.textPrimary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        row.icon,
                        size: 18,
                        color: ClaimFlowColors.textPrimary.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.label,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: ClaimFlowColors.textPrimary
                                  .withOpacity(0.45),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            row.value,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ClaimFlowColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 66,
                  color: ClaimFlowColors.textPrimary.withOpacity(0.08),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _InfoRow {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _AiStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  const _AiStat({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.white.withOpacity(0.6)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: GoogleFonts.sourceSans3(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}