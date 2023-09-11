import 'package:flutter/material.dart';

class AdminHeaderWidget extends StatelessWidget {
  final String adminName;

  const AdminHeaderWidget({Key? key, required this.adminName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2EAF9), // Color code for f2eaf9
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text(
            'Admin Panel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF49464E), // Text color set to 49464e
            ),
          ),
          const Spacer(),
          Text(
            adminName,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF49464E), // Text color set to 49464e
            ),
          ),
          const SizedBox(width: 8.0), // Add spacing between the name and icon
          const Icon(
            Icons.account_circle, // You can change this to your profile icon
            size: 32,
            color: Color(0xFF49464E), // Icon color set to 49464e
          ),
        ],
      ),
    );
  }
}
