import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';
import 'package:trash_track_admin/features/garbage/widgets/table_cell.dart';
import 'package:trash_track_admin/features/garbage/widgets/paging_component.dart';

class GarbageScreen extends StatefulWidget {
  const GarbageScreen({Key? key, this.garbage, required this.onAdd})
      : super(key: key);

  final Garbage? garbage;
  final Function() onAdd;

  @override
  _GarbageScreenState createState() => _GarbageScreenState();
}

class _GarbageScreenState extends State<GarbageScreen> {
  late GarbageService _gargbageService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Garbage> _garbageModels = [];

  GarbageType? _selectedGarbageType;
  String _searchQuery = '';

  int _currentPage = 1;
  int _itemsPerPage = 3;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _gargbageService = context.read<GarbageService>();
    _initialValue = {
      'id': widget.garbage?.id.toString(),
      'address': widget.garbage?.address,
      'garbageType': widget.garbage?.garbageType,
      'latitude': widget.garbage?.latitude,
      'longitude': widget.garbage?.longitude,
    };

    _loadPagedGarbageModels();
  }

  Future<void> _loadPagedGarbageModels() async {
    try {
      final models = await _gargbageService.getPaged(
        filter: {
          'query': _searchQuery,
          'type': mapGarbageTypeToString(_selectedGarbageType),
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _garbageModels = models.items;
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String mapGarbageTypeToString(GarbageType? garbageType) {
    switch (garbageType) {
      case GarbageType.plastic:
        return 'Plastic';
      case GarbageType.glass:
        return 'Glass';
      case GarbageType.metal:
        return 'Metal';
      case GarbageType.organic:
        return 'Organic';
      default:
        return garbageType.toString(); // Default to enum value if not found
    }
  }

  void _deleteGarbageModel(int index) {
    final garbageModel = _garbageModels[index];
    final id = garbageModel.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _gargbageService.remove(id);

        setState(() {
          _garbageModels.removeAt(index);
        });
      } catch (error) {
        print('Error deleting garbage model: $error');
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Garbage Model'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this garbage model?'),
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

  // void _onEdit(Garbage garbage) async {
  //   widget.onEdit(garbage);
  // }

  void _onAdd() async {
    widget.onAdd();
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedGarbageModels();
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
                      'Garbage',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Garbage.',
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
                  label: Text('New Garbage'),
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
                          _loadPagedGarbageModels();
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
                        child: DropdownButtonFormField<GarbageType>(
                          value: _selectedGarbageType,
                          onChanged: (newValue) {
                            print(newValue);
                            setState(() {
                              _selectedGarbageType = newValue;
                            });
                            _loadPagedGarbageModels();
                          },
                          items: [
                            DropdownMenuItem<GarbageType>(
                              value: null,
                              child: Text('Choose the garbage type'),
                            ),
                            ...GarbageType.values.map((type) {
                              return DropdownMenuItem<GarbageType>(
                                value: type,
                                child: Text(mapGarbageTypeToString(
                                    type)), 
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
                      TableCellWidget(text: 'Address'),
                      TableCellWidget(text: 'Garbage Type'),
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
                    ..._garbageModels.asMap().entries.map((entry) {
                      final index = entry.key;
                      final garbageModel = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: garbageModel.address ?? ''),
                          TableCellWidget(
                              text: mapGarbageTypeToString(
                                  garbageModel.garbageType!)),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    //_onEdit(garbageModel);
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteGarbageModel(index);
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
