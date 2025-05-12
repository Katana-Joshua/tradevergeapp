import 'package:trade_verge/features/jobs/domain/models/vehicle_type.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:math';

class PriceCalculator {
  static const double BASE_MULTIPLIER = 1.0;
  static const double SYSTEM_FEE_PERCENTAGE = 0.035; // 3.5%

  static Future<double> calculatePrice({
    required VehicleType vehicleType,
    required LatLng pickup,
    required LatLng dropoff,
  }) async {
    // Calculate distance in kilometers
    final distance = await calculateDistance(pickup, dropoff);

    // Calculate base price
    final basePrice = vehicleType.baseRate;

    // Calculate distance price
    final distancePrice = distance * vehicleType.perKmRate;

    // Calculate total before fees
    final subtotal = (basePrice + distancePrice) * BASE_MULTIPLIER;

    // Add system fee
    final systemFee = subtotal * SYSTEM_FEE_PERCENTAGE;

    // Return total rounded to nearest 100
    return ((subtotal + systemFee) / 100).ceil() * 100;
  }

  static Future<double> calculateDistance(LatLng start, LatLng end) async {
    // TODO: Implement actual distance calculation using Mapbox Directions API
    // For now, return straight-line distance
    const double R = 6371; // Earth's radius in km

    final dLat = _toRad(end.latitude - start.latitude);
    final dLon = _toRad(end.longitude - start.longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(start.latitude)) *
            cos(_toRad(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static double _toRad(double deg) => deg * pi / 180;
}
