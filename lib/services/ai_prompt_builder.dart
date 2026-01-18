import '../models/child.dart';
import '../models/task.dart';

class AIPromptBuilder {
  static String buildDailyTaskPrompt({
    required Child child,
    required int age,
    required List<Task> pastTasks,
  }) {
    final completed = pastTasks.where((t) => t.isCompleted).length;
    final skipped = pastTasks.where((t) => t.isSkipped).length;

    return '''
You are an AI assistant generating daily tasks for a child.

Child profile:
Name: ${child.name}
Age: $age

Past behavior:
Completed: $completed
Skipped: $skipped

Generate EXACTLY 5 tasks for today.

FORMAT (exactly one per line):
<Title> | <Short description> | <domain>

Allowed domains (use lowercase only):
cognitive
physical
emotional
social
ethical

Rules:
- Tasks must be age appropriate
- Tasks must be short and practical
- One task per domain (no repetition)
- Avoid repeating past tasks
- Do NOT number tasks
- Do NOT explain benefits
- Do NOT add extra text

Output ONLY the 5 task lines.
''';
  }

  static String buildDailyParentTaskPrompt({
    required String parentName,
    required bool workingStatus,
    required List<String> freeTimeSlots,
    required List<int> childrenAges, // ✅ NEW
    required List<Task> pastTasks,
  }) {
    final completed = pastTasks.where((t) => t.isCompleted).length;
    final skipped = pastTasks.where((t) => t.isSkipped).length;

    return '''
You are an AI assistant generating daily parenting tasks.

Parent profile:
Name: $parentName
Working: ${workingStatus ? "Yes" : "No"}
Free time slots: ${freeTimeSlots.join(", ")}

Children details:
Number of children: ${childrenAges.length}
Children ages: ${childrenAges.join(", ")}

Past behavior:
Completed: $completed
Skipped: $skipped

IMPORTANT:
Every task MUST involve doing something WITH the child or FOR the child.

Age rules:
- Tasks must be appropriate for the given children ages
- Avoid tasks that are unsafe or developmentally unsuitable
- If multiple ages exist, choose tasks suitable for all or adaptable

Generate EXACTLY 5 tasks for today.

Rules:
- Tasks must be short, practical, and realistic
- Tasks must match available free time
- Do NOT explain benefits
- Do NOT use teaching tone
- Do NOT invent new domains
- Do NOT repeat past tasks

Allowed domains (use lowercase only):
emotional
physical
social
cognitive
ethical

Return ONLY valid JSON.
No explanation.
No markdown.
No extra text.

JSON format:
[
  {
    "title": "",
    "description": "",
    "domain": "emotional"
  }
]
''';
  }

}