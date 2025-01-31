// Flutter imports:
import 'package:flutter/material.dart';

class ThreeDotsWaitIndicator extends StatefulWidget {
  const ThreeDotsWaitIndicator({super.key});

  @override
  ThreeDotsWaitIndicatorState createState() => ThreeDotsWaitIndicatorState();
}

class ThreeDotsWaitIndicatorState extends State<ThreeDotsWaitIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 8.0, right: 4.0),
              child: Opacity(
                opacity: _animation.value > (index * 0.3) ? 1.0 : 0.0,
                child: const Dot(),
              ),
            );
          }),
        );
      },
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.blueGrey[200],
        shape: BoxShape.circle,
      ),
    );
  }
}
