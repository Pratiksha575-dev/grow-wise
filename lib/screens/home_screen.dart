import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/user_role.dart';
import 'parent_view.dart';
import 'child_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        // Safety fallback
        if (!appState.isLoggedIn) {
          return const Scaffold(
            body: Center(child: Text('Not logged in')),
          );
        }

        // Parent flow
        if (appState.role == UserRole.parent && appState.parent != null) {
          return const ParentView();
        }

        // Child flow
        if (appState.role == UserRole.child) {
          return const ChildView();
        }

        // Waiting / transition state
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
