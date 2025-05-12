import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/jobs/data/repositories/job_repository.dart';
import 'package:trade_verge/features/jobs/domain/models/job.dart';
import 'package:trade_verge/features/jobs/domain/models/vehicle_type.dart';

final jobRepositoryProvider = Provider((ref) => JobRepository());

final jobsProvider = FutureProvider.autoDispose<List<Job>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.getJobs();
});

final jobProvider = FutureProvider.autoDispose.family<Job, String>((ref, jobId) async {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.getJobById(jobId);
});

final vehicleTypesProvider = FutureProvider<List<VehicleType>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.getVehicleTypes();
});

final jobStreamProvider = StreamProvider.autoDispose<List<Job>>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.subscribeToJobUpdates();
});

final jobStatusProvider = StateProvider<String?>((ref) => null);
