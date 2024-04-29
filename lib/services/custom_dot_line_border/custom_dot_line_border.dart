import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DottedBorderUnderText extends SingleChildRenderObjectWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double gapWidth;

  DottedBorderUnderText({
    Key? key,
    required this.child,
    this.color = Colors.white,
    this.strokeWidth = 1.0,
    this.gapWidth = 3.0,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _DottedBorderUnderTextRenderObject(
      color: color,
      strokeWidth: strokeWidth,
      gapWidth: gapWidth,
    );
  }
}

class _DottedBorderUnderTextRenderObject extends RenderProxyBox {
  final Color color;
  final double strokeWidth;
  final double gapWidth;

  _DottedBorderUnderTextRenderObject({
    required this.color,
    required this.strokeWidth,
    required this.gapWidth,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    final Rect childRect = offset & size;

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = childRect.left;
    while (startX < childRect.right) {
      final double endX = startX + gapWidth;
      context.canvas.drawLine(
        Offset(startX, childRect.bottom),
        Offset(endX, childRect.bottom),
        paint,
      );
      startX = endX + gapWidth;
    }
  }
}