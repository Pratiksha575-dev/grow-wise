// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParentAdapter extends TypeAdapter<Parent> {
  @override
  final int typeId = 0;

  @override
  Parent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Parent(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      workingStatus: fields[3] as bool,
      freeTimeSlots: (fields[4] as List).cast<String>(),
      childIds: (fields[5] as List).cast<String>(),
      loginPassword: fields[6] as String,
      pin: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Parent obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.workingStatus)
      ..writeByte(4)
      ..write(obj.freeTimeSlots)
      ..writeByte(5)
      ..write(obj.childIds)
      ..writeByte(6)
      ..write(obj.loginPassword)
      ..writeByte(7)
      ..write(obj.pin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
