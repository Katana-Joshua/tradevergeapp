class VehicleType {
  final String id;
  final String name;
  final double capacity;
  final double baseRate;
  final double perKmRate;
  final DateTime createdAt;

  VehicleType({
    required this.id,
    required this.name,
    required this.capacity,
    required this.baseRate,
    required this.perKmRate,
    required this.createdAt,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['id'],
      name: json['name'],
      capacity: (json['capacity'] as num).toDouble(),
      baseRate: (json['base_rate'] as num).toDouble(),
      perKmRate: (json['per_km_rate'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'base_rate': baseRate,
      'per_km_rate': perKmRate,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
