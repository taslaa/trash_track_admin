import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/user/screens/login_screen.dart'; // Import your LoginScreen
import 'package:trash_track_admin/features/user/services/auth_service.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (create) => VehicleModelsService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
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
      routes: {
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
