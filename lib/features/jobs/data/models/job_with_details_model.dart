import 'package:flutter/foundation.dart';
import 'package:trade_verge/features/jobs/data/models/escrow_model.dart';
import 'package:trade_verge/features/jobs/data/models/job_model.dart';
import 'package:trade_verge/features/jobs/data/models/tracking_record_model.dart';
import 'package:trade_verge/features/users/data/models/user_model.dart';

@immutable
class JobWithDetailsModel extends JobModel {
  final UserModel? client;
  final UserModel? transporter;
  final EscrowModel? escrow;
  final List<TrackingRecordModel> trackingRecords;

  const JobWithDetailsModel({
    required super.id,
    required super.clientId,
    super.transporterId,
    required super.pickupLoc,
    required super.dropoffLoc,
    required super.price,
    required super.status,
    super.escrowId,
    required super.createdAt,
    this.client,
    this.transporter,
    this.escrow,
    this.trackingRecords = const [],
  });

  factory JobWithDetailsModel.fromJson(Map<String, dynamic> json) {
    return JobWithDetailsModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      transporterId: json['transporter_id'] as String?,
      pickupLoc: json['pickup_loc'] as Map<String, dynamic>,
      dropoffLoc: json['dropoff_loc'] as Map<String, dynamic>,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      escrowId: json['escrow_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      client: json['client'] != null ? UserModel.fromJson(json['client'] as Map<String, dynamic>) : null,
      transporter: json['transporter'] != null ? UserModel.fromJson(json['transporter'] as Map<String, dynamic>) : null,
      escrow: json['escrow'] != null ? EscrowModel.fromJson(json['escrow'] as Map<String, dynamic>) : null,
      trackingRecords: (json['tracking_records'] as List<dynamic>?)
          ?.map((record) => TrackingRecordModel.fromJson(record as Map<String, dynamic>))
          .toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'client': client?.toJson(),
      'transporter': transporter?.toJson(),
      'escrow': escrow?.toJson(),
      'tracking_records': trackingRecords.map((record) => record.toJson()).toList(),
    };
  }
}