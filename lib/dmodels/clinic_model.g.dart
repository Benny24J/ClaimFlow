// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClinicModelAdapter extends TypeAdapter<ClinicModel> {
  @override
  final int typeId = 2;

  @override
  ClinicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClinicModel()
      ..localId = fields[0] as String
      ..serverId = fields[1] as String?
      ..name = fields[2] as String
      ..providerId = fields[3] as String
      ..licenseNumber = fields[4] as String
      ..address = fields[5] as String
      ..email = fields[6] as String
      ..phone = fields[7] as String
      ..isActive = fields[8] as bool
      ..licenseExpiryDate = fields[9] as DateTime?
      ..claimsVolume = fields[10] as int
      ..billingContact = fields[11] as String
      ..submissionPreference = fields[12] as String
      ..syncStatus = fields[13] as String
      ..createdAt = fields[14] as DateTime
      ..syncedAt = fields[15] as DateTime?
      ..syncError = fields[16] as String?;
  }

  @override
  void write(BinaryWriter writer, ClinicModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.providerId)
      ..writeByte(4)
      ..write(obj.licenseNumber)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.licenseExpiryDate)
      ..writeByte(10)
      ..write(obj.claimsVolume)
      ..writeByte(11)
      ..write(obj.billingContact)
      ..writeByte(12)
      ..write(obj.submissionPreference)
      ..writeByte(13)
      ..write(obj.syncStatus)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.syncedAt)
      ..writeByte(16)
      ..write(obj.syncError);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClinicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
