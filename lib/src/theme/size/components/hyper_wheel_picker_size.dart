import 'package:flutter/foundation.dart';

@immutable
final class HyperWheelPickerSize {
  const HyperWheelPickerSize({
    this.itemExtent = 32,
    this.width = 192,
    this.horizontalPadding = 8,
    this.selectionRadius = 6,
  });
  final double itemExtent;
  final double width;
  final double horizontalPadding;
  final double selectionRadius;
  HyperWheelPickerSize copyWith({
    double? itemExtent,
    double? width,
    double? horizontalPadding,
    double? selectionRadius,
  }) => HyperWheelPickerSize(
    itemExtent: itemExtent ?? this.itemExtent,
    width: width ?? this.width,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    selectionRadius: selectionRadius ?? this.selectionRadius,
  );
  static HyperWheelPickerSize lerp(
    HyperWheelPickerSize a,
    HyperWheelPickerSize b,
    double t,
  ) => HyperWheelPickerSize(
    itemExtent: a.itemExtent + (b.itemExtent - a.itemExtent) * t,
    width: a.width + (b.width - a.width) * t,
    horizontalPadding:
        a.horizontalPadding + (b.horizontalPadding - a.horizontalPadding) * t,
    selectionRadius:
        a.selectionRadius + (b.selectionRadius - a.selectionRadius) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperWheelPickerSize &&
      other.itemExtent == itemExtent &&
      other.width == width &&
      other.horizontalPadding == horizontalPadding &&
      other.selectionRadius == selectionRadius;
  @override
  int get hashCode =>
      Object.hash(itemExtent, width, horizontalPadding, selectionRadius);
}

