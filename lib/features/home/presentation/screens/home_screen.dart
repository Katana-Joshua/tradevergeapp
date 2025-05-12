import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_verge/features/home/presentation/providers/home_providers.dart';
import 'package:trade_verge/features/home/presentation/widgets/home_stats_card.dart';
import 'package:trade_verge/features/home/presentation/widgets/recent_jobs_card.dart';
import 'package:trade_verge/features/home/presentation/widgets/wallet_balance_card.dart';
import 'package:trade_verge/features/home/presentation/widgets/quick_actions_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Verge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh providers
          ref.refresh(homeStatsProvider);
          ref.refresh(recentJobsProvider);
          ref.refresh(walletBalanceProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              const WalletBalanceCard(),
              const SizedBox(height: 16),
              const HomeStatsCard(),
              const SizedBox(height: 16),
              const QuickActionsCard(),
              const SizedBox(height: 16),
              const RecentJobsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
