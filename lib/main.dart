import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/child.dart';
import 'models/parent.dart';
import 'models/task.dart';
import 'services/hive_service.dart';
import 'services/data_service.dart';
import 'app_state.dart';
import 'app.dart';

import 'package:hive/hive.dart';

void debugHive() {
  debugPrint('--- HIVE DEBUG START ---');

  final parentsBox = Hive.box<Parent>('parents');
  final childrenBox = Hive.box<Child>('children');
  final tasksBox = Hive.box<Task>('tasks');

  debugPrint('Parents count: ${parentsBox.length}');
  debugPrint('Children count: ${childrenBox.length}');
  debugPrint('Tasks count: ${tasksBox.length}');

  debugPrint('Parents: ${parentsBox.values.toList()}');
  debugPrint('Children: ${childrenBox.values.toList()}');
  debugPrint('Tasks: ${tasksBox.values.toList()}');

  debugPrint('--- HIVE DEBUG END ---');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();

  Hive.registerAdapter(ChildAdapter());
  Hive.registerAdapter(ParentAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskDomainAdapter());

  final hiveService = HiveService();
  await hiveService.init();

  final dataService = DataService(hiveService);
  final appState = AppState(dataService);

  runApp(MyApp(appState: appState));
  debugHive();
}
