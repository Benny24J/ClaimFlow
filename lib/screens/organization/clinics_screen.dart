import 'package:claimflow_africa/widgets/clinic/clinic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/dmodels/clinic_model.dart';
import 'package:claimflow_africa/providers/clinic_provider.dart';
import 'package:claimflow_africa/widgets/clinic/clinic_filter_tabs.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'add_clinic_screen.dart';
import 'clinic_detail_screen.dart';

class ClinicsScreen extends ConsumerStatefulWidget {
  const ClinicsScreen({super.key});

  @override
  ConsumerState<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends ConsumerState<ClinicsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToAddClinic() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddClinicScreen()),
    );
  }

  void _goToClinicDetail(ClinicModel clinic) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ClinicDetailScreen(clinic: clinic)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = ref.read(clinicProvider.notifier);
    final clinics = ref.watch(clinicProvider);
    final filtered = notifier.search(_searchQuery);
    final isEmpty = clinics.isEmpty;

    return Scaffold(
      backgroundColor: ClaimFlowColors.background,
      appBar: AppBar(
        backgroundColor: ClaimFlowColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: ClaimFlowColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clinics',
              style: GoogleFonts.sourceSans3(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ClaimFlowColors.primary,
              ),
            ),
            if (!isEmpty)
              Text(
                '${clinics.length} service provider${clinics.length == 1 ? '' : 's'}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: ClaimFlowColors.textPrimary.withOpacity(0.5),
                ),
              ),
          ],
        ),
        actions: [
          if (!isEmpty)
            GestureDetector(
              onTap: _goToAddClinic,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ClaimFlowColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
        ],
      ),
      body: isEmpty
          ? _EmptyState(onAddClinic: _goToAddClinic)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: ClaimFlowColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search clinics, provider ID, or location...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: ClaimFlowColors.textPrimary.withOpacity(0.35),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: ClaimFlowColors.textPrimary.withOpacity(0.35),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClinicFilterTabs(
                    selected: notifier.filter,
                    onChanged: (f) {
                      notifier.setFilter(f);
                      setState(() => _searchQuery = '');
                      _searchController.clear();
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            _searchQuery.isEmpty
                                ? 'No clinics in this category'
                                : 'No results for "$_searchQuery"',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color:
                                  ClaimFlowColors.textPrimary.withOpacity(0.4),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final clinic = filtered[index];
                            return ClinicCard(
                              clinic: clinic,
                              onTap: () => _goToClinicDetail(clinic),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: !isEmpty
          ? FloatingActionButton(
              onPressed: _goToAddClinic,
              backgroundColor: ClaimFlowColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddClinic;

  const _EmptyState({required this.onAddClinic});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: ClaimFlowColors.textPrimary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.file_copy_outlined,
              size: 36,
              color: ClaimFlowColors.textPrimary.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Clinics Added',
            style: GoogleFonts.sourceSans3(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ClaimFlowColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Add your first clinic to start managing service providers and tracking claims by location.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: ClaimFlowColors.textPrimary.withOpacity(0.45),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: onAddClinic,
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              'Add First Clinic',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}