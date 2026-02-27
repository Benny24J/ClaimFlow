import 'package:flutter/material.dart';
import 'dart:async';
import 'package:claimflow_africa/dmodels/claim_form_data.dart';
import 'package:claimflow_africa/widgets/claims/claimwidgets.dart';
import 'package:claimflow_africa/widgets/claims/patient_info.dart';
import 'package:claimflow_africa/widgets/claims/treatment_details.dart';
import 'package:claimflow_africa/widgets/claims/financial_summary.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:claimflow_africa/dmodels/claim_model.dart';

class NewClaimScreen extends StatefulWidget {
  const NewClaimScreen({super.key});

  @override
  State<NewClaimScreen> createState() => _NewClaimScreenState();
}

class _NewClaimScreenState extends State<NewClaimScreen> {
  int _currentStep = 0;
  final _formData = ClaimFormData();

  Timer? _autoSaveTimer;
  bool _isSaving = false;

  LiveRiskResult? _liveRisk;
  bool _isLoadingRisk = false;
  Timer? _riskDebounce;

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _riskDebounce?.cancel();
    super.dispose();
  }

  void _onFieldChanged() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), _autoSave);
  }

  Future<void> _autoSave() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isSaving = false);
  }

  void _onAmountChanged(double amount) {
    _formData.totalClaimAmount = amount;
    _onFieldChanged();
    _riskDebounce?.cancel();
    _riskDebounce = Timer(const Duration(milliseconds: 800), _fetchLiveRisk);
  }

  Future<void> _fetchLiveRisk() async {
    if (_formData.totalClaimAmount <= 0) return;
    setState(() => _isLoadingRisk = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoadingRisk = false;
        _liveRisk = LiveRiskResult(
          riskLevel: _formData.totalClaimAmount > 500000
              ? 'HIGH'
              : _formData.totalClaimAmount > 100000
                  ? 'MEDIUM'
                  : 'LOW',
          exposure: _formData.totalClaimAmount * 0.01,
          confidence: 98.0,
        );
      });
    }
  }

  void _nextStep() => setState(() => _currentStep++);
  void _prevStep() => setState(() => _currentStep--);

  Future<void> _saveAndAnalyze() async {
    final box = Hive.box<ClaimModel>('claims');

    final claim = ClaimModel()
      ..localId = 'CLM-LOCAL-${DateTime.now().millisecondsSinceEpoch}'
      ..patientName = _formData.fullName
      ..nhiaId = _formData.nhiaId
      ..dateOfBirth = _formData.dateOfBirth!
      ..gender = _formData.gender
      ..diagnosisCode = _formData.diagnosisCode
      ..procedureCode = _formData.procedureCode
      ..serviceDate = _formData.serviceDate!
      ..insurer = _formData.insurer
      ..totalClaimAmount = _formData.totalClaimAmount
      ..notes = _formData.notes
      ..syncStatus = ClaimSyncStatus.pendingSync.name
      ..createdAt = DateTime.now();

    await box.add(claim);
    print(' Claim saved locally: ${claim.localId}');

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      '/claim-success',
      arguments: {
        'claim': claim,
        'isSynced': false,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              _currentStep > 0 ? _prevStep : () => Navigator.pop(context),
        ),
        title: Text(
          'New Claim',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          StepProgressBar(
            currentStep: _currentStep,
            totalSteps: 3,
            isSaving: _isSaving,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
              child: _buildStep(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return Step1PatientInfo(
          key: const ValueKey('step1'),
          formData: _formData,
          onChanged: _onFieldChanged,
          onNext: _nextStep,
        );
      case 1:
        return Step2TreatmentDetails(
          key: const ValueKey('step2'),
          formData: _formData,
          onChanged: _onFieldChanged,
          onNext: _nextStep,
          onBack: _prevStep,
        );
      case 2:
        return Step3FinancialSummary(
          key: const ValueKey('step3'),
          formData: _formData,
          liveRisk: _liveRisk,
          isLoadingRisk: _isLoadingRisk,
          onAmountChanged: _onAmountChanged,
          onNotesChanged: (v) {
            _formData.notes = v;
            _onFieldChanged();
          },
          onSaveAndAnalyze: _saveAndAnalyze,
          onReviewRiskReport: () =>
              Navigator.pushNamed(context, '/risk-report'),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}