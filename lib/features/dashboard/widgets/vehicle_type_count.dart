import 'dart:math';
import 'package:flutter/material.dart';

class CountByVehicleTypeWidget extends StatelessWidget {
  final int garbageTruckCount;
  final int truckCount;

  CountByVehicleTypeWidget({
    required this.garbageTruckCount,
    required this.truckCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, // Set the width and height to control the size
      height: 20,
      child: CustomPaint(
        size: Size(20, 20), // Adjust the size as needed for the drawing logic
        painter: CountByVehicleTypePainter(
          garbageTruckCount: garbageTruckCount,
          truckCount: truckCount,
        ),
      ),
    );
  }
}

class CountByVehicleTypePainter extends CustomPainter {
  final int garbageTruckCount;
  final int truckCount;

  CountByVehicleTypePainter({
    required this.garbageTruckCount,
    required this.truckCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = garbageTruckCount + truckCount;

    final garbageTruckAngle = (garbageTruckCount / total) * 2 * pi;
    final truckAngle = (truckCount / total) * 2 * pi;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final garbageTruckPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi,
      garbageTruckAngle,
      true,
      garbageTruckPaint,
    );

    final truckPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi + garbageTruckAngle,
      truckAngle,
      true,
      truckPaint,
    );

    drawText(canvas, garbageTruckCount.toString(), center,
        -pi + (garbageTruckAngle / 2), garbageTruckPaint, size);
    drawText(canvas, truckCount.toString(), center,
        -pi + garbageTruckAngle + (truckAngle / 2), truckPaint, size);
  }

  void drawText(Canvas canvas, String text, Offset center, double angle,
      Paint paint, Size size) {
    if (text == '0') {
      // Skip drawing text if the count is 0
      return;
    }

    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white, // Text color
        fontSize: 5.0, // Text size
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    final radius = size.width / 2;

    // Calculate the position to center the text within the sector
    final x = center.dx + (radius / 2) * cos(angle) - (textWidth / 2);
    final y = center.dy + (radius / 2) * sin(angle) - (textHeight / 2);

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
