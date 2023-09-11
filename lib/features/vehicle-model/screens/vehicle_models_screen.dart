import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/table_cell.dart';
import 'package:trash_track_admin/features/vehicle-model/screens/vehicle_model_edit_screen.dart'; // Import the VehicleModelEditScreen

class VehicleModelsScreen extends StatefulWidget {
  const VehicleModelsScreen({Key? key, this.vehicleModel}) : super(key: key);
  final VehicleModel? vehicleModel;
  

  @override
  _VehicleModelsScreenState createState() => _VehicleModelsScreenState();
}

class _VehicleModelsScreenState extends State<VehicleModelsScreen> {
  late VehicleModelsService _modelProvider;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<VehicleModel> _vehicleModels = [];

  @override
  void initState() {
    super.initState();
    _modelProvider = context.read<VehicleModelsService>();
    _initialValue = {
      'id': widget.vehicleModel?.id.toString(),
      'name': widget.vehicleModel?.name,
      'vehicleType': widget.vehicleModel?.vehicleType.toString(),
    };

    _loadVehicleModels();
  }

  Future<void> _loadVehicleModels() async {
    try {
      final models = await _modelProvider.getPaged();
      print('Received models: $models');
      setState(() {
        _vehicleModels = models.items;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String getVehicleTypeString(VehicleType? vehicleType) {
    if (vehicleType == null) {
      return 'Unknown';
    }
    switch (vehicleType) {
      case VehicleType.truck:
        return 'Truck';
      case VehicleType.garbageTruck:
        return 'Garbage Truck';
      default:
        return 'Unknown';
    }
  }

  void _deleteVehicleModel(int index) {
    final vehicleModel = _vehicleModels[index];
    final id = vehicleModel.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _modelProvider.remove(id);

        setState(() {
          _vehicleModels.removeAt(index);
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
          title: Text('Delete Vehicle Model'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this vehicle model?'),
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
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
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

  void _openEditScreen(VehicleModel vehicleModel) {
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return VehicleModelEditScreen(vehicleModel: vehicleModel);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    )
        .then((result) {
      if (result == true) {
        // Handle any updates or refresh the list as needed
        // For example, you can call _loadVehicleModels() here to refresh the list.
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
                      'Vehicle Models',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Vehicle Models.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle the action to create a new vehicle model
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('New Vehicle Model'),
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
                      TableCellWidget(text: 'Name'),
                      TableCellWidget(text: 'Vehicle Type'),
                      TableCellWidget(text: 'Actions'),
                    ],
                  ),
                  if (_isLoading)
                    TableRow(
                      children: [
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._vehicleModels.asMap().entries.map((entry) {
                      final index = entry.key;
                      final vehicleModel = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: vehicleModel.name ?? ''),
                          TableCellWidget(
                              text: getVehicleTypeString(
                                  vehicleModel.vehicleType)),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _openEditScreen(
                                        vehicleModel); // Open edit screen
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteVehicleModel(index);
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
    );
  }
}
