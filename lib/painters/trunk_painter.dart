import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/element_model.dart';

class TrunkPainter {
  static void draw(Canvas canvas, CanvasElement el) {
    canvas.save();
    canvas.translate(el.x, el.y);
    canvas.rotate(el.rotation * math.pi / 180);

    final w = el.width;
    final h = el.height;

    final grad = LinearGradient(
      colors: [
        _shade(el.color, -30),
        el.color,
        _shade(el.color, -30),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromLTWH(-w / 2, 0, w, h));

    final paint = Paint()..shader = grad..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = _shade(el.color, -40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    switch (el.shape) {
      case 'classic':
        path.moveTo(-w * 0.5, h);
        path.quadraticBezierTo(-w * 0.3, h * 0.5, -w * 0.15, 0);
        path.lineTo(w * 0.15, 0);
        path.quadraticBezierTo(w * 0.3, h * 0.5, w * 0.5, h);
        break;
      case 'wide':
        path.moveTo(-w * 0.7, h);
        path.quadraticBezierTo(-w * 0.4, h * 0.5, -w * 0.2, 0);
        path.lineTo(w * 0.2, 0);
        path.quadraticBezierTo(w * 0.4, h * 0.5, w * 0.7, h);
        break;
      case 'twisted':
        path.moveTo(-w * 0.5, h);
        path.cubicTo(-w * 0.1, h * 0.7, -w * 0.4, h * 0.3, -w * 0.1, 0);
        path.lineTo(w * 0.1, 0);
        path.cubicTo(w * 0.4, h * 0.3, w * 0.1, h * 0.7, w * 0.5, h);
        break;
      case 'slim':
        path.moveTo(-w * 0.25, h);
        path.quadraticBezierTo(-w * 0.12, h * 0.5, -w * 0.07, 0);
        path.lineTo(w * 0.07, 0);
        path.quadraticBezierTo(w * 0.12, h * 0.5, w * 0.25, h);
        break;
      case 'ancient':
        path.moveTo(-w * 0.6, h);
        path.cubicTo(-w * 0.5, h * 0.8, -w * 0.6, h * 0.5, -w * 0.2, h * 0.3);
        path.cubicTo(-w * 0.3, h * 0.15, -w * 0.15, h * 0.05, 0, 0);
        path.cubicTo(w * 0.15, h * 0.05, w * 0.3, h * 0.15, w * 0.2, h * 0.3);
        path.cubicTo(w * 0.6, h * 0.5, w * 0.5, h * 0.8, w * 0.6, h);
        break;
      default:
        path.addRect(Rect.fromLTWH(-w / 2, 0, w, h));
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    // خطوط اللحاء
    final barkPaint = Paint()
      ..color = _shade(el.color, -20).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (int i = 1; i < 5; i++) {
      final ly = h / 5 * i;
      final lx = -w * 0.3 + math.sin(i * 1.5) * 8;
      final bp = Path()
        ..moveTo(lx, ly)
        ..quadraticBezierTo(lx + 10, ly - 4, lx + 20, ly + 2);
      canvas.drawPath(bp, barkPaint);
    }

    // أسماء الجذع
    if (el.names.isNotEmpty) {
      for (final n in el.names) {
        final ny = -(h * n.posY / 100);
        canvas.save();
        canvas.translate(0, ny);
        canvas.rotate(-math.pi / 2);
        final tp = TextPainter(
          text: TextSpan(
            text: n.text,
            style: const TextStyle(
              color: Color(0xFF5C3D1E),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          textDirection: TextDirection.rtl,
        )..layout();
        tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
        canvas.restore();
      }
    }

    canvas.restore();
  }

  static Color _shade(Color c, int amount) {
    return Color.fromARGB(
      c.alpha,
      (c.red + amount * 2).clamp(0, 255),
      (c.green + amount * 2).clamp(0, 255),
      (c.blue + amount * 2).clamp(0, 255),
    );
  }
}
