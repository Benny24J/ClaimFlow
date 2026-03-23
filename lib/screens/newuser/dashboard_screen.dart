import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/services/risk_evaluator.dart';
import 'package:claimflow_africa/widgets/newdashboard/setup_complete_banner.dart';
import 'package:claimflow_africa/widgets/newdashboard/new_claim_card.dart';
import 'package:claimflow_africa/widgets/newdashboard/stats_row.dart';
import 'package:claimflow_africa/widgets/newdashboard/new_user_section.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool _showSetupBanner = false;
  bool _showNewUserSection = true;

  final supabase = Supabase.instance.client;
  String? _fullName;

  @override
  void initState() {
    super.initState();
    _showSetupBanner = widget.justCompletedSetup;
    _loadUserProfile();
  }

  // ─── Load name + avatar from Supabase ────────────────────────────────────

  Future<void> _loadUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await supabase
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          _fullName = data['full_name'] as String?;
        });
      }
    } catch (e) {
      debugPrint('Failed to load profile: $e');
    }
  }

  // ─── Greeting based on time of day ───────────────────────────────────────

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  // Returns first name only, falls back to 'there'
  String get _firstName {
    if (_fullName == null || _fullName!.trim().isEmpty) return 'user';
    return _fullName!.trim().split(' ').first;
  }

  void _dismissBanner() => setState(() => _showSetupBanner = false);
  void _dismissNewUserSection() => setState(() => _showNewUserSection = false);
  void _onNewClaim() => Navigator.pushNamed(context, '/new-claim');

  // ─── Build ────────────────────────────────────────────────────────────────

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
          (total, claim) => total + RiskEvaluator.evaluate(claim).length,
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
                  // ── Back button (only when coming from setup) ──────────
                  if (widget.justCompletedSetup)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),

                  // ── Profile header row ─────────────────────────────────
                  Row(
                    children: [
                      // Greeting + name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_greeting,',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _firstName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Avatar — tappable, navigates to profile
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/profile'),
                        child:CircleAvatar(
                                radius: 24,
                                backgroundColor: theme.colorScheme.primary,
                                child: Icon(Icons.person),
                              )
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Setup banner ───────────────────────────────────────
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
                      onViewSampleClaim: () {},
                      onLearnProcess: () {},
                      onInviteTeam: () {},
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const AppBottomNav(currentIndex: 0),
        );
      },
    );
  }
}