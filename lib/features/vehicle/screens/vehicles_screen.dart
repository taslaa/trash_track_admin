import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/table_cell.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';
import 'package:trash_track_admin/features/vehicle/services/vehicles_service.dart';
import 'package:trash_track_admin/shared/widgets/paging_component.dart';
import 'package:trash_track_admin/features/vehicle/screens/vehicle_edit_screen.dart';

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

  String _licensePlateNumber = '';
  String _manufactureYear = '';

  int _currentPage = 1;
  int _itemsPerPage = 3;
  int _totalRecords = 0;

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
      'vehicleModelId': widget.vehicle?.vehicleModelId,
      'vehicleModel': widget.vehicle?.vehicleModel,
    };

    _loadVehicles();
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

    return DropdownButton<String>(
      value: _manufactureYear,
      onChanged: (year) {
        setState(() {
          _manufactureYear = year ?? '';
        });
        _loadVehicles();
      },
      items: yearItems,
      underline: Container(),
    );
  }

  Future<void> _loadVehicles() async {
    try {
      final vehicles = await _vehicleService.getPaged(
        filter: {
          'licensePlateNumber': _licensePlateNumber,
          'manufactureYear': _manufactureYear,
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _vehicles = vehicles.items;
        _totalRecords = vehicles.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _deleteVehicle(int index) {
    final vehicleModel = _vehicles[index];
    final id = vehicleModel.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _vehicleService.remove(id);

        setState(() {
          _vehicles.removeAt(index);
        });
      } catch (error) {
        print('Error deleting vehicle model: $error');
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Vehicle'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this vehicle?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1D1C1E),
                onPrimary: Colors.white,
              ),
              onPressed: () {
                onDeleteConfirmed();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Color(0xFF1D1C1E),
                  shadowColor: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _openEditScreen(Vehicle vehicle) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // Your VehicleEditScreen content here
        content: VehicleEditScreen(vehicle: vehicle),
      );
    },
  ).then((result) {
    if (result == 'reload') {
      _loadVehicles();
    }
  });
}

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
            Row(
              children: [
                Expanded(
                  flex: 1,
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
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _licensePlateNumber = value;
                          });
                          _loadVehicles();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
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
                      child: _buildYearDropdown(),
                    ),
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
                      TableCellWidget(text: 'Model'),
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
                              text: vehicle.vehicleModel?.name ?? ''),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _openEditScreen(vehicle);
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteVehicle(index);
                                  },
                                  icon: Icon(Icons.delete,
                                      color: Color(0xFF1D1C1E)),
                                ),
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
      bottomNavigationBar: PagingComponent(
        currentPage: _currentPage,
        itemsPerPage: _itemsPerPage,
        totalRecords: _vehicles.length,
        onPageChange: (newPage) {
          setState(() {
            _currentPage = newPage;
          });
        },
      ),
    );
  }
}
