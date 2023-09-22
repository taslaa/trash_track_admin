import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  final Function(String) onUpdateRoute;
  final Function(LatLng) onLocationSelected;
  final Function(String) onAddressSelected;

  MapScreen({
    Key? key,
    Garbage? garbageLocation,
    required this.isSelecting,
    required this.onUpdateRoute,
    required this.onLocationSelected,
    required this.onAddressSelected,
  }) : garbageLocation = garbageLocation ??
            Garbage(
              latitude: 43.343033,
              longitude: 17.807894,
            );

  final Garbage garbageLocation;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  MapController mapController = MapController();

  Future<String?> convertCoordinatesToAddress(
      double latitude, double longitude) async {
    final apiKey =
        'pk.eyJ1Ijoic2FsZW1oYW16YSIsImEiOiJjbG1ueDV2ZmwxMTF2MmtsOGsxaHF4Z3NnIn0.fWZbM5YRJe18jxymfT8bWQ';
    final endpoint = 'mapbox.places';

    final url = Uri.https(
        'api.mapbox.com', '/geocoding/v5/$endpoint/$longitude,$latitude.json', {
      'access_token': apiKey,
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['features'] != null &&
            jsonResponse['features'].isNotEmpty) {
          final firstFeature = jsonResponse['features'][0];
          final address = firstFeature['place_name'];

          final parts = address.split(',');
          final extractedAddress = parts[0].trim();

          return extractedAddress;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error converting coordinates to address: $e');
    }

    return null;
  }

  void _handleTap(LatLng tappedPoint) async {
    if (widget.isSelecting) {
      try {
        final address = await convertCoordinatesToAddress(
            tappedPoint.latitude, tappedPoint.longitude);
        setState(() {
          _pickedLocation = tappedPoint;
          print('Selected Location in MapScreen: $_pickedLocation');
          print('Selected address in MapScreen: $address');
          _onLocationSelected(_pickedLocation!);
          _onAddressSelected(address!);
        });
      } catch (e) {
        print('Error getting address: $e');
      }
    }
  }

  void _onLocationSelected(LatLng garbageLocation) async {
    widget.onLocationSelected(garbageLocation);
  }

  void _onAddressSelected(String address) async {
    widget.onAddressSelected(address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(
            widget.garbageLocation.latitude ?? 0.0,
            widget.garbageLocation.longitude ?? 0.0,
          ),
          zoom: 16,
          onTap: (tapPosition, latlng) {
            _handleTap(latlng);
          },
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1Ijoic2FsZW1oYW16YSIsImEiOiJjbG1ueDV2ZmwxMTF2MmtsOGsxaHF4Z3NnIn0.fWZbM5YRJe18jxymfT8bWQ',
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1Ijoic2FsZW1oYW16YSIsImEiOiJjbG1ueDV2ZmwxMTF2MmtsOGsxaHF4Z3NnIn0.fWZbM5YRJe18jxymfT8bWQ',
              'id': 'mapbox/streets-v11',
            },
          ),
          MarkerLayerOptions(
            markers: (_pickedLocation == null && widget.isSelecting)
                ? []
                : [
                    Marker(
                      width: 45.0,
                      height: 45.0,
                      point: _pickedLocation ??
                          LatLng(
                            widget.garbageLocation.latitude ?? 0.0,
                            widget.garbageLocation.longitude ?? 0.0,
                          ),
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_on,
                          size: 45.0,
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ],
          ),
        ],
      ),
      floatingActionButton: widget.isSelecting
          ? FloatingActionButton(
              onPressed: () {
                if (_pickedLocation != null) {
                  widget.onUpdateRoute('garbage/add');
                }
              },
              child: Icon(Icons.save, color: Color(0xFF49464E)),
              backgroundColor: Colors.white,
            )
          : null,
    );
  }
}
