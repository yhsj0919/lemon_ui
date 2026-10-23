import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

/// A resolved legend item. [id] is shared across charts; [index] is local.
@immutable
class HyperChartLegendEntry {
  const HyperChartLegendEntry({
    required this.id,
    required this.index,
    required this.label,
    required this.color,
    required this.hidden,
  });
  final String id;
  final int index;
  final String label;
  final Color color;
  final bool hidden;

  @override
  bool operator ==(Object other) =>
      other is HyperChartLegendEntry &&
      id == other.id &&
      index == other.index &&
      label == other.label &&
      color == other.color &&
      hidden == other.hidden;
  @override
  int get hashCode => Object.hash(id, index, label, color, hidden);
}

/// Shared visibility state. The caller owns and disposes this controller.
class HyperChartLegendController extends ChangeNotifier {
  HyperChartLegendController({Iterable<String> hiddenIds = const []})
    : _hidden = Set.of(hiddenIds);
  final Set<String> _hidden;
  Set<String> get hiddenIds => Set.unmodifiable(_hidden);
  bool isHidden(String id) => _hidden.contains(id);
  void toggle(String id) => setVisible(id, isHidden(id));
  void setVisible(String id, bool visible) {
    final changed = visible ? _hidden.remove(id) : _hidden.add(id);
    if (changed) notifyListeners();
  }

  void showAll() {
    if (_hidden.isEmpty) return;
    _hidden.clear();
    notifyListeners();
  }
}
