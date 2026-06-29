import 'package:flutter/material.dart';
import '../utils/shapes_data.dart';

class ShapePicker extends StatelessWidget {
  final String type;
  final ValueChanged<String> onSelect;

  const ShapePicker({super.key, required this.type, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final shapes = type == 'trunk' ? trunkShapes
        : type == 'branch' ? branchShapes
        : leafShapes;
    final label = type == 'trunk' ? 'الجذع' : type == 'branch' ? 'الغصن' : 'الورقة';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF1A0F00), Color(0xFF0D0700)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: Color(0x4DC9A84C))),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(color: const Color(0x66C9A84C),
              borderRadius: BorderRadius.circular(2))),
          Text('اختر شكل $label',
            style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700,
              fontSize: 16, color: Color(0xFFC9A84C))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: shapes.map((s) => GestureDetector(
              onTap: () => onSelect(s.id),
              child: Container(
                width: 60, padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0x1AC9A84C),
                  border: Border.all(color: const Color(0x40C9A84C)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(s.icon, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(s.label, style: const TextStyle(
                      color: Color(0xFFC9A84C), fontSize: 10, fontFamily: 'Cairo')),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
