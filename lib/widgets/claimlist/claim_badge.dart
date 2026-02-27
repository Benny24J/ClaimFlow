import 'package:flutter/material.dart';

class ClaimBadge extends StatelessWidget {
  final String label;

  const ClaimBadge({super.key, required this.label});

  Color _bgColor() {
    switch (label.toLowerCase()) {
      case 'high risk': return const Color(0xFFFFEBEE);
      case 'medium risk': return const Color(0xFFFFF3E0);
      case 'low risk': return const Color(0xFFE8F5E9);
      case 'approved': return const Color(0xFFE8F5E9);
      case 'overdue': return const Color(0xFFFFEBEE);
      case 'pending': return const Color(0xFFF5F5F5);
      default: return const Color(0xFFF5F5F5);
    }
  }

  Color _textColor() {
    switch (label.toLowerCase()) {
      case 'high risk': return const Color(0xFFE53935);
      case 'medium risk': return const Color(0xFFF57C00);
      case 'low risk': return const Color(0xFF43A047);
      case 'approved': return const Color(0xFF43A047);
      case 'overdue': return const Color(0xFFE53935);
      case 'pending': return const Color(0xFF9E9E9E);
      default: return const Color(0xFF9E9E9E);
    }
  }

  Color _borderColor() {
    switch (label.toLowerCase()) {
      case 'high risk': return const Color(0xFFE53935);
      case 'medium risk': return const Color(0xFFF57C00);
      case 'low risk': return const Color(0xFF43A047);
      case 'approved': return const Color(0xFF43A047);
      case 'overdue': return const Color(0xFFE53935);
      default: return const Color(0xFFE0E0E0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor().withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _textColor(),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}