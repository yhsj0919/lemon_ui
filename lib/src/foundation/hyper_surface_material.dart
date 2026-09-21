import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'hyper_fill.dart';

const _unchanged = Object();

/// 材质渲染质量。选择是显式的，不根据设备性能暗中切换。
enum HyperMaterialQuality { standard, advanced }

/// 表面材质的绘制方式。
enum HyperSurfaceMaterialKind {
  solid,
  translucent,
  frostedGlass,
  softLightGlass,
}

/// 跨控件复用的表面材质配方。
@immutable
final class HyperSurfaceMaterial {
  const HyperSurfaceMaterial._({
    required this.kind,
    this.background,
    this.blurSigmaX = 0,
    this.blurSigmaY = 0,
    this.tint,
    this.border,
    this.boxShadow = const [],
    this.fallback,
  });

  const HyperSurfaceMaterial.solid({
    HyperFill? background,
    BorderSide? border,
    List<BoxShadow> boxShadow = const [],
  }) : this._(
         kind: HyperSurfaceMaterialKind.solid,
         background: background,
         border: border,
         boxShadow: boxShadow,
       );

  const HyperSurfaceMaterial.translucent({
    HyperFill? background,
    Color? tint,
    BorderSide? border,
    List<BoxShadow> boxShadow = const [],
  }) : this._(
         kind: HyperSurfaceMaterialKind.translucent,
         background: background,
         tint: tint,
         border: border,
         boxShadow: boxShadow,
       );

  const HyperSurfaceMaterial.frostedGlass({
    HyperFill? background,
    double blurSigmaX = 20,
    double blurSigmaY = 20,
    Color? tint,
    BorderSide? border,
    List<BoxShadow> boxShadow = const [],
    HyperSurfaceMaterial? fallback,
  }) : this._(
         kind: HyperSurfaceMaterialKind.frostedGlass,
         background: background,
         blurSigmaX: blurSigmaX,
         blurSigmaY: blurSigmaY,
         tint: tint,
         border: border,
         boxShadow: boxShadow,
         fallback: fallback,
       );

  const HyperSurfaceMaterial.softLightGlass({
    HyperFill? background,
    double blurSigmaX = 28,
    double blurSigmaY = 28,
    Color? tint,
    BorderSide? border,
    List<BoxShadow> boxShadow = const [],
    HyperSurfaceMaterial? fallback,
  }) : this._(
         kind: HyperSurfaceMaterialKind.softLightGlass,
         background: background,
         blurSigmaX: blurSigmaX,
         blurSigmaY: blurSigmaY,
         tint: tint,
         border: border,
         boxShadow: boxShadow,
         fallback: fallback,
       );

  /// 材质类型。
  final HyperSurfaceMaterialKind kind;

  /// 材质背景填充。
  final HyperFill? background;

  /// 水平方向背景模糊强度。
  final double blurSigmaX;

  /// 垂直方向背景模糊强度。
  final double blurSigmaY;

  /// 绘制在内容下方的附加色层。
  final Color? tint;

  /// 材质表面边框。
  final BorderSide? border;

  /// 材质表面阴影。
  final List<BoxShadow> boxShadow;

  /// 普通质量或减少透明度时使用的不透明替代材质。
  final HyperSurfaceMaterial? fallback;

  bool get usesBackdrop =>
      kind == HyperSurfaceMaterialKind.frostedGlass ||
      kind == HyperSurfaceMaterialKind.softLightGlass;

  /// 按显式质量与透明度策略选择实际材质。
  HyperSurfaceMaterial resolve({
    required HyperMaterialQuality quality,
    bool reduceTransparency = false,
  }) {
    if (!usesBackdrop) return this;
    if (quality == HyperMaterialQuality.advanced && !reduceTransparency) {
      return this;
    }
    return fallback ??
        HyperSurfaceMaterial.solid(
          background: background,
          border: border,
          boxShadow: boxShadow,
        );
  }

  HyperSurfaceMaterial copyWith({
    HyperSurfaceMaterialKind? kind,
    Object? background = _unchanged,
    double? blurSigmaX,
    double? blurSigmaY,
    Object? tint = _unchanged,
    Object? border = _unchanged,
    List<BoxShadow>? boxShadow,
    Object? fallback = _unchanged,
  }) => HyperSurfaceMaterial._(
    kind: kind ?? this.kind,
    background: identical(background, _unchanged)
        ? this.background
        : background as HyperFill?,
    blurSigmaX: blurSigmaX ?? this.blurSigmaX,
    blurSigmaY: blurSigmaY ?? this.blurSigmaY,
    tint: identical(tint, _unchanged) ? this.tint : tint as Color?,
    border: identical(border, _unchanged) ? this.border : border as BorderSide?,
    boxShadow: boxShadow ?? this.boxShadow,
    fallback: identical(fallback, _unchanged)
        ? this.fallback
        : fallback as HyperSurfaceMaterial?,
  );

  static HyperSurfaceMaterial lerp(
    HyperSurfaceMaterial a,
    HyperSurfaceMaterial b,
    double t,
  ) {
    if (t == 0) return a;
    if (t == 1) return b;
    final compatible = a.kind == b.kind;
    if (!compatible) return t < .5 ? a : b;
    HyperFill? fill;
    if (a.background != null && b.background != null) {
      fill = HyperFill.lerp(a.background!, b.background!, t);
    } else {
      fill = t < .5 ? a.background : b.background;
    }
    return HyperSurfaceMaterial._(
      kind: a.kind,
      background: fill,
      blurSigmaX: a.blurSigmaX + (b.blurSigmaX - a.blurSigmaX) * t,
      blurSigmaY: a.blurSigmaY + (b.blurSigmaY - a.blurSigmaY) * t,
      tint: Color.lerp(a.tint, b.tint, t),
      border: a.border == null || b.border == null
          ? (t < .5 ? a.border : b.border)
          : BorderSide.lerp(a.border!, b.border!, t),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t) ?? const [],
      fallback: t < .5 ? a.fallback : b.fallback,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperSurfaceMaterial &&
          other.kind == kind &&
          other.background == background &&
          other.blurSigmaX == blurSigmaX &&
          other.blurSigmaY == blurSigmaY &&
          other.tint == tint &&
          other.border == border &&
          listEquals(other.boxShadow, boxShadow) &&
          other.fallback == fallback;

  @override
  int get hashCode => Object.hash(
    kind,
    background,
    blurSigmaX,
    blurSigmaY,
    tint,
    border,
    Object.hashAll(boxShadow),
    fallback,
  );
}
