import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late GoogleMapController _mapController;
  final LatLng _spacexHq = const LatLng(33.9207, -118.3280);
  final Set<Marker> _markers = {};
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getUserLocation();
  }

  void _setMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('spacexHq'),
        position: _spacexHq,
        infoWindow: const InfoWindow(title: 'SpaceX Headquarters'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  Future<void> _getUserLocation() async {
    Location location = Location();

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) return;
    }

    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) return;
    }

    final userLocation = await location.getLocation();
    setState(() {
      _currentLocation = userLocation;
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(userLocation.latitude!, userLocation.longitude!),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }

  void _centerOnUser() {
    if (_currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          15,
        ),
      );
    }
  }

  void _centerOnDestination() {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_spacexHq, 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _spacexHq,
              zoom: 15,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _centerOnDestination,
              child: const Icon(Icons.location_on),
            ),
          ),
          if (_currentLocation != null)
            Positioned(
              top: 80,
              right: 10,
              child: FloatingActionButton(
                onPressed: _centerOnUser,
                child: const Icon(Icons.my_location),
              ),
            ),
          Card(
            color: Colors.white,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SpaceX Headquarters',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Address: 1 Rocket Road, Hawthorne, CA 90250'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Open directions logic here
                      },
                      icon: const Icon(Icons.directions),
                      label: const Text('Get Directions'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
