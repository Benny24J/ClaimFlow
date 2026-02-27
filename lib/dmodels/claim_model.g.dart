// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClaimModelAdapter extends TypeAdapter<ClaimModel> {
  @override
  final int typeId = 0;

  @override
  ClaimModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClaimModel()
      ..localId = fields[0] as String
      ..serverId = fields[1] as String?
      ..patientName = fields[2] as String
      ..nhiaId = fields[3] as String
      ..dateOfBirth = fields[4] as DateTime
      ..gender = fields[5] as String
      ..diagnosisCode = fields[6] as String
      ..procedureCode = fields[7] as String
      ..serviceDate = fields[8] as DateTime
      ..insurer = fields[9] as String
      ..totalClaimAmount = fields[10] as double
      ..notes = fields[11] as String
      ..syncStatus = fields[12] as String
      ..createdAt = fields[13] as DateTime
      ..syncedAt = fields[14] as DateTime?
      ..syncError = fields[15] as String?;
  }

  @override
  void write(BinaryWriter writer, ClaimModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(2)
      ..write(obj.patientName)
      ..writeByte(3)
      ..write(obj.nhiaId)
      ..writeByte(4)
      ..write(obj.dateOfBirth)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.diagnosisCode)
      ..writeByte(7)
      ..write(obj.procedureCode)
      ..writeByte(8)
      ..write(obj.serviceDate)
      ..writeByte(9)
      ..write(obj.insurer)
      ..writeByte(10)
      ..write(obj.totalClaimAmount)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.syncStatus)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.syncedAt)
      ..writeByte(15)
      ..write(obj.syncError);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClaimModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
