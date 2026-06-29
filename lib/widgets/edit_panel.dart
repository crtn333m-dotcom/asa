import 'package:flutter/material.dart';
import '../models/element_model.dart';
import '../utils/shapes_data.dart';

class EditPanel extends StatefulWidget {
  final CanvasElement element;
  final ValueChanged<CanvasElement> onUpdate;
  final ValueChanged<String> onDelete;
  final VoidCallback onClose;

  const EditPanel({
    super.key,
    required this.element,
    required this.onUpdate,
    required this.onDelete,
    required this.onClose,
  });

  @override
  State<EditPanel> createState() => _EditPanelState();
}

class _EditPanelState extends State<EditPanel> {
  late CanvasElement _el;
  final _nameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _el = widget.element;
  }

  @override
  void didUpdateWidget(EditPanel old) {
    super.didUpdateWidget(old);
    if (old.element.id != widget.element.id) {
      _el = widget.element;
    }
  }

  void _update(CanvasElement updated) {
    setState(() => _el = updated);
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0F00), Color(0xFF0D0700)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: Color(0x4DC9A84C))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // مقبض
            Container(width: 40, height: 4, margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: const Color(0x66C9A84C),
                borderRadius: BorderRadius.circular(2))),
            // ترويسة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    _el.type == ElementType.trunk ? '🌳 تعديل الجذع'
                        : _el.type == ElementType.branch ? '🌿 تعديل الغصن'
                        : '🍃 تعديل الورقة',
                    style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700,
                      fontSize: 15, color: Color(0xFFC9A84C)),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => widget.onDelete(_el.id),
                    child: const Text('حذف', style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 12)),
                  ),
                  TextButton(
                    onPressed: widget.onClose,
                    child: const Text('إغلاق', style: TextStyle(color: Color(0x80C9A84C), fontSize: 12)),
                  ),
                ],
              ),
            ),
            // المحتوى
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_el.type) {
      case ElementType.trunk: return _trunkContent();
      case ElementType.branch: return _branchContent();
      case ElementType.leaf: return _leafContent();
    }
  }

  Widget _trunkContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _slider('الطول', _el.height, 80, 400,
          (v) => _update(_el.copyWith(height: v))),
      _slider('العرض', _el.width, 20, 120,
          (v) => _update(_el.copyWith(width: v))),
      _slider('التدوير', _el.rotation, -180, 180,
          (v) => _update(_el.copyWith(rotation: v))),
      _sectionTitle('أسماء الجذع (${_el.names.length}/20)'),
      Row(children: [
        Expanded(child: _textField(_nameCtrl, 'أضف اسماً')),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            if (_nameCtrl.text.trim().isEmpty || _el.names.length >= 20) return;
            final updated = List<TrunkName>.from(_el.names)
              ..add(TrunkName(text: _nameCtrl.text.trim(), posY: 50.0));
            _update(_el.copyWith(names: updated));
            _nameCtrl.clear();
          },
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0x4DC9A84C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Color(0xFFC9A84C)),
          ),
        ),
      ]),
      const SizedBox(height: 8),
      ..._el.names.asMap().entries.map((e) => _nameRow(e.key, e.value)),
    ],
  );

  Widget _nameRow(int i, TrunkName n) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Text(n.text, style: const TextStyle(color: Color(0xFFFDF6E3), fontSize: 12,
        fontFamily: 'Cairo')),
      const Spacer(),
      Slider(
        value: n.posY, min: 0, max: 100,
        activeColor: const Color(0xFFC9A84C),
        inactiveColor: const Color(0x33C9A84C),
        onChanged: (v) {
          final updated = List<TrunkName>.from(_el.names);
          updated[i] = TrunkName(text: n.text, posY: v);
          _update(_el.copyWith(names: updated));
        },
      ),
      GestureDetector(
        onTap: () {
          final updated = List<TrunkName>.from(_el.names)..removeAt(i);
          _update(_el.copyWith(names: updated));
        },
        child: const Icon(Icons.close, color: Color(0xFFFF6B6B), size: 16),
      ),
    ]),
  );

  Widget _branchContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _slider('الطول', _el.length, 40, 250,
          (v) => _update(_el.copyWith(length: v))),
      _slider('السُّمك', _el.thickness, 2, 30,
          (v) => _update(_el.copyWith(thickness: v))),
      _slider('الإمالة', _el.angle, -180, 180,
          (v) => _update(_el.copyWith(angle: v))),
      _slider('الاستدارة', _el.curve, 0, 80,
          (v) => _update(_el.copyWith(curve: v))),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _toggleBtn('↕ قلب', _el.flip,
            () => _update(_el.copyWith(flip: !_el.flip)))),
      ]),
      _sectionTitle('⚪ دائرة الرأس'),
      _slider('حجم الدائرة', _el.nodeRadius, 6, 40,
          (v) => _update(_el.copyWith(nodeRadius: v))),
      _slider('تدوير الدائرة', _el.nodeRotation, 0, 360,
          (v) => _update(_el.copyWith(nodeRotation: v))),
      _textFieldDirect(
        value: _el.nodeName,
        hint: 'اسم الدائرة',
        onChanged: (v) => _update(_el.copyWith(nodeName: v)),
      ),
      _sectionTitle('لون الدائرة'),
      _colorRow(nodeColors, _el.nodeColor,
          (c) => _update(_el.copyWith(nodeColor: c))),
      _sectionTitle('لون الغصن'),
      _colorRow(branchColors, _el.color,
          (c) => _update(_el.copyWith(color: c))),
    ],
  );

  Widget _leafContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _slider('الطول', _el.leafHeight, 20, 100,
          (v) => _update(_el.copyWith(leafHeight: v))),
      _slider('العرض', _el.leafWidth, 16, 80,
          (v) => _update(_el.copyWith(leafWidth: v))),
      _slider('الزاوية', _el.leafAngle, -180, 180,
          (v) => _update(_el.copyWith(leafAngle: v))),
      _textFieldDirect(
        value: _el.leafName,
        hint: 'اسم على الورقة',
        onChanged: (v) => _update(_el.copyWith(leafName: v)),
      ),
      _sectionTitle('اللون'),
      _colorRow(leafColors, _el.leafColor,
          (c) => _update(_el.copyWith(leafColor: c))),
    ],
  );

  Widget _slider(String label, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Color(0xCCC9A84C),
              fontSize: 12, fontFamily: 'Cairo')),
            Text(value.round().toString(), style: const TextStyle(
              color: Color(0xCCC9A84C), fontSize: 12)),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFC9A84C),
            inactiveTrackColor: const Color(0x33C9A84C),
            thumbColor: const Color(0xFFC9A84C),
            overlayColor: const Color(0x33C9A84C),
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _colorRow(List<Color> colors, Color selected, ValueChanged<Color> onTap) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: colors.map((c) => GestureDetector(
        onTap: () => onTap(c),
        child: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: c, shape: BoxShape.circle,
            border: Border.all(
              color: selected == c ? Colors.white : Colors.white24,
              width: selected == c ? 2 : 1,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
    child: Text(t, style: const TextStyle(color: Color(0x80C9A84C),
      fontSize: 11, fontFamily: 'Cairo')),
  );

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: active ? const Color(0x4DC9A84C) : const Color(0x1AC9A84C),
            border: Border.all(color: const Color(0x4DC9A84C)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label, style: const TextStyle(
            color: Color(0xFFC9A84C), fontSize: 13, fontFamily: 'Cairo')),
        ),
      );

  Widget _textField(TextEditingController ctrl, String hint) => TextField(
    controller: ctrl,
    style: const TextStyle(color: Color(0xFFFDF6E3), fontFamily: 'Cairo', fontSize: 13),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0x66C9A84C), fontSize: 12),
      filled: true, fillColor: const Color(0x1AC9A84C),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0x4DC9A84C))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0x4DC9A84C))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC9A84C))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );

  Widget _textFieldDirect({
    required String value,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    final ctrl = TextEditingController(text: value)
      ..selection = TextSelection.collapsed(offset: value.length);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        onChanged: onChanged,
        style: const TextStyle(color: Color(0xFFFDF6E3), fontFamily: 'Cairo', fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0x66C9A84C), fontSize: 12),
          filled: true, fillColor: const Color(0x1AC9A84C),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0x4DC9A84C))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0x4DC9A84C))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFC9A84C))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
