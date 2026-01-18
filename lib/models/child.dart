import 'package:hive/hive.dart';

part 'child.g.dart';

@HiveType(typeId: 2)
class Child extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int age;

  @HiveField(3)
  String parentId;

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.parentId,
  });
}
