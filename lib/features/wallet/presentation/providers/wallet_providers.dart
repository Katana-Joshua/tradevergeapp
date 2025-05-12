import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/wallet/data/repositories/wallet_repository.dart';
import 'package:trade_verge/features/wallet/data/models/transaction_model.dart';

final walletRepositoryProvider = Provider((ref) => WalletRepository());

final walletBalanceProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  return repository.getBalance();
});

final transactionHistoryProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  return repository.getTransactionHistory();
});

final paymentProcessingProvider = StateProvider<bool>((ref) => false);
