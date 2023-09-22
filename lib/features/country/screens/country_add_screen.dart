import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';

class CountryAddScreen extends StatefulWidget {
  final Function(String) onUpdateRoute;

  const CountryAddScreen({
    required this.onUpdateRoute,
  });

  @override
  _CountryAddScreenState createState() => _CountryAddScreenState();
}

class _CountryAddScreenState extends State<CountryAddScreen> {
  late TextEditingController _nameController;
  late TextEditingController _abbreviationController;
  late TextEditingController _isActiveController;
  late CountriesService _countryService;

  @override
  void initState() {
    super.initState();
    _countryService = CountriesService();
    _nameController = TextEditingController();
    _abbreviationController = TextEditingController();
    _isActiveController = TextEditingController(text: 'true'); // Set the default value to 'true'
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    _isActiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
            const SizedBox(height: 16),
            Padding(
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
            const SizedBox(height: 16),
            Padding(
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
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Get values from controllers and create a new Country object
                final newCountry = Country(
                  name: _nameController.text,
                  abbreviation: _abbreviationController.text,
                  isActive: _isActiveController.text == 'true',
                );

                // Add the new country using your service
                try {
                  await _countryService.insert(newCountry);
                  
                  widget.onUpdateRoute('countries');
                } catch (error) {
                  print('Error adding country: $error');
                }
              },
              child: Text(
                'Add Country',
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
