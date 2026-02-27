import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'claimwidgets.dart';
import 'package:claimflow_africa/dmodels/claim_form_data.dart';

class Step3FinancialSummary extends StatefulWidget {
  final ClaimFormData formData;
  final LiveRiskResult? liveRisk;
  final bool isLoadingRisk;
  final ValueChanged<double> onAmountChanged;
  final ValueChanged<String> onNotesChanged;
  final VoidCallback onSaveAndAnalyze;
  final VoidCallback onReviewRiskReport;

  const Step3FinancialSummary({
    super.key,
    required this.formData,
    required this.liveRisk,
    required this.isLoadingRisk,
    required this.onAmountChanged,
    required this.onNotesChanged,
    required this.onSaveAndAnalyze,
    required this.onReviewRiskReport,
  });

  @override
  State<Step3FinancialSummary> createState() =>
      _Step3FinancialSummaryState();
}

class _Step3FinancialSummaryState extends State<Step3FinancialSummary> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(
      text: widget.formData.totalClaimAmount > 0
          ? widget.formData.totalClaimAmount.toStringAsFixed(2)
          : '',
    );
    _notesCtrl = TextEditingController(text: widget.formData.notes);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Financial Summary',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              'Enter the total claim amount and any additional notes.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 24),

            const FieldLabel('TOTAL CLAIM AMOUNT (₦)'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: claimInputDecoration('0.00').copyWith(
                prefixText: '₦ ',
              ),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              onChanged: (v) {
                final amount = double.tryParse(v) ?? 0.0;
                widget.onAmountChanged(amount);
              },
              validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0
                  ? 'Enter a valid claim amount'
                  : null,
            ),
            const SizedBox(height: 16),

            const FieldLabel('NOTES (OPTIONAL)'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 4,
              decoration:
                  claimInputDecoration('Add any additional context...'),
              onChanged: widget.onNotesChanged,
            ),
            const SizedBox(height: 20),

            // Live Risk Preview
            _LiveRiskPreview(
              liveRisk: widget.liveRisk,
              isLoading: widget.isLoadingRisk,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSaveAndAnalyze();
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18)),
                child: const Text('Save & Analyze Claim'),
              ),
            ),
            const SizedBox(height: 14),

            Center(
              child: TextButton(
                onPressed: widget.onReviewRiskReport,
                child: Text(
                  'Review Full Risk Report',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveRiskPreview extends StatelessWidget {
  final LiveRiskResult? liveRisk;
  final bool isLoading;

  const _LiveRiskPreview({required this.liveRisk, required this.isLoading});

  Color _riskColor(String level) {
    switch (level) {
      case 'HIGH':
        return Colors.red;
      case 'MEDIUM':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.radar_rounded,
                      color: theme.colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text('Live Risk Preview',
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              if (isLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary),
                )
              else if (liveRisk != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _riskColor(liveRisk!.riskLevel),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${liveRisk!.riskLevel} RISK',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          if (liveRisk != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                _RiskStat(
                  label: 'EXPOSURE',
                  value: '₦${liveRisk!.exposure.toStringAsFixed(0)}',
                  color: _riskColor(liveRisk!.riskLevel),
                ),
                const SizedBox(width: 32),
                _RiskStat(
                  label: 'CONFIDENCE',
                  value: '${liveRisk!.confidence.toStringAsFixed(0)}%',
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ] else if (!isLoading) ...[
            const SizedBox(height: 10),
            Text(
              'Enter a claim amount to see live risk analysis.',
              style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            ),
          ],
        ],
      ),
    );
  }
}

class _RiskStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _RiskStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.labelSmall?.copyWith(
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.5),
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value,
            style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}