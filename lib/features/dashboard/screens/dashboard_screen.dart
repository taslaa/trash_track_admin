import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white, // Background color for the dashboard
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color(0xFF49464E), // Text color 49464e
            ),
          ),
          SizedBox(height: 16.0),
          // Add your dashboard widgets here
          Text(
            'Welcome to the dashboard! You can add your widgets here.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF49464E), // Text color 49464e
            ),
          ),
          // Add more widgets as needed
        ],
      ),
    );
  }
}
