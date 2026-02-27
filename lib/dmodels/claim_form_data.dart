class ClaimFormData {
 
  String fullName = '';
  String nhiaId = '';
  DateTime? dateOfBirth;
  String gender = '';

 
  String diagnosisCode = '';
  String procedureCode = '';
  DateTime? serviceDate;
  String insurer = '';

  
  double totalClaimAmount = 0.0;
  String notes = '';
}

class LiveRiskResult {
  final String riskLevel; 
  final double exposure;
  final double confidence;

  const LiveRiskResult({
    required this.riskLevel,
    required this.exposure,
    required this.confidence,
  });
}