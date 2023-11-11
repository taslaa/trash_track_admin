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
  late TextEditingController _isActiveController;
  late CountriesService _countryService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _countryService = CountriesService();
    _nameController = TextEditingController(text: widget.country.name);
    _abbreviationController =
        TextEditingController(text: widget.country.abbreviation);
    _isActiveController = TextEditingController(
        text: widget.country.isActive.toString()); // Convert bool to string
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    _isActiveController.dispose();
    super.dispose();
  }

  void _goBack() {
    widget.onUpdateRoute('countries');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _goBack,
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Text(
                'Edit Country',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
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
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
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
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
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
                          labelText: 'Active',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () async {
                    // Get values from controllers and create a new Country object
                    final editedName = _nameController.text;
                    final editedAbbreviation = _abbreviationController.text;

                    final editedCountry = Country(
                      id: widget.country.id,
                      name: editedName,
                      abbreviation: editedAbbreviation,
                      isActive: _isActiveController.text == 'true',
                    );

                    // Update the country using your service
                    try {
                      await _countryService.update(editedCountry);

                      widget.onUpdateRoute('countries');
                    } catch (error) {
                      print('Error saving country: $error');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      const Text('Save'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF49464E),
                    minimumSize: Size(400, 48),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
