// lib/features/profile/presentation/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/profile/presentation/providers/profile_provider.dart';
import 'package:trade_verge/features/profile/presentation/widgets/profile_header.dart';
import 'package:trade_verge/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:trade_verge/features/profile/presentation/widgets/profile_stats_card.dart';
import 'package:trade_verge/features/profile/presentation/widgets/profile_actions_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile screen
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (user) => RefreshIndicator(
          onRefresh: () async => ref.refresh(profileProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ProfileHeader(user: user),
                const SizedBox(height: 16),
                ProfileInfoCard(user: user),
                const SizedBox(height: 16),
                ProfileStatsCard(userId: user.id),
                const SizedBox(height: 16),
                const ProfileActionsCard(),
              ],
            ),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}
