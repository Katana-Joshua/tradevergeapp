import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trade_verge/features/wallet/data/models/transaction_model.dart';

class WalletRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const double SYSTEM_FEE_PERCENTAGE = 0.035; // 3.5%

  Future<double> getBalance() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      final data = await _supabase
          .from('wallets')
          .select('balance')
          .eq('user_id', userId)
          .single();

      return (data['balance'] as num).toDouble();
    } catch (e) {
      throw Exception('Failed to fetch wallet balance: $e');
    }
  }

  Future<Map<String, dynamic>> initiateFlutterwavePayment(double amount) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      // Create pending transaction
      final transaction = await _supabase
          .from('transactions')
          .insert({
        'user_id': userId,
        'amount': amount,
        'type': 'deposit',
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      })
          .select()
          .single();

      // Call Flutterwave API through Edge Function
      final response = await _supabase.functions.invoke(
        'flutterwave-payment',
        body: {
          'amount': amount,
          'transactionId': transaction['id'],
          'userId': userId,
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to initiate payment');
      }

      // Return payment link and reference for frontend processing
      return {
        'paymentUrl': response.data['paymentUrl'],
        'reference': response.data['reference'],
      };
    } catch (e) {
      throw Exception('Failed to initiate payment: $e');
    }
  }

  Future<void> verifyFlutterwavePayment(String reference) async {
    try {
      final response = await _supabase.functions.invoke(
        'flutterwave-verify',
        body: {
          'reference': reference,
        },
      );

      if (response.status != 200) {
        throw Exception('Payment verification failed');
      }

      if (response.data['status'] == 'successful') {
        // Update transaction status
        await _supabase
            .from('transactions')
            .update({
          'status': 'completed',
          'reference': reference,
        })
            .eq('reference', reference);
      }
    } catch (e) {
      throw Exception('Failed to verify payment: $e');
    }
  }

  Future<void> verifyJobPayment(String jobId, double amount) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      // Get user's current balance
      final walletData = await _supabase
          .from('wallets')
          .select('balance')
          .eq('user_id', userId)
          .single();

      final currentBalance = (walletData['balance'] as num).toDouble();
      final totalAmount = amount * (1 + SYSTEM_FEE_PERCENTAGE);

      if (currentBalance < totalAmount) {
        throw Exception('Insufficient balance');
      }

      // Start transaction
      await _supabase.rpc('verify_job_payment', params: {
        'p_job_id': jobId,
        'p_amount': amount,
        'p_user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to verify job payment: $e');
    }
  }

  Future<void> processTransporterOffer(String jobId, double newAmount) async {
    try {
      final totalAmount = newAmount * (1 + SYSTEM_FEE_PERCENTAGE);

      await _supabase.rpc('process_transporter_offer', params: {
        'p_job_id': jobId,
        'p_new_amount': totalAmount,
      });
    } catch (e) {
      throw Exception('Failed to process offer: $e');
    }
  }

  Future<void> releasePayment(String jobId, bool isPartial) async {
    try {
      await _supabase.rpc('release_job_payment', params: {
        'p_job_id': jobId,
        'p_is_partial': isPartial,
      });
    } catch (e) {
      throw Exception('Failed to release payment: $e');
    }
  }

  Future<List<TransactionModel>> getTransactionHistory() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      final data = await _supabase
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false);

      return (data as List).map((t) => TransactionModel.fromJson(t)).toList();
    } catch (e) {
      throw Exception('Failed to fetch transaction history: $e');
    }
  }
}