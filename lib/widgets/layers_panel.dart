import 'package:flutter/material.dart';
import '../models/element_model.dart';
import '../models/layer_model.dart';

class LayersPanel extends StatelessWidget {
  final List<LayerModel> layers;
  final List<CanvasElement> elements;
  final String? selected;
  final ValueChanged<String> onSelect;
  final Function(String, {bool? visible, bool? locked}) onUpdateLayer;
  final VoidCallback onClose;

  const LayersPanel({
    super.key,
    required this.layers, required this.elements,
    required this.selected, required this.onSelect,
    required this.onUpdateLayer, required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0, top: 0, bottom: 0,
      child: Container(
        width: 200,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xF71A0F00), Color(0xF70D0700)],
          ),
          border: Border(right: BorderSide(color: Color(0x33C9A84C))),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
                child: Row(
                  children: [
                    const Text('الطبقات', style: TextStyle(
                      color: Color(0xFFC9A84C), fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700, fontSize: 14)),
                    const Spacer(),
                    GestureDetector(onTap: onClose,
                      child: const Icon(Icons.close, color: Color(0x80C9A84C), size: 18)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: layers.reversed.map((layer) {
                    final el = elements.where((e) => e.id == layer.id).firstOrNull;
                    final isSelected = selected == layer.id;
                    return GestureDetector(
                      onTap: () => onSelect(layer.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0x26C9A84C) : Colors.transparent,
                          border: const Border(
                            bottom: BorderSide(color: Color(0x0FC9A84C))),
                        ),
                        child: Row(
                          children: [
                            Text(
                              el?.type == ElementType.trunk ? '🌳'
                                  : el?.type == ElementType.branch ? '🌿' : '🍃',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(layer.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFFC9A84C)
                                      : const Color(0xB3FDF6E3),
                                  fontSize: 12, fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => onUpdateLayer(layer.id, visible: !layer.visible),
                              child: Icon(
                                layer.visible ? Icons.visibility : Icons.visibility_off,
                                color: layer.visible
                                    ? const Color(0xFFC9A84C)
                                    : const Color(0x4DC9A84C),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => onUpdateLayer(layer.id, locked: !layer.locked),
                              child: Icon(
                                layer.locked ? Icons.lock : Icons.lock_open,
                                color: layer.locked
                                    ? const Color(0xFFFF9500)
                                    : const Color(0x4DC9A84C),
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
