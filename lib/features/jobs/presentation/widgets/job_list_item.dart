import 'package:flutter/material.dart';
import 'package:trade_verge/features/jobs/domain/models/job.dart';
import 'package:intl/intl.dart';

class JobListItem extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobListItem({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Job #${job.id.substring(0, 8)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _buildStatusBadge(),
                ],
              ),
              const SizedBox(height: 12),
              _buildUserInfo(
                context: context,
                title: 'Client',
                name: job.client?.name ?? 'Unknown',
                phone: job.client?.phone ?? 'N/A',
              ),
              if (job.transporter != null) ...[
                const SizedBox(height: 8),
                _buildUserInfo(
                  context: context,
                  title: 'Transporter',
                  name: job.transporter!.name,
                  phone: job.transporter!.phone,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    NumberFormat.currency(
                      symbol: 'UGX ',
                      decimalDigits: 0,
                    ).format(job.price),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, yyyy').format(job.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final colors = {
      'pending': Colors.orange,
      'accepted': Colors.blue,
      'in-transit': Colors.purple,
      'delivered': Colors.green,
      'completed': Colors.teal,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: (colors[job.status] ?? Colors.grey).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        job.status.toUpperCase(),
        style: TextStyle(
          color: colors[job.status] ?? Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildUserInfo({
    required BuildContext context,
    required String title,
    required String name,
    required String phone,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          phone,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}