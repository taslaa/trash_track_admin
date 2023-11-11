import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/admin-panel/widgets/admin_header.dart';
import 'package:trash_track_admin/features/admin-panel/widgets/admin_sidebar.dart';
import 'package:trash_track_admin/features/city/models/city.dart';
import 'package:trash_track_admin/features/city/screens/city_add_screen.dart';
import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/country/screens/countries_screen.dart';
import 'package:trash_track_admin/features/country/screens/country_add_screen.dart';
import 'package:trash_track_admin/features/country/screens/country_edit_screen.dart';
import 'package:trash_track_admin/features/dashboard/screens/dashboard_screen.dart';
import 'package:trash_track_admin/features/garbage/screens/map_screen.dart';
import 'package:trash_track_admin/features/quiz/models/quiz.dart';
import 'package:trash_track_admin/features/quiz/screens/quiz_edit_screen.dart';
import 'package:trash_track_admin/features/reports/models/report.dart';
import 'package:trash_track_admin/features/reports/screens/report_edit_screen.dart';
import 'package:trash_track_admin/features/reports/screens/reports_screen.dart';
import 'package:trash_track_admin/features/reservations/models/reservation.dart';
import 'package:trash_track_admin/features/reservations/screens/reservation_edit_screen.dart';
import 'package:trash_track_admin/features/reservations/screens/reservation_screen.dart';
import 'package:trash_track_admin/features/schedules/screens/garbage_select_screen.dart';
import 'package:trash_track_admin/features/schedules/screens/schedules_screen.dart';
import 'package:trash_track_admin/features/services/models/service.dart';
import 'package:trash_track_admin/features/services/screens/services_add_screen.dart';
import 'package:trash_track_admin/features/services/screens/services_edit_screen.dart';
import 'package:trash_track_admin/features/services/screens/services_screen.dart';
import 'package:trash_track_admin/features/user/models/user.dart';
import 'package:trash_track_admin/features/user/screens/user_edit_screen.dart';
import 'package:trash_track_admin/features/user/screens/users_screen.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/screens/vehicle_model_add_screen.dart';
import 'package:trash_track_admin/features/vehicle-model/screens/vehicle_model_edit_screen.dart';
import 'package:trash_track_admin/features/vehicle-model/screens/vehicle_models_screen.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';
import 'package:trash_track_admin/features/vehicle/screens/vehicle_add_screen.dart';
import 'package:trash_track_admin/features/vehicle/screens/vehicle_edit_screen.dart';
import 'package:trash_track_admin/features/vehicle/screens/vehicles_screen.dart';
import 'package:trash_track_admin/features/garbage/screens/garbage_add_screen.dart';
import 'package:trash_track_admin/features/garbage/screens/garbage_map.dart';
import 'package:trash_track_admin/features/garbage/screens/garbage_screen.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/features/city/screens/cities_screen.dart';
import 'package:trash_track_admin/features/city/screens/city_edit_screen.dart';
import 'package:trash_track_admin/features/quiz/screens/quiz_add_screen.dart';
import 'package:trash_track_admin/features/schedules/screens/garbage_display_screen.dart';
import 'package:trash_track_admin/features/quiz/screens/quizzes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:latlong2/latlong.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  String selectedRoute = 'dashboard';
  String userName = 'No Name';

  // Models
  VehicleModel? selectedVehicleModel;
  Vehicle? selectedVehicle;
  Country? selectedCountry;
  City? selectedCity;
  Service? selectedService;
  Report? selectedReport;
  Quiz? selectedQuiz;
  List<int>? selectedGarbagesIds;
  Reservation? selectedReservation;
  UserEntity? selectedUser;

  LatLng? _selectedGarbageLocation = LatLng(43.3422, 17.8128);
  String? selectedAddress = '';
  List<Garbage> _selectedGarbages = [];

  // Callbacks to handle navigation
  void onTabSelected(String route) {
    setState(() {
      selectedRoute = route;
    });

    resetAddress();
  }

  void updateSelectedRoute(String newRoute) {
    setState(() {
      selectedRoute = newRoute;
    });
  }

  // Vehicle Model Callbacks
  void onEditVehicleModel(VehicleModel vehicleModel) {
    setState(() {
      selectedVehicleModel = vehicleModel;
      selectedRoute = 'vehicle_models/edit';
    });
  }

  void onAddVehicleModel() {
    setState(() {
      selectedRoute = 'vehicle_models/add';
    });
  }

  // Vehicle Callbacks
  void onEditVehicle(Vehicle vehicle) {
    setState(() {
      selectedVehicle = vehicle;
      selectedRoute = 'vehicles/edit';
    });
  }

  // User Callbacks
  void onEditUser(UserEntity user) {
    setState(() {
      selectedUser = user;
      selectedRoute = 'users/edit';
    });
  }

  void onAddVehicle() {
    setState(() {
      selectedRoute = 'vehicles/add';
    });
  }

  // Garbage Callbacks
  void onAddGarbage() {
    setState(() {
      selectedRoute = 'garbage/add';
    });
  }

  void onSelectedLocation(LatLng selectedLocation) {
    setState(() {
      _selectedGarbageLocation = selectedLocation;
    });
  }

  void onSelectedAddress(String address) {
    setState(() {
      selectedAddress = address;
    });
  }

  void resetAddress() {
    setState(() {
      selectedAddress = '';
    });
  }

  // Country Callbacks
  void onAddCountry() {
    setState(() {
      selectedRoute = 'countries/add';
    });
  }

  void onEditCountry(Country country) {
    setState(() {
      selectedCountry = country;
      selectedRoute = 'countries/edit';
    });
  }

  // Schedule Callbacks
  void onAddSchedule() {
    setState(() {
      selectedRoute = 'schedules/add';
    });
  }

  void onDisplayGarbages(List<int> garbageIds) {
    setState(() {
      selectedGarbagesIds = garbageIds;
      selectedRoute = 'schedule/garbages';
    });
  }

  void onSelectGarbages() {
    setState(() {
      selectedRoute = 'garbages/select';
    });
  }

  void onSelectedGarbages(List<Garbage> selectedGarbages) {
    setState(() {
      _selectedGarbages = selectedGarbages;
    });
  }

  // City Callbacks
  void onAddCity() {
    setState(() {
      selectedRoute = 'cities/add';
    });
  }

  void onEditCity(City city) {
    setState(() {
      selectedCity = city;
      selectedRoute = 'cities/edit';
    });
  }

  //Quiz Callbacks
  void onAddQuiz() {
    setState(() {
      selectedRoute = 'quiz/add';
    });
  }

  void onEditQuiz(Quiz quiz) {
    setState(() {
      selectedQuiz = quiz;
      selectedRoute = 'quiz/edit';
    });
  }

  //Service Callbacks
  void onAddService() {
    setState(() {
      selectedRoute = 'services/add';
    });
  }

  void onEditService(Service service) {
    setState(() {
      selectedService = service;
      selectedRoute = 'services/edit';
    });
  }

  //Reports Callbacks
  void onEditReport(Report report) {
    setState(() {
      selectedReport = report;
      selectedRoute = 'reports/edit';
    });
  }

  //Reservation Callbacks
  void onEditReservation(Reservation reservation) {
    setState(() {
      selectedReservation = reservation;
      selectedRoute = 'reservations/edit';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserNameFromToken();
  }

  _loadUserNameFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print('Token: $token');

    if (token != null) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

      String firstName = decodedToken['FirstName'];
      String lastName = decodedToken['LastName'];

      setState(() {
        userName = '$firstName $lastName';
      });
    }
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
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: _buildSelectedScreen(selectedRoute),
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
      // DASHBOARD
      case 'dashboard':
        return DashboardScreen();
      // VEHICLE MODELS
      case 'vehicle_models':
        return VehicleModelsScreen(
          onEdit: onEditVehicleModel,
          onAdd: onAddVehicleModel,
        );
      case 'vehicle_models/edit':
        if (selectedVehicleModel != null) {
          return VehicleModelEditScreen(
            vehicleModel: selectedVehicleModel!,
            onUpdateRoute: updateSelectedRoute,
          );
        } else {
          return const Text('Invalid Vehicle Model');
        }
      case 'vehicle_models/add':
        return VehicleModelAddScreen(
          onUpdateRoute: updateSelectedRoute,
        );
      // VEHICLES
      case 'vehicles':
        return VehiclesScreen(
          onEdit: onEditVehicle,
          onAdd: onAddVehicle,
        );
      case 'vehicles/edit':
        if (selectedVehicle != null) {
          return VehicleEditScreen(
            vehicle: selectedVehicle!,
            onUpdateRoute: updateSelectedRoute,
          );
        } else {
          return const Text('Invalid Vehicle Model');
        }
      case 'vehicles/add':
        return VehicleAddScreen(
          onUpdateRoute: updateSelectedRoute,
        );

      //SCHEDULE
      case 'schedules':
        return SchedulesScreen(
          onAdd: onAddSchedule,
          onDisplayGarbages: onDisplayGarbages,
        );

      case 'schedules/add':
        return ScheduleAddScreen(
          selectedGarbages: _selectedGarbages,
          onUpdateRoute: updateSelectedRoute,
        );

      case 'garbages/select':
        return GarbageSelectScreen(
          onSelectedGarbages: onSelectedGarbages,
          onUpdateRoute: updateSelectedRoute,
        );

      case 'schedule/garbages':
        return ScheduleGarbageScreen(
          garbageIds: selectedGarbagesIds!,
        );

      // GARBAGE
      case 'garbage':
        return GarbageScreen(
          onAdd: onAddGarbage,
        );
      case 'garbage/add':
        if (_selectedGarbageLocation != null) {
          return GarbageAddScreen(
            onUpdateRoute: updateSelectedRoute,
            garbageLocation: _selectedGarbageLocation!,
            address: selectedAddress!,
            resetAddress: resetAddress,
          );
        } else {
          return const Text('Invalid Garbage Location');
        }
      case 'garbage-map':
        return GarbageMapScreen();
      case 'map':
        return MapScreen(
          isSelecting: true,
          garbageLocation: Garbage(
              latitude: _selectedGarbageLocation!.latitude,
              longitude: _selectedGarbageLocation!.longitude),
          onLocationSelected: onSelectedLocation,
          onUpdateRoute: updateSelectedRoute,
          onAddressSelected: onSelectedAddress,
        );
      // COUNTRIES
      case 'countries':
        return CountriesScreen(
          onAdd: onAddCountry,
          onEdit: onEditCountry,
        );
      case 'countries/edit':
        if (selectedCountry != null) {
          return CountryEditScreen(
            country: selectedCountry!,
            onUpdateRoute: updateSelectedRoute,
          );
        } else {
          return const Text('Invalid Vehicle Model');
        }
      case 'countries/add':
        return CountryAddScreen(
          onUpdateRoute: updateSelectedRoute,
        );

      // SERVICES
      case 'services':
        return ServicesScreen(
          onAdd: onAddService,
          onEdit: onEditService,
        );
      case 'services/edit':
        if (selectedService != null) {
          return ServiceEditScreen(
            service: selectedService!,
            onUpdateRoute: updateSelectedRoute,
          );
        } else {
          return const Text('Invalid Service');
        }
      case 'services/add':
        return ServiceAddScreen(
          onUpdateRoute: updateSelectedRoute,
        );

      // REPORTS
      case 'reports':
        return ReportsScreen(
          onEdit: onEditReport,
        );
      case 'reports/edit':
        if (selectedReport != null) {
          return ReportEditScreen(
            report: selectedReport!,
            onUpdateRoute: updateSelectedRoute,
          );
        } else {
          return const Text('Invalid Report');
        }

      // Reservations
      case 'reservations':
        return ReservationScreen(
          onEdit: onEditReservation,
        );
      case 'reservations/edit':
        if (selectedReservation != null) {
          return ReservationEditScreen(
            reservation: selectedReservation!,
            onUpdateRoute: updateSelectedRoute,
          );
        } else {
          return const Text('Invalid Reservation');
        }

      //Users
      case 'users':
        return UsersScreen(
          onEdit: onEditUser,
        );
      case 'users/edit':
        if (selectedUser != null) {
          return UserEditScreen(
            user: selectedUser!,
            onUpdateRoute: updateSelectedRoute,
          );
        } else {
          return const Text('Invalid User');
        }

      // QUIZZES
      case 'quiz':
        return QuizzesScreen(
          onAdd: onAddQuiz,
          onEdit: onEditQuiz,
        );

      case 'quiz/add':
        return QuizAddScreen(
          onUpdateRoute: updateSelectedRoute,
        );

      case 'quiz/edit':
        if (selectedCity != null) {
          return QuizEditScreen(
            quiz: selectedQuiz!,
            onUpdateRoute: updateSelectedRoute,
          );
        } else {
          return const Text('Invalid Quiz');
        }

      // CITIES
      case 'cities':
        return CitiesScreen(
          onAdd: onAddCity,
          onEdit: onEditCity,
        );
      case 'cities/add':
        return CityAddScreen(
          onUpdateRoute: updateSelectedRoute,
        );
      case 'cities/edit':
        if (selectedCity != null) {
          return CityEditScreen(
            city: selectedCity!,
            onUpdateRoute: updateSelectedRoute,
          );
        } else {
          return const Text('Invalid Vehicle Model');
        }
      default:
        return const Text(
          'Welcome to the Admin Panel!',
          style: TextStyle(fontSize: 20),
        );
    }
  }
}
