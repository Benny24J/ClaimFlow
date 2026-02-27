import 'package:flutter/material.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'package:claimflow_africa/widgets/settings2/profile/profile_account_actions.dart';
import 'package:claimflow_africa/widgets/settings2/profile/profile_avatar.dart';
import 'package:claimflow_africa/widgets/settings2/profile/profile_info_card.dart';
import 'package:claimflow_africa/widgets/settings2/profile/user_profile.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // TODO: final profile = await profileRepository.getProfile();
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _profile = UserProfile.placeholder();
        _isLoading = false;
      });
    }
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
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/edit-profile',
              arguments: {'profile': _profile},
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar + name + role
                  Center(
                    child: Column(
                      children: [
                        ProfileAvatar(
                          fullName: _profile!.fullName,
                          avatarUrl: _profile!.avatarUrl,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _profile!.fullName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _profile!.role,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
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
                        value: _profile!.fullName,
                      ),
                      ProfileInfoRow(
                        icon: Icons.email_outlined,
                        label: 'EMAIL ADDRESS',
                        value: _profile!.email,
                      ),
                      ProfileInfoRow(
                        icon: Icons.phone_outlined,
                        label: 'PHONE NUMBER',
                        value: _profile!.phone,
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
                        value: _profile!.role,
                      ),
                      ProfileInfoRow(
                        icon: Icons.business_outlined,
                        label: 'ORGANIZATION',
                        value: _profile!.organization,
                      ),
                      ProfileInfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'LOCATION',
                        value: _profile!.location,
                      ),
                    ],
                  ),

                  // Account Actions
                  const ProfileAccountActions(),
                ],
              ),
            ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}