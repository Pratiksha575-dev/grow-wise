import 'package:uuid/uuid.dart';
import '../models/parent.dart';
import '../models/child.dart';
import '../models/task.dart';
import 'hive_service.dart';

class DataService {
  final HiveService hive;
  final _uuid = const Uuid();

  DataService(this.hive);

  // -------- AUTH --------
  bool validateLogin({
    required String email,
    required String password,
  }) {
    // For now, parents are the login owners
    final parents = hive.parents.values;

    for (final parent in parents) {
      if (parent.email == email && parent.loginPassword == password) {
        return true;
      }
    }
    return false;
  }

  // ---------------- PARENT ----------------

  Parent createParent({
    required String name,
    required String email,
    required bool workingStatus,
    required List<String> freeTimeSlots,
    required String loginPassword,
    required String pin,
  }) {
    final parent = Parent(
      id: _uuid.v4(),
      name: name,
      email: email,
      workingStatus: workingStatus,
      freeTimeSlots: freeTimeSlots,
      childIds: [],
      loginPassword: loginPassword,
      pin: pin,
    );

    hive.parents.put(parent.id, parent);
    return parent;
  }


  Parent? validateParentPin(String pin) {
    try {
      return hive.parents.values.firstWhere((p) => p.pin == pin);
    } catch (_) {
      return null;
    }
  }

  // ---------------- CHILD ----------------

  Child createChild({
    required String name,
    required int age,
    required String parentId,
  }) {
    final child = Child(
      id: _uuid.v4(),
      name: name,
      age: age,
      parentId: parentId,
    );

    hive.children.put(child.id, child);

    // Link child to parent
    final parent = hive.parents.get(parentId);
    if (parent != null) {
      parent.childIds.add(child.id);
      parent.save();
    }

    return child;
  }

  Parent? getParentByEmail(String email) {
    try {
      return hive.parents.values.firstWhere(
            (p) => p.email == email,
      );
    } catch (_) {
      return null;
    }
  }

  List<Child> getChildrenOfParent(String parentId) {
    return hive.children.values
        .where((c) => c.parentId == parentId)
        .toList();
  }

  // ---------------- TASKS ----------------

  Task createTask({
    required String childId,
    required String title,
    required String description,
    required TaskDomain domain,
    bool generatedByAI = false,
  }) {
    final task = Task(
      id: _uuid.v4(),
      childId: childId,
      title: title,
      description: description,
      domain:domain,
      taskDate: DateTime.now(),
      generatedByAI: generatedByAI,
    );

    hive.tasks.put(task.id, task);
    return task;
  }

  List<Task> getTasksForChild(String childId) {
    return hive.tasks.values
        .where((t) => t.childId == childId)
        .toList();
  }

  void updateTask(Task task) {
    task.save();
  }
}
