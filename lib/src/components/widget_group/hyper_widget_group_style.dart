import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 通用控件组自身的布局与外层视觉覆盖。
@immutable
final class HyperWidgetGroupStyle {
  const HyperWidgetGroupStyle({
    this.width,
    this.itemHeight,
    this.spacing,
    this.padding,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.itemBorderRadius,
    this.boxShadow,
    this.separatorColor,
    this.separatorExtent,
    this.separatorThickness,
    this.duration,
    this.curve,
  });

  final double? width;
  final double? itemHeight;
  final double? spacing;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;

  /// 子项默认圆角；各子项可单独覆盖。
  final BorderRadiusGeometry? itemBorderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? separatorColor;
  final double? separatorExtent;
  final double? separatorThickness;
  final Duration? duration;
  final Curve? curve;

  HyperWidgetGroupStyle merge(HyperWidgetGroupStyle? other) => other == null
      ? this
      : HyperWidgetGroupStyle(
          width: other.width ?? width,
          itemHeight: other.itemHeight ?? itemHeight,
          spacing: other.spacing ?? spacing,
          padding: other.padding ?? padding,
          backgroundColor: other.backgroundColor ?? backgroundColor,
          border: other.border ?? border,
          borderRadius: other.borderRadius ?? borderRadius,
          itemBorderRadius: other.itemBorderRadius ?? itemBorderRadius,
          boxShadow: other.boxShadow ?? boxShadow,
          separatorColor: other.separatorColor ?? separatorColor,
          separatorExtent: other.separatorExtent ?? separatorExtent,
          separatorThickness: other.separatorThickness ?? separatorThickness,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
        );

  static HyperWidgetGroupStyle lerp(
    HyperWidgetGroupStyle a,
    HyperWidgetGroupStyle b,
    double t,
  ) {
    double? number(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperWidgetGroupStyle(
      width: number(a.width, b.width),
      itemHeight: number(a.itemHeight, b.itemHeight),
      spacing: number(a.spacing, b.spacing),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      border: BoxBorder.lerp(a.border, b.border, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      itemBorderRadius: BorderRadiusGeometry.lerp(
        a.itemBorderRadius,
        b.itemBorderRadius,
        t,
      ),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      separatorColor: Color.lerp(a.separatorColor, b.separatorColor, t),
      separatorExtent: number(a.separatorExtent, b.separatorExtent),
      separatorThickness: number(a.separatorThickness, b.separatorThickness),
      duration: t < .5 ? a.duration : b.duration,
      curve: t < .5 ? a.curve : b.curve,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperWidgetGroupStyle &&
      other.width == width &&
      other.itemHeight == itemHeight &&
      other.spacing == spacing &&
      other.padding == padding &&
      other.backgroundColor == backgroundColor &&
      other.border == border &&
      other.borderRadius == borderRadius &&
      other.itemBorderRadius == itemBorderRadius &&
      listEquals(other.boxShadow, boxShadow) &&
      other.separatorColor == separatorColor &&
      other.separatorExtent == separatorExtent &&
      other.separatorThickness == separatorThickness &&
      other.duration == duration &&
      other.curve == curve;

  @override
  int get hashCode => Object.hashAll([
    width,
    itemHeight,
    spacing,
    padding,
    backgroundColor,
    border,
    borderRadius,
    itemBorderRadius,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    separatorColor,
    separatorExtent,
    separatorThickness,
    duration,
    curve,
  ]);
}
