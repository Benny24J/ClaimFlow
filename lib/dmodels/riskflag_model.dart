class RiskFlag {
  final String title;
  final String description;
  final String severity; // HIGH, MEDIUM, LOW
  final double impact;
  final int stepToFix; // which step in the claim form to navigate to

  const RiskFlag({
    required this.title,
    required this.description,
    required this.severity,
    required this.impact,
    required this.stepToFix,
  });
}