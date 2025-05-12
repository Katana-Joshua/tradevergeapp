
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:trade_verge/features/wallet/presentation/widgets/balance_card.dart';
import 'package:trade_verge/features/wallet/presentation/widgets/transaction_list.dart';
import 'package:trade_verge/features/wallet/presentation/widgets/add_funds_modal.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(walletBalanceProvider);
          ref.refresh(transactionHistoryProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BalanceCard(),
              const SizedBox(height: 24),
              const Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const TransactionList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddFundsModal(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Funds'),
      ),
    );
  }
}
