import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/vehicle/services/vehicles_service.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';

class VehicleEditScreen extends StatefulWidget {
  final Vehicle vehicle;

  VehicleEditScreen({required this.vehicle});

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
  late List<VehicleModel> _vehicleModels;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
                    controller: _manufactureYearController,
                    decoration: const InputDecoration(
                      labelText: 'Manufacture Year',
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
                    decoration: const InputDecoration(
                      labelText: 'Capacity',
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
                // Get values from controllers and create a new Vehicle object
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

                // Update the vehicle using your service
                try {
                  await _vehicleService.update(editedVehicle);
                  Navigator.pop(context, 'reload');
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
                minimumSize: Size(400, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
