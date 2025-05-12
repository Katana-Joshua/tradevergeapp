import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/home/data/repositories/home_repository.dart';
import 'package:trade_verge/features/jobs/domain/models/job.dart';

final homeRepositoryProvider = Provider((ref) => HomeRepository());

final homeStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getHomeStats();
});

final recentJobsProvider = FutureProvider<List<Job>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getRecentJobs();
});

final walletBalanceProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getWalletBalance();
});