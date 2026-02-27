import 'package:claimflow_africa/screens/all/ai_recommendation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/riskflag_model.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'package:claimflow_africa/widgets/ar/ageing_calculator.dart';
import 'package:claimflow_africa/widgets/ar/ageing_claim_row.dart';
import 'package:claimflow_africa/widgets/ar/ageing_distribution_chart.dart';
import 'package:claimflow_africa/widgets/ar/total_outstanding_banner.dart';
import 'package:claimflow_africa/widgets/ar/ageing_empty_state.dart';
import '../../widgets/ar/ageing_bucket_card.dart';
import 'package:claimflow_africa/widgets/ar/ai_insight_card.dart';


class ARAgingDashboard extends StatefulWidget {
  const ARAgingDashboard({super.key});

  @override
  State<ARAgingDashboard> createState() => _ARAgingDashboardState();
}

class _ARAgingDashboardState extends State<ARAgingDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AgeingClaimItem> _filterClaims(
      List<AgeingClaimItem> items, String query) {
    if (query.isEmpty) return items;
    final q = query.toLowerCase();
    return items.where((item) {
      return item.claim.patientName.toLowerCase().contains(q) ||
          item.claim.displayId.toLowerCase().contains(q) ||
          item.claim.insurer.toLowerCase().contains(q);
    }).toList();
  }

  void _navigateToClaimDetails(BuildContext context, AgeingClaimItem item) {
    Navigator.pushNamed(
      context,
      '/claim-details',
      arguments: {
        'claim': item.claim,
        'riskFlags': <RiskFlag>[],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClaimFlowColors.background,
      appBar: AppBar(
        backgroundColor: ClaimFlowColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back,
              color: ClaimFlowColors.textPrimary),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A/R Ageing',
              style: GoogleFonts.sourceSans3(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: ClaimFlowColors.textPrimary,
              ),
            ),
            Text(
              'Dashboard',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: ClaimFlowColors.textPrimary.withOpacity(0.45),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person_outline,
                color: ClaimFlowColors.textPrimary.withOpacity(0.6)),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_alt_outlined,
                color: ClaimFlowColors.textPrimary.withOpacity(0.6)),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.download_outlined,
                color: ClaimFlowColors.textPrimary.withOpacity(0.6)),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ClaimModel>('claims').listenable(),
        builder: (context, Box<ClaimModel> box, _) {
          final claims = box.values.toList();

         
          if (claims.isEmpty) {
            return AgeingEmptyState(
              onViewClosedClaims: () =>
                  Navigator.pushNamed(context, '/claims'),
            );
          }

          
          final data = AgeingCalculator.calculate(claims);
          final highRiskClaims = data.claimItems
              .where((item) => item.daysOverdue > 90)
              .toList();
          final filteredClaims =
              _filterClaims(data.claimItems, _searchQuery);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _FilterPill(
                          icon: Icons.local_hospital_outlined,
                          label: 'Main Hospital'),
                      const SizedBox(width: 10),
                      _FilterPill(
                          icon: Icons.calendar_today_outlined,
                          label: 'Last 30 Days'),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Outstanding Banner
                      TotalOutstandingBanner(
                        totalAmount: data.totalOutstanding,
                        monthlyChangePercent: data.monthlyChangePercent,
                      ),
                      const SizedBox(height: 24),

                      
                      Text(
                        'AGEING OVERVIEW',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color:
                              ClaimFlowColors.textPrimary.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 12),

                      
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.4,
                        children: data.buckets
                            .where((b) => b.range != '120+')
                            .map((b) => AgeingBucketCard(bucket: b))
                            .toList(),
                      ),
                      const SizedBox(height: 10),

                     
                      AgeingBucketCard(
                          bucket: data.buckets
                              .firstWhere((b) => b.range == '120+')),
                      const SizedBox(height: 20),

                     
                      AgeingDistributionChart(buckets: data.buckets),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                
                if (highRiskClaims.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AiInsightCard(
                      highRiskClaims: highRiskClaims,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AiRecommendationScreen(
                            highRiskClaims: highRiskClaims,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Claims List',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: ClaimFlowColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) =>
                        setState(() => _searchQuery = val),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: ClaimFlowColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search claims, patients, or payers...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: ClaimFlowColors.textPrimary.withOpacity(0.35),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: ClaimFlowColors.textPrimary.withOpacity(0.35),
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),


                if (filteredClaims.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'No claims found'
                            : 'No results for "$_searchQuery"',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: ClaimFlowColors.textPrimary.withOpacity(0.4),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: ClaimFlowColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: filteredClaims
                            .map((item) => AgeingClaimRow(
                                  item: item,
                                  onTap: () => _navigateToClaimDetails(
                                      context, item),
                                ))
                            .toList(),
                      ),
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}



class _FilterPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FilterPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ClaimFlowColors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: ClaimFlowColors.textPrimary.withOpacity(0.5)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ClaimFlowColors.textPrimary.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down,
              size: 16,
              color: ClaimFlowColors.textPrimary.withOpacity(0.4)),
        ],
      ),
    );
  }
}