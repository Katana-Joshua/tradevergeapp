import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_verge/features/auth/presentation/screens/login_screen.dart';
import 'package:trade_verge/features/auth/presentation/screens/register_screen.dart';
import 'package:trade_verge/features/home/presentation/screens/home_screen.dart';
import 'package:trade_verge/features/jobs/presentation/screens/job_details_screen.dart';
import 'package:trade_verge/features/jobs/presentation/screens/jobs_screen.dart';
import 'package:trade_verge/features/profile/presentation/screens/profile_screen.dart';
import 'package:trade_verge/features/wallet/presentation/screens/wallet_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/jobs',
      builder: (context, state) => const JobsScreen(),
    ),
    GoRoute(
      path: '/jobs/:id',
      builder: (context, state) => JobDetailsScreen(
        jobId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const WalletScreen(),
    ),
  ],
);