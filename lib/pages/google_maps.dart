import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late GoogleMapController _mapController;
  final LatLng _spacexHq =
      const LatLng(33.9207, -118.3280); // SpaceX Headquarters

  final Set<Marker> _markers = {
    const Marker(
      markerId: const MarkerId('spacexHq'),
      position: LatLng(33.9207, -118.3280),
      infoWindow: InfoWindow(title: 'SpaceX Headquarters'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _spacexHq,
          zoom: 15,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}