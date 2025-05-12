import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/jobs/domain/models/job.dart';
import 'package:trade_verge/features/jobs/presentation/providers/jobs_provider.dart';
import 'package:trade_verge/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:intl/intl.dart';

class CreateJobScreen extends ConsumerStatefulWidget {
  const CreateJobScreen({super.key});

  @override
  ConsumerState<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends ConsumerState<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();
  String? _selectedVehicleType;
  double _estimatedPrice = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Verify wallet balance
      final walletBalance = await ref.read(walletRepositoryProvider).getBalance();
      if (walletBalance < _estimatedPrice) {
        throw Exception('Insufficient balance');
      }

      // Create job
      final jobRepository = ref.read(jobRepositoryProvider);
      await jobRepository.createJob({
        'pickup_loc': {
          'address': _pickupController.text,
          'lat': 0.0, // Replace with actual coordinates
          'lng': 0.0,
        },
        'dropoff_loc': {
          'address': _dropoffController.text,
          'lat': 0.0, // Replace with actual coordinates
          'lng': 0.0,
        },
        'vehicle_type': _selectedVehicleType,
        'price': _estimatedPrice,
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job created successfully')),
        );
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
        setState(() => _isLoading = false);
      }
    }
  }

  void _updateEstimatedPrice() {
    if (_selectedVehicleType == null) return;

    // TODO: Calculate price based on distance and vehicle type
    setState(() {
      _estimatedPrice = 50000; // Example fixed price
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleTypesAsync = ref.watch(vehicleTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Job'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _pickupController,
                decoration: const InputDecoration(
                  labelText: 'Pickup Location',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pickup location';
                  }
                  return null;
                },
                onChanged: (_) => _updateEstimatedPrice(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dropoffController,
                decoration: const InputDecoration(
                  labelText: 'Dropoff Location',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter dropoff location';
                  }
                  return null;
                },
                onChanged: (_) => _updateEstimatedPrice(),
              ),
              const SizedBox(height: 16),
              vehicleTypesAsync.when(
                data: (vehicleTypes) => DropdownButtonFormField<String>(
                  value: _selectedVehicleType,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_shipping),
                  ),
                  items: vehicleTypes.map((type) {
                    return DropdownMenuItem(
                      value: type.id,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedVehicleType = value);
                    _updateEstimatedPrice();
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a vehicle type';
                    }
                    return null;
                  },
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price Breakdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Base Price'),
                          Text(
                            NumberFormat.currency(
                              symbol: 'UGX ',
                              decimalDigits: 0,
                            ).format(_estimatedPrice),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                              symbol: 'UGX ',
                              decimalDigits: 0,
                            ).format(_estimatedPrice),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleCreateJob,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}