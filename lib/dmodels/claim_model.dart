import 'package:hive/hive.dart';

part 'claim_model.g.dart';

@HiveType(typeId: 0)
class ClaimModel extends HiveObject {
  @HiveField(0)
  late String localId;

  @HiveField(1)
  String? serverId;

  @HiveField(2)
  late String patientName;

  @HiveField(3)
  late String nhiaId;

  @HiveField(4)
  late DateTime dateOfBirth;

  @HiveField(5)
  late String gender;

  @HiveField(6)
  late String diagnosisCode;

  @HiveField(7)
  late String procedureCode;

  @HiveField(8)
  late DateTime serviceDate;

  @HiveField(9)
  late String insurer;

  @HiveField(10)
  late double totalClaimAmount;

  @HiveField(11)
  late String notes;

  @HiveField(12)
  late String syncStatus;

  @HiveField(13)
  late DateTime createdAt;

  @HiveField(14)
  DateTime? syncedAt;

  @HiveField(15)
  String? syncError;

  ClaimSyncStatus get status => ClaimSyncStatus.values.firstWhere(
        (e) => e.name == syncStatus,
        orElse: () => ClaimSyncStatus.pendingSync,
      );

  String get displayId => serverId ?? localId;

  bool get isSynced => status == ClaimSyncStatus.synced;
  bool get isPending => status == ClaimSyncStatus.pendingSync;
  bool get isFailed => status == ClaimSyncStatus.failed;
}

enum ClaimSyncStatus { synced, pendingSync, failed }