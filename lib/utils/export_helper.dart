import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';
import '../models/element_model.dart';
import '../models/layer_model.dart';
import '../painters/canvas_painter.dart';
import '../painters/frame_painter.dart';

class ExportOptions {
  final String frameType;
  final Color frameColor;
  final String text1;
  final double text1X, text1Y;
  final String text2;
  final double text2X, text2Y;

  const ExportOptions({
    this.frameType = 'none',
    this.frameColor = const Color(0xFFC9A84C),
    this.text1 = '',
    this.text1X = 50, this.text1Y = 10,
    this.text2 = '',
    this.text2X = 50, this.text2Y = 90,
  });
}

Future<void> exportToImage({
  required List<CanvasElement> elements,
  required List<LayerModel> layers,
  required Color bgColor,
  required ExportOptions options,
  required Size screenSize,
}) async {
  const W = 1080.0, H = 1920.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, W, H));

  final scaleX = W / screenSize.width;
  final scaleY = H / screenSize.height;
  canvas.scale(scaleX, scaleY);

  // رسم المحتوى
  MainCanvasPainter(
    elements: elements,
    layers: layers,
    selected: null,
    bgColor: bgColor,
  ).paint(canvas, screenSize);

  canvas.scale(1 / scaleX, 1 / scaleY);

  // الإطار
  if (options.frameType != 'none') {
    FramePainter.draw(canvas, const Size(W, H), options.frameType, options.frameColor);
  }

  // النصوص
  for (final t in [
    (options.text1, options.text1X, options.text1Y),
    (options.text2, options.text2X, options.text2Y),
  ]) {
    if (t.$1.isEmpty) continue;
    final tp = TextPainter(
      text: TextSpan(
        text: t.$1,
        style: const TextStyle(
          color: Color(0xFF1A0F00),
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();
    tp.paint(canvas, Offset(
      W * t.$2 / 100 - tp.width / 2,
      H * t.$3 / 100 - tp.height / 2,
    ));
  }

  final picture = recorder.endRecording();
  final img = await picture.toImage(W.toInt(), H.toInt());
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

  if (bytes == null) return;

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/salalati_${DateTime.now().millisecondsSinceEpoch}.png');
  await file.writeAsBytes(bytes.buffer.asUint8List());
  await GallerySaver.saveImage(file.path, albumName: 'سلالتي');
}
