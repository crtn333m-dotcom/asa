enum LayerType { trunk, branch, leaf }

class LayerModel {
  final String id;
  String name;
  LayerType type;
  bool visible;
  bool locked;

  LayerModel({
    required this.id,
    required this.name,
    required this.type,
    this.visible = true,
    this.locked = false,
  });

  LayerModel copyWith({bool? visible, bool? locked, String? name}) {
    return LayerModel(
      id: id,
      name: name ?? this.name,
      type: type,
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
    );
  }
}
