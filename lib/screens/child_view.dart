import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/task.dart';
import 'profile_view.dart';
import '/widgets/task_card.dart';

class ChildView extends StatefulWidget {
  const ChildView({super.key});

  @override
  State<ChildView> createState() => _ChildViewState();
}

class _ChildViewState extends State<ChildView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final child = appState.child;

    if (child == null) {
      return const Scaffold(
        body: Center(child: Text('No child selected')),
      );
    }

    final List<Task> tasks =
    appState.dataService.getTasksForChild(child.id);

    final completed =
        tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi ${child.name} 👋'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tasks'),
            Tab(text: 'Progress'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ChildTasksTab(
            tasks: tasks,
            onUpdate: () => setState(() {}),
          ),
          _ChildProgressTab(
            total: tasks.length,
            completed: completed,
          ),
          const ProfileView(),
        ],
      ),
    );
  }
}

//
// ================= TAB 1: TASKS =================
//

class _ChildTasksTab extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback onUpdate;

  const _ChildTasksTab({
    required this.tasks,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks for today 😊',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(
          task: tasks[index],
          onUpdate: onUpdate,
        );
      },
    );
  }
}

//
// ================= TAB 2: PROGRESS =================
//

class _ChildProgressTab extends StatelessWidget {
  final int total;
  final int completed;

  const _ChildProgressTab({
    required this.total,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final percent =
    total == 0 ? 0 : (completed / total * 100).round();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Progress 📊',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '$completed of $total tasks completed',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: total == 0 ? 0 : completed / total,
                    minHeight: 10,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Keep going! 🌟',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Completing tasks daily helps build habits, '
                'confidence, and emotional strength.',
          ),
        ],
      ),
    );
  }
}
