import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '/screens/entry_mode_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    debugPrint('🔐 LOGIN ATTEMPT');
    debugPrint('Email entered: $email');

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Please enter email and password';
        _isLoading = false;
      });
      debugPrint('❌ Login failed: empty fields');
      return;
    }

    final appState = context.read<AppState>();

    final isValid = appState.dataService.validateLogin(
      email: email,
      password: password,
    );

    debugPrint(
      isValid
          ? '✅ Login matched record in Hive'
          : '❌ Login did NOT match any record in Hive',
    );

    if (!isValid) {
      setState(() {
        _error = 'Invalid email or password';
        _isLoading = false;
      });
      return;
    }

    // 🔴 MISSING PIECE — FETCH PARENT
    final parent =
    appState.dataService.getParentByEmail(email);

    if (parent == null) {
      setState(() {
        _error = 'Account data error. Please sign up again.';
        _isLoading = false;
      });
      debugPrint('❌ Parent not found after login (corrupt state)');
      return;
    }

    // ✅ CRITICAL FIX
    appState.setCurrentParent(parent);
    appState.markLoggedIn();

    debugPrint('✅ Parent loaded into AppState: ${parent.email}');
    debugPrint('✅ AppState marked as logged in');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const EntryModeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🌱 Branding
              const Text(
                'Welcome back 🌿',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Login to continue your journey',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // 📧 Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // 🔒 Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _login,
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
      ),
    );
  }
}
