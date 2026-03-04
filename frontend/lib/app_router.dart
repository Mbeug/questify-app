import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/login/login_page.dart';
import 'features/signup/signup_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/profile/profile_page.dart';
import 'features/quests/quest_list_page.dart';
import 'features/quests/create_quest_page.dart';
import 'features/settings/settings_page.dart';

final GlobalKey<NavigatorState> _rootKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

CustomTransitionPage<void> _fadeTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _slideUpTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: curved,
          child: child,
        ),
      );
    },
  );
}

GoRouter buildRouter() => GoRouter(
      navigatorKey: _rootKey,
      initialLocation: '/login',
      routes: [
        // Auth pages — simple fade
        GoRoute(
          path: '/login',
          pageBuilder: (_, state) =>
              _fadeTransition(state, const LoginPage()),
        ),
        GoRoute(
          path: '/signup',
          pageBuilder: (_, state) =>
              _fadeTransition(state, const SignupPage()),
        ),

        // Main pages — slide up + fade
        GoRoute(
          path: '/dashboard',
          pageBuilder: (_, state) =>
              _slideUpTransition(state, const DashboardPage()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (_, state) =>
              _slideUpTransition(state, const ProfilePage()),
        ),
        GoRoute(
          path: '/quests',
          pageBuilder: (_, state) =>
              _slideUpTransition(state, const QuestListPage()),
        ),
        GoRoute(
          path: '/quests/create',
          pageBuilder: (_, state) =>
              _slideUpTransition(state, const CreateQuestPage()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (_, state) =>
              _slideUpTransition(state, const SettingsPage()),
        ),
      ],
    );
