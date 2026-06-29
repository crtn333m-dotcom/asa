import 'package:flutter/material.dart';

enum ElementType { trunk, branch, leaf }

class TrunkName {
  String text;
  double posY; // 0..100 نسبة على الجذع
  TrunkName({required this.text, this.posY = 50});
}

class CanvasElement {
  final String id;
  ElementType type;
  double x, y;

  // جذع
  double width;
  double height;
  String shape;
  Color color;
  double rotation;
  List<TrunkName> names;

  // غصن
  double length;
  double thickness;
  double angle;
  double curve;
  bool flip;
  double nodeRadius;
  Color nodeColor;
  double nodeRotation;
  String nodeName;
  String? attachTo;

  // ورقة
  double leafWidth;
  double leafHeight;
  double leafAngle;
  Color leafColor;
  String leafName;

  CanvasElement({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    this.width = 60,
    this.height = 220,
    this.shape = 'classic',
    this.color = const Color(0xFF7A5210),
    this.rotation = 0,
    List<TrunkName>? names,
    this.length = 100,
    this.thickness = 8,
    this.angle = -45,
    this.curve = 25,
    this.flip = false,
    this.nodeRadius = 14,
    this.nodeColor = const Color(0xFFC9A84C),
    this.nodeRotation = 0,
    this.nodeName = '',
    this.attachTo,
    this.leafWidth = 36,
    this.leafHeight = 52,
    this.leafAngle = -60,
    this.leafColor = const Color(0xFF40916C),
    this.leafName = '',
  }) : names = names ?? [];

  CanvasElement copyWith({
    double? x, double? y,
    double? width, double? height, String? shape,
    Color? color, double? rotation, List<TrunkName>? names,
    double? length, double? thickness, double? angle,
    double? curve, bool? flip,
    double? nodeRadius, Color? nodeColor,
    double? nodeRotation, String? nodeName,
    double? leafWidth, double? leafHeight,
    double? leafAngle, Color? leafColor, String? leafName,
  }) {
    return CanvasElement(
      id: id, type: type,
      x: x ?? this.x, y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      rotation: rotation ?? this.rotation,
      names: names ?? this.names,
      length: length ?? this.length,
      thickness: thickness ?? this.thickness,
      angle: angle ?? this.angle,
      curve: curve ?? this.curve,
      flip: flip ?? this.flip,
      nodeRadius: nodeRadius ?? this.nodeRadius,
      nodeColor: nodeColor ?? this.nodeColor,
      nodeRotation: nodeRotation ?? this.nodeRotation,
      nodeName: nodeName ?? this.nodeName,
      attachTo: attachTo,
      leafWidth: leafWidth ?? this.leafWidth,
      leafHeight: leafHeight ?? this.leafHeight,
      leafAngle: leafAngle ?? this.leafAngle,
      leafColor: leafColor ?? this.leafColor,
      leafName: leafName ?? this.leafName,
    );
  }
}
