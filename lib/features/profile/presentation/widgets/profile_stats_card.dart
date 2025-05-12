// lib/features/profile/presentation/widgets/profile_stats_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/profile/presentation/providers/profile_provider.dart';

class ProfileStatsCard extends ConsumerWidget {
  final String userId;

  const ProfileStatsCard({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider(userId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            statsAsync.when(
              data: (stats) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          label: 'Total Jobs',
                          value: stats['totalJobs'].toString(),
                          icon: Icons.work,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          label: 'Completed',
                          value: stats['completedJobs'].toString(),
                          icon: Icons.check_circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          label: 'Rating',
                          value: stats['averageRating'].toStringAsFixed(1),
                          icon: Icons.star,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          label: 'Reviews',
                          value: stats['totalRatings'].toString(),
                          icon: Icons.rate_review,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.grey,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
