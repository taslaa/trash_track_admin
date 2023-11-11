import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/country/widgets/table_cell.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';
import 'package:trash_track_admin/features/garbage/widgets/paging_component.dart';
import 'package:trash_track_admin/features/schedules/models/schedule.dart';
import 'package:trash_track_admin/features/schedules/service/schedule_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:trash_track_admin/features/schedules/widgets/driver_table_cell.dart';
import 'dart:convert';

import 'package:trash_track_admin/features/user/services/users_service.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen(
      {Key? key,
      this.schedule,
      required this.onAdd,
      required this.onDisplayGarbages})
      : super(key: key);

  final Schedule? schedule;
  final Function() onAdd;
  final Function(List<int>) onDisplayGarbages;

  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  late ScheduleService _scheduleService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Schedule> _schedules = [];

  PickupStatus? _selectedPickupStatus;

  int _currentPage = 1;
  int _itemsPerPage = 5;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _scheduleService = context.read<ScheduleService>();
    _initialValue = {
      'id': widget.schedule?.id.toString(),
      'pickupDate': widget.schedule?.pickupDate,
      'status': widget.schedule?.status,
      'vehicleId': widget.schedule?.vehicleId,
      'vehicle': widget.schedule?.vehicle,
      'scheduleDrivers': widget.schedule?.scheduleDrivers,
      'scheduleGarbages': widget.schedule?.scheduleGarbages,
    };

    _loadPagedSchedules();
  }

  Future<void> _loadPagedSchedules() async {
    try {
      final models = await _scheduleService.getPaged(
        filter: {
          'status': mapPickupStatusToString(_selectedPickupStatus),
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _schedules.clear(); // Clear the existing list
        _schedules.addAll(models.items); // Add the fetched schedules
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }

    _fetchUserNamesForSchedule(11);
  }

  String mapPickupStatusToString(PickupStatus? pickupStatus) {
    switch (pickupStatus) {
      case PickupStatus.completed:
        return 'Completed';
      case PickupStatus.pending:
        return 'Pending';
      case PickupStatus.cancelled:
        return 'Cancelled';
      default:
        return pickupStatus.toString(); // Default to enum value if not found
    }
  }

  void _deleteSchedule(int index) async {
    final schedule = _schedules[index];
    final id = schedule.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _scheduleService.remove(id);

        setState(() {
          _schedules.removeAt(index);
        });
        await _loadPagedSchedules(); // Wait for the load to complete before refreshing the list
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
          title: Text('Delete Schedule'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this schedule?'),
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

  void _onAdd() async {
    widget.onAdd();
  }

  void _onDisplayGarbages(List<int> garbageIds) async {
    widget.onDisplayGarbages(garbageIds);
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedSchedules();
  }

  Future<List<int>> _fetchDriverIdsForSchedule(int? scheduleId) async {
    final url = Uri.parse(
        'https://localhost:7090/api/ScheduleDrivers/BySchedule?scheduleId=$scheduleId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<int>();
    } else {
      throw Exception('Failed to load driver IDs');
    }
  }

  Future<List<String>> _fetchUserNamesForSchedule(int? scheduleId) async {
    final userService = context.read<UserService>();
    final driverIds = await _fetchDriverIdsForSchedule(scheduleId!);

    final names = <String>[];

    for (final driverId in driverIds) {
      final user = await userService.getById(driverId);
      if (user != null) {
        names.add(user.firstName);
      }
    }
    print(names);
    return names.toList();
  }

  Future<Widget> _buildDriverIdsForScheduleAsync(int? scheduleId) async {
    final driverIds = await _fetchDriverIdsForSchedule(scheduleId);
    return Text(driverIds.toString());
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
                      'Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Schedule.',
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
                  label: Text('New Schedule'),
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
                      child: Container(
                        alignment: Alignment.center,
                        child: DropdownButtonFormField<PickupStatus>(
                          value: _selectedPickupStatus,
                          onChanged: (newValue) {
                            print(newValue);
                            setState(() {
                              _selectedPickupStatus = newValue;
                            });
                            _loadPagedSchedules();
                          },
                          items: [
                            DropdownMenuItem<PickupStatus>(
                              value: null,
                              child: Text('Choose the pickup status'),
                            ),
                            ...PickupStatus.values.map((type) {
                              return DropdownMenuItem<PickupStatus>(
                                value: type,
                                child: Text(mapPickupStatusToString(type)),
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
                      TableCellWidget(text: 'Pickup date'),
                      TableCellWidget(text: 'Pickup status'),
                      TableCellWidget(text: 'Drivers'),
                      TableCellWidget(text: 'Vehicle'),
                      TableCellWidget(text: 'Garbages'),
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
                      ],
                    )
                  else
                    ..._schedules.asMap().entries.map((entry) {
                      final index = entry.key;
                      final schedule = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(
                              text: DateFormat('dd/MM/yyyy').format(
                                  schedule.pickupDate ?? DateTime.now())),
                          TableCellWidget(
                              text: mapPickupStatusToString(schedule.status!)),
                          TableCellWidget(
                              text: schedule.scheduleDrivers!
                                  .map((e) => e.driver!.firstName)
                                  .join(', ')),
                          TableCellWidget(
                              text: schedule.vehicle?.licensePlateNumber ?? ''),
                          TableCell(
                              child: ElevatedButton(
                                  onPressed: () {
                                    final garbageIds = schedule
                                        .scheduleGarbages!
                                        .map((e) => e.garbageId)
                                        .where((id) => id != null)
                                        .map((id) => id!)
                                        .toList();
                                    _onDisplayGarbages(garbageIds);
                                  },
                                  child: Text('Show Garbages'))),
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
