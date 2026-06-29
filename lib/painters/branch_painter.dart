import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/element_model.dart';

class BranchPainter {
  static void draw(Canvas canvas, CanvasElement el) {
    canvas.save();
    canvas.translate(el.x, el.y);
    final rad = el.angle * math.pi / 180;
    canvas.rotate(rad);
    if (el.flip) canvas.scale(1, -1);

    final paint = Paint()
      ..color = el.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = el.thickness
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final len = el.length;

    switch (el.shape) {
      case 'straight':
        path.moveTo(0, 0);
        path.lineTo(len, 0);
        break;
      case 'curved':
        path.moveTo(0, 0);
        path.quadraticBezierTo(len * 0.5, -el.curve, len, 0);
        break;
      case 'drooping':
        path.moveTo(0, 0);
        path.quadraticBezierTo(len * 0.5, el.curve, len, el.curve * 0.5);
        break;
      case 'forked':
        final split = len * 0.55;
        path.moveTo(0, 0);
        path.lineTo(split, 0);
        canvas.drawPath(path, paint);
        final p2 = Path()
          ..moveTo(split, 0)
          ..lineTo(len, -(len - split) * 0.5);
        final p3 = Path()
          ..moveTo(split, 0)
          ..lineTo(len, (len - split) * 0.4);
        canvas.drawPath(p2, paint..strokeWidth = el.thickness * 0.7);
        canvas.drawPath(p3, paint..strokeWidth = el.thickness * 0.7);
        canvas.restore();
        _drawNode(canvas, el);
        return;
      case 'wavy':
        path.moveTo(0, 0);
        path.cubicTo(
          len * 0.25, -el.curve,
          len * 0.75, el.curve,
          len, 0,
        );
        break;
      default:
        path.moveTo(0, 0);
        path.lineTo(len, 0);
    }

    canvas.drawPath(path, paint);
    canvas.restore();
    _drawNode(canvas, el);
  }

  static void _drawNode(Canvas canvas, CanvasElement el) {
    final rad = el.angle * math.pi / 180;
    final nx = el.x + math.cos(rad) * el.length;
    final ny = el.y + math.sin(rad) * el.length;

    canvas.save();
    canvas.translate(nx, ny);
    canvas.rotate(el.nodeRotation * math.pi / 180);

    final r = el.nodeRadius;
    final nodePaint = Paint()
      ..color = el.nodeColor
      ..style = PaintingStyle.fill;
    final nodeStroke = Paint()
      ..color = _shade(el.nodeColor, -40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset.zero, r, nodePaint);
    canvas.drawCircle(Offset.zero, r, nodeStroke);

    if (el.nodeName.isNotEmpty) {
      final maxChars = el.nodeName.length > 4 ? 4 : el.nodeName.length;
      final tp = TextPainter(
        text: TextSpan(
          text: el.nodeName.substring(0, maxChars),
          style: TextStyle(
            color: const Color(0xFF1A0F00),
            fontSize: math.max(7, r * 0.65),
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    }

    canvas.restore();
  }

  static Color _shade(Color c, int amount) => Color.fromARGB(
    c.alpha,
    (c.red + amount * 2).clamp(0, 255),
    (c.green + amount * 2).clamp(0, 255),
    (c.blue + amount * 2).clamp(0, 255),
  );
}
