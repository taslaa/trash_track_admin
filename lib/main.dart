import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/user/screens/login_screen.dart'; // Import your LoginScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Replace MyHomePage with your LoginScreen
      home: LoginScreen(), 
    );
  }
}
