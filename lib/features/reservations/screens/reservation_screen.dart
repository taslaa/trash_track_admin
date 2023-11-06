import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/features/garbage/services/garbage_service.dart';
import 'package:trash_track_admin/features/garbage/widgets/table_cell.dart';
import 'package:trash_track_admin/features/garbage/widgets/paging_component.dart';
import 'package:trash_track_admin/features/reservations/models/reservation.dart';
import 'package:trash_track_admin/features/reservations/services/reservation_service.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key, this.reservation, required this.onEdit})
      : super(key: key);

  final Reservation? reservation;
  final Function(Reservation) onEdit;


  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late ReservationService _reservationService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Reservation> _reservations = [];

  ReservationStatus? _selectedReservationStatus;
  int _currentPage = 1;
  int _itemsPerPage = 3;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _reservationService = context.read<ReservationService>();
    _initialValue = {
      'id': widget.reservation?.id.toString() ?? '',
      'userId': widget.reservation?.userId,
      'user': widget.reservation?.user,
      'serviceId': widget.reservation?.serviceId,
      'service': widget.reservation?.service,
      'reservationStatus': widget.reservation?.status.toString(),
      'latitude': widget.reservation?.latitude,
      'longitude': widget.reservation?.longitude,
      'price': widget.reservation?.price
    };

    _loadPagedReservation();
  }

   String mapReservationStatusToString(ReservationStatus? status) {
    if (status == null) {
      return 'Unknown';
    }
    switch (status) {
      case ReservationStatus.inProgress:
        return 'In Progress';
      case ReservationStatus.done:
        return 'Done';
      default:
        return 'Unknown';
    }
  }

  Future<void> _loadPagedReservation() async {
    try {
      final models = await _reservationService.getPaged(
        filter: {
          'status': mapReservationStatusToString(_selectedReservationStatus),
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _reservations = models.items;
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _deleteReservation(int index) {
    final reservation = _reservations[index];
    final id = reservation.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _reservationService.remove(id);

        setState(() {
          _reservations.removeAt(index);
        });
      } catch (error) {
        print('Error deleting reservation: $error');
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Reservation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this reservation?'),
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

  void _onEdit(Reservation reservation) async {
    widget.onEdit(reservation);
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedReservation();
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
                      'Reservations',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Reservation.',
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
                        child: DropdownButtonFormField<ReservationStatus>(
                          value: _selectedReservationStatus,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedReservationStatus = newValue;
                            });
                            _loadPagedReservation();
                          },
                          items: [
                            DropdownMenuItem<ReservationStatus>(
                              value: null,
                              child: Text('Choose the reservation status'),
                            ),
                            ...ReservationStatus.values.map((type) {
                              return DropdownMenuItem<ReservationStatus>(
                                value: type,
                                child: Text(mapReservationStatusToString(
                                    type)), 
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
                      TableCellWidget(text: 'User'),
                      TableCellWidget(text: 'Service'),
                      TableCellWidget(text: 'Reservation Status'),
                      TableCellWidget(text: 'Longitude'),
                      TableCellWidget(text: 'Latitude'),
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
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._reservations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final reservation = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: reservation.user?.firstName ?? ''),
                          TableCellWidget(text: reservation.service?.name ?? ''),
                          TableCellWidget(
                              text: mapReservationStatusToString(
                                  reservation.status!)),
                          TableCellWidget(text: reservation.latitude?.toString() ?? ''),
                          TableCellWidget(text: reservation.longitude?.toString() ?? ''),
                          TableCellWidget(text: reservation.price?.toString() ?? ''),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _onEdit(reservation);
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteReservation(index);
                                  },
                                  icon: Icon(Icons.delete,
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
