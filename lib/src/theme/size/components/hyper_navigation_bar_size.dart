import 'package:flutter/foundation.dart';

@immutable
final class HyperNavigationBarSize {
  const HyperNavigationBarSize({
    this.minHeight = 64,
    this.iconSize = 24,
    this.itemSpacing = 12,
    this.verticalPadding = 12,
  });
  const HyperNavigationBarSize.phone()
    : minHeight = 64,
      iconSize = 24,
      itemSpacing = 4,
      verticalPadding = 8;
  const HyperNavigationBarSize.desktop()
    : minHeight = 56,
      iconSize = 24,
      itemSpacing = 2,
      verticalPadding = 8;
  final double minHeight, iconSize, itemSpacing, verticalPadding;
  HyperNavigationBarSize copyWith({
    double? minHeight,
    double? iconSize,
    double? itemSpacing,
    double? verticalPadding,
  }) => HyperNavigationBarSize(
    minHeight: minHeight ?? this.minHeight,
    iconSize: iconSize ?? this.iconSize,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    verticalPadding: verticalPadding ?? this.verticalPadding,
  );
  static HyperNavigationBarSize lerp(
    HyperNavigationBarSize a,
    HyperNavigationBarSize b,
    double t,
  ) => HyperNavigationBarSize(
    minHeight: a.minHeight + (b.minHeight - a.minHeight) * t,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    itemSpacing: a.itemSpacing + (b.itemSpacing - a.itemSpacing) * t,
    verticalPadding:
        a.verticalPadding + (b.verticalPadding - a.verticalPadding) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperNavigationBarSize &&
      other.minHeight == minHeight &&
      other.iconSize == iconSize &&
      other.itemSpacing == itemSpacing &&
      other.verticalPadding == verticalPadding;
  @override
  int get hashCode =>
      Object.hash(minHeight, iconSize, itemSpacing, verticalPadding);
}
