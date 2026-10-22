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
  clearFrostedGlass,
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
    this.edgeGradient,
    this.edgeEnabled,
    this.outsideShadow = false,
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
    Gradient? edgeGradient = clearGlassEdge,
    bool? edgeEnabled,
    List<BoxShadow> boxShadow = const [],
    HyperSurfaceMaterial? fallback,
  }) : this._(
         kind: HyperSurfaceMaterialKind.frostedGlass,
         background: background,
         blurSigmaX: blurSigmaX,
         blurSigmaY: blurSigmaY,
         tint: tint,
         border: border,
         edgeGradient: edgeGradient,
         edgeEnabled: edgeEnabled,
         boxShadow: boxShadow,
         fallback: fallback,
       );

  const HyperSurfaceMaterial.softLightGlass({
    HyperFill? background,
    double blurSigmaX = 28,
    double blurSigmaY = 28,
    Color? tint,
    BorderSide? border,
    Gradient? edgeGradient = clearGlassEdge,
    bool? edgeEnabled,
    List<BoxShadow> boxShadow = const [],
    HyperSurfaceMaterial? fallback,
  }) : this._(
         kind: HyperSurfaceMaterialKind.softLightGlass,
         background: background,
         blurSigmaX: blurSigmaX,
         blurSigmaY: blurSigmaY,
         tint: tint,
         border: border,
         edgeGradient: edgeGradient,
         edgeEnabled: edgeEnabled,
         boxShadow: boxShadow,
         fallback: fallback,
       );

  /// 高透毛玻璃：轻染色、方向高光及外侧阴影；默认质量仍由材质主题管理。
  const HyperSurfaceMaterial.clearFrostedGlass({
    HyperFill? background = const HyperFill.gradient(
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0x14FFFFFF), Color(0x05607080)],
      ),
    ),
    double blurSigmaX = 15,
    double blurSigmaY = 15,
    Color? tint,
    BorderSide? border,
    Gradient? edgeGradient = clearGlassEdge,
    bool? edgeEnabled,
    List<BoxShadow> boxShadow = const [
      BoxShadow(color: Color(0x140F2035), blurRadius: 20, spreadRadius: -2),
      BoxShadow(color: Color(0x080F2035), blurRadius: 4),
    ],
    bool outsideShadow = true,
    HyperSurfaceMaterial? fallback = const HyperSurfaceMaterial.solid(
      background: HyperFill.color(Color(0xFFF1F2F4)),
      border: BorderSide(color: Color(0x220F2035)),
    ),
  }) : this._(
         kind: HyperSurfaceMaterialKind.clearFrostedGlass,
         background: background,
         blurSigmaX: blurSigmaX,
         blurSigmaY: blurSigmaY,
         tint: tint,
         border: border,
         edgeGradient: edgeGradient,
         edgeEnabled: edgeEnabled,
         boxShadow: boxShadow,
         outsideShadow: outsideShadow,
         fallback: fallback,
       );

  /// 未指定背景的毛玻璃使用组件语义底色时的默认不透明度。
  static const double semanticGlassOpacity = .75;

  /// 普通半透明填充的默认不透明度，与毛玻璃配方分开管理。
  static const double semanticTranslucentOpacity = .75;

  /// 已确认实验配方的单线高光；可通过 copyWith 替换或传 null 关闭。
  static const Gradient clearGlassEdge = SweepGradient(
    colors: [
      Color(0x66D8E3ED),
      Color(0x88EDF3F8),
      Color(0x66C8D5E1),
      Color(0x88E5EBF1),
      Color(0xF5FFFFFF),
      Color(0x88E5EBF1),
      Color(0x66D8E3ED),
    ],
    stops: [0, .125, .3, .52, .625, .73, 1],
  );

  /// 可选的单线高光轮廓；实例显式 border 优先。
  final Gradient? edgeGradient;

  /// 高光边缘开关；null 使用表面用途默认值（普通控件关闭，浮层开启）。
  final bool? edgeEnabled;

  /// 已解析材质的高光；显式边框（包括关闭边框）阻止额外轮廓。
  Gradient? resolveEdgeGradient({
    bool hasBorderOverride = false,
    bool defaultEnabled = false,
  }) =>
      usesBackdrop &&
          (edgeEnabled ?? defaultEnabled) &&
          !hasBorderOverride &&
          border == null
      ? edgeGradient
      : null;

  /// 阴影是否裁去表面内部，避免高透明表面透出阴影底色。
  final bool outsideShadow;

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
      kind == HyperSurfaceMaterialKind.softLightGlass ||
      kind == HyperSurfaceMaterialKind.clearFrostedGlass;

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
    Object? edgeGradient = _unchanged,
    Object? edgeEnabled = _unchanged,
    bool? outsideShadow,
  }) => HyperSurfaceMaterial._(
    kind: kind ?? this.kind,
    edgeEnabled: identical(edgeEnabled, _unchanged)
        ? this.edgeEnabled
        : edgeEnabled as bool?,
    edgeGradient: identical(edgeGradient, _unchanged)
        ? this.edgeGradient
        : edgeGradient as Gradient?,
    outsideShadow: outsideShadow ?? this.outsideShadow,
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
      edgeEnabled: t < .5 ? a.edgeEnabled : b.edgeEnabled,
      edgeGradient: Gradient.lerp(a.edgeGradient, b.edgeGradient, t),
      outsideShadow: t < .5 ? a.outsideShadow : b.outsideShadow,
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
          other.edgeGradient == edgeGradient &&
          other.edgeEnabled == edgeEnabled &&
          other.outsideShadow == outsideShadow &&
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
    edgeGradient,
    edgeEnabled,
    outsideShadow,
    background,
    blurSigmaX,
    blurSigmaY,
    tint,
    border,
    Object.hashAll(boxShadow),
    fallback,
  );
}
