import 'package:flutter/widgets.dart';

@immutable
class HyperSelectionSize {
  const HyperSelectionSize({
    required this.maxPanelHeight,
    required this.chipSpacing,
    required this.minimumInputWidth,
  });
  final double maxPanelHeight, chipSpacing, minimumInputWidth;
  HyperSelectionSize copyWith({
    double? maxPanelHeight,
    double? chipSpacing,
    double? minimumInputWidth,
  }) => HyperSelectionSize(
    maxPanelHeight: maxPanelHeight ?? this.maxPanelHeight,
    chipSpacing: chipSpacing ?? this.chipSpacing,
    minimumInputWidth: minimumInputWidth ?? this.minimumInputWidth,
  );
  static HyperSelectionSize lerp(
    HyperSelectionSize a,
    HyperSelectionSize b,
    double t,
  ) => HyperSelectionSize(
    maxPanelHeight:
        a.maxPanelHeight + (b.maxPanelHeight - a.maxPanelHeight) * t,
    chipSpacing: a.chipSpacing + (b.chipSpacing - a.chipSpacing) * t,
    minimumInputWidth:
        a.minimumInputWidth + (b.minimumInputWidth - a.minimumInputWidth) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperSelectionSize &&
      maxPanelHeight == other.maxPanelHeight &&
      chipSpacing == other.chipSpacing &&
      minimumInputWidth == other.minimumInputWidth;
  @override
  int get hashCode =>
      Object.hash(maxPanelHeight, chipSpacing, minimumInputWidth);
}
