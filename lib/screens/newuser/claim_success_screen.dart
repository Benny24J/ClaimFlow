import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/riskflag_model.dart';
import 'package:claimflow_africa/widgets/claims/claim_id_card.dart';
import 'package:claimflow_africa/widgets/claims/action_button.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'package:claimflow_africa/widgets/claims/what_happens_next_card.dart';




class ClaimSuccessScreen extends StatefulWidget {
  final ClaimModel claim;
  final bool isSynced;

  const ClaimSuccessScreen({
    super.key,
    required this.claim,
    required this.isSynced,
  });

  @override
  State<ClaimSuccessScreen> createState() => _ClaimSuccessScreenState();
}

class _ClaimSuccessScreenState extends State<ClaimSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  Timer? _timestampTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
    _timestampTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _timestampTimer?.cancel();
    super.dispose();
  }

  String _formatTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays}d ago';
  }

  void _copyClaimId() {
    Clipboard.setData(ClipboardData(text: widget.claim.displayId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Claim ID copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _viewClaimDetails() {
    Navigator.pushNamed(
      context,
      '/claim-details',
      arguments: {
        'claim': widget.claim,
        'riskFlags': <RiskFlag>[], // AI will populate later
      },
    );
  }

  Future<void> _downloadReceipt() async {
    // TODO: await claimsRepository.downloadReceipt(widget.claim.displayId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Downloading receipt...'),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _shareStatus() async {
    // TODO: Share.share('Claim ${widget.claim.displayId} submitted via ClaimFlow Africa.');
    debugPrint('Sharing claim: ${widget.claim.displayId}');
  }

  void _submitAnotherClaim() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/new-claim',
      (route) => route.settings.name == '/dashboard',
    );
  }

  void _backToClaimsList() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/claims',
      (route) => route.settings.name == '/dashboard',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _backToClaimsList,
        ),
        title: Text(
          'New Claim',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 48),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                widget.isSynced
                    ? 'Claim Submitted\nSuccessfully'
                    : 'Claim Saved\nLocally',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                widget.isSynced
                    ? "Your claim has been validated and submitted to the payer. You'll receive updates on its status."
                    : "Your claim has been saved locally and will be submitted automatically when you're back online.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              ClaimIdCard(
                claimId: widget.claim.displayId,
                timestamp: _formatTimestamp(widget.claim.createdAt),
                isSynced: widget.isSynced,
                onCopy: _copyClaimId,
              ),
              const SizedBox(height: 16),

              WhatHappensNext(isSynced: widget.isSynced),
              const SizedBox(height: 24),

              ActionButton(
                icon: Icons.description_outlined,
                label: 'View Claim Details',
                onTap: _viewClaimDetails,
              ),
              const SizedBox(height: 10),
              ActionButton(
                icon: Icons.download_outlined,
                label: 'Download Receipt',
                onTap: _downloadReceipt,
              ),
              const SizedBox(height: 10),
              ActionButton(
                icon: Icons.share_outlined,
                label: 'Share Status',
                onTap: _shareStatus,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitAnotherClaim,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Submit Another Claim'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _backToClaimsList,
                child: Text(
                  'Back to Claims List',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 1),
    );
  }
}


