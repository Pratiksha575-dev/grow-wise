import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'models/user_role.dart';

import 'auth/auth_landing_screen.dart';
import 'screens/home_screen.dart';
import 'screens/parent_view.dart';
import 'screens/child_view.dart';

class MyApp extends StatelessWidget {
  final AppState appState;

  const MyApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GrowWise',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
        ),
        home: const RootNavigator(),
      ),
    );
  }
}

class RootNavigator extends StatelessWidget {
  const RootNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        // 1️⃣ Not logged in at all
        if (appState.parent == null && appState.child == null) {
          return const AuthLandingScreen();
        }

        // 2️⃣ Logged in, but no role chosen yet
        if (appState.role == null) {
          return const HomeScreen();
        }

        // 3️⃣ Parent flow
        if (appState.role == UserRole.parent) {
          return const ParentView();
        }

        // 4️⃣ Child flow
        if (appState.role == UserRole.child) {
          return const ChildView();
        }

        return const AuthLandingScreen();
      },
    );
  }
}

