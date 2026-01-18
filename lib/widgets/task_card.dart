import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onUpdate;
  final bool showDomain;

  const TaskCard({
    super.key,
    required this.task,
    required this.onUpdate,
    this.showDomain = true, // default for child
  });

  //  Pastel background per domain
  Color _bgColor(TaskDomain domain) {
    switch (domain) {
      case TaskDomain.emotional:
        return const Color(0xFFFFEEF3);
      case TaskDomain.physical:
        return const Color(0xFFE8F1FF);
      case TaskDomain.social:
        return const Color(0xFFFFF4E5);
      case TaskDomain.ethical:
        return const Color(0xFFEAF7EE);
      case TaskDomain.cognitive:
      default:
        return const Color(0xFFF1ECFF);
    }
  }

  Color _accentColor(TaskDomain domain) {
    switch (domain) {
      case TaskDomain.emotional:
        return Colors.pink;
      case TaskDomain.physical:
        return Colors.blue;
      case TaskDomain.social:
        return Colors.orange;
      case TaskDomain.ethical:
        return Colors.green;
      case TaskDomain.cognitive:
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    //  Skip → remove from list
    if (task.isSkipped) return const SizedBox.shrink();

    final bg = _bgColor(task.domain);
    final accent = _accentColor(task.domain);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏷 DOMAIN CHIP (OPTIONAL)
            if (showDomain)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task.domain.name.toUpperCase(),
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            if (showDomain) const SizedBox(height: 12),

            //  TITLE
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // DESCRIPTION
            Text(
              task.description,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 16),

            //  ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ️ LIKE
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        task.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.pink,
                      ),
                      onPressed: () {
                        task.isLiked = !task.isLiked;
                        task.save();
                        onUpdate();
                      },
                    ),
                    Text(
                      'Like',
                      style: TextStyle(
                        color:
                        task.isLiked ? Colors.pink : Colors.grey,
                      ),
                    ),
                  ],
                ),

                // ⏭ SKIP + DONE
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Skip',
                      icon: const Icon(Icons.skip_next),
                      color: Colors.grey,
                      onPressed: () {
                        task.isSkipped = true;
                        task.save();
                        onUpdate();
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.done,
                        size: 18,
                        color:Colors.white,
                      ),
                      label: Text(
                        task.isCompleted
                            ? 'Completed'
                            : 'Mark Done',
                      style: TextStyle(color:Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: task.isCompleted
                            ? Colors.green
                            : Colors.green.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: task.isCompleted
                          ? null
                          : () {
                        task.isCompleted = true;
                        task.save();
                        onUpdate();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
