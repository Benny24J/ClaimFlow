import 'package:claimflow_africa/screens/settings1/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'package:claimflow_africa/widgets/settings2/profile/profile_account_actions.dart';
import 'package:claimflow_africa/widgets/settings2/profile/profile_avatar.dart';
import 'package:claimflow_africa/widgets/settings2/profile/profile_info_card.dart';
// import 'package:claimflow_africa/widgets/settings2/profile/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

Future<void> _loadProfile() async {
  try {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      setState(() {
        _errorMessage = 'User not logged in';
        _isLoading = false;
      });
      return;
    }

    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (!mounted) return;

    setState(() {
      _profile = data; 
      _isLoading = false;
    });

  } catch (e) {
    if (!mounted) return;

    setState(() {
      _errorMessage = 'Failed to load profile';
      _isLoading = false;
    });
  }
}

String _displayValue(dynamic value) {
  if (value == null || value.toString().trim().isEmpty) {
    return 'No data available';
  }
  return value.toString();
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
          'Profile',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_profile != null)
            TextButton(
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context)=> EditProfileScreen())
              ),
              child: Text(
                'Edit Profile',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(theme),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _loadProfile();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_profile == null) {
      return const Center(child: Text('No profile data available.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + name + role
          Center(
            child: Column(
              children: [
                ProfileAvatar(
                  fullName: _displayValue(_profile!['full_name']),
                  avatarUrl: '',
                ),
                const SizedBox(height: 12),
                Text(
                  _displayValue(_profile!['full_name']),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _displayValue(_profile!['role']),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Personal Information
          ProfileInfoCard(
            sectionTitle: 'PERSONAL INFORMATION',
            rows: [
              ProfileInfoRow(
                icon: Icons.person_outline,
                label: 'FULL NAME',
                value: _profile!['full_name'],
              ),
              ProfileInfoRow(
                icon: Icons.email_outlined,
                label: 'EMAIL ADDRESS',
                value: _profile!['email'],
              ),
              ProfileInfoRow(
                icon: Icons.phone_outlined,
                label: 'PHONE NUMBER',
                value:_displayValue(_profile!['phone']),
              ),
            ],
          ),

          // Work Information
          ProfileInfoCard(
            sectionTitle: 'WORK INFORMATION',
            rows: [
              ProfileInfoRow(
                icon: Icons.business_center_outlined,
                label: 'ROLE',
                value: _displayValue(_profile!['role']),
              ),
              ProfileInfoRow(
                icon: Icons.business_outlined,
                label: 'ORGANIZATION',
                value: _displayValue(_profile!['organization']),
              ),

              ProfileInfoRow(
                icon: Icons.location_on_outlined,
                label: 'LOCATION',
                value: _displayValue(_profile!['location']),
              ),
            ],
          ),

          const ProfileAccountActions(),
        ],
      ),
    );
  }
}