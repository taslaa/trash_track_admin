import 'dart:math';

import 'package:flutter/material.dart';

class CountByGarbageTypeWidget extends StatelessWidget {
  final int metalGarbageCount;
  final int glassGarbageCount;
  final int plasticGarbageCount;
  final int organicGarbageCount;

  CountByGarbageTypeWidget({
    required this.metalGarbageCount,
    required this.glassGarbageCount,
    required this.plasticGarbageCount,
    required this.organicGarbageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, // Set the width and height to control the size
      height: 20,
      child: CustomPaint(
        size: Size(20, 20), // Adjust the size as needed for the drawing logic
        painter: CountByGarbageTypePainter(
          metalGarbageCount: metalGarbageCount,
          glassGarbageCount: glassGarbageCount,
          plasticGarbageCount: plasticGarbageCount,
          organicGarbageCount: organicGarbageCount,
        ),
      ),
    );
  }
}

class CountByGarbageTypePainter extends CustomPainter {
  final int metalGarbageCount;
  final int glassGarbageCount;
  final int plasticGarbageCount;
  final int organicGarbageCount;

  CountByGarbageTypePainter({
    required this.metalGarbageCount,
    required this.glassGarbageCount,
    required this.plasticGarbageCount,
    required this.organicGarbageCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = metalGarbageCount +
        glassGarbageCount +
        plasticGarbageCount +
        organicGarbageCount;

    final metalGarbageAngle = (metalGarbageCount / total) * 2 * pi;
    final glassGarbageAngle = (glassGarbageCount / total) * 2 * pi;
    final plasticGarbageAngle = (plasticGarbageCount / total) * 2 * pi;
    final organicGarbageAngle = (organicGarbageCount / total) * 2 * pi;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final metalGarbagePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi,
      metalGarbageAngle,
      true,
      metalGarbagePaint,
    );

    final glassGarbagePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi + metalGarbageAngle,
      glassGarbageAngle,
      true,
      glassGarbagePaint,
    );

    final plasticGarbagePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi + metalGarbageAngle + glassGarbageAngle,
      plasticGarbageAngle,
      true,
      plasticGarbagePaint,
    );

    final organicGarbagePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi + metalGarbageAngle + glassGarbageAngle + plasticGarbageAngle,
      organicGarbageAngle,
      true,
      organicGarbagePaint,
    );

    // Display the garbage type counts within their respective sectors
    drawText(canvas, metalGarbageCount.toString(), center,
        -pi + (metalGarbageAngle / 2), metalGarbagePaint, size);
    drawText(
        canvas,
        glassGarbageCount.toString(),
        center,
        -pi + metalGarbageAngle + (glassGarbageAngle / 2),
        glassGarbagePaint,
        size);
    drawText(
        canvas,
        plasticGarbageCount.toString(),
        center,
        -pi + metalGarbageAngle + glassGarbageAngle + (plasticGarbageAngle / 2),
        plasticGarbagePaint,
        size);
    drawText(
        canvas,
        organicGarbageCount.toString(),
        center,
        -pi +
            metalGarbageAngle +
            glassGarbageAngle +
            plasticGarbageAngle +
            (organicGarbageAngle / 2),
        organicGarbagePaint,
        size);
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
