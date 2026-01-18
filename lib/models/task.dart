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
  bool isCompleted;

  @HiveField(5)
  bool isLiked;

  @HiveField(6)
  bool isSkipped;

  @HiveField(7)
  bool generatedByAI;

  @HiveField(8)
  DateTime taskDate;

  Task({
    required this.id,
    required this.childId,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isLiked = false,
    this.isSkipped = false,
    this.generatedByAI = false,
    required this.taskDate,
  });
}
