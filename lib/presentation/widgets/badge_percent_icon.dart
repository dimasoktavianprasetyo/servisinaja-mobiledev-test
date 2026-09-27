import 'package:flutter/material.dart';

class BadgePercentIcon extends StatelessWidget {
  final double size;
  final Color color;

  const BadgePercentIcon({
    super.key,
    this.size = 24,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _BadgePercentPainter(color: color),
      ),
    );
  }
}

class _BadgePercentPainter extends CustomPainter {
  final Color color;

  _BadgePercentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(3.85 * scale, 8.62 * scale);
    path.arcToPoint(
      Offset(8.63 * scale, 3.85 * scale),
      radius: Radius.circular(4 * scale),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(15.37 * scale, 3.85 * scale),
      radius: Radius.circular(4 * scale),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(20.15 * scale, 8.63 * scale),
      radius: Radius.circular(4 * scale),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(20.15 * scale, 15.37 * scale),
      radius: Radius.circular(4 * scale),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(15.37 * scale, 20.15 * scale),
      radius: Radius.circular(4 * scale),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(8.63 * scale, 20.15 * scale),
      radius: Radius.circular(4 * scale),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(3.85 * scale, 15.37 * scale),
      radius: Radius.circular(4 * scale),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(3.85 * scale, 8.62 * scale),
      radius: Radius.circular(4 * scale),
      clockwise: true,
    );
    path.close();

    canvas.drawPath(path, strokePaint);

    // Percentage divider line
    canvas.drawLine(
      Offset(15 * scale, 9 * scale),
      Offset(9 * scale, 15 * scale),
      strokePaint,
    );

    // Percentage dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(9 * scale, 9 * scale), 1.25 * scale, dotPaint);
    canvas.drawCircle(Offset(15 * scale, 15 * scale), 1.25 * scale, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _BadgePercentPainter oldDelegate) =>
      oldDelegate.color != color;
}
