import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:claimflow_africa/dmodels/clinic_model.dart';
import 'package:claimflow_africa/services/clinic_service.dart';

enum ClinicFilter { all, active, inactive }

class ClinicNotifier extends Notifier<List<ClinicModel>> {
  ClinicFilter _filter = ClinicFilter.all;

  ClinicFilter get filter => _filter;

  @override
  List<ClinicModel> build() {
    final box = Hive.box<ClinicModel>('clinics');
    box.listenable().addListener(_onBoxChanged);
    return ClinicService.getAll();
  }

  void _onBoxChanged() {
    state = _applyFilter(_filter);
  }

  List<ClinicModel> _applyFilter(ClinicFilter filter) {
    switch (filter) {
      case ClinicFilter.active:
        return ClinicService.getActive();
      case ClinicFilter.inactive:
        return ClinicService.getInactive();
      case ClinicFilter.all:
        return ClinicService.getAll();
    }
  }

  void setFilter(ClinicFilter filter) {
    _filter = filter;
    state = _applyFilter(filter);
  }

  List<ClinicModel> search(String query) {
    final all = _applyFilter(_filter);
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.providerId.toLowerCase().contains(q) ||
          c.address.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> addClinic({
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
    await ClinicService.addClinic(
      name: name,
      providerId: providerId,
      licenseNumber: licenseNumber,
      address: address,
      email: email,
      phone: phone,
      isActive: isActive,
      licenseExpiryDate: licenseExpiryDate,
      billingContact: billingContact,
      submissionPreference: submissionPreference,
    );
    state = _applyFilter(_filter);
  }

  Future<void> toggleActive(ClinicModel clinic) async {
    await ClinicService.toggleActive(clinic);
    state = _applyFilter(_filter);
  }

  Future<void> deleteClinic(ClinicModel clinic) async {
    await ClinicService.deleteClinic(clinic);
    state = _applyFilter(_filter);
  }
}

final clinicProvider =
    NotifierProvider<ClinicNotifier, List<ClinicModel>>(ClinicNotifier.new);