import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/shared/services/enums_service.dart';

class VehicleModelEditScreen extends StatefulWidget {
  final VehicleModel vehicleModel;
  

  VehicleModelEditScreen({required this.vehicleModel});

  @override
  _VehicleModelEditScreenState createState() => _VehicleModelEditScreenState();
}

class _VehicleModelEditScreenState extends State<VehicleModelEditScreen> {
  late EnumsService _enumsService;
  late TextEditingController _nameController;
  late int _selectedVehicleTypeIndex;
  late Map<int, String> _vehicleTypes;
  bool _isLoading = true;
  final vehicleModelService = VehicleModelsService(); // Create an instance of your service.

  @override
  void initState() {
    super.initState();
    _enumsService = EnumsService();
    _nameController = TextEditingController(text: widget.vehicleModel.name);
    _selectedVehicleTypeIndex = widget.vehicleModel.vehicleType!.index;
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

      // Check if the received data is in the expected format (Map<int, String>).
      if (typesData is Map<int, String>) {
        // Data is in the expected format, so update the state.
        setState(() {
          _vehicleTypes = typesData;
          _isLoading = false;
        });
      } else {
        // Handle the case where the data format is unexpected.
        print('Received unexpected data format for vehicle types: $typesData');
        // You may need to convert or parse the data here to match the expected format.
      }
    } catch (error) {
      // Handle errors if any occur during the data fetching process.
      print('Error fetching vehicle types: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Vehicle Model'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : DropdownButtonFormField<int>(
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
                    decoration: InputDecoration(labelText: 'Vehicle Type'),
                  ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final selectedVehicleType = VehicleType.values[_selectedVehicleTypeIndex];

                // Capture the edited data
                final editedName = _nameController.text;

                // Update the VehicleModel
                final editedVehicleModel = VehicleModel(
                  id: widget.vehicleModel.id,
                  name: editedName,
                  vehicleType: selectedVehicleType,
                  // Add any other fields as needed
                );

                try {
                  // Call the update method from your service
                  await vehicleModelService.update(editedVehicleModel);

                  // After saving, navigate back to VehicleModelsScreen or take any other action.
                  Navigator.of(context).pop(); // Pop the current screen to return to the previous screen.
                } catch (error) {
                  // Handle errors if the save operation fails.
                  print('Error saving vehicle model: $error');
                  // You may display an error message to the user.
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
