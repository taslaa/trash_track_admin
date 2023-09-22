import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';

class CountryEditScreen extends StatefulWidget {
  final Country country;
  final Function(String) onUpdateRoute;

  CountryEditScreen({required this.country, required this.onUpdateRoute});

  @override
  _CountryEditScreenState createState() => _CountryEditScreenState();
}

class _CountryEditScreenState extends State<CountryEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _abbreviationController;
  late bool _isActive;
  bool _isLoading = false;
  final _countryService = CountriesService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.country.name);
    _abbreviationController =
        TextEditingController(text: widget.country.abbreviation);
    _isActive = widget.country.isActive ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    super.dispose();
  }

  void _goBack() {
    widget.onUpdateRoute('country_models');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _goBack();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.arrow_back,
                size: 32.0,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Edit Country',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
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
                            controller: _abbreviationController,
                            decoration: const InputDecoration(
                              labelText: 'Abbreviation',
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
                        Switch(
                          value: _isActive,
                          onChanged: (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                          activeColor: Color(0xFF1D1C1E),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final editedName = _nameController.text;
                        final editedAbbreviation = _abbreviationController.text;

                        final editedCountry = Country(
                          id: widget.country.id,
                          name: editedName,
                          abbreviation: editedAbbreviation,
                          isActive: _isActive,
                        );

                        try {
                          await _countryService.update(editedCountry);

                          widget.onUpdateRoute('country_models');
                        } catch (error) {
                          print('Error saving country: $error');
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
                        minimumSize: Size(400, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
