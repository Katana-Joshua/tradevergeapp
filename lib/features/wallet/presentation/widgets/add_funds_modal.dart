import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:url_launcher/url_launcher.dart';

class AddFundsModal extends ConsumerStatefulWidget {
  const AddFundsModal({super.key});

  @override
  ConsumerState<AddFundsModal> createState() => _AddFundsModalState();
}

class _AddFundsModalState extends ConsumerState<AddFundsModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleAddFunds() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final amount = double.parse(_amountController.text);
      final repository = ref.read(walletRepositoryProvider);

      final result = await repository.initiateFlutterwavePayment(amount);

      if (mounted) {
        Navigator.of(context).pop();

        // Launch Flutterwave payment page
        final paymentUrl = Uri.parse(result['paymentUrl']);
        if (await canLaunchUrl(paymentUrl)) {
          await launchUrl(paymentUrl);
        } else {
          throw Exception('Could not launch payment URL');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add Funds',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (UGX)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessing ? null : _handleAddFunds,
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : const Text('Add Funds'),
            ),
          ],
        ),
      ),
    );
  }
}