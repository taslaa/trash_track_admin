import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/table_cell.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';
import 'package:trash_track_admin/features/vehicle/services/vehicles_service.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({Key? key, this.vehicle}) : super(key: key);
  final Vehicle? vehicle;

  @override
  _VehiclesScreenState createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  late VehiclesService _vehicleService;
  late VehicleModelsService _modelsService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Vehicle> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _vehicleService = VehiclesService();
    _modelsService = VehicleModelsService();
    _initialValue = {
      'id': widget.vehicle?.id.toString(),
      'color': widget.vehicle?.color,
      'notes': widget.vehicle?.notes,
      'licensePlateNumber': widget.vehicle?.licensePlateNumber,
      'manufactureYear': widget.vehicle?.manufactureYear,
      'capacity': widget.vehicle?.capacity,
      'vehicleModelId': widget.vehicle?.vehicleModelId
    };

    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      final vehicles = await _vehicleService
          .getPaged(); // Replace with your method to fetch vehicles
      print('Received vehicles: $vehicles');
      setState(() {
        _vehicles = vehicles.items;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  // Add any other methods for handling actions, similar to what you did for Vehicle Models

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicles',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Vehicles.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => {}, // Open the Add screen as a modal
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('New Vehicle'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1D1C1E),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE0D8E0),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Table(
                border: TableBorder.all(
                  color: Colors.transparent,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F1FB),
                    ),
                    children: [
                      TableCellWidget(text: 'Color'),
                      TableCellWidget(text: 'Notes'),
                      TableCellWidget(text: 'License Plate'),
                      TableCellWidget(text: 'Manufacture Year'),
                      TableCellWidget(text: 'Capacity'),
                      TableCellWidget(text: 'Model ID'),
                      TableCellWidget(text: 'Actions'),
                    ],
                  ),
                  if (_isLoading)
                    TableRow(
                      children: [
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._vehicles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final vehicle = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: vehicle.color ?? ''),
                          TableCellWidget(text: vehicle.notes ?? ''),
                          TableCellWidget(
                              text: vehicle.licensePlateNumber ?? ''),
                          TableCellWidget(
                              text: vehicle.manufactureYear?.toString() ?? ''),
                          TableCellWidget(
                              text: vehicle.capacity?.toString() ?? ''),
                          TableCellWidget(
                              text: vehicle.vehicleModelId?.toString() ?? ''),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Handle edit action
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                // Add IconButton for delete action if needed
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
