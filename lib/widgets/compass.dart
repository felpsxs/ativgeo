import 'dart:math';

import 'package:flutter/material.dart';

class Compass extends StatelessWidget {
  final double heading;

  const Compass({
    super.key,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: CompassPainter(heading: heading),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final double heading;

  CompassPainter({
    required this.heading,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blueAccent
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius - 3, circlePaint);

    canvas.save();

    canvas.translate(center.dx, center.dy);
    canvas.rotate((-90 + heading) * pi / 180);

    final tickPaint = Paint()..strokeWidth = 2;

    // Desenha os riscos da bússola
    for (int degree = 0; degree < 360; degree += 5) {
      final angle = degree * pi / 180;

      final isMajor = degree % 30 == 0;

      final innerRadius = isMajor ? radius - 25 : radius - 15;
      final outerRadius = radius - 5;

      final start = Offset(
        cos(angle) * innerRadius,
        sin(angle) * innerRadius,
      );

      final end = Offset(
        cos(angle) * outerRadius,
        sin(angle) * outerRadius,
      );

      canvas.drawLine(start, end, tickPaint);
    }

    const directions = {
      0: 'N',
      90: 'E',
      180: 'S',
      270: 'W',
    };

    // Posiciona os textos da bússola
    for (final entry in directions.entries) {
      final degree = entry.key;
      final text = entry.value;

      final angle = degree * pi / 180;

      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final textRadius = radius - 45;

      final position = Offset(
        cos(angle) * textRadius - textPainter.width / 2,
        sin(angle) * textRadius - textPainter.height / 2,
      );

      textPainter.paint(canvas, position);
    }

    canvas.restore();

    final centerPaint = Paint();

    canvas.drawCircle(
      center,
      5,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CompassPainter oldDelegate) {
    return oldDelegate.heading != heading;
  }
}