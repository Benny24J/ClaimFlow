import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/providers/clinic_provider.dart';
import 'package:claimflow_africa/widgets/claims/claimwidgets.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';

class AddClinicScreen extends ConsumerStatefulWidget {
  const AddClinicScreen({super.key});

  @override
  ConsumerState<AddClinicScreen> createState() => _AddClinicScreenState();
}

class _AddClinicScreenState extends ConsumerState<AddClinicScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _providerIdCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _isActive = true;
  bool _isSaving = false;
  DateTime? _licenseExpiryDate;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _providerIdCtrl.dispose();
    _licenseCtrl.dispose();
    _addressCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _licenseExpiryDate = picked);
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await ref.read(clinicProvider.notifier).addClinic(
          name: _nameCtrl.text.trim(),
          providerId: _providerIdCtrl.text.trim(),
          licenseNumber: _licenseCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          isActive: _isActive,
          licenseExpiryDate: _licenseExpiryDate,
        );

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Add Clinic',
              style: GoogleFonts.sourceSans3(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ClaimFlowColors.primary,
              ),
            ),
            Text(
              'Register new service provider',
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
              Icons.business_outlined,
              color: ClaimFlowColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel(label: 'BASIC INFORMATION'),
              const SizedBox(height: 12),

              _FormCard(
                children: [
                  _FormField(
                    label: 'Clinic Name',
                    required: true,
                    child: TextFormField(
                      controller: _nameCtrl,
                      decoration: claimInputDecoration(
                          'e.g., Harmony Health Clinic'),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Clinic name is required' : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FormField(
                    label: 'Provider ID',
                    required: true,
                    child: TextFormField(
                      controller: _providerIdCtrl,
                      decoration:
                          claimInputDecoration('e.g., HHC-NG-2024-001'),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Provider ID is required' : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FormField(
                    label: 'License Number',
                    required: true,
                    child: TextFormField(
                      controller: _licenseCtrl,
                      decoration: claimInputDecoration(
                          'e.g., MED-LAG-2024-12345'),
                      validator: (v) => v!.trim().isEmpty
                          ? 'License number is required'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FormField(
                    label: 'License Expiry Date',
                    required: false,
                    child: GestureDetector(
                      onTap: _pickExpiryDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _licenseExpiryDate != null
                                  ? _formatDate(_licenseExpiryDate!)
                                  : 'Select expiry date',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: _licenseExpiryDate != null
                                    ? ClaimFlowColors.textPrimary
                                    : ClaimFlowColors.textPrimary
                                        .withOpacity(0.35),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color:
                                  ClaimFlowColors.textPrimary.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _SectionLabel(label: 'CONTACT INFORMATION'),
              const SizedBox(height: 12),

              _FormCard(
                children: [
                  _FormField(
                    label: 'Address',
                    required: true,
                    child: TextFormField(
                      controller: _addressCtrl,
                      maxLines: 3,
                      decoration: claimInputDecoration(
                          'e.g., 45 Allen Avenue, Ikeja, Lagos'),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Address is required' : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FormField(
                    label: 'Contact Email',
                    required: true,
                    child: TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: claimInputDecoration(
                          'e.g., admin@harmonyclinic.ng'),
                      validator: (v) {
                        if (v!.trim().isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FormField(
                    label: 'Phone Number',
                    required: true,
                    child: TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration:
                          claimInputDecoration('e.g., +234 803 456 7890'),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Phone number is required' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _SectionLabel(label: 'STATUS'),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Status',
                            style: GoogleFonts.sourceSans3(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: ClaimFlowColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Clinic can submit and manage claims',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color:
                                  ClaimFlowColors.textPrimary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                      activeColor: ClaimFlowColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Save Clinic',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
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

class _FormCard extends StatelessWidget {
  final List<Widget> children;

  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;

  const _FormField({
    required this.label,
    required this.required,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ClaimFlowColors.textPrimary,
            ),
            children: required
                ? [
                    const TextSpan(
                      text: '*',
                      style: TextStyle(color: Color(0xFFE53935)),
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}