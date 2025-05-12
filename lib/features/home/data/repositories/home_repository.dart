import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trade_verge/features/jobs/domain/models/job.dart';

class HomeRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, int>> getHomeStats() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      // Get jobs by status
      final pendingJobs = await _supabase
          .from('jobs')
          .select('id')
          .eq('status', 'pending')
          .eq('client_id', userId)
          .or('transporter_id.eq.$userId');

      final inTransitJobs = await _supabase
          .from('jobs')
          .select('id')
          .eq('status', 'in-transit')
          .eq('client_id', userId)
          .or('transporter_id.eq.$userId');

      final completedJobs = await _supabase
          .from('jobs')
          .select('id')
          .eq('status', 'completed')
          .eq('client_id', userId)
          .or('transporter_id.eq.$userId');

      return {
        'pendingJobs': (pendingJobs as List).length,
        'inTransitJobs': (inTransitJobs as List).length,
        'completedJobs': (completedJobs as List).length,
      };
    } catch (e) {
      throw Exception('Failed to fetch home stats: $e');
    }
  }

  Future<List<Job>> getRecentJobs() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      final data = await _supabase
          .from('jobs')
          .select('''
            *,
            client:client_id(id, name, email, phone),
            transporter:transporter_id(id, name, email, phone)
          ''')
          .eq('client_id', userId)
          .or('transporter_id.eq.$userId')
          .order('created_at', ascending: false)
          .limit(5);

      return (data as List).map((job) => Job.fromJson(job)).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent jobs: $e');
    }
  }

  Future<double> getWalletBalance() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      final data = await _supabase
          .from('wallets')
          .select('balance')
          .eq('user_id', userId)
          .single();

      return (data['balance'] as num).toDouble();
    } catch (e) {
      throw Exception('Failed to fetch wallet balance: $e');
    }
  }
}
