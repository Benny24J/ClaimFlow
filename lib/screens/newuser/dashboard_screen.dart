import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/riskflag_model.dart';
import 'package:claimflow_africa/widgets/newdashboard/setup_complete_banner.dart';
import 'package:claimflow_africa/widgets/newdashboard/new_claim_card.dart';
import 'package:claimflow_africa/widgets/newdashboard/stats_row.dart';
import 'package:claimflow_africa/widgets/newdashboard/new_user_section.dart';

class DashboardScreen extends StatefulWidget {
  final bool justCompletedSetup;

  const DashboardScreen({
    super.key,
    this.justCompletedSetup = false,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  bool _showSetupBanner = false;
  bool _showNewUserSection = true;

  @override
  void initState() {
    super.initState();
    _showSetupBanner = widget.justCompletedSetup;
  }

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

  void _dismissBanner() => setState(() => _showSetupBanner = false);
  void _dismissNewUserSection() => setState(() => _showNewUserSection = false);

  void _onNewClaim() => Navigator.pushNamed(context, '/new-claim');

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/organization');
        break;
      case 1:
        Navigator.pushNamed(context, '/add-staff');
        break;
      case 2:
        Navigator.pushNamed(context, '/billing');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    
    return ValueListenableBuilder(
      valueListenable: Hive.box<ClaimModel>('claims').listenable(),
      builder: (context, Box<ClaimModel> box, _) {
        final claims = box.values.toList();

        
        final int claimsSubmitted = claims.length;
        final int pendingReview = claims.where((c) => c.isPending).length;
        final int riskAlerts = claims.fold(
          0,
          (total, claim) => total + _evaluateRisks(claim).length,
        );

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.justCompletedSetup)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),

                  if (_showSetupBanner) ...[
                    SetupCompleteBanner(onDismiss: _dismissBanner),
                    const SizedBox(height: 16),
                  ],

                  NewClaimCard(onTap: _onNewClaim),
                  const SizedBox(height: 20),

                  StatsRow(
                    claimsSubmitted: claimsSubmitted,
                    pendingReview: pendingReview,
                    riskAlerts: riskAlerts,
                    onRiskAlertsTap: () =>
                        Navigator.pushNamed(context, '/risks'),
                  ),
                  const SizedBox(height: 20),

                  if (_showNewUserSection)
                    NewUserSection(
                      onDismiss: _dismissNewUserSection,
                      onViewSampleClaim: () =>
                          Navigator.pushNamed(context, '/sample-claim'),
                      onLearnProcess: () =>
                          Navigator.pushNamed(context, '/learn-process'),
                      onInviteTeam: () =>
                          Navigator.pushNamed(context, '/add-staff'),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentNavIndex,
            onTap: _onNavTap,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurface.withAlpha(100),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.business_outlined),
                activeIcon: Icon(Icons.business),
                label: 'Organization',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group_add_outlined),
                activeIcon: Icon(Icons.group_add),
                label: 'Add Staff',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'Billing',
              ),
            ],
          ),
        );
      },
    );
  }
}