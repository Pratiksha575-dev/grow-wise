import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/user_role.dart';
import 'parent_pin_screen.dart';
import 'select_child_screen.dart';

class EntryModeScreen extends StatelessWidget {
  const EntryModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🌱 Header
              const Text(
                'Who is using GrowWise?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Choose how you want to continue',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 48),

              // -------- PARENT CARD --------
              _ModeCard(
                icon: Icons.person,
                title: 'Parent',
                subtitle: 'Manage children, view progress,\nget parenting tasks',
                onTap: () {
                  context.read<AppState>().chooseRole(UserRole.parent);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ParentPinScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // -------- CHILD CARD --------
              _ModeCard(
                icon: Icons.child_care,
                title: 'Child',
                subtitle: 'Complete fun daily tasks\nand grow every day',
                onTap: () {
                  context.read<AppState>().chooseRole(UserRole.child);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectChildScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.green.shade100,
              child: Icon(icon, size: 28, color: Colors.green.shade700),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
