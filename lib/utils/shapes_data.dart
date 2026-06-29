import 'package:flutter/material.dart';

class ShapeOption {
  final String id;
  final String label;
  final String icon;
  const ShapeOption({required this.id, required this.label, required this.icon});
}

const trunkShapes = [
  ShapeOption(id: 'classic',  label: 'كلاسيكي', icon: '🌳'),
  ShapeOption(id: 'wide',     label: 'عريض',    icon: '🌲'),
  ShapeOption(id: 'twisted',  label: 'ملتوي',   icon: '🌴'),
  ShapeOption(id: 'slim',     label: 'رفيع',    icon: '🎋'),
  ShapeOption(id: 'ancient',  label: 'قديم',    icon: '🪵'),
];

const branchShapes = [
  ShapeOption(id: 'straight', label: 'مستقيم',  icon: '─'),
  ShapeOption(id: 'curved',   label: 'منحني',   icon: '⌒'),
  ShapeOption(id: 'drooping', label: 'متدلٍّ',  icon: '⌣'),
  ShapeOption(id: 'forked',   label: 'متشعب',   icon: '⑂'),
  ShapeOption(id: 'wavy',     label: 'متموج',   icon: '〜'),
];

const leafShapes = [
  ShapeOption(id: 'oval',     label: 'بيضاوي',  icon: '🍃'),
  ShapeOption(id: 'heart',    label: 'قلب',     icon: '💚'),
  ShapeOption(id: 'pointed',  label: 'مدببة',   icon: '◆'),
  ShapeOption(id: 'round',    label: 'مستديرة', icon: '⬤'),
  ShapeOption(id: 'maple',    label: 'قيقب',    icon: '🍁'),
];

const leafColors = [
  Color(0xFF2D6A4F), Color(0xFF40916C), Color(0xFF52B788),
  Color(0xFF74C69D), Color(0xFF95D5B2), Color(0xFFB7E4C7),
  Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFD93D),
  Color(0xFFC9A84C), Color(0xFF8B6914), Color(0xFF5C3D1E),
];

const branchColors = [
  Color(0xFF5C3D1E), Color(0xFF7A5210), Color(0xFF8B6914),
  Color(0xFFA07830), Color(0xFF6B4226), Color(0xFF4A2C12),
];

const nodeColors = [
  Color(0xFFC9A84C), Color(0xFFFF6B6B), Color(0xFF52B788),
  Color(0xFF6B9FFF), Color(0xFFE8C96A), Color(0xFFFF9500),
  Color(0xFFFFFFFF),
];

const backgroundColors = [
  _BgColor('كريمي',       Color(0xFFFDF6E3)),
  _BgColor('أبيض',        Color(0xFFFFFFFF)),
  _BgColor('رمادي فاتح',  Color(0xFFF0F0F0)),
  _BgColor('بيج',         Color(0xFFF5F0E8)),
  _BgColor('أزرق فاتح',  Color(0xFFEBF4FA)),
  _BgColor('أخضر فاتح',  Color(0xFFEBF5EB)),
  _BgColor('ليلي',        Color(0xFF1A1A2E)),
  _BgColor('داكن',        Color(0xFF0D1117)),
];

class _BgColor {
  final String label;
  final Color value;
  const _BgColor(this.label, this.value);
}
