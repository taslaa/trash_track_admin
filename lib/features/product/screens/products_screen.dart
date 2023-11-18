import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';
import 'package:trash_track_admin/features/garbage/widgets/table_cell.dart';
import 'package:trash_track_admin/features/garbage/widgets/paging_component.dart';
import 'package:trash_track_admin/features/product/models/product.dart';
import 'package:trash_track_admin/features/product/services/products_service.dart';
import 'dart:typed_data';

class ProductScreen extends StatefulWidget {
  const ProductScreen(
      {Key? key, this.product, required this.onAdd, required this.onEdit})
      : super(key: key);

  final Product? product;
  final Function() onAdd;
  final Function(Product) onEdit;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductsService _productService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Product> _productModels = [];

  ProductType? _selectedProductType;
  String _name = '';

  int _currentPage = 1;
  int _itemsPerPage = 5;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _productService = context.read<ProductsService>();
    _initialValue = {
      'id': widget.product?.id.toString(),
      'name': widget.product?.name,
      'description': widget.product?.description,
      'code': widget.product?.code,
      'photo': widget.product?.photo,
      'price': widget.product?.price,
      'type': widget.product?.type,
    };

    _loadPagedProductModels();
  }

  Future<void> _loadPagedProductModels() async {
    try {
      final models = await _productService.getPaged(
        filter: {
          'name': _name,
          'productType': mapProductTypeToString(_selectedProductType),
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _productModels = models.items;
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String mapProductTypeToString(ProductType? productType) {
    switch (productType) {
      case ProductType.trashBag:
        return 'TrashBag';
      case ProductType.trashBin:
        return 'TrashBin';
      case ProductType.protectiveGear:
        return 'ProtectiveGear';
      default:
        return productType.toString(); // Default to enum value if not found
    }
  }

  void _deleteGarbageModel(int index) {
    final productModel = _productModels[index];
    final id = productModel.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _productService.remove(id);

        setState(() {
          _productModels.removeAt(index);
        });
      } catch (error) {
        print('Error deleting garbage model: $error');
      }
    });
  }

  Widget _base64ToImage(String base64String) {
    if (base64String.isNotEmpty) {
      try {
        return Image.memory(
          Uint8List.fromList(base64.decode(base64String)),
          fit: BoxFit.cover,
          width: 100, // Adjust the width as needed
          height: 100, // Adjust the height as needed
        );
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return SizedBox.shrink(); // Empty container if no photo
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product Model'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this product model?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1D1C1E),
                onPrimary: Colors.white,
              ),
              onPressed: () {
                onDeleteConfirmed();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _onEdit(Product product) async {
    widget.onEdit(product);
  }

  void _onAdd() async {
    widget.onAdd();
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedProductModels();
  }

  void _showPhotoModal(String base64Image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _base64ToImage(base64Image),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                      'Products',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Products.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _onAdd();
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('New Product'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1D1C1E),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
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
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                          _loadPagedProductModels();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
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
                      child: Container(
                        alignment: Alignment.center,
                        child: DropdownButtonFormField<ProductType>(
                          value: _selectedProductType,
                          onChanged: (newValue) {
                            print(newValue);
                            setState(() {
                              _selectedProductType = newValue;
                            });
                            _loadPagedProductModels();
                          },
                          items: [
                            DropdownMenuItem<ProductType>(
                              value: null,
                              child: Text('Choose the product type'),
                            ),
                            ...ProductType.values.map((type) {
                              return DropdownMenuItem<ProductType>(
                                value: type,
                                child: Text(mapProductTypeToString(type)),
                              );
                            }).toList(),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Color(0xFF49464E),
                          ),
                          icon: Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE0D8E0),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Table(
                border: TableBorder.all(
                  color: Colors.transparent,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F1FB),
                    ),
                    children: [
                      TableCellWidget(text: 'Name'),
                      TableCellWidget(text: 'Product Type'),
                      TableCellWidget(text: 'Description'),
                      TableCellWidget(text: 'Code'),
                      TableCellWidget(text: 'Price'),
                      TableCellWidget(text: 'Actions'),
                    ],
                  ),
                  if (_isLoading)
                    TableRow(
                      children: [
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._productModels.asMap().entries.map((entry) {
                      final index = entry.key;
                      final productModel = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: productModel.name ?? ''),
                          TableCellWidget(
                              text: mapProductTypeToString(productModel.type!)),
                          TableCellWidget(text: productModel.description ?? ''),
                          TableCellWidget(text: productModel.code ?? ''),
                          TableCellWidget(
                              text: '\$${productModel.price.toString()}'),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _deleteGarbageModel(index);
                                  },
                                  icon: Icon(Icons.delete,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showPhotoModal(productModel.photo!);
                                  },
                                  icon: Icon(Icons.photo,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _onEdit(productModel);
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PagingComponent(
        currentPage: _currentPage,
        itemsPerPage: _itemsPerPage,
        totalRecords: _totalRecords,
        onPageChange: _handlePageChange,
      ),
    );
  }
}
