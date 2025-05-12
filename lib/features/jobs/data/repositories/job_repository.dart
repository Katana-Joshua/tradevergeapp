import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trade_verge/features/jobs/domain/models/job.dart';
import 'package:trade_verge/features/jobs/domain/models/vehicle_type.dart';

class JobRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Job>> getJobs({String? status}) async {
    try {
      final query = _supabase
          .from('jobs')
          .select('''
            *,
            client:client_id(id, name, email, phone),
            transporter:transporter_id(id, name, email, phone),
            tracking_records(lat, lng, timestamp)
          ''')
          .match(status != null ? {'status': status} : {})
          .order('created_at', ascending: false);

      final data = await query;
      return (data as List).map((job) => Job.fromJson(job)).toList();
    } catch (e) {
      throw Exception('Failed to fetch jobs: $e');
    }
  }

  Future<Job> getJobById(String jobId) async {
    try {
      final data = await _supabase.from('jobs').select('''
            *,
            client:client_id(id, name, email, phone),
            transporter:transporter_id(id, name, email, phone),
            tracking_records(lat, lng, timestamp)
          ''').eq('id', jobId).single();

      return Job.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch job: $e');
    }
  }

  Future<List<VehicleType>> getVehicleTypes() async {
    try {
      final data =
          await _supabase.from('vehicle_types').select().order('created_at');

      return (data as List).map((type) => VehicleType.fromJson(type)).toList();
    } catch (e) {
      throw Exception('Failed to fetch vehicle types: $e');
    }
  }

  Future<Job> createJob(Map<String, dynamic> jobData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      final data = await _supabase
          .from('jobs')
          .insert({
            ...jobData,
            'client_id': userId,
            'status': 'pending',
          })
          .select()
          .single();

      return Job.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create job: $e');
    }
  }

  Future<void> submitBid(String jobId, double amount, String note) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      await _supabase.from('bids').insert({
        'job_id': jobId,
        'transporter_id': userId,
        'amount': amount,
        'note': note,
      });
    } catch (e) {
      throw Exception('Failed to submit bid: $e');
    }
  }

  Future<void> acceptBid(String bidId, String jobId) async {
    try {
      await _supabase.rpc('accept_bid', params: {
        'p_bid_id': bidId,
        'p_job_id': jobId,
      });
    } catch (e) {
      throw Exception('Failed to accept bid: $e');
    }
  }

  Future<void> submitRating(String jobId, int rating, String comment) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      final job = await getJobById(jobId);
      final rateeId = userId == job.clientId ? job.transporterId : job.clientId;

      await _supabase.from('ratings').insert({
        'job_id': jobId,
        'rater_id': userId,
        'ratee_id': rateeId,
        'score': rating,
        'comment': comment,
      });
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }

  Future<void> acceptJob(String jobId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      await _supabase.from('jobs').update({
        'transporter_id': userId,
        'status': 'accepted',
      }).eq('id', jobId);
    } catch (e) {
      throw Exception('Failed to accept job: $e');
    }
  }

  Future<void> startJob(String jobId) async {
    try {
      await _supabase.from('jobs').update({
        'status': 'in-transit',
      }).eq('id', jobId);
    } catch (e) {
      throw Exception('Failed to start job: $e');
    }
  }

  Future<void> completeJob(String jobId) async {
    try {
      await _supabase.from('jobs').update({
        'status': 'delivered',
      }).eq('id', jobId);
    } catch (e) {
      throw Exception('Failed to complete job: $e');
    }
  }

  Stream<List<Job>> subscribeToJobUpdates() {
    return _supabase.from('jobs').stream(primaryKey: ['id']).map(
        (jobs) => jobs.map((job) => Job.fromJson(job)).toList());
  }
}
