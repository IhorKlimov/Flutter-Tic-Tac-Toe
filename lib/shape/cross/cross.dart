import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/shape/cross/cross_painter.dart';

class Cross extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CrossState();
}

class CrossState extends State<Cross>
    with SingleTickerProviderStateMixin {
  CrossPainter painter;
  Animation<double> animation;
  AnimationController controller;
  double fraction = 0.0;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    painter = CrossPainter(fraction);
    return CustomPaint(painter: painter);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}


