import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/vehicle/services/vehicles_service.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';

class VehicleAddScreen extends StatefulWidget {
  final Function(String) onUpdateRoute;

  VehicleAddScreen({required this.onUpdateRoute});

  @override
  _VehicleAddScreenState createState() => _VehicleAddScreenState();
}

class _VehicleAddScreenState extends State<VehicleAddScreen> {
  late TextEditingController _colorController;
  late TextEditingController _notesController;
  late TextEditingController _licensePlateController;
  late TextEditingController _manufactureYearController;
  late TextEditingController _capacityController;
  late VehiclesService _vehicleService;
  List<VehicleModel> _vehicleModels = [];
  late int _selectedVehicleModelId = 0;
  late VehicleModelsService _vehicleModelsService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _vehicleService = VehiclesService();
    _vehicleModelsService = VehicleModelsService();
    _colorController = TextEditingController();
    _notesController = TextEditingController();
    _licensePlateController = TextEditingController();
    _manufactureYearController = TextEditingController();
    _capacityController = TextEditingController();

    _selectedVehicleModelId = 0;

    _loadVehicleModels();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _notesController.dispose();
    _licensePlateController.dispose();
    _manufactureYearController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _loadVehicleModels() async {
    try {
      final vehicleModels = await _vehicleModelsService.getPaged();
      setState(() {
        _vehicleModels = [VehicleModel(id: 0, name: 'Choose a Vehicle Model')] + vehicleModels.items;
        _isLoading = false; // Mark loading as complete
      });
    } catch (error) {
      print('Error loading vehicle models: $error');
      setState(() {
        _isLoading = false; // Mark loading as complete even on error
      });
    }
  }

  Widget _buildYearDropdown() {
    List<DropdownMenuItem<String>> yearItems = [];
    yearItems.add(DropdownMenuItem<String>(
      value: '',
      child: Text('Choose the manufacture year'),
    ));
    for (int year = DateTime.now().year; year >= 1980; year--) {
      yearItems.add(DropdownMenuItem<String>(
        value: year.toString(),
        child: Text(year.toString()),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manufacture Year',
          style: TextStyle(
            color: const Color(0xFF49464E),
          ),
        ),
        SizedBox(height: 8),
        Container(
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
            child: DropdownButtonFormField<String>(
              value: _manufactureYearController.text,
              onChanged: (year) {
                setState(() {
                  _manufactureYearController.text = year ?? '';
                });
              },
              items: yearItems,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator while fetching data
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Similar structure to GarbageScreen UI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Vehicle',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1C1E),
                            ),
                          ),
                          Text(
                            'Enter vehicle details',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1D1C1E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Input fields
                  TextFormField(
                    controller: _colorController,
                    decoration: InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: Color(0xFF49464E),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: Color(0xFF49464E),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _licensePlateController,
                    decoration: InputDecoration(
                      labelText: 'License Plate',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: Color(0xFF49464E),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Year dropdown
                  _buildYearDropdown(),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _capacityController,
                    decoration: InputDecoration(
                      labelText: 'Capacity',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: Color(0xFF49464E),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Dropdown for vehicle models
                  DropdownButton<int>(
                    value: _selectedVehicleModelId,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedVehicleModelId = newValue ?? 0;
                      });
                    },
                    items: _vehicleModels.map((model) {
                      return DropdownMenuItem<int>(
                        value: model.id,
                        child: Text(model.name ?? ''),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final newVehicle = Vehicle(
                        color: _colorController.text,
                        notes: _notesController.text,
                        licensePlateNumber: _licensePlateController.text,
                        manufactureYear: int.tryParse(_manufactureYearController.text),
                        capacity: int.tryParse(_capacityController.text),
                        vehicleModelId: _selectedVehicleModelId,
                      );

                      try {
                        await _vehicleService.insert(newVehicle);
                        widget.onUpdateRoute('vehicles');
                      } catch (error) {
                        print('Error adding vehicle: $error');
                      }
                    },
                    child: Text(
                      'Add Vehicle',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF49464E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(400, 48),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
