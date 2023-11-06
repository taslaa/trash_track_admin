import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/vehicle/services/vehicles_service.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';
import 'package:latlong2/latlong.dart';

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
        _vehicleModels = [VehicleModel(id: 0, name: 'Choose a Vehicle Model')] +
            vehicleModels.items;
        _isLoading = false; // Mark loading as complete
      });
    } catch (error) {
      print('Error loading vehicle models: $error');
      setState(() {
        _isLoading = false; // Mark loading as complete even on error
      });
    }
  }

  void _goBack() {
    widget.onUpdateRoute('vehicles');
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
            const SizedBox(height: 10),
            Text(
              'Add Vehicle',
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
                      controller: _colorController,
                      decoration: InputDecoration(
                        labelText: 'Color',
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
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
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
                      controller: _licensePlateController,
                      decoration: InputDecoration(
                        labelText: 'License Plate',
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
                    child: DropdownButtonFormField<String>(
                      value: _manufactureYearController.text,
                      onChanged: (year) {
                        setState(() {
                          _manufactureYearController.text = year ?? '';
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: '',
                          child: Text('Choose the manufacture year'),
                        ),
                        for (int year = DateTime.now().year;
                            year >= 1980;
                            year--)
                          DropdownMenuItem<String>(
                            value: year.toString(),
                            child: Text(year.toString()),
                          ),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                      controller: _capacityController,
                      decoration: InputDecoration(
                        labelText: 'Capacity',
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
                    child: DropdownButtonFormField<int>(
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
                      decoration: InputDecoration(
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
                onPressed: () async {
                  final newVehicle = Vehicle(
                    color: _colorController.text,
                    notes: _notesController.text,
                    licensePlateNumber: _licensePlateController.text,
                    manufactureYear:
                        int.tryParse(_manufactureYearController.text),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    const Text('Add Vehicle'),
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
