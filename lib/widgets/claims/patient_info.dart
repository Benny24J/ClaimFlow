import 'package:flutter/material.dart';
import 'package:claimflow_africa/dmodels/claim_form_data.dart';
import 'package:claimflow_africa/widgets/claims/claimwidgets.dart';

class Step1PatientInfo extends StatefulWidget {
  final ClaimFormData formData;
  final VoidCallback onChanged;
  final VoidCallback onNext;

  const Step1PatientInfo({
    super.key,
    required this.formData,
    required this.onChanged,
    required this.onNext,
  });

  @override
  State<Step1PatientInfo> createState() => _Step1PatientInfoState();
}

class _Step1PatientInfoState extends State<Step1PatientInfo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nhiaCtrl;
  late final TextEditingController _dobCtrl;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.formData.fullName);
    _nhiaCtrl = TextEditingController(text: widget.formData.nhiaId);
    _dobCtrl = TextEditingController(
      text: widget.formData.dateOfBirth != null
          ? _formatDate(widget.formData.dateOfBirth!)
          : '',
    );
    _selectedGender =
        widget.formData.gender.isEmpty ? null : widget.formData.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nhiaCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.formData.dateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      widget.formData.dateOfBirth = picked;
      _dobCtrl.text = _formatDate(picked);
      widget.onChanged();
      setState(() {});
    }
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      widget.formData.fullName = _nameCtrl.text.trim();
      widget.formData.nhiaId = _nhiaCtrl.text.trim();
      widget.formData.gender = _selectedGender ?? '';
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
            Text('Patient Information',
                style: theme.textTheme.headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(
              "Enter the patient's basic details to start the claim.",
              style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 35),

            const FieldLabel('FULL NAME'),
            const SizedBox(height: 11),
            TextFormField(
              controller: _nameCtrl,
              decoration: claimInputDecoration('e.g. Musa Abubakar'),
              onChanged: (_) => widget.onChanged(),
              validator: (v) =>
                  v!.trim().isEmpty ? 'Full name is required' : null,
            ),
            const SizedBox(height: 20),

            const FieldLabel('NHIA ID / POLICY NUMBER'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nhiaCtrl,
              decoration: claimInputDecoration('e.g. NH/12345/A'),
              onChanged: (_) => widget.onChanged(),
              validator: (v) =>
                  v!.trim().isEmpty ? 'NHIA ID is required' : null,
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel('DATE OF BIRTH'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _dobCtrl,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration:
                            claimInputDecoration('mm/dd/yyyy').copyWith(
                          suffixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 20),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Date of birth is required' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel('GENDER'),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedGender,
                        decoration: claimInputDecoration('Select'),
                        items: ['Male', 'Female', 'Other']
                            .map((g) => DropdownMenuItem(
                                value: g, child: Text(g)))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _selectedGender = v);
                          widget.onChanged();
                        },
                        validator: (v) =>
                            v == null ? 'Please select a gender' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _onNext,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}