// widgets/social_login_row.dart
import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  final void Function(String provider)? onTap;

  const SocialIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget socialIcon(String assetName, String provider) {
      return GestureDetector(
        onTap: () {
          if (onTap != null) onTap!(provider);
        },
        child: Image.asset(
          assetName,
          width: 48,
          height: 48,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        socialIcon('assets/images/fb.png', 'facebook'),
        socialIcon('assets/images/ins.png', 'instagram'),
        socialIcon('assets/images/gg.png', 'google'),
        socialIcon('assets/images/app.png', 'apple'),
      ],
    );
  }
}