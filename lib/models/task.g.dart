// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 3;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      childId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      taskDate: fields[4] as DateTime,
      isCompleted: fields[5] as bool,
      isLiked: fields[6] as bool,
      isSkipped: fields[7] as bool,
      domain: fields[8] as TaskDomain,
      generatedByAI: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.childId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.taskDate)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.isLiked)
      ..writeByte(7)
      ..write(obj.isSkipped)
      ..writeByte(8)
      ..write(obj.domain)
      ..writeByte(9)
      ..write(obj.generatedByAI);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskDomainAdapter extends TypeAdapter<TaskDomain> {
  @override
  final int typeId = 4;

  @override
  TaskDomain read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskDomain.emotional;
      case 1:
        return TaskDomain.social;
      case 2:
        return TaskDomain.physical;
      case 3:
        return TaskDomain.cognitive;
      case 4:
        return TaskDomain.ethical;
      default:
        return TaskDomain.emotional;
    }
  }

  @override
  void write(BinaryWriter writer, TaskDomain obj) {
    switch (obj) {
      case TaskDomain.emotional:
        writer.writeByte(0);
        break;
      case TaskDomain.social:
        writer.writeByte(1);
        break;
      case TaskDomain.physical:
        writer.writeByte(2);
        break;
      case TaskDomain.cognitive:
        writer.writeByte(3);
        break;
      case TaskDomain.ethical:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDomainAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
