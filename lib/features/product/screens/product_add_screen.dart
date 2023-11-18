import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/product/models/product.dart';
import 'package:trash_track_admin/features/product/services/products_service.dart';
import 'package:trash_track_admin/shared/services/enums_service.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class ProductAddScreen extends StatefulWidget {
  final Function(String) onUpdateRoute;

  ProductAddScreen({required this.onUpdateRoute});

  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  late EnumsService _enumsService;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _codeController;
  late TextEditingController _photoController;
  late TextEditingController _priceController;
  late int _selectedProductTypeIndex;
  late Map<int, String> _productTypes;
  bool _isLoading = true;
  final productService = ProductsService();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _enumsService = EnumsService();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _codeController = TextEditingController();
    _photoController = TextEditingController();
    _priceController = TextEditingController();
    _selectedProductTypeIndex = 0;
    _fetchProductTypes();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _photoController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _fetchProductTypes() async {
    try {
      final typesData = await _enumsService.getProductTypes();

      if (typesData is Map<int, String>) {
        setState(() {
          _productTypes = typesData;
          _isLoading = false;
        });
      } else {
        print('Received unexpected data format for product types: $typesData');
      }
    } catch (error) {
      print('Error fetching product types: $error');
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.single;

      setState(() {
        _photoController.text = file.name;
      });

      List<int> fileBytes = await File(file.path!).readAsBytes();

      String base64Image = base64Encode(fileBytes);

      _photoController.text = base64Image;

      print('Selected image: $base64Image');
    }
  }

  void _goBack() {
    widget.onUpdateRoute('product');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
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
            const SizedBox(height: 50),
            Text(
              'Add Product',
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Code',
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
            const SizedBox(height: 16),
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
                  child: SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      onPressed: () => _pickFile(), // or ImageSource.camera
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo),
                          const SizedBox(width: 8),
                          const Text('Pick Photo'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF49464E),
                        minimumSize: Size(400, 48),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price',
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
            const SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
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
                          child: DropdownButtonFormField<int>(
                            value: _selectedProductTypeIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedProductTypeIndex = newValue ?? 0;
                              });
                            },
                            items: _productTypes.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Product Type',
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
            const SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () async {
                  final selectedProductType =
                      ProductType.values[_selectedProductTypeIndex];

                  final newName = _nameController.text;
                  final newDescription = _descriptionController.text;
                  final newCode = _codeController.text;
                  final newPrice =
                      double.tryParse(_priceController.text) ?? 0.0;

                  final newProduct = Product(
                    name: newName,
                    description: newDescription,
                    code: newCode,
                    photo:
                        _photoController.text, // Use the base64-encoded photo
                    price: newPrice,
                    type: selectedProductType,
                  );

                  try {
                    await productService.insert(newProduct);

                    widget.onUpdateRoute('product');
                  } catch (error) {
                    print('Error adding product: $error');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    const Text('Add Product'),
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
    );
  }
}
