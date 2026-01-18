import 'package:hive/hive.dart';

part 'parent.g.dart';

@HiveType(typeId: 0)
class Parent extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  bool workingStatus;

  @HiveField(4)
  List<String> freeTimeSlots;

  @HiveField(5)
  List<String> childIds;

  @HiveField(6)
  String loginPassword; // 🔐 NEW FIELD

  @HiveField(7)
  String pin; // 🔒 SAFE PIN

  Parent({
    required this.id,
    required this.name,
    required this.email,
    required this.workingStatus,
    required this.freeTimeSlots,
    required this.childIds,
    required this.loginPassword,
    required this.pin,
  });
}
