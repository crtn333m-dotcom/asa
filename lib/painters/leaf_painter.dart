import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/element_model.dart';

class LeafPainter {
  static void draw(Canvas canvas, CanvasElement el) {
    canvas.save();
    canvas.translate(el.x, el.y);
    canvas.rotate(el.leafAngle * math.pi / 180);

    final w = el.leafWidth;
    final h = el.leafHeight;

    final grad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [_lighten(el.leafColor, 20), el.leafColor],
    ).createShader(Rect.fromLTWH(-w / 2, -h / 2, w, h));

    final fill = Paint()..shader = grad..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = _shade(el.leafColor, -30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = _buildPath(el.shape, w, h);
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // عرق الورقة
    final veinPaint = Paint()
      ..color = _shade(el.leafColor, -25).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    canvas.drawLine(Offset(0, -h * 0.35), Offset(0, h * 0.35), veinPaint);

    // الاسم
    if (el.leafName.isNotEmpty) {
      canvas.rotate(-math.pi / 2);
      final maxC = el.leafName.length > 8 ? 8 : el.leafName.length;
      final tp = TextPainter(
        text: TextSpan(
          text: el.leafName.substring(0, maxC),
          style: TextStyle(
            color: Colors.white,
            fontSize: math.max(8, w * 0.22),
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            shadows: const [Shadow(blurRadius: 3, color: Colors.black54)],
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    }

    canvas.restore();
  }

  static Path _buildPath(String shape, double w, double h) {
    final path = Path();
    switch (shape) {
      case 'oval':
        path.addOval(Rect.fromLTWH(-w / 2, -h / 2, w, h));
        break;
      case 'heart':
        path.moveTo(0, h * 0.3);
        path.cubicTo(-w / 2, 0, -w / 2, -h / 2, 0, -h * 0.25);
        path.cubicTo(w / 2, -h / 2, w / 2, 0, 0, h * 0.3);
        break;
      case 'pointed':
        path.moveTo(0, -h / 2);
        path.quadraticBezierTo(w / 2, 0, 0, h / 2);
        path.quadraticBezierTo(-w / 2, 0, 0, -h / 2);
        break;
      case 'round':
        final r = math.min(w, h) / 2;
        path.addOval(Rect.fromCircle(center: Offset.zero, radius: r));
        break;
      case 'maple':
        final r = math.min(w, h) / 2;
        for (int i = 0; i < 7; i++) {
          final a1 = -math.pi / 2 + (i * 2 * math.pi) / 7;
          final a2 = a1 + math.pi / 7;
          if (i == 0) {
            path.moveTo(math.cos(a1) * r, math.sin(a1) * r);
          } else {
            path.lineTo(math.cos(a1) * r, math.sin(a1) * r);
          }
          path.lineTo(math.cos(a2) * r * 0.5, math.sin(a2) * r * 0.5);
        }
        path.close();
        break;
      default:
        path.addOval(Rect.fromLTWH(-w / 2, -h / 2, w, h));
    }
    return path;
  }

  static Color _shade(Color c, int a) => Color.fromARGB(
    c.alpha, (c.red + a * 2).clamp(0, 255),
    (c.green + a * 2).clamp(0, 255), (c.blue + a * 2).clamp(0, 255));

  static Color _lighten(Color c, int a) => _shade(c, a);
}
