import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/canvas_provider.dart';
import '../painters/canvas_painter.dart';
import '../widgets/toolbar.dart';
import '../widgets/shape_picker.dart';
import '../widgets/edit_panel.dart';
import '../widgets/layers_panel.dart';
import '../widgets/export_modal.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});
  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  bool _showLayers = false;
  bool _showEdit = false;
  bool _showExport = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CanvasProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: provider.bgColor,
      body: Stack(
        children: [
          // الكانفاس الرئيسي
          GestureDetector(
            onTapDown: (d) {
              final hit = provider.hitTest(d.localPosition);
              if (hit != null) {
                provider.setSelected(hit.id);
                setState(() { _showEdit = true; });
              } else {
                provider.setSelected(null);
                setState(() { _showEdit = false; });
              }
            },
            onPanUpdate: (d) {
              if (provider.selected != null) {
                provider.moveElement(
                  provider.selected!,
                  d.delta.dx,
                  d.delta.dy,
                );
              }
            },
            child: CustomPaint(
              size: size,
              painter: MainCanvasPainter(
                elements: provider.elements,
                layers: provider.layers,
                selected: provider.selected,
                bgColor: provider.bgColor,
              ),
              child: SizedBox(width: size.width, height: size.height),
            ),
          ),

          // الشريط العلوي
          AppToolbar(
            hasTrunk: provider.hasTrunk,
            selectedType: provider.selectedElement?.type,
            bgColor: provider.bgColor,
            onAddTrunk: () => _showPicker(context, 'trunk'),
            onAddBranch: () => _showPicker(context, 'branch'),
            onAddLeaf: () => _showPicker(context, 'leaf'),
            onBgChange: provider.setBgColor,
            onToggleLayers: () => setState(() => _showLayers = !_showLayers),
            onExport: () => setState(() => _showExport = true),
          ),

          // لوحة الطبقات
          if (_showLayers)
            LayersPanel(
              layers: provider.layers,
              elements: provider.elements,
              selected: provider.selected,
              onSelect: (id) {
                provider.setSelected(id);
                setState(() => _showEdit = true);
              },
              onUpdateLayer: provider.updateLayer,
              onClose: () => setState(() => _showLayers = false),
            ),

          // لوحة التعديل
          if (_showEdit && provider.selectedElement != null)
            EditPanel(
              element: provider.selectedElement!,
              onUpdate: (updated) =>
                  provider.updateElement(updated.id, updated),
              onDelete: (id) {
                provider.deleteElement(id);
                setState(() => _showEdit = false);
              },
              onClose: () => setState(() => _showEdit = false),
            ),

          // نافذة التصدير
          if (_showExport)
            ExportModal(
              screenSize: size,
              elements: provider.elements,
              layers: provider.layers,
              bgColor: provider.bgColor,
              onClose: () => setState(() => _showExport = false),
            ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context, String type) {
    final provider = context.read<CanvasProvider>();
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ShapePicker(
        type: type,
        onSelect: (shape) {
          final cx = size.width / 2;
          final cy = size.height * 0.6;
          if (type == 'trunk') {
            provider.addTrunk(shape, cx, cy);
          } else if (type == 'branch') {
            provider.addBranch(shape, provider.selected, cx, cy * 0.7);
          } else {
            provider.addLeaf(shape, provider.selected, cx, cy * 0.6);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
