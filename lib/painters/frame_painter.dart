import 'package:flutter/material.dart';
import 'dart:math' as math;

class FramePainter {
  static void draw(Canvas canvas, Size size, String frameType, Color color) {
    switch (frameType) {
      case 'simple':    _simple(canvas, size, color); break;
      case 'geometric': _geometric(canvas, size, color); break;
      case 'arabesque': _arabesque(canvas, size, color); break;
      case 'calligraphy': _calligraphy(canvas, size, color); break;
      case 'floral':    _floral(canvas, size, color); break;
    }
  }

  static void _simple(Canvas canvas, Size s, Color c) {
    const m = 12.0;
    final p = Paint()..color = c.withOpacity(0.7)
      ..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawRect(Rect.fromLTRB(m, m, s.width - m, s.height - m), p);
    p.strokeWidth = 0.5;
    canvas.drawRect(Rect.fromLTRB(m+6, m+6, s.width-m-6, s.height-m-6), p);
    final fp = Paint()..color = c.withOpacity(0.5)..style = PaintingStyle.fill;
    for (final corner in [
      Offset(m, m), Offset(s.width-m, m),
      Offset(s.width-m, s.height-m), Offset(m, s.height-m)
    ]) {
      canvas.drawCircle(corner, 4, fp);
    }
  }

  static void _geometric(Canvas canvas, Size s, Color c) {
    _simple(canvas, s, c);
    const m = 14.0;
    const cs = 36.0;
    final corners = [
      [Offset(m, m), 0.0],
      [Offset(s.width-m, m), math.pi/2],
      [Offset(s.width-m, s.height-m), math.pi],
      [Offset(m, s.height-m), -math.pi/2],
    ];
    final p = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = 1;
    for (final corner in corners) {
      canvas.save();
      canvas.translate((corner[0] as Offset).dx, (corner[0] as Offset).dy);
      canvas.rotate(corner[1] as double);
      for (int i = 0; i < 3; i++) {
        final path = Path()
          ..moveTo(0, 0)..lineTo(cs - i*10, 0)..lineTo(0, cs - i*10)..close();
        canvas.drawPath(path, p..color = c.withOpacity(0.3 - i * 0.07));
      }
      canvas.restore();
    }
  }

  static void _arabesque(Canvas canvas, Size s, Color c) {
    _simple(canvas, s, c);
    const m = 16.0;
    const step = 40.0;
    final p = Paint()..color = c.withOpacity(0.45)
      ..style = PaintingStyle.stroke..strokeWidth = 0.8;
    for (double x = m; x < s.width - m; x += step) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(x + step/2, m), width: step, height: step),
        math.pi, math.pi, false, p);
      canvas.drawArc(
        Rect.fromCenter(center: Offset(x + step/2, s.height-m), width: step, height: step),
        0, math.pi, false, p);
    }
    for (double y = m; y < s.height - m; y += step) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(m, y + step/2), width: step, height: step),
        math.pi/2, math.pi, false, p);
      canvas.drawArc(
        Rect.fromCenter(center: Offset(s.width-m, y + step/2), width: step, height: step),
        -math.pi/2, math.pi, false, p);
    }
  }

  static void _calligraphy(Canvas canvas, Size s, Color c) {
    _simple(canvas, s, c);
    const m = 14.0;
    final ornaments = ['✦', '❁', '✦', '❀'];
    final corners = [
      Offset(m+20, m+20), Offset(s.width-m-20, m+20),
      Offset(m+20, s.height-m-20), Offset(s.width-m-20, s.height-m-20),
    ];
    for (int i = 0; i < corners.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: ornaments[i],
          style: TextStyle(color: c.withOpacity(0.5), fontSize: 14)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, corners[i] - Offset(tp.width/2, tp.height/2));
    }
  }

  static void _floral(Canvas canvas, Size s, Color c) {
    _simple(canvas, s, c);
    const m = 14.0;
    const step = 55.0;
    final fp = Paint()..color = c.withOpacity(0.55)..style = PaintingStyle.fill;
    final positions = <Offset>[];
    for (double x = m + step; x < s.width - m; x += step) {
      positions.add(Offset(x, m+4));
      positions.add(Offset(x, s.height-m-4));
    }
    for (double y = m + step; y < s.height - m; y += step) {
      positions.add(Offset(m+4, y));
      positions.add(Offset(s.width-m-4, y));
    }
    for (final pos in positions) {
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      for (int p = 0; p < 6; p++) {
        final a = p * math.pi * 2 / 6;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(math.cos(a)*4, math.sin(a)*4), width: 6, height: 4),
          fp);
      }
      canvas.drawCircle(Offset.zero, 2,
        fp..color = c.withOpacity(0.8));
      canvas.restore();
    }
  }
}
