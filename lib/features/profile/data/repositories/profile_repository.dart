// lib/features/profile/data/repositories/profile_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trade_verge/features/users/data/models/user_model.dart';
import 'dart:io';

class ProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserModel> getCurrentUser() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      final data =
          await _supabase.from('users').select().eq('id', userId).single();

      return UserModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      // Get jobs count
      final jobsCount = await _supabase
          .from('jobs')
          .select('id')
          .eq('client_id', userId)
          .or('transporter_id.eq.$userId');

      // Get completed jobs count
      final completedJobsCount = await _supabase
          .from('jobs')
          .select('id')
          .eq('status', 'completed')
          .eq('client_id', userId)
          .or('transporter_id.eq.$userId');

      // Get ratings
      final ratings = await _supabase
          .from('ratings')
          .select('score')
          .eq('ratee_id', userId);

      // Calculate average rating
      final avgRating = ratings.isEmpty
          ? 0.0
          : ratings.map((r) => r['score'] as num).reduce((a, b) => a + b) /
              ratings.length;

      return {
        'totalJobs': (jobsCount as List).length,
        'completedJobs': (completedJobsCount as List).length,
        'totalRatings': ratings.length,
        'averageRating': avgRating,
      };
    } catch (e) {
      throw Exception('Failed to fetch user stats: $e');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      await _supabase.from('users').update(updates).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<String> uploadProfileImage(String filePath) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      final fileExt = filePath.split('.').last;
      final fileName = 'profile_$userId.$fileExt';

      await _supabase.storage
          .from('profile-images')
          .upload(fileName, File(filePath));

      final imageUrl =
          _supabase.storage.from('profile-images').getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }
}
