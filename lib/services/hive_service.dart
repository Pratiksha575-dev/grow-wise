import 'package:hive/hive.dart';
import '../models/parent.dart';
import '../models/child.dart';
import '../models/task.dart';

class HiveService {
  static const parentBoxName = 'parents';
  static const childBoxName = 'children';
  static const taskBoxName = 'tasks';

  late Box<Parent> _parentBox;
  late Box<Child> _childBox;
  late Box<Task> _taskBox;

  Future<void> init() async {
    _parentBox = await Hive.openBox<Parent>(parentBoxName);
    _childBox = await Hive.openBox<Child>(childBoxName);
    _taskBox = await Hive.openBox<Task>(taskBoxName);
  }

  Box<Parent> get parents => _parentBox;
  Box<Child> get children => _childBox;
  Box<Task> get tasks => _taskBox;
}
