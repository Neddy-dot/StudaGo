import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/auth/views/login_screen.dart';
import '../../features/attendance/views/check_in_out_screen.dart';

import '../../features/parent/views/parent_dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/check-in',
      builder: (context, state) => const CheckInOutScreen(),
    ),
    // Placeholder routes for other dashboards
    GoRoute(
      path: '/admin',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Admin Dashboard')),
        body: const Center(child: Text('Admin Dashboard Placeholder')),
      ),
    ),
    GoRoute(
      path: '/parent',
      builder: (context, state) => const ParentDashboardScreen(),
    ),
  ],
);
