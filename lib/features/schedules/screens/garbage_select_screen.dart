import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/shared/models/search_result.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';

class GarbageSelectScreen extends StatefulWidget {
  final Function(List<Garbage>) onSelectedGarbages;
  final Function(String) onUpdateRoute;

  GarbageSelectScreen({
    Key? key,
    required this.onSelectedGarbages,
    required this.onUpdateRoute,
  }) : super(key: key);

  @override
  _GarbageSelectScreenState createState() => _GarbageSelectScreenState();
}

class _GarbageSelectScreenState extends State<GarbageSelectScreen> {
  final MapController mapController = MapController();
  List<Marker> _garbageMarkers = [];
  List<Garbage> selectedGarbages = [];

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
              _handleGarbageSelection(garbage);
            },
            child: Container(
              child: Icon(
                Icons.location_on,
                size: 45.0,
                color: selectedGarbages.contains(garbage)
                    ? Colors.blue
                    : Color(0xFF49464E),
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

  void _handleGarbageSelection(Garbage garbage) {
    setState(() {
      if (selectedGarbages.contains(garbage)) {
        selectedGarbages.remove(garbage);
      } else {
        selectedGarbages.add(garbage);
      }
    });
  }

  void _saveSelectedGarbages() {
    widget.onSelectedGarbages(selectedGarbages);
    widget.onUpdateRoute('schedules/add');
    print('Selected Garbages: $selectedGarbages');
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
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelectedGarbages,
        child: Icon(Icons.save, color: Color(0xFF49464E)),
        backgroundColor: Colors.white,
      ),
    );
  }
}
