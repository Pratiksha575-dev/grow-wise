import 'package:flutter/material.dart';
import 'package:grow_wise/auth/auth_landing_screen.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/child.dart';
import '../models/task.dart';
import 'profile_view.dart';

class ParentView extends StatefulWidget {
  const ParentView({super.key});

  @override
  State<ParentView> createState() => _ParentViewState();
}

class _ParentViewState extends State<ParentView>
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
    final parent = appState.parent;

    if (parent == null) {
      return const Scaffold(
        body: Center(child: Text('Parent data missing')),
      );
    }

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
                  builder: (_) => const AuthLandingScreen(), // temporary landing
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
          _ParentTasksTab(),
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

class _ParentTasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Raw placeholder for now
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Parenting Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.task_alt),
              title: Text('Spend 10 minutes talking'),
              subtitle: Text('Have an open conversation with your child'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.task_alt),
              title: Text('Observe behavior today'),
              subtitle: Text('Note emotional patterns'),
            ),
          ),
        ],
      ),
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

    if (children.isEmpty) {
      return const Center(child: Text('No children added'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: children.length,
      itemBuilder: (context, index) {
        final child = children[index];
        final tasks =
        appState.dataService.getTasksForChild(child.id);
        final completed =
            tasks.where((t) => t.isCompleted).length;

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.child_care),
            title: Text(child.name),
            subtitle: Text(
              'Completed $completed / ${tasks.length} tasks',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChildProgressDetail(child: child),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

//
// ================= CHILD DETAIL (PLACEHOLDER) =================
//

class ChildProgressDetail extends StatelessWidget {
  final Child child;

  const ChildProgressDetail({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${child.name} Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: const Text(
          'Detailed analytics, AI insights, '
              'task likes, skips, suggestions '
              'will appear here later.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
