import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/child.dart';
import 'data_service.dart';
import 'ai_prompt_builder.dart';

const String OLLAMA_BASE_URL = 'http://localhost:11434';

class AITaskEngine {
  final DataService dataService;

  AITaskEngine(this.dataService);


  // ================= OLLAMA CALL =================
  Future<String> _callAI(String prompt) async {
    debugPrint('🚀 Calling Ollama (local LLM)');

    final response = await http.post(
      Uri.parse('$OLLAMA_BASE_URL/api/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "model": "mistral:7b-instruct",
        "prompt": prompt,
        "stream": false,
      }),
    );

    if (response.statusCode != 200) {
      debugPrint('❌ Ollama error: ${response.body}');
      throw Exception('Ollama request failed');
    }

    final decoded = jsonDecode(response.body);

    if (decoded['response'] != null) {
      return decoded['response'];
    }

    throw Exception('Invalid Ollama response');
  }

  // ================= CHILD TASKS =================
  Future<void> generateDailyTasksWithAI(Child child) async {
    final today = DateTime.now();

    final alreadyGenerated = dataService
        .getTasksForChild(child.id)
        .any((t) =>
    t.taskDate.year == today.year &&
        t.taskDate.month == today.month &&
        t.taskDate.day == today.day &&
        t.generatedByAI);

    if (alreadyGenerated) {
      debugPrint('ℹ️ Child tasks already generated today');
      return;
    }

    final pastTasks = dataService.getTasksForChild(child.id);

    final prompt = AIPromptBuilder.buildDailyTaskPrompt(
      child: child,
      age: child.age,
      pastTasks: pastTasks,
    );

    final aiResponse = await _callAI(prompt);

    debugPrint('📥 CHILD AI RESPONSE:\n$aiResponse');

    _parseAndStoreTasks(
      rawText: aiResponse,
      ownerId: child.id,
    );
  }

  // ================= PARENT TASKS =================
  Future<void> generateDailyParentTasksWithAI({
    required String parentId,
    required String parentName,
    required bool workingStatus,
    required List<String> freeTimeSlots,
    required int childrenCount,
  }) async {
    final today = DateTime.now();

    final alreadyGenerated = dataService
        .getTasksForChild(parentId)
        .any((t) =>
    t.taskDate.year == today.year &&
        t.taskDate.month == today.month &&
        t.taskDate.day == today.day &&
        t.generatedByAI);

    if (alreadyGenerated) {
      debugPrint('ℹ️ Parent tasks already generated today');
      return;
    }

    final pastTasks = dataService.getTasksForChild(parentId);
    final childrenAges = dataService
        .getChildrenOfParent(parentId)
        .map((c) => c.age)
        .toList();

    final prompt = AIPromptBuilder.buildDailyParentTaskPrompt(
      parentName: parentName,
      workingStatus: workingStatus,
      freeTimeSlots: freeTimeSlots,
      childrenAges: childrenAges,
      pastTasks: pastTasks,
    );

    final aiResponse = await _callAI(prompt);

    debugPrint('📥 PARENT AI RESPONSE:\n$aiResponse');

    _parseAndStoreTasks(
      rawText: aiResponse,
      ownerId: parentId, // parent stored like child
    );
  }

  // ================= COMMON PARSER =================
  void _parseAndStoreTasks({
    required String rawText,
    required String ownerId,
  }) {
    rawText = rawText.trim();

    // ---------- CASE 1: JSON (Parent tasks) ----------
    if (_isJsonResponse(rawText)) {
      try {
        final decoded = jsonDecode(rawText);

        if (decoded is! List) return;

        for (final t in decoded) {
          if (t is! Map) continue;

          final domainStr = (t['domain'] ?? '').toString().toLowerCase();

          final domain = TaskDomain.values.firstWhere(
                (e) => e.name == domainStr,
            orElse: () => TaskDomain.cognitive,
          );

          dataService.createTask(
            childId: ownerId,
            title: t['title'] ?? '',
            description: t['description'] ?? '',
            domain: domain,
            generatedByAI: true,
          );
        }

        debugPrint('✅ JSON AI tasks stored for $ownerId');
        return;
      } catch (e) {
        debugPrint('❌ Failed to decode AI JSON: $e');
        return;
      }
    }

    // ---------- CASE 2: PIPE FORMAT (Child tasks) ----------
    final lines = rawText.split('\n');
    int created = 0;

    for (final line in lines) {
      if (!line.contains('|')) continue;

      final parts = line.split('|');
      if (parts.length != 3) continue;

      final title = parts[0].trim();
      final description = parts[1].trim();
      final domainStr = parts[2].trim().toLowerCase();

      final domain = TaskDomain.values.firstWhere(
            (e) => e.name == domainStr,
        orElse: () => TaskDomain.cognitive,
      );

      dataService.createTask(
        childId: ownerId,
        title: title,
        description: description,
        domain: domain,
        generatedByAI: true,
      );

      created++;
      if (created == 5) break;
    }

    debugPrint('✅ PIPE AI tasks stored for $ownerId');
  }
  bool _isJsonResponse(String text) {
    final t = text.trim();
    return t.startsWith('[') && t.endsWith(']');
  }

}
