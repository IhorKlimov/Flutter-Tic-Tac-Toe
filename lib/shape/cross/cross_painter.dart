import 'package:flutter/material.dart';

class CrossPainter extends CustomPainter {
  Paint _paint;
  double _fraction;

  CrossPainter(this._fraction) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size) {
    double leftLineFraction, rightLineFraction;

    if (_fraction < .5) {
      leftLineFraction = _fraction / .5;
      rightLineFraction = 0.0;
    } else {
      leftLineFraction = 1.0;
      rightLineFraction = (_fraction - .5) / .5;
    }

    canvas.drawLine(
        Offset(0.0, 0.0),
        Offset(size.width * leftLineFraction, size.height * leftLineFraction),
        _paint);

    if (_fraction >= .5) {
      canvas.drawLine(
              Offset(size.width, 0.0),
              Offset(size.width - size.width * rightLineFraction,
                  size.height * rightLineFraction),
              _paint);
    }
  }

  @override
  bool shouldRepaint(CrossPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}
