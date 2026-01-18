import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/user_role.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.role == UserRole.parent && appState.parent != null) {
      return _ParentProfile(appState);
    }

    if (appState.role == UserRole.child && appState.child != null) {
      return _ChildProfile(appState);
    }

    return const Scaffold(
      body: Center(child: Text('No profile data')),
    );
  }
}

// ===================== PARENT PROFILE =====================

class _ParentProfile extends StatelessWidget {
  final AppState appState;

  const _ParentProfile(this.appState);

  @override
  Widget build(BuildContext context) {
    final parent = appState.parent!;
    final children = appState.childrenOfParent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileHeader(
            icon: Icons.person,
            title: parent.name.isEmpty ? 'Parent' : parent.name,
            subtitle: parent.email,
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: 'Personal Info',
            children: [
              _InfoRow('Name', parent.name),
              _InfoRow('Email', parent.email),
              _InfoRow(
                'Working Status',
                parent.workingStatus ? 'Working' : 'Not Working',
              ),
            ],
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: 'Free Time Availability',
            children: [
              parent.freeTimeSlots.isEmpty
                  ? const Text('No time slots selected')
                  : Wrap(
                spacing: 8,
                children: parent.freeTimeSlots
                    .map((slot) => Chip(label: Text(slot)))
                    .toList(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: 'Children',
            children: children.isEmpty
                ? const [
              Text(
                'No children added',
                style: TextStyle(color: Colors.grey),
              ),
            ]
                : children.map((child) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.child_care),
                  title: Text(child.name),
                  subtitle: Text('Age ${child.age}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Future: open child summary
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ===================== CHILD PROFILE =====================

class _ChildProfile extends StatelessWidget {
  final AppState appState;

  const _ChildProfile(this.appState);

  @override
  Widget build(BuildContext context) {
    final child = appState.child!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileHeader(
            icon: Icons.child_care,
            title: child.name,
            subtitle: 'Age ${child.age}',
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: 'Details',
            children: [
              _InfoRow('Name', child.name),
              _InfoRow('Age', child.age.toString()),
            ],
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: 'Access',
            children: const [
              Text(
                'Profile details can be edited by parent only.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===================== REUSABLE UI =====================

class _ProfileHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              child: Icon(icon, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
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
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
