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

  LatLng? _selectedGarbageLocation = LatLng(43.3422, 17.8128);
  String? selectedAddress = '';

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
