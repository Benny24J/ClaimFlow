import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/riskflag_model.dart';

class RiskEvaluator {
  static List<RiskFlag> evaluate(ClaimModel claim) {
    final List<RiskFlag> flags = [];

    if (claim.nhiaId.isEmpty) {
      flags.add(RiskFlag(
        title: 'Missing NHIA ID',
        description: 'This claim has no NHIA ID assigned.',
        severity: 'URGENT',
        impact: claim.totalClaimAmount,
        stepToFix: 1,
      ));
    }

    if (claim.diagnosisCode.isEmpty) {
      flags.add(RiskFlag(
        title: 'Missing Clinical Data',
        description: 'Diagnosis code is missing.',
        severity: 'HIGH',
        impact: claim.totalClaimAmount,
        stepToFix: 2,
      ));
    }

    if (claim.procedureCode.isEmpty) {
      flags.add(RiskFlag(
        title: 'Invalid Provider Code',
        description: 'Procedure code is missing or invalid.',
        severity: 'HIGH',
        impact: claim.totalClaimAmount,
        stepToFix: 3,
      ));
    }

    if (claim.totalClaimAmount > 100000) {
      flags.add(RiskFlag(
        title: 'High Value Claim',
        description: 'Claim amount exceeds ₦100,000 threshold.',
        severity: 'MEDIUM',
        impact: claim.totalClaimAmount,
        stepToFix: 4,
      ));
    }

    if (claim.diagnosisCode.isNotEmpty &&
        claim.procedureCode.isNotEmpty &&
        claim.diagnosisCode == claim.procedureCode) {
      flags.add(RiskFlag(
        title: 'Mismatched Codes',
        description: 'Diagnosis and procedure codes are identical.',
        severity: 'MEDIUM',
        impact: claim.totalClaimAmount,
        stepToFix: 2,
      ));
    }

    return flags;
  }
}