import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';
import 'package:trash_track_admin/features/services/models/service.dart';
import 'package:trash_track_admin/features/services/service/services_service.dart';

class ServiceEditScreen extends StatefulWidget {
  final Service service;
  final Function(String) onUpdateRoute;

  ServiceEditScreen({required this.service, required this.onUpdateRoute});

  @override
  _ServiceEditScreenState createState() => _ServiceEditScreenState();
}

class _ServiceEditScreenState extends State<ServiceEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late ServicesService _servicesService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _servicesService = ServicesService();
    _nameController = TextEditingController(text: widget.service.name);
    _descriptionController =
        TextEditingController(text: widget.service.description);
    _priceController = TextEditingController(
        text: widget.service.price?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _goBack() {
    widget.onUpdateRoute('services');
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
                'Edit Service',
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
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
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
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: const Color(0xFF49464E),
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
                    final editedName = _nameController.text;
                    final editedDescription = _descriptionController.text;

                    final editedService = Service(
                      id: widget.service.id,
                      name: editedName,
                      description: editedDescription,
                      price: double.tryParse(_priceController.text)
                    );

                    try {
                      await _servicesService.update(editedService);

                      widget.onUpdateRoute('service_models');
                    } catch (error) {
                      print('Error saving service: $error');
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
