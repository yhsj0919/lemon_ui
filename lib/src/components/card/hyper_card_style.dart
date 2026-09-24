import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';

/// HyperCard 的视觉和布局覆盖；空字段继续继承主题。
@immutable
final class HyperCardStyle {
  HyperCardStyle({
    this.background,
    this.material,
    this.foregroundColor,
    this.overlayColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.margin,
    this.constraints,
    this.pressedScale,
    this.animationDuration,
    this.animationCurve,
    this.clipBehavior,
    List<BoxShadow>? boxShadow,
  }) : boxShadow = boxShadow == null ? null : List.unmodifiable(boxShadow);

  final HyperFill? background;
  final HyperSurfaceMaterial? material;
  final Color? foregroundColor;
  final Color? overlayColor;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final double? pressedScale;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final Clip? clipBehavior;

  HyperCardStyle merge(HyperCardStyle? other) {
    if (other == null) return this;
    return HyperCardStyle(
      background: other.background ?? background,
      material: other.material ?? material,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      overlayColor: other.overlayColor ?? overlayColor,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      padding: other.padding ?? padding,
      margin: other.margin ?? margin,
      constraints: other.constraints ?? constraints,
      pressedScale: other.pressedScale ?? pressedScale,
      animationDuration: other.animationDuration ?? animationDuration,
      animationCurve: other.animationCurve ?? animationCurve,
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  static HyperCardStyle lerp(HyperCardStyle a, HyperCardStyle b, double t) {
    T? discrete<T>(T? x, T? y) => t < .5 ? x : y;
    double? number(double? x, double? y) =>
        x == null || y == null ? discrete(x, y) : x + (y - x) * t;
    return HyperCardStyle(
      background: a.background == null || b.background == null
          ? discrete(a.background, b.background)
          : HyperFill.lerp(a.background!, b.background!, t),
      material: a.material == null || b.material == null
          ? discrete(a.material, b.material)
          : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
      border: a.border == null || b.border == null
          ? discrete(a.border, b.border)
          : BoxBorder.lerp(a.border!, b.border!, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      margin: EdgeInsetsGeometry.lerp(a.margin, b.margin, t),
      constraints: BoxConstraints.lerp(a.constraints, b.constraints, t),
      pressedScale: number(a.pressedScale, b.pressedScale),
      animationDuration: discrete(a.animationDuration, b.animationDuration),
      animationCurve: discrete(a.animationCurve, b.animationCurve),
      clipBehavior: discrete(a.clipBehavior, b.clipBehavior),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperCardStyle &&
      other.background == background &&
      other.material == material &&
      other.foregroundColor == foregroundColor &&
      other.overlayColor == overlayColor &&
      other.border == border &&
      other.borderRadius == borderRadius &&
      listEquals(other.boxShadow, boxShadow) &&
      other.padding == padding &&
      other.margin == margin &&
      other.constraints == constraints &&
      other.pressedScale == pressedScale &&
      other.animationDuration == animationDuration &&
      other.animationCurve == animationCurve &&
      other.clipBehavior == clipBehavior;

  @override
  int get hashCode => Object.hash(
    background,
    material,
    foregroundColor,
    overlayColor,
    border,
    borderRadius,
    Object.hashAll(boxShadow ?? const []),
    padding,
    margin,
    constraints,
    pressedScale,
    animationDuration,
    animationCurve,
    clipBehavior,
  );
}
