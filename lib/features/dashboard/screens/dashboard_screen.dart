import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trash_track_admin/features/dashboard/widgets/role_count.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int administratorCount = 0;
  int userCount = 0;
  int driverCount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final adminCountResponse = await http
        .get(Uri.parse('http://localhost:5057/api/Users/AdministratorCount'));
    final userCountResponse =
        await http.get(Uri.parse('http://localhost:5057/api/Users/UserCount'));
    final driverCountResponse = await http
        .get(Uri.parse('http://localhost:5057/api/Users/DriverCount'));

    if (adminCountResponse.statusCode == 200) {
      final adminData = int.parse(adminCountResponse.body);
      setState(() {
        administratorCount = adminData;
      });
    }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
            CountByRoleWidget(
              administratorCount: administratorCount,
              userCount: userCount,
              driverCount: driverCount,
            ),
        ],
      ),
    );
  }
}