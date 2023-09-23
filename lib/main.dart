import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';
import 'package:trash_track_admin/features/user/screens/login_screen.dart'; 
import 'package:trash_track_admin/features/user/services/auth_service.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services library

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (create) => VehicleModelsService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => GarbageService()),
        ChangeNotifierProvider(create: (_) => CountriesService()),
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

