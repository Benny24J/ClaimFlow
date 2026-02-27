import 'package:claimflow_africa/dmodels/claim_model.dart';

class AgeingBucket {
  final String label;
  final String range;
  final double totalAmount;
  final int claimCount;
  final double percentageChange;
  final bool isHighRisk;

  const AgeingBucket({
    required this.label,
    required this.range,
    required this.totalAmount,
    required this.claimCount,
    required this.percentageChange,
    this.isHighRisk = false,
  });
}

class AgeingClaimItem {
  final ClaimModel claim;
  final int daysOverdue;
  final int riskScore;

  const AgeingClaimItem({
    required this.claim,
    required this.daysOverdue,
    required this.riskScore,
  });
}

class AgeingData {
  final double totalOutstanding;
  final double monthlyChangePercent;
  final List<AgeingBucket> buckets;
  final List<AgeingClaimItem> claimItems;

  const AgeingData({
    required this.totalOutstanding,
    required this.monthlyChangePercent,
    required this.buckets,
    required this.claimItems,
  });
}

class AgeingCalculator {
  static AgeingData calculate(List<ClaimModel> claims) {
    final now = DateTime.now();

    // Bucket accumulators
    final Map<String, double> amounts = {
      '0-30': 0,
      '31-60': 0,
      '61-90': 0,
      '91-120': 0,
      '120+': 0,
    };
    final Map<String, int> counts = {
      '0-30': 0,
      '31-60': 0,
      '61-90': 0,
      '91-120': 0,
      '120+': 0,
    };

    final List<AgeingClaimItem> claimItems = [];

    for (final claim in claims) {
      final days = now.difference(claim.serviceDate).inDays;
      final riskScore = _calculateRiskScore(claim, days);

      claimItems.add(AgeingClaimItem(
        claim: claim,
        daysOverdue: days,
        riskScore: riskScore,
      ));

      final bucket = _getBucketKey(days);
      amounts[bucket] = (amounts[bucket] ?? 0) + claim.totalClaimAmount;
      counts[bucket] = (counts[bucket] ?? 0) + 1;
    }

    
    claimItems.sort((a, b) => b.daysOverdue.compareTo(a.daysOverdue));

    final totalOutstanding =
        amounts.values.fold(0.0, (sum, val) => sum + val);

    final buckets = [
      AgeingBucket(
        label: '0-30 Days',
        range: '0-30',
        totalAmount: amounts['0-30']!,
        claimCount: counts['0-30']!,
        percentageChange: -5.0,
      ),
      AgeingBucket(
        label: '31-60 Days',
        range: '31-60',
        totalAmount: amounts['31-60']!,
        claimCount: counts['31-60']!,
        percentageChange: -3.0,
      ),
      AgeingBucket(
        label: '61-90 Days',
        range: '61-90',
        totalAmount: amounts['61-90']!,
        claimCount: counts['61-90']!,
        percentageChange: 8.0,
      ),
      AgeingBucket(
        label: '91-120 Days',
        range: '91-120',
        totalAmount: amounts['91-120']!,
        claimCount: counts['91-120']!,
        percentageChange: 12.0,
      ),
      AgeingBucket(
        label: '120+ Days',
        range: '120+',
        totalAmount: amounts['120+']!,
        claimCount: counts['120+']!,
        percentageChange: 15.0,
        isHighRisk: true,
      ),
    ];

    return AgeingData(
      totalOutstanding: totalOutstanding,
      monthlyChangePercent: -8.0,
      buckets: buckets,
      claimItems: claimItems,
    );
  }

  static String _getBucketKey(int days) {
    if (days <= 30) return '0-30';
    if (days <= 60) return '31-60';
    if (days <= 90) return '61-90';
    if (days <= 120) return '91-120';
    return '120+';
  }

  static int _calculateRiskScore(ClaimModel claim, int days) {
    int score = 0;

    
    if (days > 120) {
      score += 60;
    } else if (days > 90) score += 45;
    else if (days > 60) score += 30;
    else if (days > 30) score += 15;

    
    if (claim.totalClaimAmount > 100000) {
      score += 20;
    } else if (claim.totalClaimAmount > 50000) score += 10;


    if (claim.diagnosisCode.isEmpty) score += 10;
    if (claim.procedureCode.isEmpty) score += 10;

    return score.clamp(0, 100);
  }
}