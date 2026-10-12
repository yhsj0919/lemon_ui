import 'package:flutter/widgets.dart';

/// 当前设备两种标签栏共用的高度及各自的圆角、间距。
@immutable
final class HyperTabBarSize {
  const HyperTabBarSize({
    required this.height,
    this.padding = EdgeInsets.zero,
    required this.segmentedRadius,
    required this.separatedRadius,
    required this.itemSpacing,
    required this.underlineThickness,
  });

  /// 标签栏内容到两侧边缘的留白；不改变标签自身内边距。
  final EdgeInsetsGeometry padding;
  final double height;
  final double segmentedRadius;
  final double separatedRadius;

  /// 独立圆角标签之间的间距。
  final double itemSpacing;

  /// 下划线形态的指示线粗细。
  final double underlineThickness;

  HyperTabBarSize copyWith({
    double? height,
    EdgeInsetsGeometry? padding,
    double? segmentedRadius,
    double? separatedRadius,
    double? itemSpacing,
    double? underlineThickness,
  }) => HyperTabBarSize(
    height: height ?? this.height,
    padding: padding ?? this.padding,
    segmentedRadius: segmentedRadius ?? this.segmentedRadius,
    separatedRadius: separatedRadius ?? this.separatedRadius,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    underlineThickness: underlineThickness ?? this.underlineThickness,
  );

  static HyperTabBarSize lerp(HyperTabBarSize a, HyperTabBarSize b, double t) =>
      HyperTabBarSize(
        height: a.height + (b.height - a.height) * t,
        padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
        segmentedRadius:
            a.segmentedRadius + (b.segmentedRadius - a.segmentedRadius) * t,
        separatedRadius:
            a.separatedRadius + (b.separatedRadius - a.separatedRadius) * t,
        itemSpacing: a.itemSpacing + (b.itemSpacing - a.itemSpacing) * t,
        underlineThickness:
            a.underlineThickness +
            (b.underlineThickness - a.underlineThickness) * t,
      );

  @override
  bool operator ==(Object other) =>
      other is HyperTabBarSize &&
      other.height == height &&
      other.padding == padding &&
      other.segmentedRadius == segmentedRadius &&
      other.separatedRadius == separatedRadius &&
      other.itemSpacing == itemSpacing &&
      other.underlineThickness == underlineThickness;

  @override
  int get hashCode => Object.hash(
    height,
    padding,
    segmentedRadius,
    separatedRadius,
    itemSpacing,
    underlineThickness,
  );
}
