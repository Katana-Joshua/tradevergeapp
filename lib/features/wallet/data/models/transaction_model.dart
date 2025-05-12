
import 'package:flutter/foundation.dart';

@immutable
class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String type; // 'deposit', 'withdrawal', 'system_fee', 'job_payment'
  final String status;
  final String? jobId;
  final String? reference;
  final DateTime timestamp;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    this.jobId,
    this.reference,
    required this.timestamp,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      status: json['status'] as String,
      jobId: json['job_id'] as String?,
      reference: json['reference'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'type': type,
      'status': status,
      'job_id': jobId,
      'reference': reference,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
