import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/table_cell.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/paging_component.dart';

class VehicleModelsScreen extends StatefulWidget {
  const VehicleModelsScreen({
    Key? key,
    this.vehicleModel,
    required this.onEdit,
    required this.onAdd,
  }) : super(key: key);
  final VehicleModel? vehicleModel;
  final Function(VehicleModel) onEdit;
  final Function() onAdd;

  @override
  _VehicleModelsScreenState createState() => _VehicleModelsScreenState();
}

class _VehicleModelsScreenState extends State<VehicleModelsScreen> {
  late VehicleModelsService _modelProvider;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<VehicleModel> _vehicleModels = [];

  VehicleType? _selectedVehicleType;
  String _searchQuery = '';

  int _currentPage = 1;
  int _itemsPerPage = 5;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _modelProvider = context.read<VehicleModelsService>();
    _initialValue = {
      'id': widget.vehicleModel?.id.toString(),
      'name': widget.vehicleModel?.name,
      'vehicleType': widget.vehicleModel?.vehicleType.toString(),
    };

    _loadPagedVehicleModels();
  }

  String convertToEnumValue(VehicleType? selectedValue) {
    switch (selectedValue) {
      case VehicleType.truck:
        return 'Truck';
      case VehicleType.garbageTruck:
        return 'GarbageTruck';
      default:
        return '';
    }
  }

  Future<void> _loadPagedVehicleModels() async {
    try {
      final models = await _modelProvider.getPaged(
        filter: {
          'query': _searchQuery,
          'type': convertToEnumValue(_selectedVehicleType),
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _vehicleModels = models.items;
        _totalRecords = models.totalCount;
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

  void _onEdit(VehicleModel vehicleModel) async {
    widget.onEdit(vehicleModel);
  }

  void _onAdd() async {
    widget.onAdd();
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedVehicleModels();
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
                    _onAdd();
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
                            _searchQuery = value;
                          });
                          _loadPagedVehicleModels();
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
                      child: Container(
                        alignment: Alignment.center,
                        child: DropdownButtonFormField<VehicleType>(
                          value: _selectedVehicleType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedVehicleType = newValue;
                            });
                            _loadPagedVehicleModels();
                          },
                          items: [
                            DropdownMenuItem<VehicleType>(
                              value: null,
                              child: Text('Choose the vehicle type'),
                            ),
                            ...VehicleType.values.map((type) {
                              return DropdownMenuItem<VehicleType>(
                                value: type,
                                child: Text(getVehicleTypeString(type)),
                              );
                            }).toList(),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Color(0xFF49464E),
                          ),
                          icon: Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
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
                                    _onEdit(vehicleModel);
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

      bottomNavigationBar: PagingComponent(
        currentPage: _currentPage,
        itemsPerPage: _itemsPerPage,
        totalRecords: _totalRecords,
        onPageChange: _handlePageChange,
      ),
    );
  }
}