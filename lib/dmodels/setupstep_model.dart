
import 'package:flutter/material.dart';

class SetupStep {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool completed;
  final String route;

  const SetupStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.route,
  });

SetupStep copyWith({bool? completed}) {
    return SetupStep(
      icon: icon,
      title: title,
      subtitle: subtitle,
      completed: completed ?? this.completed,
      route: route,
    );
  }
}
