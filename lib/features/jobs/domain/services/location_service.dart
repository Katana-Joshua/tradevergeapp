import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trade_verge/core/constants/api_constants.dart';

class LocationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> geocodeAddress(String address) async {
    try {
      final response = await _supabase.functions.invoke(
        'geocode',
        body: {'address': address},
      );

      if (response.status != 200) {
        throw Exception('Failed to geocode address');
      }

      return {
        'lat': response.data['lat'],
        'lng': response.data['lng'],
        'address': response.data['address'],
      };
    } catch (e) {
      throw Exception('Failed to geocode address: $e');
    }
  }

  Future<void> updateLocation({
    required String jobId,
    required double lat,
    required double lng,
  }) async {
    try {
      await _supabase.functions.invoke(
        'location-update',
        body: {
          'jobId': jobId,
          'lat': lat,
          'lng': lng,
        },
      );
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> subscribeToLocationUpdates(String jobId) {
    return _supabase
        .from('tracking_records')
        .stream(primaryKey: ['id'])
        .eq('job_id', jobId)
        .order('timestamp', ascending: true)
        .map((records) => records);
  }

  Future<List<Map<String, dynamic>>> getRouteDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'directions',
        body: {
          'origin': [origin.longitude, origin.latitude],
          'destination': [destination.longitude, destination.latitude],
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to get directions');
      }

      return response.data['routes'] as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Failed to get directions: $e');
    }
  }
}
