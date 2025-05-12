class TrackingRecord {
  final String id;
  final String jobId;
  final double lat;
  final double lng;
  final DateTime timestamp;

  TrackingRecord({
    required this.id,
    required this.jobId,
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  factory TrackingRecord.fromJson(Map<String, dynamic> json) {
    return TrackingRecord(
      id: json['id'],
      jobId: json['job_id'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
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
