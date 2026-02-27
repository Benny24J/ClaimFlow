import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/riskflag_model.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'package:claimflow_africa/widgets/claimlist/claim_search_bar.dart';
import 'package:claimflow_africa/widgets/claimlist/claim_filter_tabs.dart';
import 'package:claimflow_africa/widgets/claimlist/claim_card.dart';
import 'package:claimflow_africa/widgets/claimlist/claim_empty_state.dart';

class ClaimListScreen extends StatefulWidget {
  const ClaimListScreen({super.key});

  @override
  State<ClaimListScreen> createState() => _ClaimListScreenState();
}

class _ClaimListScreenState extends State<ClaimListScreen> {
  final _searchController = TextEditingController();
  ClaimFilter _activeFilter = ClaimFilter.all;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  
  List<ClaimModel> _getAllClaims(Box<ClaimModel> box) {
    final localClaims = box.values.toList();
    // TODO: merge with API claims when backend is ready
    // final apiClaims = await claimsRepository.fetchClaims();
    // final merged = [...localClaims, ...apiClaims];
    // deduplicate by serverId
    localClaims.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return localClaims;
  }

  
  List<ClaimModel> _applyFilter(List<ClaimModel> claims) {
    switch (_activeFilter) {
      case ClaimFilter.atRisk:
        // TODO: filter by riskLevel from AI when backend ready
        
        return claims.where((c) => c.totalClaimAmount > 10000).toList();
      case ClaimFilter.overdue:
        return claims.where((c) => c.isFailed).toList();
      case ClaimFilter.all:
     
        return claims;
    }
  }

  
  List<ClaimModel> _applySearch(List<ClaimModel> claims) {
    if (_searchQuery.isEmpty) return claims;
    final q = _searchQuery.toLowerCase();
    return claims.where((c) {
      return c.patientName.toLowerCase().contains(q) ||
          c.insurer.toLowerCase().contains(q) ||
          c.localId.toLowerCase().contains(q) ||
          (c.serverId?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  void _goToClaimDetails(BuildContext context, ClaimModel claim) {
    Navigator.pushNamed(
      context,
      '/claim-details',
      arguments: {
        'claim': claim,
        'riskFlags': <RiskFlag>[], // TODO: pass real flags from AI
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Claim List',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              children: [
                ClaimSearchBar(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
                const SizedBox(height: 12),
                ClaimFilterTabs(
                  selected: _activeFilter,
                  onChanged: (f) => setState(() => _activeFilter = f),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          
          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<ClaimModel>('claims').listenable(),
              builder: (context, Box<ClaimModel> box, _) {
                final all = _getAllClaims(box);
                final filtered = _applyFilter(all);
                final results = _applySearch(filtered);

                if (results.isEmpty) {
                  return ClaimEmptyState(activeFilter: _activeFilter);
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final claim = results[index];
                    return ClaimCard(
                      claim: claim,
                      onTap: () => _goToClaimDetails(context, claim),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

     
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/new-claim'),
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}