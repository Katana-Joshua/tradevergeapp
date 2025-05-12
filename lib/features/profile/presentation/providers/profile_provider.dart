// lib/features/profile/presentation/providers/profile_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/profile/data/repositories/profile_repository.dart';
import 'package:trade_verge/features/users/data/models/user_model.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository());

final profileProvider = FutureProvider<UserModel>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getCurrentUser();
});

final userStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getUserStats(userId);
});
