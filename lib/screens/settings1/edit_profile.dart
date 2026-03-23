import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  // Controllers — initialized in initState once profile is loaded
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isSaving = false;
  bool _isLoading = true;
  String? _errorMessage;

  static const _roleOptions = ['user', 'manager', 'admin'];
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _organizationController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ─── Load existing profile to pre-fill fields ─────────────────────────────

  Future<void> _loadCurrentProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No authenticated user found.';
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      if (mounted) {
        _nameController.text = data['full_name'] ?? '';
        _phoneController.text = data['phone_no'] ?? '';
        _selectedRole = _roleOptions.contains(data['role'])
            ? data['role']
            : _roleOptions.first;
        _organizationController.text = data['organization'] ?? '';
        _locationController.text = data['location'] ?? '';
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load profile. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  // ─── Save ─────────────────────────────────────────────────────────────────

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Not authenticated');

      final updates = {
        'phone': _phoneController.text.trim(),
        'role': _selectedRole ?? 'user',
        'organization': _organizationController.text.trim(),
        'location': _locationController.text.trim(),
      };

      await supabase.from('profiles').update(updates).eq('id', user.id);

      if (!mounted) return;
      _showSuccess('Profile updated successfully.');
      Navigator.pop(context, true); // signals ProfileScreen to reload
    } catch (e) {
      print(e);
      _showError('Failed to save changes. Please try again.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─── Navigate to profile preview ─────────────────────────────────────────

  void _goToPreview() {
    Navigator.pushNamed(context, '/profile');
  }

  // ─── Snackbars ────────────────────────────────────────────────────────────

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ));
  }

  // ─── UI Helpers ───────────────────────────────────────────────────────────

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.black45),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        labelStyle: const TextStyle(fontSize: 13, color: Colors.black45),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      );

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.black45,
          ),
        ),
      );

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration(label: label, icon: icon),
        validator: validator ??
            (value) => (value == null || value.trim().isEmpty)
                ? '$label is required'
                : null,
      );

  // Groups fields inside a white rounded card with dividers between them
  Widget _fieldCard({required List<Widget> fields}) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [
            for (int i = 0; i < fields.length; i++) ...[
              fields[i],
              if (i < fields.length - 1)
                const Divider(height: 1, color: Colors.black12),
            ],
          ],
        ),
      );

  // ─── Body states ──────────────────────────────────────────────────────────

  Widget _buildError() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadCurrentProfile();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );

  Widget _buildForm(ThemeData theme) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Preview banner ─────────────────────────────────────────
              GestureDetector(
                onTap: _goToPreview,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Preview your profile',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 13,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Personal Information ───────────────────────────────────
              _sectionLabel('PERSONAL INFORMATION'),
              _fieldCard(fields: [
                _field(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    if (value.trim().length < 3) return 'Name is too short';
                    return null;
                  },
                ),
                _field(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^\+?[\d\s\-]{7,15}$')
                        .hasMatch(value.trim())) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ]),
              const SizedBox(height: 24),

              // ── Work Information ───────────────────────────────────────
              _sectionLabel('WORK INFORMATION'),
              _fieldCard(fields: [
                // Role dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: _inputDecoration(
                      label: 'Role',
                      icon: Icons.business_center_outlined,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.black45),
                    items: _roleOptions
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(
                                role[0].toUpperCase() + role.substring(1),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedRole = value),
                    validator: (value) =>
                        value == null ? 'Please select a role' : null,
                  ),
                ),
                _field(
                  controller: _organizationController,
                  label: 'Organization',
                  icon: Icons.business_outlined,
                ),
                _field(
                  controller: _locationController,
                  label: 'Location',
                  icon: Icons.location_on_outlined,
                ),
              ]),
              const SizedBox(height: 32),

              // ── Save Button ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Cancel ─────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );

  // ─── Build ────────────────────────────────────────────────────────────────

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
          'Edit Profile',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Preview icon button in AppBar
          IconButton(
            tooltip: 'Preview profile',
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: theme.colorScheme.primary,
            ),
            onPressed: _goToPreview,
          ),
          // Save text button in AppBar
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Save',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildError()
              : _buildForm(theme),
    );
  }
}