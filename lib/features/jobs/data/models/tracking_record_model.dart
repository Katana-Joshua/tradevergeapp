import 'package:flutter/foundation.dart';

@immutable
class TrackingRecordModel {
  final String id;
  final String jobId;
  final double lat;
  final double lng;
  final DateTime timestamp;

  const TrackingRecordModel({
    required this.id,
    required this.jobId,
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  factory TrackingRecordModel.fromJson(Map<String, dynamic> json) {
    return TrackingRecordModel(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'lat': lat,
      'lng': lng,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}