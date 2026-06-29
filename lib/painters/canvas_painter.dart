import 'package:flutter/material.dart';
import '../models/element_model.dart';
import '../models/layer_model.dart';
import 'trunk_painter.dart';
import 'branch_painter.dart';
import 'leaf_painter.dart';

class MainCanvasPainter extends CustomPainter {
  final List<CanvasElement> elements;
  final List<LayerModel> layers;
  final String? selected;
  final Color bgColor;

  MainCanvasPainter({
    required this.elements,
    required this.layers,
    required this.selected,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // خلفية
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bgColor,
    );

    for (final el in elements) {
      final layer = layers.where((l) => l.id == el.id).firstOrNull;
      if (layer?.visible == false) continue;

      switch (el.type) {
        case ElementType.trunk:
          TrunkPainter.draw(canvas, el);
          break;
        case ElementType.branch:
          BranchPainter.draw(canvas, el);
          break;
        case ElementType.leaf:
          LeafPainter.draw(canvas, el);
          break;
      }

      // مؤشر التحديد
      if (el.id == selected) {
        _drawSelectionRing(canvas, el);
      }
    }
  }

  void _drawSelectionRing(Canvas canvas, CanvasElement el) {
    double cx = el.x, cy = el.y, r = 40;
    if (el.type == ElementType.trunk) {
      cx = el.x;
      cy = el.y + el.height / 2;
      r = (el.width > el.height ? el.width : el.height) * 0.4;
    }
    canvas.drawCircle(
      Offset(cx, cy), r,
      Paint()
        ..color = const Color(0xFFC9A84C).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(MainCanvasPainter old) => true;
}
