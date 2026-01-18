import 'package:hive/hive.dart';

part 'task.g.dart';


@HiveType(typeId: 3)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String childId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime taskDate;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  bool isLiked;

  @HiveField(7)
  bool isSkipped;

  @HiveField(8)
  TaskDomain domain;

  @HiveField(9)
  bool generatedByAI;

  Task({
    required this.id,
    required this.childId,
    required this.title,
    required this.description,
    required this.taskDate,
    this.isCompleted = false,
    this.isLiked = false,
    this.isSkipped = false,
    required this.domain,
    this.generatedByAI = true,
  });
}



@HiveType(typeId: 4) // ⚠️ UNIQUE & NEW
enum TaskDomain {
  @HiveField(0)
  emotional,

  @HiveField(1)
  social,

  @HiveField(2)
  physical,

  @HiveField(3)
  cognitive,

  @HiveField(4)
  ethical,
}
