import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  CameraPosition? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _setMarkers();
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
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position currentPosition = await Geolocator.getCurrentPosition();
      _currentLocation = CameraPosition(
        zoom: 14,
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
      );
    }
    setState(() {});
  }

  Future<void> _getDirections() async {
    final string = await getGeometryString(_currentLocation!.target);

    final latLngList = decodePolyline(string);

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route_path'),
          points: latLngList,
          color: Colors.black,
          width: 5,
        ),
      );
    });
  }

  Future<String> getGeometryString(LatLng routePoint) async {
    const String openRouteServiceToken =
        "5b3ce3597851110001cf624820cabfa7b863436d8e77699410fbf3ba";

    final Dio dio = Dio();

    final coordinates = [
      [routePoint.longitude, routePoint.latitude],
      [_spacexHq.longitude, _spacexHq.latitude]
    ];

    const url = 'https://api.openrouteservice.org/v2/directions/driving-car';
    final headers = {
      "Accept":
          "application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8",
      "Authorization": openRouteServiceToken,
      "Content-Type": "application/json; charset=utf-8",
    };

    try {
      final response = await dio.post(
        url,
        options: Options(headers: headers),
        data: {
          "coordinates": coordinates,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final geometry = data['routes'][0]['geometry'];

        return geometry;
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
    }
    return "";
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  void _centerOnUser() {
    if (_currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation!.target.latitude,
              _currentLocation!.target.longitude),
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
        backgroundColor: const Color(0xffAD49E1),
        title: const Text(
          'Maps',
          style: TextStyle(color: Colors.white),
        ),
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
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
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
                  onPressed: () {
                    _centerOnUser();
                  },
                  child: const Icon(Icons.my_location),
                ),
              ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Card(
                color: const Color(0xff7A1CAC),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Address: 1 Rocket Road, Hawthorne, CA 90250',
                        style: TextStyle(color: Colors.white60),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          _getDirections();
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
      ),
    );
  }
}
