import 'package:flutter/material.dart';
import 'package:claimflow_africa/dmodels/setupstep_model.dart';
  
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late List<SetupStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = [
      SetupStep(
        icon: Icons.verified_outlined,
        title: 'Verify Email',
        subtitle: 'Check your inbox for a verification link.',
        completed: true,
        route: '/verify-email',
      ),
      SetupStep(
        icon: Icons.business_outlined,
        title: 'Add Organization Details',
        subtitle: 'Tell us about your healthcare practice.',
        completed: false,
        route: '/org-details',
      ),
      SetupStep(
        icon: Icons.credit_card_outlined,
        title: 'Set Payment Information',
        subtitle: 'Connect your bank account for reimbursements.',
        completed: false,
        route: '/payment-info',
      ),
      SetupStep(
        icon: Icons.group_add_outlined,
        title: 'Add Team Members',
        subtitle: 'Invite your administrative staff (Optional).',
        completed: false,
        route: '/team-members',
      ),
    ];
  }

  int get _completedCount => _steps.where((s) => s.completed).length;
  double get _progress => _completedCount / _steps.length;

  void _onStepTapped(int index) async {
    if (_steps[index].completed) return;

    
    final completed = await Navigator.pushNamed(context, _steps[index].route);

    if (completed == true) {
      setState(() {
        _steps[index] = _steps[index].copyWith(completed: true);
      });
    }
  }

  void _onCtaPressed() {
    final nextStep = _steps.firstWhere(
      (s) => !s.completed,
      orElse: () => _steps.last,
    );
    Navigator.pushNamed(context, nextStep.route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Welcome to ClaimFlow',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Let's set up your account to start submitting claims and preventing losses.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(153),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Progress section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ACCOUNT SETUP: $_completedCount OF ${_steps.length} COMPLETED',
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withAlpha(128),
                    ),
                  ),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.outline.withAlpha(51),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
              const SizedBox(height: 24),

              // Steps
              ...List.generate(
                _steps.length,
                (index) => GestureDetector(
                  onTap: () => _onStepTapped(index),
                  child: _SetupStepCard(step: _steps[index]),
                ),
              ),

              const SizedBox(height: 28),

              // CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onCtaPressed,
                  child: const Text('Complete Organization Setup'),
                ),
              ),
              const SizedBox(height: 16),

              // Skip link
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                  child: Text(
                    'SKIP FOR NOW',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(128),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupStepCard extends StatelessWidget {
  final SetupStep step;
  const _SetupStepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: step.completed
              ? theme.colorScheme.primary.withAlpha(77)
              : theme.colorScheme.outline.withAlpha(64),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: step.completed
                  ? theme.colorScheme.primary.withAlpha(30)
                  : theme.colorScheme.onSurface.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: step.completed
                ? Icon(Icons.check_circle_rounded,
                    color: theme.colorScheme.primary, size: 24)
                : Icon(step.icon,
                    color: theme.colorScheme.onSurface.withAlpha(128), size: 22),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: step.completed
                        ? theme.colorScheme.onSurface.withAlpha(128)
                        : theme.colorScheme.onSurface,
                    decoration:
                        step.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(115),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (!step.completed)
            Icon(Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withAlpha(102), size: 22),
        ],
      ),
    );
  }
}