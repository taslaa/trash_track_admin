import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';
import 'dart:math' as math;

import 'package:trash_track_admin/shared/models/search_result.dart';

class ScheduleGarbageScreen extends StatefulWidget {
  List<int> garbageIds;

  ScheduleGarbageScreen({required this.garbageIds});

  @override
  _ScheduleGarbageScreenState createState() => _ScheduleGarbageScreenState();
}

class _ScheduleGarbageScreenState extends State<ScheduleGarbageScreen> {
  final MapController mapController = MapController();
  List<Marker> _garbageMarkers = [];
  Garbage? _selectedGarbage;
  LatLng _truckPosition = LatLng(0, 0); // Initial truck position
  List<LatLng> _route = []; // Route for the truck
  double _truckSpeed = 0.0025; // Adjust truck speed

  final GarbageService _garbageService = GarbageService();

  @override
  void initState() {
    super.initState();
    _fetchGarbageLocations(widget.garbageIds);
  }

  Future<void> _fetchGarbageLocations(List<int> garbageIds) async {
    try {
      final SearchResult<Garbage> result = await _garbageService.getPaged();

      final List<Marker> markers = result.items
          .where((garbage) => garbageIds.contains(garbage.id))
          .map((garbage) {
        return Marker(
          width: 45.0,
          height: 45.0,
          point: LatLng(garbage.latitude!, garbage.longitude!),
          builder: (ctx) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedGarbage = garbage;
              });
              _showGarbageDetailModal(context);
            },
            child: Container(
              child: Icon(
                Icons.location_on,
                size: 45.0,
                color: Colors.blue,
              ),
            ),
          ),
        );
      }).toList();

      setState(() {
        _garbageMarkers = markers;
        _route = _generateRoute(markers.map((marker) => marker.point).toList(), LatLng(43.3864535036079, 17.88144966878662));
      });

      _animateTruck();
    } catch (error) {
      print('Error fetching garbage locations: $error');
    }
  }

  double haversine(LatLng point1, LatLng point2) {
    const double radius = 6371.0; // Earth's radius in kilometers

    final lat1 = point1.latitude;
    final lon1 = point1.longitude;
    final lat2 = point2.latitude;
    final lon2 = point2.longitude;

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) * math.pow(math.sin(dLon / 2), 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distance = radius * c;

    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  List<LatLng> _generateRoute(List<LatLng> markerPositions, LatLng finalDestination) {
    if (markerPositions.isEmpty) {
      return _generateSegmentRoute(_truckPosition, finalDestination);
    }
    final List<LatLng> route = [];

    // Add route to garbage locations
    for (int i = 0; i < markerPositions.length - 1; i++) {
      final start = markerPositions[i];
      final end = markerPositions[i + 1];
      route.addAll(_generateSegmentRoute(start, end));
    }

    // Add route to final destination
    final lastGarbageLocation = markerPositions.last;
    route.addAll(_generateSegmentRoute(lastGarbageLocation, finalDestination));

    return route;
  }

  List<LatLng> _generateSegmentRoute(LatLng start, LatLng end) {
    final List<LatLng> segmentRoute = [];
    final distance = haversine(start, end);
    final steps = (distance / _truckSpeed).ceil();

    for (int step = 1; step <= steps; step++) {
      final fraction = step / steps;
      final lat = start.latitude + fraction * (end.latitude - start.latitude);
      final lng = start.longitude + fraction * (end.longitude - start.longitude);
      segmentRoute.add(LatLng(lat, lng));
    }

    return segmentRoute;
  }

  void _animateTruck() {
    final int routeLength = _route.length;

    if (routeLength > 1) {
      int index = 0;

      Future<void> animate() async {
        await Future.delayed(Duration(milliseconds: 300));

        setState(() {
          _truckPosition = _route[index];
          index++;

          if (index < routeLength) {
            animate();
          }
        });
      }

      animate();
    }
  }

  void _showGarbageDetailModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GarbageDetailModal(garbage: _selectedGarbage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(43.34, 17.81),
          zoom: 10.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: _garbageMarkers,
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 45.0,
                height: 45.0,
                point: _truckPosition,
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.fire_truck,
                    size: 45.0,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GarbageDetailModal extends StatelessWidget {
  final Garbage? garbage;

  GarbageDetailModal({Key? key, this.garbage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Garbage Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (garbage != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address: ${garbage!.address}'),
                  Text('Latitude: ${garbage!.latitude}'),
                  Text('Longitude: ${garbage!.longitude}'),
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
