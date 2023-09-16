import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/user/screens/login_screen.dart'; // Import your LoginScreen
import 'package:trash_track_admin/features/user/services/auth_service.dart'; // Import your AuthService

class AdminSidebar extends StatefulWidget {
  final ValueChanged<String> onTabSelected; // Define the callback
  final String selectedRoute; // Define the selected route

  const AdminSidebar({
    required this.onTabSelected,
    required this.selectedRoute,
  });

  @override
  _AdminSidebarState createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  List<Map<String, dynamic>> entities = [
    {'name': 'Dashboard', 'icon': Icons.dashboard, 'route': 'dashboard'},
    {
      'name': 'Vehicle Model',
      'icon': Icons.directions_car,
      'route': 'vehicle_models'
    },
    {'name': 'Vehicle', 'icon': Icons.fire_truck_rounded, 'route': 'vehicles'},
    {'name': 'City', 'icon': Icons.location_city, 'route': 'cities'},
    {'name': 'Country', 'icon': Icons.public, 'route': 'countries'},
  ];

 @override
Widget build(BuildContext context) {
  return Container(
    width: 200,
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border(
        right: BorderSide(
          color: Color(0xFFE0D8F0),
        ),
      ),
    ),
    child: Column(
      children: [
        Expanded(
          child: Column(
            children: [
              for (final entity in entities)
                buildSidebarItem(entity['icon'], entity['name'], entity['route']),
              SizedBox(height: 20), // Add some space between items and the logout button
            ],
          ),
        ),
        buildLogoutButton(),
      ],
    ),
  );
}


  Widget buildSidebarItem(IconData icon, String entityName, String route) {
    final isSelected = widget.selectedRoute == route;

    return GestureDetector(
      onTap: () {
        // Call the callback to handle tab selection
        widget.onTabSelected(route);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        color: isSelected ? Color(0xFFE9DEF8) : Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(0xFF49464E),
              size: 32,
            ),
            SizedBox(width: 8),
            Text(
              entityName,
              style: TextStyle(
                color: Color(0xFF49464E),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogoutButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          AuthService().signOut(context);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                Icons.exit_to_app, // Use the logout icon
                color: Color(0xFF49464E),
                size: 32,
              ),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFF49464E),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
