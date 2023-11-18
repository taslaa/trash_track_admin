import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/city/widgets/paging_component.dart';
import 'package:trash_track_admin/features/order/models/order.dart';
import 'package:trash_track_admin/features/order/services/orders_service.dart';
import 'package:trash_track_admin/features/order/services/orders_service.dart';
import 'package:trash_track_admin/features/order/widgets/table_cell.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:trash_track_admin/features/user/models/user.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    Key? key,
    required this.onAdd,
  }) : super(key: key);

  final Function() onAdd;

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late OrdersService _orderService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Order> _orders = [];

  String _orderNumberFilter = '';
  String _isCanceledFilter = '';

  int _currentPage = 1;
  int _itemsPerPage = 5;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _orderService = context.read<OrdersService>();
    _initialValue = {
      'id': null,
      'orderNumber': null,
      'orderDate': null,
      'total': null,
      'userId': null,
      'user': null,
      'orderDetails': null,
    };

    _loadPagedOrders();
  }

  Future<void> _loadPagedOrders() async {
    try {
      final models = await _orderService.getPaged(
        filter: {
          'orderNumber': _orderNumberFilter,
          'isCanceled': _isCanceledFilter.toString(),
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _orders.clear(); // Clear the existing list
        _orders.addAll(models.items); // Add the fetched orders
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _onDeleteOrder(int index) async {
    final order = _orders[index];
    final id = order.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _orderService.remove(id);

        setState(() {
          _orders.removeAt(index);
        });
        await _loadPagedOrders(); // Wait for the load to complete before refreshing the list
      } catch (error) {
        print('Error deleting order: $error');
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this order?'),
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

  void _onAdd() async {
    widget.onAdd();
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedOrders();
  }

  void _cancelOrder(int index) async {
    final order = _orders[index];
    final orderId = order.id ?? 0;

    _showCancelConfirmationDialog(() async {
      try {
        await _orderService.toggleOrderStatus(orderId);

        await _loadPagedOrders();
      } catch (error) {
        print('Error canceling order: $error');
      }
    });
  }

  Future<void> _showCancelConfirmationDialog(Function onCancelConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel this order?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                onCancelConfirmed();
                Navigator.of(context).pop();
              },
              child: Text('Cancel Order'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1D1C1E),
                onPrimary: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showOrderDetailsModal(Order order) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (order.orderDetails != null &&
                    order.orderDetails!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text('Order Items:'),
                      for (var orderDetail in order.orderDetails!)
                        Text(
                            'Name: ${orderDetail.product!.name} - Quantity: ${orderDetail.quantity} - Price: ${orderDetail.product!.price}'),
                    ],
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
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
                      'Orders',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Orders.',
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
                            _orderNumberFilter = value;
                          });
                          _loadPagedOrders();
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
                        child: DropdownButtonFormField<String>(
                          value: _isCanceledFilter,
                          onChanged: (newValue) {
                            setState(() {
                              _isCanceledFilter = newValue ?? '';
                            });
                            _loadPagedOrders();
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: '', // Add the empty string value
                              child: Text('Choose Activity Status'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'false',
                              child: Text('Active'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'true',
                              child: Text('Canceled'),
                            ),
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
                      TableCellWidget(text: 'Order Number'),
                      TableCellWidget(text: 'Order Date'),
                      TableCellWidget(text: 'Total'),
                      TableCellWidget(text: 'User'),
                      TableCellWidget(text: 'Status'),
                      TableCellWidget(text: 'Details'),
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
                    ..._orders.asMap().entries.map((entry) {
                      final index = entry.key;
                      final order = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: order.orderNumber ?? ''),
                          TableCellWidget(
                            text: DateFormat('dd/MM/yyyy').format(
                              order.orderDate ?? DateTime.now(),
                            ),
                          ),
                          TableCellWidget(text: '\$${order.total.toString()}'),
                          TableCellWidget(
                            text: order.user?.firstName ?? '',
                          ),
                          TableCellWidget(
                            text: order.isCanceled! ? 'Canceled' : 'Active',
                          ),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showOrderDetailsModal(order);
                                  },
                                  child: Text('Products'),
                                ),
                                SizedBox(
                                    width: 8), // Add spacing between buttons
                                ElevatedButton(
                                  onPressed: () {
                                    _cancelOrder(index);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  child: Text('Cancel Order'),
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
