import 'package:flutter/foundation.dart';

@immutable
class JobModel {
  final String id;
  final String? clientId;
  final String? transporterId;
  final Map<String, dynamic> pickupLoc;
  final Map<String, dynamic> dropoffLoc;
  final double price;
  final String status;
  final String? escrowId;
  final DateTime createdAt;

  const JobModel({
    required this.id,
    this.clientId,
    this.transporterId,
    required this.pickupLoc,
    required this.dropoffLoc,
    required this.price,
    required this.status,
    this.escrowId,
    required this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String?,
      transporterId: json['transporter_id'] as String?,
      pickupLoc: json['pickup_loc'] as Map<String, dynamic>,
      dropoffLoc: json['dropoff_loc'] as Map<String, dynamic>,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      escrowId: json['escrow_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'transporter_id': transporterId,
      'pickup_loc': pickupLoc,
      'dropoff_loc': dropoffLoc,
      'price': price,
      'status': status,
      'escrow_id': escrowId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  JobModel copyWith({
    String? id,
    String? clientId,
    String? transporterId,
    Map<String, dynamic>? pickupLoc,
    Map<String, dynamic>? dropoffLoc,
    double? price,
    String? status,
    String? escrowId,
    DateTime? createdAt,
  }) {
    return JobModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      transporterId: transporterId ?? this.transporterId,
      pickupLoc: pickupLoc ?? this.pickupLoc,
      dropoffLoc: dropoffLoc ?? this.dropoffLoc,
      price: price ?? this.price,
      status: status ?? this.status,
      escrowId: escrowId ?? this.escrowId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
