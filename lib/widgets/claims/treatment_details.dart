import 'package:flutter/material.dart';
import 'package:claimflow_africa/widgets/claims/claimwidgets.dart';
import 'package:claimflow_africa/dmodels/claim_form_data.dart';

class Step2TreatmentDetails extends StatefulWidget {
  final ClaimFormData formData;
  final VoidCallback onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step2TreatmentDetails({
    super.key,
    required this.formData,
    required this.onChanged,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step2TreatmentDetails> createState() => _Step2TreatmentDetailsState();
}

class _Step2TreatmentDetailsState extends State<Step2TreatmentDetails> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _diagnosisCtrl;
  late final TextEditingController _procedureCtrl;
  late final TextEditingController _serviceDateCtrl;
  late final TextEditingController _insurerCtrl;

  @override
  void initState() {
    super.initState();
    _diagnosisCtrl =
        TextEditingController(text: widget.formData.diagnosisCode);
    _procedureCtrl =
        TextEditingController(text: widget.formData.procedureCode);
    _serviceDateCtrl = TextEditingController(
      text: widget.formData.serviceDate != null
          ? _formatDate(widget.formData.serviceDate!)
          : '',
    );
    _insurerCtrl = TextEditingController(text: widget.formData.insurer);
  }

  @override
  void dispose() {
    _diagnosisCtrl.dispose();
    _procedureCtrl.dispose();
    _serviceDateCtrl.dispose();
    _insurerCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickServiceDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.formData.serviceDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      widget.formData.serviceDate = picked;
      _serviceDateCtrl.text = _formatDate(picked);
      widget.onChanged();
      setState(() {});
    }
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      widget.formData.diagnosisCode = _diagnosisCtrl.text.trim();
      widget.formData.procedureCode = _procedureCtrl.text.trim();
      widget.formData.insurer = _insurerCtrl.text.trim();
      widget.onNext();
    }
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
            Text('Treatment Details',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              'Select the diagnosis and procedure codes for this visit.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 24),

            const FieldLabel('DIAGNOSIS CODE (ICD-10)'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _diagnosisCtrl,
              decoration:
                  claimInputDecoration('Search or enter code').copyWith(
                prefixIcon: const Icon(Icons.search, size: 20),
              ),
              onChanged: (_) => widget.onChanged(),
              validator: (v) =>
                  v!.trim().isEmpty ? 'Diagnosis code is required' : null,
            ),
            const SizedBox(height: 16),

            const FieldLabel('PROCEDURE CODE'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _procedureCtrl,
              decoration: claimInputDecoration('e.g. 99213'),
              onChanged: (_) => widget.onChanged(),
              validator: (v) =>
                  v!.trim().isEmpty ? 'Procedure code is required' : null,
            ),
            const SizedBox(height: 16),

            const FieldLabel('SERVICE DATE'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _serviceDateCtrl,
              readOnly: true,
              onTap: _pickServiceDate,
              decoration: claimInputDecoration('mm/dd/yyyy').copyWith(
                suffixIcon: const Icon(Icons.calendar_today_outlined,
                    size: 18),
              ),
              validator: (v) =>
                  v!.isEmpty ? 'Service date is required' : null,
            ),
            const SizedBox(height: 16),

            const FieldLabel('INSURER'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _insurerCtrl,
              decoration: claimInputDecoration('Enter insurer name'),
              onChanged: (_) => widget.onChanged(),
              validator: (v) =>
                  v!.trim().isEmpty ? 'Insurer is required' : null,
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _onNext,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}