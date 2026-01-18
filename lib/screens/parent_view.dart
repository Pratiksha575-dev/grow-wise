import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/child.dart';
import '../models/task.dart';
import '../services/ai_task_engine.dart';
import '../auth/auth_landing_screen.dart';
import '../widgets/task_card.dart';
import 'profile_view.dart';

class ParentView extends StatefulWidget {
  const ParentView({super.key});

  @override
  State<ParentView> createState() => _ParentViewState();
}

class _ParentViewState extends State<ParentView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _aiCalled = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    //  Call AI only once
    if (_aiCalled) return;

    final appState = context.read<AppState>();
    final parent = appState.parent;

    if (parent != null) {
      final aiEngine = AITaskEngine(appState.dataService);

      aiEngine.generateDailyParentTasksWithAI(
        parentId: parent.id,
        parentName: parent.name,
        workingStatus: parent.workingStatus,
        freeTimeSlots: parent.freeTimeSlots,
        childrenCount: appState.childrenOfParent.length,
      );

      _aiCalled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final parent = appState.parent;

    if (parent == null) {
      return const Scaffold(
        body: Center(child: Text('Parent data missing')),
      );
    }

    final parentTasks = appState.dataService
        .getTasksForChild(parent.id)
        .where((t) => t.generatedByAI)
        .toList();

    final children = appState.childrenOfParent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tasks'),
            Tab(text: 'Progress'),
            Tab(text: 'Profile'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              appState.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const AuthLandingScreen(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ParentTasksTab(tasks: parentTasks),
          _ProgressSummaryTab(children: children),
          const ProfileView(),
        ],
      ),
    );
  }
}

//
// ================= TAB 1: PARENT TASKS =================
//

class _ParentTasksTab extends StatefulWidget {
  final List<Task> tasks;

  const _ParentTasksTab({required this.tasks});

  @override
  State<_ParentTasksTab> createState() => _ParentTasksTabState();
}

class _ParentTasksTabState extends State<_ParentTasksTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.tasks.isEmpty) {
      return const Center(
        child: Text(
          'No parenting tasks for today 🌱',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(
          task: widget.tasks[index],
          showDomain: false,
          onUpdate: () {
            setState(() {});
          },
        );
      },
    );
  }
}

//
// ================= TAB 2: CHILD PROGRESS =================
//

class _ProgressSummaryTab extends StatelessWidget {
  final List<Child> children;

  const _ProgressSummaryTab({required this.children});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final parent = appState.parent!;

    // 🔹 Parent tasks
    final parentTasks = appState.dataService
        .getTasksForChild(parent.id)
        .where((t) => t.generatedByAI)
        .toList();

    final completed =
        parentTasks.where((t) => t.isCompleted).length;
    final skipped =
        parentTasks.where((t) => t.isSkipped).length;
    final total = parentTasks.length;

    final double completionPercent =
    total == 0 ? 0.0 : completed / total;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= PARENT SUMMARY =================
          const Text(
            'Your Progress 📊',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          _ProgressCard(
            title: 'Tasks Completed',
            value: '$completed / $total',
            progress: completionPercent,
            color: Colors.green,
          ),

          const SizedBox(height: 12),

          _ProgressCard(
            title: 'Tasks Skipped',
            value: skipped.toString(),
            progress: total == 0 ? 0.0 : skipped / total,
            color: Colors.orange,
          ),

          const SizedBox(height: 32),

          // ================= CHILD SUMMARY =================
          const Text(
            'Children Progress 👨‍👩‍👧‍👦',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          if (children.isEmpty)
            const Text('No children added')
          else
            ...children.map((child) {
              final tasks =
              appState.dataService.getTasksForChild(child.id);
              final done =
                  tasks.where((t) => t.isCompleted).length;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.child_care),
                  title: Text(child.name),
                  subtitle: Text(
                    'Completed $done / ${tasks.length} tasks',
                  ),
                ),
              );
            }),
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
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
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

