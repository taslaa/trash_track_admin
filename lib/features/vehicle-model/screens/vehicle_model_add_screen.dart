import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/shared/services/enums_service.dart';

class VehicleModelAddScreen extends StatefulWidget {
  @override
  _VehicleModelAddScreenState createState() => _VehicleModelAddScreenState();
}

class _VehicleModelAddScreenState extends State<VehicleModelAddScreen> {
  late EnumsService _enumsService;
  late TextEditingController _nameController;
  late int _selectedVehicleTypeIndex;
  late Map<int, String> _vehicleTypes;
  bool _isLoading = true;
  final vehicleModelService = VehicleModelsService();

  @override
  void initState() {
    super.initState();
    _enumsService = EnumsService();
    _nameController = TextEditingController();
    _selectedVehicleTypeIndex = 0; // Set the default vehicle type
    _fetchVehicleTypes();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _fetchVehicleTypes() async {
    try {
      final typesData = await _enumsService.getVehicleTypes();

      if (typesData is Map<int, String>) {
        setState(() {
          _vehicleTypes = typesData;
          _isLoading = false;
        });
      } else {
        print('Received unexpected data format for vehicle types: $typesData');
      }
    } catch (error) {
      print('Error fetching vehicle types: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
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
              _isLoading
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFF49464E),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonFormField<int>(
                            value: _selectedVehicleTypeIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedVehicleTypeIndex = newValue ?? 0;
                              });
                            },
                            items: _vehicleTypes.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Vehicle Type',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Color(0xFF49464E),
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final selectedVehicleType =
                      VehicleType.values[_selectedVehicleTypeIndex];

                  final newName = _nameController.text;

                  final newVehicleModel = VehicleModel(
                    name: newName,
                    vehicleType: selectedVehicleType,
                  );

                  try {
                    await vehicleModelService.insert(newVehicleModel);

                    Navigator.pop(context, 'reload');
                  } catch (error) {
                    print('Error adding vehicle model: $error');
                  }
                },
                child: Text(
                  'Add',
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
      ),
    );
  }
}
