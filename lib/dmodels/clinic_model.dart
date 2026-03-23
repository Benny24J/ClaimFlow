import 'package:hive/hive.dart';

part 'clinic_model.g.dart';

@HiveType(typeId: 2)
class ClinicModel extends HiveObject {
  @HiveField(0)
  late String localId;

  @HiveField(1)
  String? serverId;

  @HiveField(2)
  late String name;

  @HiveField(3)
  late String providerId;

  @HiveField(4)
  late String licenseNumber;

  @HiveField(5)
  late String address;

  @HiveField(6)
  late String email;

  @HiveField(7)
  late String phone;

  @HiveField(8)
  late bool isActive;

  @HiveField(9)
  DateTime? licenseExpiryDate;

  @HiveField(10)
  late int claimsVolume;

  @HiveField(11)
  late String billingContact;

  @HiveField(12)
  late String submissionPreference;

  @HiveField(13)
  late String syncStatus;

  @HiveField(14)
  late DateTime createdAt;

  @HiveField(15)
  DateTime? syncedAt;

  @HiveField(16)
  String? syncError;

  bool get isLicenseExpiringSoon {
    if (licenseExpiryDate == null) return false;
    final daysUntilExpiry =
        licenseExpiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry >= 0;
  }

  bool get isLicenseExpired {
    if (licenseExpiryDate == null) return false;
    return licenseExpiryDate!.isBefore(DateTime.now());
  }

  String get location {
    final parts = address.split(',');
    if (parts.length >= 2) {
      return '${parts[parts.length - 2].trim()}, ${parts[parts.length - 1].trim()}';
    }
    return address;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'providerId': providerId,
      'licenseNumber': licenseNumber,
      'address': address,
      'email': email,
      'phone': phone,
      'isActive': isActive,
      'licenseExpiryDate': licenseExpiryDate?.toIso8601String(),
      'claimsVolume': claimsVolume,
      'billingContact': billingContact,
      'submissionPreference': submissionPreference,
    };
  }
}