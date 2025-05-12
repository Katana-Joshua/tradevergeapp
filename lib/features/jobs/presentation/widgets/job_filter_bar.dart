import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/jobs/presentation/providers/jobs_provider.dart';

class JobFilterBar extends ConsumerWidget {
  const JobFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(jobStatusProvider);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              context: context,
              label: 'All',
              value: null,
              selectedStatus: selectedStatus,
              onSelected: (value) => ref.read(jobStatusProvider.notifier).state = value,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context: context,
              label: 'Pending',
              value: 'pending',
              selectedStatus: selectedStatus,
              onSelected: (value) => ref.read(jobStatusProvider.notifier).state = value,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context: context,
              label: 'Accepted',
              value: 'accepted',
              selectedStatus: selectedStatus,
              onSelected: (value) => ref.read(jobStatusProvider.notifier).state = value,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context: context,
              label: 'In Transit',
              value: 'in-transit',
              selectedStatus: selectedStatus,
              onSelected: (value) => ref.read(jobStatusProvider.notifier).state = value,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context: context,
              label: 'Delivered',
              value: 'delivered',
              selectedStatus: selectedStatus,
              onSelected: (value) => ref.read(jobStatusProvider.notifier).state = value,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context: context,
              label: 'Completed',
              value: 'completed',
              selectedStatus: selectedStatus,
              onSelected: (value) => ref.read(jobStatusProvider.notifier).state = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required String? value,
    required String? selectedStatus,
    required Function(String?) onSelected,
  }) {
    final isSelected = selectedStatus == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(value),
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}