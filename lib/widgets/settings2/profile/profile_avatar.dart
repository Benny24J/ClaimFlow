import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String fullName;

  const ProfileAvatar({
    super.key,
    required this.fullName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: avatarUrl != null
              ? ClipOval(
                  child: Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(theme),
                  ),
                )
              : _placeholder(theme),
        ),
      ],
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Icon(
      Icons.person_outline_rounded,
      size: 44,
      color: Colors.white.withValues(alpha: 0.9),
    );
  }
}