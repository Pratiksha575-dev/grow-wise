import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/task.dart';
import '../services/ai_task_engine.dart';
import 'profile_view.dart';
import '../widgets/task_card.dart';

class ChildView extends StatefulWidget {
  const ChildView({super.key});

  @override
  State<ChildView> createState() => _ChildViewState();
}

class _ChildViewState extends State<ChildView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _tasksGenerated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appState = context.read<AppState>();
      final child = appState.child;

      if (child == null || _tasksGenerated) return;

      _tasksGenerated = true;

      final aiEngine = AITaskEngine(appState.dataService);
      await aiEngine.generateDailyTasksWithAI(child);

      if (mounted) setState(() {});
    });
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

    final completed = tasks.where((t) => t.isCompleted).length;
    final liked = tasks.where((t) => t.isLiked).length;

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
            liked: liked,
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
  final int liked;

  const _ChildProgressTab({
    required this.total,
    required this.completed,
    required this.liked,
  });

  @override
  Widget build(BuildContext context) {
    final double completionPercent =
    total == 0 ? 0.0 : (completed / total);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Progress 🌟',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          _ProgressCard(
            title: 'Tasks Completed',
            value: '$completed / $total',
            progress: completionPercent,
            color: Colors.green,
          ),

          const SizedBox(height: 16),

          _ProgressCard(
            title: 'Tasks You Liked ❤️',
            value: liked.toString(),
            progress: total == 0 ? 0.0 : liked / total,
            color: Colors.pink,
          ),

          const SizedBox(height: 24),

          const Text(
            'Keep going!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Every small task you complete helps you grow smarter, '
                'stronger, and more confident 🌱',
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final String value;
  final double progress;
  final Color color;

  const _ProgressCard({
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: color,
              backgroundColor: color.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
