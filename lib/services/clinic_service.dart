import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:claimflow_africa/dmodels/clinic_model.dart';

class ClinicService {
  static const String _boxName = 'clinics';
  static const _uuid = Uuid();

  static Box<ClinicModel> get _box => Hive.box<ClinicModel>(_boxName);

  static Future<void> addClinic({
    required String name,
    required String providerId,
    required String licenseNumber,
    required String address,
    required String email,
    required String phone,
    required bool isActive,
    DateTime? licenseExpiryDate,
    String billingContact = '',
    String submissionPreference = 'Electronic (Automated)',
  }) async {
    final clinic = ClinicModel()
      ..localId = _uuid.v4()
      ..name = name
      ..providerId = providerId
      ..licenseNumber = licenseNumber
      ..address = address
      ..email = email
      ..phone = phone
      ..isActive = isActive
      ..licenseExpiryDate = licenseExpiryDate
      ..claimsVolume = 0
      ..billingContact = billingContact
      ..submissionPreference = submissionPreference
      ..syncStatus = 'pendingSync'
      ..createdAt = DateTime.now();

    await _box.add(clinic);
  }

  static Future<void> updateClinic(ClinicModel clinic) async {
    clinic.syncStatus = 'pendingSync';
    await clinic.save();
  }

  static Future<void> deleteClinic(ClinicModel clinic) async {
    await clinic.delete();
  }

  static Future<void> toggleActive(ClinicModel clinic) async {
    clinic.isActive = !clinic.isActive;
    clinic.syncStatus = 'pendingSync';
    await clinic.save();
  }

  static List<ClinicModel> getAll() {
    return _box.values.toList();
  }

  static List<ClinicModel> getActive() {
    return _box.values.where((c) => c.isActive).toList();
  }

  static List<ClinicModel> getInactive() {
    return _box.values.where((c) => !c.isActive).toList();
  }
}