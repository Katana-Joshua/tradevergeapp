import 'package:trade_verge/features/jobs/domain/models/tracking_record.dart';
import 'package:trade_verge/features/users/domain/models/user.dart';

class Job {
  final String id;
  final String? clientId;
  final String? transporterId;
  final Map<String, dynamic> pickupLoc;
  final Map<String, dynamic> dropoffLoc;
  final double price;
  final String status;
  final String? escrowId;
  final DateTime createdAt;
  final User? client;
  final User? transporter;
  final List<TrackingRecord> trackingRecords;

  Job({
    required this.id,
    this.clientId,
    this.transporterId,
    required this.pickupLoc,
    required this.dropoffLoc,
    required this.price,
    required this.status,
    this.escrowId,
    required this.createdAt,
    this.client,
    this.transporter,
    this.trackingRecords = const [],
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      clientId: json['client_id'],
      transporterId: json['transporter_id'],
      pickupLoc: json['pickup_loc'],
      dropoffLoc: json['dropoff_loc'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
      escrowId: json['escrow_id'],
      createdAt: DateTime.parse(json['created_at']),
      client: json['client'] != null ? User.fromJson(json['client']) : null,
      transporter: json['transporter'] != null ? User.fromJson(json['transporter']) : null,
      trackingRecords: (json['tracking_records'] as List?)
          ?.map((record) => TrackingRecord.fromJson(record))
          .toList() ?? [],
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
      'client': client?.toJson(),
      'transporter': transporter?.toJson(),
      'tracking_records': trackingRecords.map((record) => record.toJson()).toList(),
    };
  }

  Job copyWith({
    String? id,
    String? clientId,
    String? transporterId,
    Map<String, dynamic>? pickupLoc,
    Map<String, dynamic>? dropoffLoc,
    double? price,
    String? status,
    String? escrowId,
    DateTime? createdAt,
    User? client,
    User? transporter,
    List<TrackingRecord>? trackingRecords,
  }) {
    return Job(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      transporterId: transporterId ?? this.transporterId,
      pickupLoc: pickupLoc ?? this.pickupLoc,
      dropoffLoc: dropoffLoc ?? this.dropoffLoc,
      price: price ?? this.price,
      status: status ?? this.status,
      escrowId: escrowId ?? this.escrowId,
      createdAt: createdAt ?? this.createdAt,
      client: client ?? this.client,
      transporter: transporter ?? this.transporter,
      trackingRecords: trackingRecords ?? this.trackingRecords,
    );
  }
}
