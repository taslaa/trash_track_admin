import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trash_track_admin/shared/models/search_result.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

import '../models/garbage.dart';
import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';

class GarbageMapScreen extends StatefulWidget {
  @override
  _GarbageMapScreenState createState() => _GarbageMapScreenState();
}

class _GarbageMapScreenState extends State<GarbageMapScreen> {
  final MapController mapController = MapController();
  List<Marker> _garbageMarkers = [];
  Garbage? _selectedGarbage;

  final GarbageService _garbageService = GarbageService();

  @override
  void initState() {
    super.initState();
    _fetchGarbageLocations();
  }

  Future<void> _fetchGarbageLocations() async {
    try {
      final SearchResult<Garbage> result = await _garbageService.getPaged();

      final List<Marker> markers = result.items.map((garbage) {
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

      // Set the state to rebuild the widget with the markers
      setState(() {
        _garbageMarkers = markers;
      });
    } catch (error) {
      print('Error fetching garbage locations: $error');
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
            urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: _garbageMarkers,
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
                  // Add more garbage details as needed
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}