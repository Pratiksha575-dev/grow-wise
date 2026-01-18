import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/user_role.dart';
import 'parent_view.dart';

class ParentPinScreen extends StatefulWidget {
  const ParentPinScreen({super.key});

  @override
  State<ParentPinScreen> createState() => _ParentPinScreenState();
}

class _ParentPinScreenState extends State<ParentPinScreen> {
  final _pinController = TextEditingController();
  String? error;

  void _verifyPin() {
    final appState = context.read<AppState>();
    final parent = appState.parent;

    if (parent == null) {
      setState(() {
        error = 'Parent data missing. Please login again.';
      });
      debugPrint('❌ ParentPinScreen: parent is null');
      return;
    }

    debugPrint('🔐 PIN CHECK ATTEMPT');
    debugPrint('Parent ID: ${parent.id}');
    debugPrint('Entered PIN: ${_pinController.text}');

    if (parent.pin != _pinController.text.trim()) {
      setState(() {
        error = 'Incorrect PIN';
      });
      debugPrint('❌ PIN mismatch');
      return;
    }

    // ✅ PIN VERIFIED
    debugPrint('✅ PIN verified successfully');

    appState.chooseRole(UserRole.parent);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const ParentView()),
      (route)=>false,
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent PIN')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Parent Safe PIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'PIN',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _verifyPin,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
