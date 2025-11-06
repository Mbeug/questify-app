import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/login/login_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/profile/profile_page.dart';


final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');


GoRouter buildRouter() => GoRouter(
navigatorKey: _rootKey,
initialLocation: '/login',
routes: [
GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
],
);