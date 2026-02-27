import 'package:flutter/material.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'package:claimflow_africa/widgets/settings2/settings3/settings_footer.dart';
import 'package:claimflow_africa/widgets/settings2/settings3/settings_tile.dart';
import 'package:claimflow_africa/widgets/settings2/settings3/settings_toggle_tile.dart';
import 'package:claimflow_africa/widgets/settings2/settings3/settings_section.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
         flexibleSpace: Text(
          'Manage your account and app preferences',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SettingsSection(
              title: 'ACCOUNTS',
              children: [
                SettingsTile(
                  icon: Icons.person_outline,
                  iconBgColor: const Color(0xFF4CAF50),
                  title: 'My Profile',
                  subtitle: 'Manage personal information and login identity',
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                SettingsTile(
                  icon: Icons.business_outlined,
                  iconBgColor: const Color(0xFF2196F3),
                  title: 'Organization Info',
                  subtitle: 'Clinic details and enterprise settings',
                  onTap: () =>
                      Navigator.pushNamed(context, '/organization'),
                ),
                SettingsTile(
                  icon: Icons.shield_outlined,
                  iconBgColor: const Color(0xFF9E9E9E),
                  title: 'Roles & Permissions',
                  subtitle: 'Staff access management and role assignments',
                  onTap: () => Navigator.pushNamed(context, '/roles'),
                ),
              ],
            ),

            
            SettingsSection(
              title: 'APP PREFERENCES',
              children: [
                SettingsTile(
                  icon: Icons.notifications_outlined,
                  iconBgColor: const Color(0xFFFF9800),
                  title: 'Notifications',
                  subtitle: 'Manage alerts, reminders, and push notifications',
                  onTap: () =>
                      Navigator.pushNamed(context, '/notifications'),
                ),
                SettingsTile(
                  icon: Icons.language_outlined,
                  iconBgColor: const Color(0xFF2196F3),
                  title: 'Language & Region',
                  subtitle: 'Currency format, timezone, and language settings',
                  onTap: () => Navigator.pushNamed(context, '/language'),
                ),
                SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  iconBgColor: const Color(0xFF9C27B0),
                  title: 'Display Preferences',
                  subtitle: 'Theme, text size, and visual settings',
                  comingSoon: true,
                ),
              ],
            ),

          
            SettingsSection(
              title: 'SECURITY',
              children: [
                SettingsToggleTile(
                  icon: Icons.fingerprint,
                  iconBgColor: const Color(0xFF4CAF50),
                  title: 'Biometric Login',
                  subtitle: 'Face ID or fingerprint authentication',
                  storageKey: 'biometric_enabled',
                ),
                SettingsTile(
                  icon: Icons.phone_android_outlined,
                  iconBgColor: const Color(0xFF2196F3),
                  title: 'Session & Device Management',
                  subtitle: 'Active sessions and trusted devices',
                  onTap: () => Navigator.pushNamed(context, '/sessions'),
                ),
              ],
            ),

            
            SettingsSection(
              title: 'HELP & SUPPORT',
              children: [
                SettingsTile(
                  icon: Icons.help_outline,
                  iconBgColor: const Color(0xFF4CAF50),
                  title: 'Help Center',
                  subtitle: 'Guides, tutorials, and support documentation',
                  onTap: () => Navigator.pushNamed(context, '/help'),
                ),
              ],
            ),

           
            SettingsSection(
              title: 'ABOUT CLAIMFLOW',
              children: [
                SettingsTile(
                  icon: Icons.info_outline,
                  iconBgColor: const Color(0xFF9E9E9E),
                  title: 'App Version',
                  subtitle: 'v1.2.4 (Build 2024.02.26)',
                  showChevron: false,
                  onTap: null,
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  iconBgColor: const Color(0xFF9E9E9E),
                  title: 'Privacy Policy',
                  subtitle: 'How we protect and handle your data',
                  onTap: () => Navigator.pushNamed(context, '/privacy'),
                ),
                SettingsTile(
                  icon: Icons.balance_outlined,
                  iconBgColor: const Color(0xFF9E9E9E),
                  title: 'Terms of Service',
                  subtitle: 'Usage agreements and legal terms',
                  onTap: () => Navigator.pushNamed(context, '/terms'),
                ),
                SettingsTile(
                  icon: Icons.track_changes_outlined,
                  iconBgColor: const Color(0xFF4CAF50),
                  title: 'SDG 8 Impact',
                  subtitle: 'Decent work and economic growth contribution',
                  onTap: () =>
                      Navigator.pushNamed(context, '/sdg-impact'),
                ),
              ],
            ),

           
            const SettingsFooter(),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}