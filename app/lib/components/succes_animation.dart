import 'package:flutter/material.dart';
import 'package:angles/angles.dart';
import 'dart:math';

class CheckAnimation extends StatefulWidget {
  final double size;
  final VoidCallback onComplete;

  CheckAnimation({this.size = 50, required this.onComplete}); // Adjusted size to 50

  @override
  _CheckAnimationState createState() => _CheckAnimationState();
}

class _CheckAnimationState extends State<CheckAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this);
    curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addListener(() {
      setState(() {});
      if (_controller.status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      color: Colors.transparent,
      child: CustomPaint(
        painter: CheckPainter(value: curve.value),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CheckPainter extends CustomPainter {
  late Paint _paint;
  double value;

  late double _length;
  late double _offset;
  late double _startingAngle;

  CheckPainter({required this.value}) {
    _paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    _length = 20; // Adjusted length to make the animation smaller
    _offset = 0;
    _startingAngle = 205;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset(0, 0) & size;
    _paint.color = Colors.greenAccent.withOpacity(.05);

    // Draw the circular highlight
    _paint.color = Colors.greenAccent.withOpacity(0.3);
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 5.0;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, _paint);

    // Draw the checkmark
    _paint.color = Colors.greenAccent;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 5.0;

    double line1x1 = size.width * 0.2;
    double line1y1 = size.height * 0.5;
    double line1x2 = size.width * 0.45;
    double line1y2 = size.height * 0.7;

    double line2x1 = size.width * 0.45;
    double line2y1 = size.height * 0.7;
    double line2x2 = size.width * 0.8;
    double line2y2 = size.height * 0.3;

    double progress = value;

    if (progress < 0.5) {
      double x = line1x1 + (line1x2 - line1x1) * (progress / 0.5);
      double y = line1y1 + (line1y2 - line1y1) * (progress / 0.5);
      canvas.drawLine(Offset(line1x1, line1y1), Offset(x, y), _paint);
    } else {
      canvas.drawLine(Offset(line1x1, line1y1), Offset(line1x2, line1y2), _paint);
      double x = line2x1 + (line2x2 - line2x1) * ((progress - 0.5) / 0.5);
      double y = line2y1 + (line2y2 - line2y1) * ((progress - 0.5) / 0.5);
      canvas.drawLine(Offset(line2x1, line2y1), Offset(x, y), _paint);
    }
  }

  @override
  bool shouldRepaint(CheckPainter old) {
    return old.value != value;
  }
}