import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/child.dart';
import 'child_view.dart';

class SelectChildScreen extends StatelessWidget {
  const SelectChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final parent = appState.parent;

    if (parent == null) {
      return const Scaffold(
        body: Center(
          child: Text('No parent data found'),
        ),
      );
    }

    final List<Child> children = appState.childrenOfParent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Who are you?'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: children.isEmpty
            ? const Center(
          child: Text(
            'No child profiles available',
            style: TextStyle(fontSize: 16),
          ),
        )
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) {
            final child = children[index];
            return _ChildCard(
              child: child,
              onTap: () {
                // ✅ 1. Set selected child
                appState.selectChild(child);

                // ✅ 2. Navigate to ChildView
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChildView()),
                    (route)=>false,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  final Child child;
  final VoidCallback onTap;

  const _ChildCard({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 32,
              child: Icon(Icons.child_care, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              child.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Age ${child.age}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
