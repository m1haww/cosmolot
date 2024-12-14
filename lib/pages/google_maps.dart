import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late GoogleMapController _mapController;
  final LatLng _spacexHq = const LatLng(33.9207, -118.3280);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LocationData? _currentLocation;
  String googleMapsApiKey =
      'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key

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
      _getDirections(LatLng(userLocation.latitude!, userLocation.longitude!));
    });
  }

  Future<void> _getDirections(LatLng origin) async {
    final directionsUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${_spacexHq.latitude},${_spacexHq.longitude}&key=$googleMapsApiKey';

    final response = await http.get(Uri.parse(directionsUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final route = data['routes'][0]['legs'][0]['steps'] as List;
        final List<LatLng> polylineCoordinates = [];

        for (var step in route) {
          final polylinePoints = step['polyline']['points'];
          polylineCoordinates.addAll(_decodePolyline(polylinePoints));
        }

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    } else {
      print('Failed to get directions');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dLng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylineCoordinates;
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
        centerTitle: true,
        backgroundColor: Color(0xffAD49E1),
        title: const Text('Maps'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _spacexHq,
                zoom: 15,
              ),
              markers: _markers,
              polylines: _polylines,
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
            Positioned(
              bottom: 115,
              left: 0,
              right: 0,
              child: Card(
                color: Color(0xff7A1CAC),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'SpaceX Headquarters',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('Address: 1 Rocket Road, Hawthorne, CA 90250'),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
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
      ),
    );
  }
}
