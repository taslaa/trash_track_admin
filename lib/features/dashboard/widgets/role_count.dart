import 'dart:math';

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
      ..color = Colors.red // Color for users
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592 + administratorAngle,
      userAngle,
      true,
      userPaint,
    );

    final driverPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592 + administratorAngle + userAngle,
      driverAngle,
      true,
      driverPaint,
    );

    // Display the role counts within their respective sectors
    drawText(canvas, administratorCount.toString(), center, -3.141592 + (administratorAngle / 2), administratorPaint, size);
    drawText(canvas, userCount.toString(), center, -3.141592 + administratorAngle + (userAngle / 2), userPaint, size);
    drawText(canvas, driverCount.toString(), center, -3.141592 + administratorAngle + userAngle + (driverAngle / 2), driverPaint, size);
  }

  void drawText(Canvas canvas, String text, Offset center, double angle, Paint paint, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white, // Text color
        fontSize: 18.0, // Text size
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    final radius = size.width / 2;
    final x = center.dx + (radius / 1.5) * cos(angle) - (textWidth / 2);
    final y = center.dy + (radius / 1.5) * sin(angle) - (textHeight / 2);

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

