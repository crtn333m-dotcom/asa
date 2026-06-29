import 'package:flutter/material.dart';
import '../models/element_model.dart';
import '../utils/shapes_data.dart';

class AppToolbar extends StatefulWidget {
  final bool hasTrunk;
  final ElementType? selectedType;
  final Color bgColor;
  final VoidCallback onAddTrunk, onAddBranch, onAddLeaf;
  final ValueChanged<Color> onBgChange;
  final VoidCallback onToggleLayers, onExport;

  const AppToolbar({
    super.key,
    required this.hasTrunk,
    required this.selectedType,
    required this.bgColor,
    required this.onAddTrunk,
    required this.onAddBranch,
    required this.onAddLeaf,
    required this.onBgChange,
    required this.onToggleLayers,
    required this.onExport,
  });

  @override
  State<AppToolbar> createState() => _AppToolbarState();
}

class _AppToolbarState extends State<AppToolbar> {
  bool _open = true;
  bool _showBg = false;

  @override
  Widget build(BuildContext context) {
    if (!_open) {
      return Positioned(
        top: 12, right: 12,
        child: GestureDetector(
          onTap: () => setState(() => _open = true),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: const Color(0xE6C9A84C),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [BoxShadow(color: Color(0x66C9A84C), blurRadius: 16)],
            ),
            child: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1A0F00), size: 18),
          ),
        ),
      );
    }

    return Positioned(
      top: 0, left: 0, right: 0,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xF70D0700), Color(0xE61A0F00)],
              ),
              border: Border(bottom: BorderSide(color: Color(0x4DC9A84C))),
            ),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    _ToolBtn(
                      icon: Icons.arrow_back_ios,
                      label: 'طي',
                      onTap: () => setState(() { _open = false; _showBg = false; }),
                    ),
                    const SizedBox(width: 4),
                    _ToolBtn(
                      icon: Icons.park,
                      label: 'جذع',
                      onTap: widget.hasTrunk ? null : widget.onAddTrunk,
                    ),
                    if (widget.hasTrunk) ...[
                      const SizedBox(width: 4),
                      _ToolBtn(icon: Icons.account_tree, label: 'غصن', onTap: widget.onAddBranch),
                    ],
                    if (widget.selectedType == ElementType.branch) ...[
                      const SizedBox(width: 4),
                      _ToolBtn(icon: Icons.eco, label: 'ورقة', onTap: widget.onAddLeaf),
                    ],
                    const SizedBox(width: 8),
                    _ToolBtn(
                      icon: Icons.palette,
                      label: 'لون',
                      onTap: () => setState(() => _showBg = !_showBg),
                    ),
                    const SizedBox(width: 4),
                    _ToolBtn(icon: Icons.layers, label: 'طبقات', onTap: widget.onToggleLayers),
                    const SizedBox(width: 4),
                    _ToolBtn(icon: Icons.download, label: 'حفظ', onTap: widget.onExport),
                  ],
                ),
              ),
            ),
          ),
          if (_showBg)
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xF71A0F00),
                border: Border.all(color: const Color(0x4DC9A84C)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                spacing: 8, runSpacing: 8,
                children: backgroundColors.map((bg) => GestureDetector(
                  onTap: () { widget.onBgChange(bg.value); setState(() => _showBg = false); },
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: bg.value,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.bgColor == bg.value
                            ? const Color(0xFFC9A84C) : Colors.white24,
                        width: widget.bgColor == bg.value ? 2 : 1,
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ToolBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.35 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0x1AC9A84C),
            border: Border.all(color: const Color(0x33C9A84C)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFFC9A84C), size: 20),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(
                color: Color(0xFFC9A84C), fontSize: 9, fontFamily: 'Cairo')),
            ],
          ),
        ),
      ),
    );
  }
}
