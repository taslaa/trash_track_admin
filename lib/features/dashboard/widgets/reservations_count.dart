import 'package:flutter/material.dart';

class CountReservationsWidget extends StatelessWidget {
  final int reservationCount;

  CountReservationsWidget({
    required this.reservationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        reservationCount.toString(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
