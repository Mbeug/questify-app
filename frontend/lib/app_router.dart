import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/auth_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/profile/profile_page.dart';
import 'features/quests/quests_tab_page.dart';
import 'features/quests/quest_list_page.dart';
import 'features/quests/create_quest_page.dart';
import 'features/settings/settings_page.dart';
import 'features/group/group_screen.dart';
import 'features/customization/customization_screen.dart';
import 'features/shared/shell_scaffold.dart';

// ============================================================================
//  Router — 5-tab ShellRoute + auth routes
// ============================================================================

final GlobalKey<NavigatorState> _rootKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

// ──── Transition helpers ────

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

// ──── Router builder ────

GoRouter buildRouter() => GoRouter(
      navigatorKey: _rootKey,
      initialLocation: '/login',
      routes: [
        // ── Auth route (single merged page) ──
        GoRoute(
          path: '/login',
          pageBuilder: (_, state) =>
              _fadeTransition(state, const AuthPage()),
        ),

        // ── Main app with persistent 5-tab bottom nav ──
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ShellScaffold(navigationShell: navigationShell);
          },
          branches: [
            // Tab 0: Accueil (Dashboard — recap only)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/dashboard',
                  pageBuilder: (_, state) =>
                      _slideUpTransition(state, const DashboardPage()),
                ),
              ],
            ),

            // Tab 1: Quetes (quest management)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/quests',
                  pageBuilder: (_, state) =>
                      _slideUpTransition(state, const QuestsTabPage()),
                  routes: [
                    // Nested: quest list (full detail view)
                    GoRoute(
                      path: 'list',
                      pageBuilder: (_, state) =>
                          _slideUpTransition(state, const QuestListPage()),
                    ),
                    // Nested: create quest
                    GoRoute(
                      path: 'create',
                      pageBuilder: (_, state) =>
                          _slideUpTransition(state, const CreateQuestPage()),
                    ),
                  ],
                ),
              ],
            ),

            // Tab 2: Groupe
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/group',
                  pageBuilder: (_, state) =>
                      _slideUpTransition(state, const GroupScreen()),
                ),
              ],
            ),

            // Tab 3: Themes (Customization)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customization',
                  pageBuilder: (_, state) =>
                      _slideUpTransition(state, const CustomizationScreen()),
                ),
              ],
            ),

            // Tab 4: Profil
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  pageBuilder: (_, state) =>
                      _slideUpTransition(state, const ProfilePage()),
                  routes: [
                    GoRoute(
                      path: 'settings',
                      pageBuilder: (_, state) =>
                          _slideUpTransition(state, const SettingsPage()),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
