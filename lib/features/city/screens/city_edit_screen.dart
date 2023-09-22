import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/city/models/city.dart';
import 'package:trash_track_admin/features/city/services/cities_service.dart';
import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';

class CityEditScreen extends StatefulWidget {
  final City city;
  final Function(String) onUpdateRoute;

  CityEditScreen({required this.city, required this.onUpdateRoute});

  @override
  _CityEditScreenState createState() => _CityEditScreenState();
}

class _CityEditScreenState extends State<CityEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _zipCodeController;
  late CitiesService _citiesService;
  List<Country> _countries = [];
  late String? _selectedCountryId;
  late CountriesService _countriesService;
  bool _isLoading = false;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _citiesService = CitiesService();
    _countriesService = CountriesService();
    _nameController = TextEditingController(text: widget.city.name ?? '');
    _zipCodeController = TextEditingController(text: widget.city.zipCode ?? '');
    _isActive = widget.city.isActive ?? false;
    _selectedCountryId = widget.city.countryId.toString();

    _loadCountries();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
    });

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
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _goBack();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              size: 32.0,
                            ),
                          ),
                          Text(
                            'Edit City',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 32.0),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF49464E),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF49464E),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF49464E),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: TextFormField(
                                  controller: _zipCodeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Zip Code',
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF49464E),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Active',
                                style: TextStyle(
                                  color: Color(0xFF49464E),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Checkbox(
                                value: _isActive,
                                onChanged: (value) {
                                  setState(() {
                                    _isActive = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF49464E),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              final editedCity = City(
                                id: widget.city.id,
                                name: _nameController.text,
                                zipCode: _zipCodeController.text,
                                isActive: _isActive,
                                countryId:
                                    int.tryParse(_selectedCountryId ?? ''),
                              );
                              try {
                                await _citiesService.update(editedCity);
                                widget.onUpdateRoute('cities');
                              } catch (error) {
                                print('Error saving city: $error');
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF49464E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(200, 48),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _goBack() {
    widget.onUpdateRoute('cities');
  }
}
