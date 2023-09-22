import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/city/models/city.dart';
import 'package:trash_track_admin/features/city/services/cities_service.dart';
import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';

class CityAddScreen extends StatefulWidget {
  final Function(String) onUpdateRoute;

  CityAddScreen({required this.onUpdateRoute});

  @override
  _CityAddScreenState createState() => _CityAddScreenState();
}

class _CityAddScreenState extends State<CityAddScreen> {
  late TextEditingController _nameController;
  late TextEditingController _zipCodeController;
  late TextEditingController _isActiveController;
  late CitiesService _citiesService;
  List<Country> _countries = [];
  late String? _selectedCountryId;
  late CountriesService _countriesService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _citiesService = CitiesService();
    _countriesService = CountriesService();
    _nameController = TextEditingController();
    _zipCodeController = TextEditingController();
    _isActiveController = TextEditingController(text: 'true');
    _selectedCountryId = '';

    _loadCountries();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await _countriesService.getPaged();
      setState(() {
        _countries = countries.items;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading countries: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add City',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1C1E),
                            ),
                          ),
                          Text(
                            'Enter city details',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1D1C1E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF49464E),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF49464E),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _zipCodeController,
                        decoration: InputDecoration(
                          labelText: 'Zip Code',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF49464E),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButtonFormField<String>(
                        value: _isActiveController.text,
                        onChanged: (isActive) {
                          setState(() {
                            _isActiveController.text = isActive ?? 'true';
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'true',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'false',
                            child: Text('Inactive'),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF49464E),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedCountryId,
                        onChanged: (countryId) {
                          setState(() {
                            _selectedCountryId = countryId;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text('Choose a country'),
                          ),
                          ..._countries.map((country) {
                            return DropdownMenuItem<String>(
                              value: country.id.toString(),
                              child: Text(country.name ?? ''),
                            );
                          }).toList(),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Select Country',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final newCity = City(
                        name: _nameController.text,
                        zipCode: _zipCodeController.text,
                        isActive: _isActiveController.text == 'true',
                        countryId: int.tryParse(_selectedCountryId!),
                      );

                      try {
                        await _citiesService.insert(newCity);
                        widget.onUpdateRoute('cities');
                      } catch (error) {
                        print('Error adding city: $error');
                      }
                    },
                    child: Text(
                      'Add City',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF49464E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(400, 48),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
