import 'package:flutter/foundation.dart';

/// 当前设备的通用控件组布局尺寸，单位为逻辑像素。
@immutable
final class HyperWidgetGroupSize {
  const HyperWidgetGroupSize({
    required this.spacing,
    required this.separatorExtent,
    required this.separatorThickness,
    required this.radius,
    required this.innerRadius,
  });

  final double spacing;
  final double separatorExtent;
  final double separatorThickness;
  final double radius;

  /// 空白分隔时子项朝向组内侧的圆角。
  final double innerRadius;

  HyperWidgetGroupSize copyWith({
    double? spacing,
    double? separatorExtent,
    double? separatorThickness,
    double? radius,
    double? innerRadius,
  }) => HyperWidgetGroupSize(
    spacing: spacing ?? this.spacing,
    separatorExtent: separatorExtent ?? this.separatorExtent,
    separatorThickness: separatorThickness ?? this.separatorThickness,
    radius: radius ?? this.radius,
    innerRadius: innerRadius ?? this.innerRadius,
  );

  static HyperWidgetGroupSize lerp(
    HyperWidgetGroupSize a,
    HyperWidgetGroupSize b,
    double t,
  ) => HyperWidgetGroupSize(
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    separatorExtent:
        a.separatorExtent + (b.separatorExtent - a.separatorExtent) * t,
    separatorThickness:
        a.separatorThickness +
        (b.separatorThickness - a.separatorThickness) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    innerRadius: a.innerRadius + (b.innerRadius - a.innerRadius) * t,
  );

  @override
  bool operator ==(Object other) =>
      other is HyperWidgetGroupSize &&
      other.spacing == spacing &&
      other.separatorExtent == separatorExtent &&
      other.separatorThickness == separatorThickness &&
      other.radius == radius &&
      other.innerRadius == innerRadius;

  @override
  int get hashCode => Object.hash(
    spacing,
    separatorExtent,
    separatorThickness,
    radius,
    innerRadius,
  );
}
