import 'package:flutter/widgets.dart';

/// 当前设备标签栏的高度、内容留白及各外观的几何规格。
@immutable
final class HyperTabBarSize {
  const HyperTabBarSize({
    required this.height,
    this.padding = EdgeInsets.zero,
    required this.segmentedRadius,
    required this.separatedRadius,
    required this.itemSpacing,
    this.itemHorizontalPadding,
    required this.underlineThickness,
  });

  /// 标签栏内容到两侧边缘的留白；不改变标签自身内边距。
  final EdgeInsetsGeometry padding;
  final double height;
  final double segmentedRadius;
  final double separatedRadius;

  /// 独立圆角标签之间的间距。
  final double itemSpacing;

  /// 标签内容单侧的水平留白，不包含标签间距和标签栏边缘留白。
  ///
  /// 旧构造未指定时沿用当前设备的 controlPadding 水平单侧规格。
  final double? itemHorizontalPadding;

  /// 下划线形态的指示线粗细。
  final double underlineThickness;

  HyperTabBarSize copyWith({
    double? height,
    EdgeInsetsGeometry? padding,
    double? segmentedRadius,
    double? separatedRadius,
    double? itemSpacing,
    double? itemHorizontalPadding,
    double? underlineThickness,
  }) => HyperTabBarSize(
    height: height ?? this.height,
    padding: padding ?? this.padding,
    segmentedRadius: segmentedRadius ?? this.segmentedRadius,
    separatedRadius: separatedRadius ?? this.separatedRadius,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    itemHorizontalPadding: itemHorizontalPadding ?? this.itemHorizontalPadding,
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
        itemHorizontalPadding:
            a.itemHorizontalPadding == null || b.itemHorizontalPadding == null
            ? (t < .5 ? a.itemHorizontalPadding : b.itemHorizontalPadding)
            : a.itemHorizontalPadding! +
                  (b.itemHorizontalPadding! - a.itemHorizontalPadding!) * t,
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
      other.itemHorizontalPadding == itemHorizontalPadding &&
      other.underlineThickness == underlineThickness;

  @override
  int get hashCode => Object.hash(
    height,
    padding,
    segmentedRadius,
    separatedRadius,
    itemSpacing,
    itemHorizontalPadding,
    underlineThickness,
  );
}
