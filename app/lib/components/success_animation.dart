import 'package:flutter/material.dart';

class SuccessAnimation extends StatefulWidget {
  final double size;
  final VoidCallback onComplete;

  const SuccessAnimation({super.key, this.size = 50, required this.onComplete});

  @override
  SuccessAnimationState createState() => SuccessAnimationState();
}

class SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addListener(() {
      setState(() {});
      if (_controller.status == AnimationStatus.completed && widget.onComplete != null) { // kan nooit null zijn, dus gaat altijd de if in
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
        painter: SuccessPainter(value: curve.value),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SuccessPainter extends CustomPainter {
  late Paint _paint;
  double value;

  SuccessPainter({required this.value}) {
    _paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = const Color.fromARGB(137, 105, 240, 175);

    // Draw the circular highlight
    _paint.color = const Color.fromARGB(82, 105, 240, 175);
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
  bool shouldRepaint(SuccessPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}