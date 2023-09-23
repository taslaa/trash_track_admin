import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/features/garbage/screens/map_screen.dart';
import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';
import 'package:trash_track_admin/shared/services/enums_service.dart';
import 'package:latlong2/latlong.dart';

class GarbageAddScreen extends StatefulWidget {
  final Function(String) onUpdateRoute;
  final LatLng garbageLocation;
  final String address;
  final VoidCallback resetAddress;

  const GarbageAddScreen({
    required this.onUpdateRoute,
    required this.garbageLocation,
    required this.address,
    required this.resetAddress,
  });

  @override
  State<GarbageAddScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends State<GarbageAddScreen> {
  late EnumsService _enumsService;
  late String _addressController;
  late int _selectedGarbageTypeIndex;
  late Map<int, String> _garbageTypes;
  bool _isLoading = true;
  final garbageService = GarbageService();
  Garbage? _garbageLocation;

  @override
  void initState() {
    super.initState();
    _enumsService = EnumsService();
    _addressController = widget.address;
    _selectedGarbageTypeIndex = 0;
    _garbageLocation = Garbage(
      latitude: widget.garbageLocation.latitude,
      longitude: widget.garbageLocation.longitude,
    );
    _fetchGarbageTypes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchGarbageTypes() async {
    try {
      final typesData = await _enumsService.getGarbageTypes();

      if (typesData is Map<int, String>) {
        setState(() {
          _garbageTypes = typesData;
          _isLoading = false;
        });
      } else {
        print('Received unexpected data format for garbage types: $typesData');
      }
    } catch (error) {
      print('Error fetching garbage types: $error');
    }
  }

  void _goBack() {
    widget.onUpdateRoute('garbage'); 
    widget.resetAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _goBack,
                ),
              ],
            ),
            const SizedBox(height: 100),
            Text(
              'Add Garbage',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFF49464E),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: TextEditingController(text: _addressController),
                      decoration: InputDecoration(
                        labelText: 'Address (Automatically Filled)',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: const Color(0xFF49464E),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: 400,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF49464E),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonFormField<int>(
                            value: _selectedGarbageTypeIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedGarbageTypeIndex = newValue ?? 0;
                              });
                            },
                            items: _garbageTypes.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Garbage Type',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: const Color(0xFF49464E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () {
                  widget.onUpdateRoute('map');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 8),
                    const Text('Select Location'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF49464E),
                  minimumSize: Size(400, 48),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () async {
                  if (_garbageLocation == null) {
                    print('Location not selected');
                    return;
                  }

                  final selectedGarbageType =
                      GarbageType.values[_selectedGarbageTypeIndex];

                  final newName = _addressController;

                  final newGarbage = Garbage(
                    address: newName,
                    garbageType: selectedGarbageType,
                    latitude: _garbageLocation!.latitude,
                    longitude: _garbageLocation!.longitude,
                  );

                  try {
                    await garbageService.insert(newGarbage);

                    widget.resetAddress(); // Reset the address

                    widget.onUpdateRoute('garbage');
                  } catch (error) {
                    print('Error adding garbage: $error');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    const Text('Add Garbage'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF49464E),
                  minimumSize: Size(400, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
