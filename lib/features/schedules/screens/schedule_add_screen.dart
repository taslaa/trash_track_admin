import 'dart:html';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:trash_track_admin/features/schedules/models/schedule.dart';
import 'package:trash_track_admin/features/schedules/models/schedule_driver.dart';
import 'package:trash_track_admin/features/schedules/service/schedule_service.dart';
import 'package:trash_track_admin/features/user/models/user.dart';
import 'package:trash_track_admin/features/user/services/users_service.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';
import 'package:trash_track_admin/features/vehicle/screens/vehicles_screen.dart';
import 'package:trash_track_admin/features/vehicle/services/vehicles_service.dart';
import 'package:trash_track_admin/shared/services/enums_service.dart';
import 'package:multiselect/multiselect.dart';

class ScheduleAddScreen extends StatefulWidget {
  ScheduleAddScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleAddScreen> createState() => _ScheduleAddScreenState();
}

class _ScheduleAddScreenState extends State<ScheduleAddScreen> {
  late ScheduleService _scheduleService;
  List<UserEntity> _users = [];
  late UserService _userService;
  List<Vehicle> _vehicles = [];
  late int _selectedVehicleId = 0;
  late VehiclesService _vehicleService;
  bool _isLoading = true;
  late EnumsService _enumsService;
  late int _selectedPickupStatusIndex;
  late Map<int, String> _pickupStatus;
  DateTime _selectedDate = DateTime.now();
  List<UserEntity> _selectedUsers = [];

  @override
  void initState() {
    super.initState();
    _scheduleService = ScheduleService();
    _vehicleService = VehiclesService();
    _enumsService = EnumsService();
    _selectedVehicleId = 0;
    _loadVehicles();
    _selectedPickupStatusIndex = 0;
    _fetchPickupStatus();
    _userService = UserService();
    _loadUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchPickupStatus() async {
    try {
      final typesData = await _enumsService.getPickupStatus();

      if (typesData is Map<int, String>) {
        setState(() {
          _pickupStatus = typesData;
          _isLoading = false;
        });
      } else {
        print('Received unexpected data format for pickup status: $typesData');
      }
    } catch (error) {
      print('Error fetching pickup status: $error');
    }
  }

  Future<void> _loadVehicles() async {
    try {
      final vehicles = await _vehicleService.getPaged();
      setState(() {
        _vehicles = [Vehicle(id: 0, licensePlateNumber: 'Choose a Vehicle')] +
            vehicles.items;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading vehicles: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _userService.getPaged();
      setState(() {
        _users = users.items;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading users: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<ScheduleDriver> convertUsersToScheduleDrivers(List<UserEntity> users) {
    return users.map((user) {
      return ScheduleDriver(driverId: user.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Add Schedule',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: 400,
                    child: Padding(
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
                          child: DropdownButtonFormField<int>(
                            value: _selectedPickupStatusIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedPickupStatusIndex = newValue ?? 0;
                              });
                            },
                            items: _pickupStatus.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Pickup Status',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: const Color(0xFF49464E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              child: Padding(
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
                    child: DropdownButtonFormField<int>(
                      value: _selectedVehicleId,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedVehicleId = newValue ?? 0;
                        });
                      },
                      items: _vehicles.map((model) {
                        return DropdownMenuItem<int>(
                            value: model.id,
                            child: Text((model.licensePlateNumber ?? '')));
                      }).toList(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: const Color(0xFF49464E),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Multiselect dropdown for users
            DropDownMultiSelect(
              options: _users.map((user) => user.firstName).toList(),
              selectedValues:
                  _selectedUsers.map((user) => user.firstName).toList(),
              onChanged: (values) {
                setState(() {
                  _selectedUsers = _users
                      .where((user) => values.contains(user.firstName))
                      .toList();
                });
                print(_selectedUsers);
              },
              whenEmpty: 'Select Users',
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () async {
                  final selectedPickupStatus =
                      PickupStatus.values[_selectedPickupStatusIndex];

                  final newSchedule = Schedule(
                      pickupDate: _selectedDate,
                      vehicleId: _selectedVehicleId,
                      status: selectedPickupStatus,
                      scheduleDrivers:
                          convertUsersToScheduleDrivers(_selectedUsers));

                  try {
                    await _scheduleService.insert(newSchedule);
                  } catch (error) {
                    print('Error adding schedule: $error');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    const Text('Add Schedule'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF49464E),
                  minimumSize: Size(400, 48),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Pickup Date'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
