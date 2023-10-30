import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/features/schedules/models/schedule.dart';
import 'package:trash_track_admin/features/schedules/models/schedule_driver.dart';
import 'package:trash_track_admin/features/schedules/service/schedule_provider.dart';
import 'package:trash_track_admin/features/schedules/service/schedule_service.dart';
import 'package:trash_track_admin/features/user/models/user.dart';
import 'package:trash_track_admin/features/user/services/users_service.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';
import 'package:trash_track_admin/features/vehicle/screens/vehicles_screen.dart';
import 'package:trash_track_admin/features/vehicle/services/vehicles_service.dart';
import 'package:trash_track_admin/shared/services/enums_service.dart';
import 'package:multiselect/multiselect.dart';
import 'package:intl/intl.dart';

class ScheduleAddScreen extends StatefulWidget {
  List<Garbage> selectedGarbages = [];
  final Function(String) onUpdateRoute;

  ScheduleAddScreen({
    required this.selectedGarbages,
    required this.onUpdateRoute,
  });

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
  DateTime _selectedDate = DateTime.now();
  List<UserEntity> _selectedUsers = [];
  ScheduleProvider scheduleProvider = ScheduleProvider();

  @override
  void initState() {
    super.initState();
    _scheduleService = ScheduleService();
    _vehicleService = VehiclesService();
    _enumsService = EnumsService();
    _selectedVehicleId = 0;
    _loadVehicles();
    _userService = UserService();
    _loadUsers();
  }

  @override
  void dispose() {
    super.dispose();
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

  void _goBack() {
    widget.onUpdateRoute('schedules');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _goBack,
                ),
              ],
            ),
            const SizedBox(height: 100),
            Text(
              'Add Schedule', // Title text
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 400, // Set the width here
              child: ElevatedButton.icon(
                onPressed: () => _selectDate(context),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Set the background color to white
                  onPrimary: const Color(0xFF49464E), // Set the text color
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0), // Add some vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Apply border radius
                    side: BorderSide(
                      color: const Color(0xFF49464E), // Set border color
                      width: 0.5, // Set border width
                    ),
                  ),
                ),
                icon: Icon(Icons.date_range,
                    color: const Color(0xFF49464E)), // Add date icon
                label: Text(DateFormat('dd/MM/yyyy').format(_selectedDate),
                    style: TextStyle(
                        fontSize:
                            16.0)), // Set button text to the selected date
              ),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 400, // Set the width here
                        child: Container(
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFF49464E), width: 0.5),
                          ),
                          child: DropDownMultiSelect(
                            options:
                                _users.map((user) => user.firstName).toList(),
                            selectedValues: _selectedUsers
                                .map((user) => user.firstName)
                                .toList(),
                            onChanged: (values) {
                              setState(() {
                                _selectedUsers = _users
                                    .where((user) =>
                                        values.contains(user.firstName))
                                    .toList();
                              });
                              print(_selectedUsers);
                            },
                            whenEmpty: 'Select Users',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 400, // Set the width here
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.onUpdateRoute('garbages/select');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .white, // Set the background color to white
                            onPrimary:
                                const Color(0xFF49464E), // Set the text color
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0), // Add some vertical padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Apply border radius
                              side: BorderSide(
                                color:
                                    const Color(0xFF49464E), // Set border color
                                width: 0.5, // Set border width
                              ),
                            ),
                          ),
                          icon: Icon(Icons.location_on,
                              color:
                                  const Color(0xFF49464E)), // Add location icon
                          label: Text('Select Garbages',
                              style:
                                  TextStyle(fontSize: 16.0)), // Set button text
                        ),
                      )
                    ],
                  ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400, // Set the width here
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
            SizedBox(
              width: 400, // Set the width here
              child: ElevatedButton(
                onPressed: () async {
                  final List<Map<String, int?>> _scheduleDrivers =
                      _selectedUsers.map((user) {
                    return {
                      "DriverId": user.id,
                    };
                  }).toList();

                  final List<Map<String, int?>> _scheduleGarbages =
                      widget.selectedGarbages?.map((garbage) {
                            return {
                              "GarbageId": garbage.id,
                            };
                          }).toList() ??
                          [];

                  final newSchedule = Schedule(
                    pickupDate: _selectedDate,
                    vehicleId: _selectedVehicleId,
                    scheduleDrivers: _scheduleDrivers,
                    scheduleGarbages: _scheduleGarbages,
                  );

                  try {
                    await _scheduleService.insert(newSchedule);

                    widget.onUpdateRoute('dashboard');
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
