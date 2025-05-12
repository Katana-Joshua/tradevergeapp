import 'package:flutter/foundation.dart';

@immutable
class EscrowModel {
  final String id;
  final String jobId;
  final double amount;
  final String status;
  final DateTime createdAt;

  const EscrowModel({
    required this.id,
    required this.jobId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory EscrowModel.fromJson(Map<String, dynamic> json) {
    return EscrowModel(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}