import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/admin-panel/widgets/admin_header.dart';
import 'package:trash_track_admin/features/admin-panel/widgets/admin_sidebar.dart';
import 'package:trash_track_admin/features/dashboard/screens/dashboard_screen.dart';
import 'package:trash_track_admin/features/user/services/auth_service.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/screens/vehicle_models_screen.dart';
import 'package:trash_track_admin/features/vehicle/screens/vehicles_screen.dart';

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
        return VehiclesScreen(); // Replace 'VehicleModelsScreen' with your actual screen
      default:
        return const Text(
          'Welcome to the Admin Panel!',
          style: TextStyle(fontSize: 20),
        );
    }
  }
}
