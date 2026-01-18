import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'entry_mode_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _nameController = TextEditingController();
  final _pinController = TextEditingController();

  bool workingStatus = false;
  List<String> selectedTimeSlots = [];

  final List<_ChildInput> _children = [];

  void _toggleSlot(String slot) {
    setState(() {
      selectedTimeSlots.contains(slot)
          ? selectedTimeSlots.remove(slot)
          : selectedTimeSlots.add(slot);
    });
  }

  void _addChildDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Child'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Child Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final age = int.tryParse(ageController.text);

              if (name.isEmpty || age == null) return;

              setState(() {
                _children.add(_ChildInput(name: name, age: age));
              });

              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _continue() async {
    if (_nameController.text.isEmpty ||
        _pinController.text.isEmpty ||
        _children.isEmpty) {
      debugPrint('❌ WelcomeScreen validation failed');
      return;
    }

    final appState = context.read<AppState>();
    final dataService = appState.dataService;

    // 🔒 Parent MUST already exist (created during signup/login)
    final parent = appState.parent;

    if (parent == null) {
      debugPrint('❌ ERROR: Parent missing in WelcomeScreen');
      return;
    }

    // UPDATE EXISTING PARENT PROFILE
    parent.name = _nameController.text.trim();
    parent.workingStatus = workingStatus;
    parent.freeTimeSlots = selectedTimeSlots;

    // 🔐 SAVE PARENT SAFE PIN (for ParentView access)
    parent.pin = _pinController.text.trim();

    await parent.save();

    debugPrint('✅ PARENT UPDATED');
    debugPrint('Parent ID: ${parent.id}');
    debugPrint('Parent Email: ${parent.email}');
    debugPrint('Parent Safe PIN saved');

    // -------- CREATE CHILDREN --------
    for (final child in _children) {
      final createdChild = dataService.createChild(
        name: child.name,
        age: child.age,
        parentId: parent.id,
      );

      debugPrint(
        '👶 CHILD STORED → ${createdChild.name}, age ${createdChild.age}, parentId ${createdChild.parentId}',
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EntryModeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let’s set up your family 🌱',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            // -------- PARENT INFO --------
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Currently working?'),
              value: workingStatus,
              onChanged: (v) => setState(() => workingStatus = v),
            ),

            const SizedBox(height: 12),
            const Text('Free Time Availability'),

            Wrap(
              spacing: 10,
              children: ['10 min', '30 min', '1 hr']
                  .map(
                    (slot) => ChoiceChip(
                  label: Text(slot),
                  selected: selectedTimeSlots.contains(slot),
                  onSelected: (_) => _toggleSlot(slot),
                ),
              )
                  .toList(),
            ),

            const SizedBox(height: 24),

            // -------- PARENT SAFE PIN --------
            TextField(
              controller: _pinController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Create Parent Safe PIN',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            // -------- CHILDREN SECTION --------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Children',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: _addChildDialog,
                  icon: const Icon(Icons.add_circle, size: 28),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ..._children.map(
                  (c) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(c.name),
                  subtitle: Text('Age ${c.age}'),
                  leading: const Icon(Icons.child_care),
                ),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _continue,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildInput {
  final String name;
  final int age;

  _ChildInput({required this.name, required this.age});
}
