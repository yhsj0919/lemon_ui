import 'package:flutter/foundation.dart';

/// 当前设备的固定与滚动顶栏高度。
@immutable
final class HyperAppBarSize {
  const HyperAppBarSize({
    required this.collapsedHeight,
    required this.mediumExpandedHeight,
    required this.expandedHeight,
    required this.titleHorizontalPadding,
  });

  final double collapsedHeight;
  final double mediumExpandedHeight;
  final double expandedHeight;
  final double titleHorizontalPadding;

  HyperAppBarSize copyWith({
    double? collapsedHeight,
    double? mediumExpandedHeight,
    double? expandedHeight,
    double? titleHorizontalPadding,
  }) => HyperAppBarSize(
    collapsedHeight: collapsedHeight ?? this.collapsedHeight,
    mediumExpandedHeight: mediumExpandedHeight ?? this.mediumExpandedHeight,
    expandedHeight: expandedHeight ?? this.expandedHeight,
    titleHorizontalPadding:
        titleHorizontalPadding ?? this.titleHorizontalPadding,
  );

  static HyperAppBarSize lerp(HyperAppBarSize a, HyperAppBarSize b, double t) =>
      HyperAppBarSize(
        collapsedHeight:
            a.collapsedHeight + (b.collapsedHeight - a.collapsedHeight) * t,
        mediumExpandedHeight:
            a.mediumExpandedHeight +
            (b.mediumExpandedHeight - a.mediumExpandedHeight) * t,
        expandedHeight:
            a.expandedHeight + (b.expandedHeight - a.expandedHeight) * t,
        titleHorizontalPadding:
            a.titleHorizontalPadding +
            (b.titleHorizontalPadding - a.titleHorizontalPadding) * t,
      );

  @override
  bool operator ==(Object other) =>
      other is HyperAppBarSize &&
      other.collapsedHeight == collapsedHeight &&
      other.mediumExpandedHeight == mediumExpandedHeight &&
      other.expandedHeight == expandedHeight &&
      other.titleHorizontalPadding == titleHorizontalPadding;

  @override
  int get hashCode => Object.hash(
    collapsedHeight,
    mediumExpandedHeight,
    expandedHeight,
    titleHorizontalPadding,
  );
}
