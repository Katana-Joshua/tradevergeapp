import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:trade_verge/features/wallet/data/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionHistoryProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(
            child: Text('No transactions yet'),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionItem(context, transaction);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: ${error.toString()}'),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionModel transaction) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getTransactionColor(transaction.type).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getTransactionIcon(transaction.type),
          color: _getTransactionColor(transaction.type),
        ),
      ),
      title: Text(
        _getTransactionTitle(transaction.type),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        DateFormat('MMM d, yyyy HH:mm').format(transaction.timestamp),
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${transaction.type == 'deposit' ? '+' : '-'} UGX ${transaction.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaction.type == 'deposit' ? Colors.green : Colors.red,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(transaction.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              transaction.status.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(transaction.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'deposit':
        return Colors.green;
      case 'withdrawal':
        return Colors.red;
      case 'system_fee':
        return Colors.purple;
      case 'job_payment':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'deposit':
        return Icons.add_circle;
      case 'withdrawal':
        return Icons.remove_circle;
      case 'system_fee':
        return Icons.account_balance;
      case 'job_payment':
        return Icons.local_shipping;
      default:
        return Icons.swap_horiz;
    }
  }

  String _getTransactionTitle(String type) {
    switch (type) {
      case 'deposit':
        return 'Deposit';
      case 'withdrawal':
        return 'Withdrawal';
      case 'system_fee':
        return 'System Fee';
      case 'job_payment':
        return 'Job Payment';
      default:
        return 'Transaction';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}