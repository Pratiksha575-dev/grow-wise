import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onUpdate;

  const TaskCard({
    super.key,
    required this.task,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(task.description),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ❤️ Like
                IconButton(
                  icon: Icon(
                    task.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: task.isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    task.isLiked = !task.isLiked;
                    task.save();
                    onUpdate();
                  },
                ),

                // ⏭️ Skip
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    task.isSkipped = true;
                    task.save();
                    onUpdate();
                  },
                ),

                // ✅ Complete
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (v) {
                    task.isCompleted = v ?? false;
                    task.save();
                    onUpdate();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
