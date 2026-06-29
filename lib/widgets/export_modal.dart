import 'package:flutter/material.dart';
import '../models/element_model.dart';
import '../models/layer_model.dart';
import '../utils/export_helper.dart';

class ExportModal extends StatefulWidget {
  final Size screenSize;
  final List<CanvasElement> elements;
  final List<LayerModel> layers;
  final Color bgColor;
  final VoidCallback onClose;

  const ExportModal({
    super.key,
    required this.screenSize, required this.elements,
    required this.layers, required this.bgColor,
    required this.onClose,
  });

  @override
  State<ExportModal> createState() => _ExportModalState();
}

class _ExportModalState extends State<ExportModal> {
  String _frameType = 'simple';
  Color _frameColor = const Color(0xFFC9A84C);
  String _text1 = '', _text2 = '';
  double _t1x = 50, _t1y = 10, _t2x = 50, _t2y = 90;
  bool _exporting = false;

  static const frames = [
    ('none', 'بدون'),
    ('simple', 'بسيط'),
    ('geometric', 'هندسي'),
    ('arabesque', 'أرابيسك'),
    ('calligraphy', 'خطي'),
    ('floral', 'زهري'),
  ];

  static const frameColors = [
    Color(0xFFC9A84C), Color(0xFFFFFFFF), Color(0xFFFF6B6B),
    Color(0xFF52B788), Color(0xFF6B9FFF),
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75),
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
            Container(width: 40, height: 4, margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: const Color(0x66C9A84C),
                borderRadius: BorderRadius.circular(2))),
            const Text('📥 تصدير صورة', style: TextStyle(
              fontFamily: 'Cairo', fontWeight: FontWeight.w700,
              fontSize: 15, color: Color(0xFFC9A84C))),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title('الإطار'),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: frames.map((f) => GestureDetector(
                        onTap: () => setState(() => _frameType = f.$1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _frameType == f.$1
                                ? const Color(0x59C9A84C) : const Color(0x1AC9A84C),
                            border: Border.all(
                              color: _frameType == f.$1
                                  ? const Color(0xFFC9A84C) : const Color(0x40C9A84C)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(f.$2, style: const TextStyle(
                            color: Color(0xFFC9A84C), fontSize: 12, fontFamily: 'Cairo')),
                        ),
                      )).toList(),
                    ),
                    if (_frameType != 'none') ...[
                      const SizedBox(height: 10),
                      _title('لون الإطار'),
                      Row(
                        children: frameColors.map((c) => GestureDetector(
                          onTap: () => setState(() => _frameColor = c),
                          child: Container(
                            width: 28, height: 28, margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: c, shape: BoxShape.circle,
                              border: Border.all(
                                color: _frameColor == c ? Colors.white : Colors.white24,
                                width: _frameColor == c ? 2 : 1),
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _title('نص أول'),
                    _inputField(_text1, 'مثال: عائلة الدخيل', (v) => setState(() => _text1 = v)),
                    if (_text1.isNotEmpty) ...[
                      _posSlider('موضع أفقي', _t1x, (v) => setState(() => _t1x = v)),
                      _posSlider('موضع عمودي', _t1y, (v) => setState(() => _t1y = v)),
                    ],
                    const SizedBox(height: 6),
                    _title('نص ثاني'),
                    _inputField(_text2, 'مثال: 1445هـ', (v) => setState(() => _text2 = v)),
                    if (_text2.isNotEmpty) ...[
                      _posSlider('موضع أفقي', _t2x, (v) => setState(() => _t2x = v)),
                      _posSlider('موضع عمودي', _t2y, (v) => setState(() => _t2y = v)),
                    ],
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _exporting ? null : _export,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(color: Color(0x4DC9A84C), blurRadius: 20)],
                        ),
                        child: Center(child: _exporting
                          ? const CircularProgressIndicator(color: Color(0xFF1A0F00))
                          : const Text('⬇️ تصدير وحفظ في المعرض', style: TextStyle(
                              fontFamily: 'Cairo', fontWeight: FontWeight.w700,
                              fontSize: 15, color: Color(0xFF1A0F00)))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      await exportToImage(
        elements: widget.elements,
        layers: widget.layers,
        bgColor: widget.bgColor,
        screenSize: widget.screenSize,
        options: ExportOptions(
          frameType: _frameType, frameColor: _frameColor,
          text1: _text1, text1X: _t1x, text1Y: _t1y,
          text2: _text2, text2X: _t2x, text2Y: _t2y,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ تم الحفظ في معرض الصور'),
            backgroundColor: Color(0xFF2D6A4F)));
        widget.onClose();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'),
            backgroundColor: const Color(0xFFFF6B6B)));
      }
    }
    setState(() => _exporting = false);
  }

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(color: Color(0x80C9A84C),
      fontSize: 11, fontFamily: 'Cairo')),
  );

  Widget _inputField(String value, String hint, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Color(0xFFFDF6E3),
          fontFamily: 'Cairo', fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0x66C9A84C)),
          filled: true, fillColor: const Color(0x1AC9A84C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0x4DC9A84C))),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0x4DC9A84C))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _posSlider(String label, double val, ValueChanged<double> onChanged) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label: ${val.round()}%', style: const TextStyle(
        color: Color(0x66C9A84C), fontSize: 10, fontFamily: 'Cairo')),
      SliderTheme(
        data: const SliderThemeData(
          activeTrackColor: Color(0xFFC9A84C),
          inactiveTrackColor: Color(0x33C9A84C),
          thumbColor: Color(0xFFC9A84C),
          trackHeight: 2,
        ),
        child: Slider(value: val, min: 5, max: 95, onChanged: onChanged),
      ),
    ]);
}
