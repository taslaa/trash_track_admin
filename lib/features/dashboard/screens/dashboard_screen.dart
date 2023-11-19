import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/dashboard/widgets/role_count.dart';
import 'package:trash_track_admin/features/dashboard/widgets/garbage_type_count.dart';
import 'package:trash_track_admin/features/dashboard/widgets/vehicle_type_count.dart';
import 'package:trash_track_admin/features/dashboard/widgets/reservations_count.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int administratorCount = 0;
  int userCount = 0;
  int driverCount = 0;

  int metalGarbageCount = 0;
  int glassGarbageCount = 0;
  int plasticGarbageCount = 0;
  int organicGarbageCount = 0;

  int garbageTruckCount = 0;
  int truckCount = 0;

  int reservationsCount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataForReservations();
    fetchDataForGarbage();
    fetchDataForVehicles();
  }

  Future<void> fetchData() async {
    try {
      final adminCountResponse = await http.get(
          Uri.parse('http://localhost:7034/api/Users/AdministratorCount'));
      if (adminCountResponse.statusCode == 200) {
        final adminData = int.parse(adminCountResponse.body);
        setState(() {
          administratorCount = adminData;
        });
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
    final userCountResponse =
        await http.get(Uri.parse('http://localhost:7034/api/Users/UserCount'));
    final driverCountResponse = await http
        .get(Uri.parse('http://localhost:7034/api/Users/DriverCount'));

    if (userCountResponse.statusCode == 200) {
      final userData = int.parse(userCountResponse.body);
      setState(() {
        userCount = userData;
      });
    }

    if (driverCountResponse.statusCode == 200) {
      final driverData = int.parse(driverCountResponse.body);
      setState(() {
        driverCount = driverData;
      });
    }
  }

  Future<void> fetchDataForGarbage() async {
    final metalGarbageCountResponse = await http
        .get(Uri.parse('http://localhost:7034/api/Garbage/MetalGarbageCount'));
    final glassGarbageCountResponse = await http
        .get(Uri.parse('http://localhost:7034/api/Garbage/GlassGarbageCount'));
    final plasticGarbageCountResponse = await http.get(
        Uri.parse('http://localhost:7034/api/Garbage/PlasticGarbageCount'));
    final organicGarbageCountResponse = await http.get(
        Uri.parse('http://localhost:7034/api/Garbage/OrganicGarbageCount'));

    if (metalGarbageCountResponse.statusCode == 200) {
      final metalGarbageData = int.parse(metalGarbageCountResponse.body);
      setState(() {
        metalGarbageCount = metalGarbageData;
      });
    }

    if (glassGarbageCountResponse.statusCode == 200) {
      final glassGarbageData = int.parse(glassGarbageCountResponse.body);
      setState(() {
        glassGarbageCount = glassGarbageData;
      });
    }

    if (plasticGarbageCountResponse.statusCode == 200) {
      final plasticGarbageData = int.parse(plasticGarbageCountResponse.body);
      setState(() {
        plasticGarbageCount = plasticGarbageData;
      });
    }

    if (organicGarbageCountResponse.statusCode == 200) {
      final organicGarbageData = int.parse(organicGarbageCountResponse.body);
      setState(() {
        organicGarbageCount = organicGarbageData;
      });
    }
  }

  Future<void> fetchDataForVehicles() async {
    final garbageTruckCountResponse = await http.get(
        Uri.parse('http://localhost:7034/api/VehicleModels/GarbageTruckCount'));
    final truckCountResponse = await http
        .get(Uri.parse('http://localhost:7034/api/VehicleModels/TruckCount'));

    if (garbageTruckCountResponse.statusCode == 200) {
      final garbageTruckData = int.parse(garbageTruckCountResponse.body);
      setState(() {
        garbageTruckCount = garbageTruckData;
      });
    }

    if (truckCountResponse.statusCode == 200) {
      final truckData = int.parse(truckCountResponse.body);
      setState(() {
        truckCount = truckData;
      });
    }
  }

  Future<void> fetchDataForReservations() async {
    final reservationsCountResponse = await http.get(
        Uri.parse('http://localhost:7034/api/Reservation/ReservationCount'));

    if (reservationsCountResponse.statusCode == 200) {
      final reservationData = int.parse(reservationsCountResponse.body);
      setState(() {
        reservationsCount = reservationData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          _buildSquare(
            color: Color(0xFFF0F0F0), // #fafafa
            roleWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Count by Roles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40), // Add space between title and content
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the squares and role names
                  children: [
                    _buildRoleSquare(Colors.blue, 'Administrator'),
                    _buildRoleSquare(Colors.red, 'User'),
                    _buildRoleSquare(Colors.green, 'Driver'),
                  ],
                ),
                SizedBox(
                    height:
                        130), // Add space between content and CountByRoleWidget
                Align(
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale:
                        10.0, // Adjust the scale factor to make the widget larger
                    alignment: Alignment.center,
                    child: CountByRoleWidget(
                      administratorCount: administratorCount,
                      userCount: userCount,
                      driverCount: driverCount,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildSquare(
            color: Color(0xFFF0F0F0), // #fafafa
            roleWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Count by Garbage Types',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40), // Add space between title and content
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the squares and role names
                  children: [
                    _buildRoleSquare(Colors.blue, 'Metal'),
                    _buildRoleSquare(Colors.red, 'Plastic'),
                    _buildRoleSquare(Colors.yellow, 'Organic'),
                    _buildRoleSquare(Colors.green, 'Glass'),
                  ],
                ),
                SizedBox(
                    height:
                        130), // Add space between content and CountByRoleWidget
                Align(
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale:
                        10.0, // Adjust the scale factor to make the widget larger
                    alignment: Alignment.center,
                    child: CountByGarbageTypeWidget(
                      metalGarbageCount: administratorCount,
                      glassGarbageCount: userCount,
                      plasticGarbageCount: driverCount,
                      organicGarbageCount: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildSquare(
            color: Color(0xFFF0F0F0), // #fafafa
            roleWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Count by Vehicle Types',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40), // Add space between title and content
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the squares and role names
                  children: [
                    _buildRoleSquare(Colors.blue, 'Garbage Truck'),
                    _buildRoleSquare(Colors.red, 'Truck'),
                  ],
                ),
                SizedBox(
                    height:
                        130), // Add space between content and CountByRoleWidget
                Align(
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale:
                        10.0, // Adjust the scale factor to make the widget larger
                    alignment: Alignment.center,
                    child: CountByVehicleTypeWidget(
                      garbageTruckCount: administratorCount,
                      truckCount: userCount,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildSquare(
            color: Color(0xFFF0F0F0), // #fafafa
            roleWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Count of Reservations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40), // Add space between title and content
                SizedBox(
                    height:
                        130), // Add space between content and CountByRoleWidget
                Align(
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale:
                        10.0, // Adjust the scale factor to make the widget larger
                    alignment: Alignment.center,
                    child: CountReservationsWidget(
                      reservationCount: reservationsCount,
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

  Widget _buildSquare({Color? color, Widget? roleWidget}) {
    return Container(
      color: color,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: roleWidget,
      ),
    );
  }

  Widget _buildRoleSquare(Color color, String roleName) {
    return Container(
      margin: EdgeInsets.only(right: 8), // Add spacing between squares
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          SizedBox(width: 8), // Add spacing between the square and role name
          Text(
            roleName,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
