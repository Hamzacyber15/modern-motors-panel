import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modern_motors_panel/app_theme.dart';

class MmloadingWidget extends StatefulWidget {
  const MmloadingWidget({super.key});

  @override
  State<MmloadingWidget> createState() => _MmloadingWidgetState();
}

class _MmloadingWidgetState extends State<MmloadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 140,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Clockwise arc
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size(90, 90),
                    painter: ArcPainter(AppTheme.orangeColor, 2, 0),
                  ),
                );
              },
            ),

            // Anticlockwise arc
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Transform.rotate(
                  angle: -_controller.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: ArcPainter(AppTheme.primaryColor, 2, math.pi / 2),
                  ),
                );
              },
            ),

            // Logo in center
            Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/mm_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Loading text
            Positioned(
              bottom: -30,
              child: Text(
                "loading".tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double startAngle;

  ArcPainter(this.color, this.strokeWidth, this.startAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, startAngle, math.pi * 1.5, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
