import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/reservations/services/reservation_service.dart';
import 'package:trash_track_admin/features/reservations/models/reservation.dart';
import 'package:trash_track_admin/shared/services/enums_service.dart';

class ReservationEditScreen extends StatefulWidget {
  final Reservation reservation;
  final Function(String) onUpdateRoute;

  ReservationEditScreen({required this.reservation, required this.onUpdateRoute});

  @override
  _ReservationEditScreenState createState() => _ReservationEditScreenState();
}

class _ReservationEditScreenState extends State<ReservationEditScreen> {
  late EnumsService _enumsService;
  late int _selectedReservationStatusIndex;
  late Map<int, String> _reservationStatus;
  bool _isLoading = true;
  final reservationService = ReservationService();

  @override
  void initState() {
    super.initState();
    _enumsService = EnumsService();
    _selectedReservationStatusIndex = widget.reservation.status!.index;
    _fetchReservationStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchReservationStatus() async {
    try {
      final typesData = await _enumsService.getReservationStatus();

      if (typesData is Map<int, String>) {
        setState(() {
          _reservationStatus = typesData;
          _isLoading = false;
        });
      } else {
        print('Received unexpected data format for reservation states: $typesData');
      }
    } catch (error) {
      print('Error fetching reservation states: $error');
    }
  }

  void _goBack() {
    widget.onUpdateRoute('reservations');
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
            const SizedBox(height: 100),
            Text(
              'Edit Reservation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
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
                            value: _selectedReservationStatusIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedReservationStatusIndex = newValue ?? 0;
                              });
                            },
                            items: _reservationStatus.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Reservation Status',
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
                  final selectedReservationStatus =
                      ReservationStatus.values[_selectedReservationStatusIndex];

                  final editedReservation = Reservation(
                    id: widget.reservation.id,
                    status: selectedReservationStatus,
                  );

                  try {
                    await reservationService.updateReservationStatus(editedReservation);

                    widget.onUpdateRoute('reservations');
                  } catch (error) {
                    print('Error saving reservation: $error');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    const Text('Save Reservation'),
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