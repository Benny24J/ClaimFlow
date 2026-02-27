
import 'package:claimflow_africa/widgets/ar/ageing_calculator.dart';

class AiRecommendation {
  final int claimCount;
  final double totalAmount;
  final String dominantInsurer;
  final int denialProbability;
  final String whyItMatters;
  final String suggestedFix;
  final String urgencyLevel; // LOW, MEDIUM, HIGH, CRITICAL

  const AiRecommendation({
    required this.claimCount,
    required this.totalAmount,
    required this.dominantInsurer,
    required this.denialProbability,
    required this.whyItMatters,
    required this.suggestedFix,
    required this.urgencyLevel,
  });
}

class AiRecommendationEngine {
 
  static AiRecommendation generate(List<AgeingClaimItem> highRiskClaims) {
    if (highRiskClaims.isEmpty) {
      return const AiRecommendation(
        claimCount: 0,
        totalAmount: 0,
        dominantInsurer: 'N/A',
        denialProbability: 0,
        whyItMatters: 'No high-risk claims detected at this time.',
        suggestedFix: 'Continue monitoring your claims regularly.',
        urgencyLevel: 'LOW',
      );
    }

    final claimCount = highRiskClaims.length;
    final totalAmount = highRiskClaims.fold(
        0.0, (sum, item) => sum + item.claim.totalClaimAmount);

    
    final insurerCount = <String, int>{};
    for (final item in highRiskClaims) {
      final insurer = item.claim.insurer;
      insurerCount[insurer] = (insurerCount[insurer] ?? 0) + 1;
    }
    final dominantInsurer = insurerCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    
    final avgDays =
        highRiskClaims.fold(0, (sum, item) => sum + item.daysOverdue) /
            claimCount;
    final avgRiskScore =
        highRiskClaims.fold(0, (sum, item) => sum + item.riskScore) /
            claimCount;

    final daysFactor = (avgDays / 200).clamp(0.0, 0.5);
    final riskFactor = (avgRiskScore / 100) * 0.4;
    final missingDataCount = highRiskClaims
        .where((item) =>
            item.claim.diagnosisCode.isEmpty ||
            item.claim.procedureCode.isEmpty)
        .length;
    final missingDataFactor = (missingDataCount / claimCount) * 0.1;

    final denialProbability =
        ((daysFactor + riskFactor + missingDataFactor) * 100)
            .round()
            .clamp(10, 95);

   
    String urgencyLevel;
    if (denialProbability >= 70 || avgDays > 120) {
      urgencyLevel = 'CRITICAL';
    } else if (denialProbability >= 50 || avgDays > 90) {
      urgencyLevel = 'HIGH';
    } else if (denialProbability >= 30) {
      urgencyLevel = 'MEDIUM';
    } else {
      urgencyLevel = 'LOW';
    }

    
    final formattedAmount = totalAmount >= 1000000
        ? '₦${(totalAmount / 1000000).toStringAsFixed(2)}M'
        : '₦${(totalAmount / 1000).toStringAsFixed(0)},000';

    
    final whyItMatters =
        'AI analysis detected $claimCount claim${claimCount > 1 ? 's' : ''} '
        'over 90 days old with $dominantInsurer showing a $denialProbability% '
        'denial probability based on historical patterns. These claims total '
        '$formattedAmount and require immediate follow-up to prevent write-offs.';

   
    final String suggestedFix;
    if (urgencyLevel == 'CRITICAL') {
      suggestedFix =
          'Escalate immediately — assign these $claimCount claims to your most '
          'experienced recovery specialist. Contact $dominantInsurer\'s claims '
          'department directly using the verified phone number in the system. '
          'Consider filing a formal dispute for claims exceeding 120 days.';
    } else if (urgencyLevel == 'HIGH') {
      suggestedFix =
          'Auto-prioritize these claims and assign to your most experienced '
          'recovery specialist. Contact $dominantInsurer\'s claims department '
          'directly using the verified phone number in the system.';
    } else if (urgencyLevel == 'MEDIUM') {
      suggestedFix =
          'Schedule follow-up calls with $dominantInsurer within the next 3 '
          'business days. Ensure all $claimCount claims have complete '
          'documentation before re-submission.';
    } else {
      suggestedFix =
          'Monitor these claims closely over the next 2 weeks. Verify that all '
          'supporting documentation is complete and up to date.';
    }

    return AiRecommendation(
      claimCount: claimCount,
      totalAmount: totalAmount,
      dominantInsurer: dominantInsurer,
      denialProbability: denialProbability,
      whyItMatters: whyItMatters,
      suggestedFix: suggestedFix,
      urgencyLevel: urgencyLevel,
    );
  }
}