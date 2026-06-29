import 'package:flutter/material.dart';
import '../models/element_model.dart';
import '../models/layer_model.dart';

int _idCounter = 0;
String _nextId() => 'el_${_idCounter++}';

class CanvasProvider extends ChangeNotifier {
  List<CanvasElement> elements = [];
  List<LayerModel> layers = [];
  String? selected;
  bool hasTrunk = false;
  Color bgColor = const Color(0xFFFDF6E3);

  CanvasElement? get selectedElement =>
      elements.where((e) => e.id == selected).firstOrNull;

  LayerModel? layerOf(String id) =>
      layers.where((l) => l.id == id).firstOrNull;

  // ── إضافة جذع ──────────────────────────────────────────────
  void addTrunk(String shape, double cx, double cy) {
    if (hasTrunk) return;
    final el = CanvasElement(
      id: _nextId(), type: ElementType.trunk,
      x: cx, y: cy, shape: shape,
      width: 60, height: 220,
      color: const Color(0xFF7A5210),
    );
    elements.add(el);
    layers.add(LayerModel(id: el.id, name: 'الجذع', type: LayerType.trunk));
    hasTrunk = true;
    selected = el.id;
    notifyListeners();
  }

  // ── إضافة غصن ──────────────────────────────────────────────
  void addBranch(String shape, String? attachId, double cx, double cy) {
    final el = CanvasElement(
      id: _nextId(), type: ElementType.branch,
      x: cx, y: cy, shape: shape,
      length: 100, thickness: 8, angle: -45,
      color: const Color(0xFF7A5210),
      nodeColor: const Color(0xFFC9A84C),
      attachTo: attachId,
    );
    elements.add(el);
    layers.add(LayerModel(id: el.id, name: 'غصن', type: LayerType.branch));
    selected = el.id;
    notifyListeners();
  }

  // ── إضافة ورقة ──────────────────────────────────────────────
  void addLeaf(String shape, String? attachId, double cx, double cy) {
    final el = CanvasElement(
      id: _nextId(), type: ElementType.leaf,
      x: cx, y: cy, shape: shape,
      leafWidth: 36, leafHeight: 52, leafAngle: -60,
      leafColor: const Color(0xFF40916C),
      attachTo: attachId,
    );
    elements.add(el);
    layers.add(LayerModel(id: el.id, name: 'ورقة', type: LayerType.leaf));
    selected = el.id;
    notifyListeners();
  }

  // ── تحديث عنصر ──────────────────────────────────────────────
  void updateElement(String id, CanvasElement updated) {
    final i = elements.indexWhere((e) => e.id == id);
    if (i >= 0) { elements[i] = updated; notifyListeners(); }
  }

  // ── حذف عنصر ──────────────────────────────────────────────
  void deleteElement(String id) {
    final el = elements.where((e) => e.id == id).firstOrNull;
    elements.removeWhere((e) => e.id == id || e.attachTo == id);
    layers.removeWhere((l) => l.id == id);
    if (el?.type == ElementType.trunk) hasTrunk = false;
    if (selected == id) selected = null;
    notifyListeners();
  }

  // ── تحريك عنصر ──────────────────────────────────────────────
  void moveElement(String id, double dx, double dy) {
    final layer = layerOf(id);
    if (layer?.locked == true) return;
    for (int i = 0; i < elements.length; i++) {
      final e = elements[i];
      if (e.id == id || e.attachTo == id) {
        final childLayer = layerOf(e.id);
        if (childLayer?.locked == true) continue;
        elements[i] = e.copyWith(x: e.x + dx, y: e.y + dy);
      }
    }
    notifyListeners();
  }

  // ── تحديد ──────────────────────────────────────────────────
  void setSelected(String? id) {
    selected = id;
    notifyListeners();
  }

  // ── طبقات ──────────────────────────────────────────────────
  void updateLayer(String id, {bool? visible, bool? locked}) {
    final i = layers.indexWhere((l) => l.id == id);
    if (i >= 0) {
      layers[i] = layers[i].copyWith(visible: visible, locked: locked);
      notifyListeners();
    }
  }

  // ── خلفية ──────────────────────────────────────────────────
  void setBgColor(Color c) { bgColor = c; notifyListeners(); }

  // ── اكتشاف لمس ──────────────────────────────────────────────
  CanvasElement? hitTest(Offset pos) {
    for (int i = elements.length - 1; i >= 0; i--) {
      final el = elements[i];
      final layer = layerOf(el.id);
      if (layer?.visible == false) continue;
      if (_hits(el, pos)) return el;
    }
    return null;
  }

  bool _hits(CanvasElement el, Offset pos) {
    switch (el.type) {
      case ElementType.trunk:
        return pos.dx >= el.x - el.width / 2 - 20 &&
            pos.dx <= el.x + el.width / 2 + 20 &&
            pos.dy >= el.y - 20 &&
            pos.dy <= el.y + el.height + 20;
      case ElementType.branch:
        final rad = el.angle * 3.14159 / 180;
        final ex = el.x + el.length * 0.5 * cos(rad);
        final ey = el.y + el.length * 0.5 * sin(rad);
        return (pos - Offset(ex, ey)).distance < el.length * 0.55 + 20;
      case ElementType.leaf:
        return (pos - Offset(el.x, el.y)).distance <
            (el.leafWidth > el.leafHeight ? el.leafWidth : el.leafHeight) * 0.7;
    }
  }
}

double cos(double rad) => _cos(rad);
double sin(double rad) => _sin(rad);

double _cos(double x) {
  return double.parse(
      (x is double ? x : x.toDouble()).toString().contains('.')
          ? '${_mathCos(x)}'
          : '${_mathCos(x.toDouble())}');
}

double _sin(double x) => _mathSin(x);

double _mathCos(double x) {
  import dart:math show cos;
  return cos(x);
}

double _mathSin(double x) {
  import dart:math show sin;
  return sin(x);
}
