import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/jobs/domain/models/job.dart';
import 'package:trade_verge/features/jobs/presentation/providers/jobs_provider.dart';
import 'package:trade_verge/features/wallet/presentation/providers/wallet_providers.dart';

class JobActionsCard extends ConsumerWidget {
  final Job job;

  const JobActionsCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(jobRepositoryProvider);
    final walletRepository = ref.watch(walletRepositoryProvider);

    switch (job.status) {
      case 'pending':
        if (job.transporterId == null) {
          return ElevatedButton(
            onPressed: () async {
              try {
                await repository.acceptJob(job.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job accepted successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Accept Job'),
          );
        }
        return const Text('Waiting for payment');

      case 'accepted':
        return ElevatedButton(
          onPressed: () async {
            try {
              await repository.startJob(job.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job started successfully')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Start Job'),
        );

      case 'in-transit':
        return ElevatedButton(
          onPressed: () async {
            try {
              await repository.completeJob(job.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job completed successfully')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Complete Job'),
        );

      case 'delivered':
        return ElevatedButton(
          onPressed: () async {
            try {
              await walletRepository.releasePayment(job.id, false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment released successfully')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Release Payment'),
        );

      case 'completed':
        return const Text('Job completed');

      default:
        return const SizedBox.shrink();
    }
  }
}
