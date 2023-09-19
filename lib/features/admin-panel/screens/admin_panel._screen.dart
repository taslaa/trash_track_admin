import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/admin-panel/widgets/admin_header.dart';
import 'package:trash_track_admin/features/admin-panel/widgets/admin_sidebar.dart';
import 'package:trash_track_admin/features/dashboard/screens/dashboard_screen.dart';
import 'package:trash_track_admin/features/garbage/screens/add-garbage.dart';
import 'package:trash_track_admin/features/garbage/screens/garbage-map.dart';
import 'package:trash_track_admin/features/vehicle-model/screens/vehicle_models_screen.dart';
import 'package:trash_track_admin/features/vehicle/screens/vehicles_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  String selectedRoute = 'dashboard';
  String userName = 'No Name';

  void onTabSelected(String route) {
    setState(() {
      selectedRoute = route;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserNameFromToken();
  }

  _loadUserNameFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print('Token: $token');

    if (token != null) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

      String firstName = decodedToken['FirstName'];
      String lastName = decodedToken['LastName'];

      setState(() {
        userName = '$firstName $lastName';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AdminHeaderWidget(
            adminName: userName,
          ),
          Expanded(
            child: Row(
              children: [
                AdminSidebar(
                  selectedRoute: selectedRoute,
                  onTabSelected: onTabSelected,
                ),
                Expanded(
                  // Use a Container to allow the DashboardScreen to expand
                  child: Container(
                    color: Colors.white, // Set background color as needed
                    child: Center(
                      child: _buildSelectedScreen(
                          selectedRoute), // Show the selected screen
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedScreen(String selectedRoute) {
    switch (selectedRoute) {
      case 'dashboard':
        return DashboardScreen();
      case 'vehicle_models':
        return VehicleModelsScreen();
      case 'vehicles':
        return VehiclesScreen();
      case 'garbage':
        return AddPlaceScreen();
      case 'garbage-map':
        return GarbageMapScreen();
      default:
        return const Text(
          'Welcome to the Admin Panel!',
          style: TextStyle(fontSize: 20),
        );
    }
  }
}
