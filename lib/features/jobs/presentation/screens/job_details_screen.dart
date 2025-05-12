import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/jobs/domain/models/job.dart';
import 'package:trade_verge/features/jobs/presentation/providers/jobs_provider.dart';
import 'package:trade_verge/features/jobs/presentation/widgets/job_details_card.dart';
import 'package:trade_verge/features/jobs/presentation/widgets/job_map_view.dart';
import 'package:trade_verge/features/jobs/presentation/widgets/job_tracking_timeline.dart';
import 'package:trade_verge/features/jobs/presentation/widgets/job_actions_card.dart';

class JobDetailsScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailsScreen({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(jobProvider(jobId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: jobAsync.when(
        data: (job) => _buildContent(context, job, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Job job, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(jobProvider(jobId));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            JobDetailsCard(job: job),
            const SizedBox(height: 16),
            JobActionsCard(job: job),
            const SizedBox(height: 16),
            JobTrackingTimeline(job: job),
            const SizedBox(height: 16),
            JobMapView(job: job),
          ],
        ),
      ),
    );
  }
}