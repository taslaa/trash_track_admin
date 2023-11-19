import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';
import 'package:trash_track_admin/features/garbage/models/garbage_selected_values_model.dart';
import 'package:trash_track_admin/features/notifications/services/notification_provider.dart';
import 'package:trash_track_admin/features/order/services/orders_service.dart';
import 'package:trash_track_admin/features/product/services/products_service.dart';
import 'package:trash_track_admin/features/quiz/services/quiz_service.dart';
import 'package:trash_track_admin/features/reports/services/reports_service.dart';
import 'package:trash_track_admin/features/reservations/services/reservation_service.dart';
import 'package:trash_track_admin/features/schedules/models/selected_values_model.dart';
import 'package:trash_track_admin/features/schedules/service/schedule_service.dart';
import 'package:trash_track_admin/features/services/service/services_service.dart';
import 'package:trash_track_admin/features/user/screens/login_screen.dart';
import 'package:trash_track_admin/features/user/services/auth_service.dart';
import 'package:trash_track_admin/features/user/services/users_service.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';
import 'package:flutter/services.dart';

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
        ChangeNotifierProvider(create: (_) => ServicesService()),
        ChangeNotifierProvider(create: (_) => ReportsService()),
        ChangeNotifierProvider(create: (_) => ReservationService()),
        ChangeNotifierProvider(create: (_) => ScheduleService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => QuizService()),
        ChangeNotifierProvider(create: (_) => SelectedValuesModel()),
        ChangeNotifierProvider(create: (_) => GarbageSelectedValuesModel()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => OrdersService()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
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
