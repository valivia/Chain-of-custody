import 'package:flutter/material.dart';

class FailedAnimation extends StatefulWidget {
  final double size;
  final VoidCallback onComplete;

  FailedAnimation({this.size = 100, required this.onComplete});

  @override
  _FailedAnimationState createState() => _FailedAnimationState();
}

class _FailedAnimationState extends State<FailedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
      if (_controller.status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 5.0),
        ),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: CrossPainter(_animation),
            );
          },
        ),
      ),
    );
  }
}

class CrossPainter extends CustomPainter {
  final Animation<double> animation;

  CrossPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double progress = animation.value;

    if (progress < 0.5) {
      final double x = size.width * 0.2 + (size.width * 0.6 * (progress / 0.5));
      final double y = size.height * 0.2 + (size.height * 0.6 * (progress / 0.5));
      path.moveTo(size.width * 0.2, size.height * 0.2);
      path.lineTo(x, y);
    } else {
      path.moveTo(size.width * 0.2, size.height * 0.2);
      path.lineTo(size.width * 0.8, size.height * 0.8);
      final double x = size.width * 0.8 - (size.width * 0.6 * ((progress - 0.5) / 0.5));
      final double y = size.height * 0.2 + (size.height * 0.6 * ((progress - 0.5) / 0.5));
      path.moveTo(size.width * 0.8, size.height * 0.2);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}