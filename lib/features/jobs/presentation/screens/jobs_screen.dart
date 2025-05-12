import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_verge/features/jobs/presentation/providers/jobs_provider.dart';
import 'package:trade_verge/features/jobs/presentation/widgets/job_filter_bar.dart';
import 'package:trade_verge/features/jobs/presentation/widgets/job_list_item.dart';

class JobsScreen extends ConsumerWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsProvider);
    final selectedStatus = ref.watch(jobStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(jobsProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          const JobFilterBar(),
          Expanded(
            child: jobsAsync.when(
              data: (jobs) {
                final filteredJobs = selectedStatus != null
                    ? jobs.where((job) => job.status == selectedStatus).toList()
                    : jobs;

                if (filteredJobs.isEmpty) {
                  return const Center(
                    child: Text('No jobs found'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => ref.refresh(jobsProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return JobListItem(
                        job: job,
                        onTap: () => context.push('/jobs/${job.id}'),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/jobs/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}