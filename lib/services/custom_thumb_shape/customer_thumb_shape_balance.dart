import 'package:flutter/material.dart';

class CustomSliderComponentShape extends SliderComponentShape {
  final double diamondSize = 16.0;
  final double borderRadius = 6.0;


  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(diamondSize, diamondSize);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center,
      {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required Size sizeWithOverflow,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double textScaleFactor,
        required double value,
      }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = isDiscrete ? const Color(0xFF0334155) : Colors.grey
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = const Color(0xFFcbd5e1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;


    Path diamond = Path();
    diamond.moveTo(center.dx, center.dy - diamondSize / 2);
    diamond.lineTo(center.dx + diamondSize / 2, center.dy);
    diamond.lineTo(center.dx, center.dy + diamondSize / 2);
    diamond.lineTo(center.dx - diamondSize / 2, center.dy);
    diamond.close();

    canvas.drawPath(diamond, paint);
    canvas.drawPath(diamond, borderPaint);
  }
}
