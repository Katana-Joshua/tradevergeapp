import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trade_verge/features/jobs/domain/models/job.dart';
import 'dart:math';

class JobMapView extends StatefulWidget {
  final Job job;

  const JobMapView({
    super.key,
    required this.job,
  });

  @override
  State<JobMapView> createState() => _JobMapViewState();
}

class _JobMapViewState extends State<JobMapView> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMapView();
  }

  void _updateMapView() {
    final pickupLatLng = LatLng(
      widget.job.pickupLoc['lat'],
      widget.job.pickupLoc['lng'],
    );

    final dropoffLatLng = LatLng(
      widget.job.dropoffLoc['lat'],
      widget.job.dropoffLoc['lng'],
    );

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLatLng,
          infoWindow: const InfoWindow(title: 'Pickup Location'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: dropoffLatLng,
          infoWindow: const InfoWindow(title: 'Dropoff Location'),
        ),
      );

      if (widget.job.trackingRecords.isNotEmpty) {
        final currentLocation = LatLng(
          widget.job.trackingRecords.last.lat,
          widget.job.trackingRecords.last.lng,
        );

        _markers.add(
          Marker(
            markerId: const MarkerId('current'),
            position: currentLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: const InfoWindow(title: 'Current Location'),
          ),
        );
      }

      // Draw route
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [pickupLatLng, dropoffLatLng],
          color: Colors.blue,
          width: 5,
        ),
      );
    });

    // Fit bounds
    final bounds = LatLngBounds(
      southwest: LatLng(
        [pickupLatLng.latitude, dropoffLatLng.latitude].reduce(min),
        [pickupLatLng.longitude, dropoffLatLng.longitude].reduce(min),
      ),
      northeast: LatLng(
        [pickupLatLng.latitude, dropoffLatLng.latitude].reduce(max),
        [pickupLatLng.longitude, dropoffLatLng.longitude].reduce(max),
      ),
    );

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.job.pickupLoc['lat'],
              widget.job.pickupLoc['lng'],
            ),
            zoom: 12,
          ),
          markers: _markers,
          polylines: _polylines,
          mapType: MapType.normal,
          myLocationEnabled: false,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
        ),
      ),
    );
  }
}
