import 'package:flutter/material.dart';
import 'helper_card.dart';

class NewUserSection extends StatelessWidget {
  final VoidCallback onDismiss;
  final VoidCallback onViewSampleClaim;
  final VoidCallback onLearnProcess;
  final VoidCallback onInviteTeam;

  const NewUserSection({
    super.key,
    required this.onDismiss,
    required this.onViewSampleClaim,
    required this.onLearnProcess,
    required this.onInviteTeam,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 14,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 1),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'New to ClaimFlow?',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                size: 18,
                color: theme.colorScheme.onSurface.withAlpha(100),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HelperCard(icon: Icons.description_outlined, label: 'View Sample Claim', onTap: onViewSampleClaim),
        const SizedBox(height: 10),
        HelperCard(icon: Icons.school_outlined, label: 'Learn Submission Process', onTap: onLearnProcess),
        const SizedBox(height: 10),
        HelperCard(icon: Icons.group_add_outlined, label: 'Invite Team Member', onTap: onInviteTeam),
      ],
    );
  }
}