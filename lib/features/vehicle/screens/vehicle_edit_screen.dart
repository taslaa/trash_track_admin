import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/vehicle/services/vehicles_service.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';

class VehicleEditScreen extends StatefulWidget {
  final Vehicle vehicle;
  final Function(String) onUpdateRoute;

  VehicleEditScreen({required this.vehicle, required this.onUpdateRoute});

  @override
  _VehicleEditScreenState createState() => _VehicleEditScreenState();
}

class _VehicleEditScreenState extends State<VehicleEditScreen> {
  late TextEditingController _colorController;
  late TextEditingController _notesController;
  late TextEditingController _licensePlateController;
  late TextEditingController _manufactureYearController;
  late TextEditingController _capacityController;
  late VehiclesService _vehicleService;
  List<VehicleModel> _vehicleModels = [];
  late int _selectedVehicleModelId;
  late VehicleModelsService _vehicleModelsService;

  @override
  void initState() {
    super.initState();
    _vehicleService = VehiclesService();
    _vehicleModelsService = VehicleModelsService();
    _colorController = TextEditingController(text: widget.vehicle.color ?? '');
    _notesController = TextEditingController(text: widget.vehicle.notes ?? '');
    _licensePlateController =
        TextEditingController(text: widget.vehicle.licensePlateNumber ?? '');
    _manufactureYearController = TextEditingController(
        text: widget.vehicle.manufactureYear?.toString() ?? '');
    _capacityController =
        TextEditingController(text: widget.vehicle.capacity?.toString() ?? '');

    _selectedVehicleModelId = widget.vehicle.vehicleModelId ?? 0;

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
        _vehicleModels = vehicleModels.items;
      });
    } catch (error) {
      print('Error loading vehicle models: $error');
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
        DropdownButtonFormField<String>(
          value: _manufactureYearController.text,
          onChanged: (year) {
            setState(() {
              _manufactureYearController.text = year ?? '';
            });
          },
          items: yearItems,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: const Color(0xFF49464E),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _goBack() {
    widget.onUpdateRoute('vehicles');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _goBack();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 32.0, // Adjust the size as needed
                      ),
                    ),
                    Text(
                      'Edit Vehicle',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 32.0), // Adjust the space between back icon and title
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 200, // Adjust the width as needed
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
                            decoration: const InputDecoration(
                              labelText: 'Color',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              color: Color(0xFF49464E),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 200, // Adjust the width as needed
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
                            decoration: const InputDecoration(
                              labelText: 'Notes',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              color: Color(0xFF49464E),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 200, // Adjust the width as needed
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
                            decoration: const InputDecoration(
                              labelText: 'License Plate',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              color: Color(0xFF49464E),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 200, // Adjust the width as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF49464E),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: _buildYearDropdown(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 200, // Adjust the width as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF49464E),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButton<int>(
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final editedVehicle = Vehicle(
                          id: widget.vehicle.id,
                          color: _colorController.text,
                          notes: _notesController.text,
                          licensePlateNumber: _licensePlateController.text,
                          manufactureYear:
                              int.tryParse(_manufactureYearController.text),
                          capacity: int.tryParse(_capacityController.text),
                          vehicleModelId: _selectedVehicleModelId,
                        );
                        try {
                          await _vehicleService.update(editedVehicle);

                          widget.onUpdateRoute('vehicles');
                        } catch (error) {
                          print('Error saving vehicle: $error');
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF49464E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(200, 48), // Adjust the width as needed
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
