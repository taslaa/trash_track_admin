import 'package:flutter/material.dart';

class CountByRoleWidget extends StatelessWidget {
  final int administratorCount;
  final int userCount;
  final int driverCount;

  CountByRoleWidget({
    required this.administratorCount,
    required this.userCount,
    required this.driverCount,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(120, 120), // Adjust the size as needed
      painter: CountByRolePainter(
        administratorCount: administratorCount,
        userCount: userCount,
        driverCount: driverCount,
      ),
    );
  }
}

class CountByRolePainter extends CustomPainter {
  final int administratorCount;
  final int userCount;
  final int driverCount;

  CountByRolePainter({
    required this.administratorCount,
    required this.userCount,
    required this.driverCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = administratorCount + userCount + driverCount;

    final administratorAngle = (administratorCount / total) * 2 * 3.141592;
    final userAngle = (userCount / total) * 2 * 3.141592;
    final driverAngle = (driverCount / total) * 2 * 3.141592;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final administratorPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592,
      administratorAngle,
      true,
      administratorPaint,
    );

    final userPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592 + administratorAngle,
      userAngle,
      true,
      userPaint,
    );

    final driverPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592 + administratorAngle + userAngle,
      driverAngle,
      true,
      driverPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
