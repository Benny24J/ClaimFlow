import 'package:flutter/material.dart';

class ProfileAccountActions extends StatelessWidget {
  const ProfileAccountActions({super.key});

  Future<void> _onDeactivate(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded,
                color: Color(0xFFE53935), size: 22),
            SizedBox(width: 8),
            Text('Deactivate Account?'),
          ],
        ),
        content: const Text(
          'This will permanently deactivate your account. '
          'You will lose access to all claims and data. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935)),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // TODO: await authRepository.deactivateAccount();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/signin',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCOUNT ACTIONS',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 10),

        // Change Password
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/change-password'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              'Change Password',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Deactivate Account
        GestureDetector(
          onTap: () => _onDeactivate(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE53935).withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              'Deactivate Account',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE53935),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}