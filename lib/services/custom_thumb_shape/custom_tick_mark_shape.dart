import 'package:flutter/material.dart';

class CustomTickMarkShape extends SliderTickMarkShape {
  final double diamondSize = 8.0;

  @override
  Size getPreferredSize({required bool isEnabled,required SliderThemeData sliderTheme}) {
    return Size(diamondSize, diamondSize);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        required bool isEnabled,
      }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = isEnabled ? const Color(0xFFcbd5e1) : const Color(0xFF0f172a)
      ..style = isEnabled ? PaintingStyle.fill : PaintingStyle.stroke ;

    Path diamond = Path();
    diamond.moveTo(center.dx, center.dy - diamondSize / 2);
    diamond.lineTo(center.dx + diamondSize / 2, center.dy);
    diamond.lineTo(center.dx, center.dy + diamondSize / 2);
    diamond.lineTo(center.dx - diamondSize / 2, center.dy);
    diamond.close();

    canvas.drawPath(diamond, paint);
  }
}
