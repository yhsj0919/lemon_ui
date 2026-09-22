import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../theme/color/hyper_contrast_theme.dart';

/// 图标按钮自己的视觉样式，不继承普通按钮样式。
@immutable
final class HyperIconButtonStyle {
  HyperIconButtonStyle({
    this.background,
    this.material,
    this.foregroundColor,
    this.contrastMode,
    this.overlayColor,
    this.border,
    this.borderRadius,
    this.size,
    this.minimumTapTargetSize,
    this.iconSize,
    this.margin,
    this.progressColor,
    this.progressTrackColor,
    this.progressSize,
    this.progressThickness,
    this.clipBehavior,
    List<BoxShadow>? boxShadow,
  }) : boxShadow = boxShadow == null ? null : List.unmodifiable(boxShadow);

  /// 按钮背景；null 表示继续继承。
  final HyperFill? background;

  /// 表面材质配方。
  final HyperSurfaceMaterial? material;

  /// 图标颜色。
  final Color? foregroundColor;

  /// 图标与背景之间的反色策略。
  final HyperContrastMode? contrastMode;

  /// 悬停和按下状态层颜色。
  final Color? overlayColor;

  /// 按钮边框；[BorderSide.none] 表示显式关闭。
  final BorderSide? border;

  /// 按钮圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 按钮阴影；空列表表示显式关闭。
  final List<BoxShadow>? boxShadow;

  /// 正方形视觉区域的边长。
  final double? size;

  /// 独立于视觉尺寸的最小命中区域边长。
  final double? minimumTapTargetSize;

  /// 图标尺寸。
  final double? iconSize;

  /// 按钮外部边距。
  final EdgeInsetsGeometry? margin;

  /// 加载指示器颜色。
  final Color? progressColor;

  /// 加载指示器轨道颜色。
  final Color? progressTrackColor;

  /// 加载指示器尺寸。
  final double? progressSize;

  /// 加载指示器线宽。
  final double? progressThickness;

  /// 高级材质的裁切方式。
  final Clip? clipBehavior;

  HyperIconButtonStyle merge(HyperIconButtonStyle? other) {
    if (other == null) return this;
    return HyperIconButtonStyle(
      background: other.background ?? background,
      material: other.material ?? material,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      contrastMode: other.contrastMode ?? contrastMode,
      overlayColor: other.overlayColor ?? overlayColor,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      size: other.size ?? size,
      minimumTapTargetSize: other.minimumTapTargetSize ?? minimumTapTargetSize,
      iconSize: other.iconSize ?? iconSize,
      margin: other.margin ?? margin,
      progressColor: other.progressColor ?? progressColor,
      progressTrackColor: other.progressTrackColor ?? progressTrackColor,
      progressSize: other.progressSize ?? progressSize,
      progressThickness: other.progressThickness ?? progressThickness,
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  static HyperIconButtonStyle lerp(
    HyperIconButtonStyle a,
    HyperIconButtonStyle b,
    double t,
  ) => HyperIconButtonStyle(
    background: _lerpFill(a.background, b.background, t),
    material: t < .5 ? a.material : b.material,
    foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
    contrastMode: t < .5 ? a.contrastMode : b.contrastMode,
    overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
    border: BorderSide.lerp(
      a.border ?? BorderSide.none,
      b.border ?? BorderSide.none,
      t,
    ),
    borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
    boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
    size: _lerpDouble(a.size, b.size, t),
    minimumTapTargetSize: _lerpDouble(
      a.minimumTapTargetSize,
      b.minimumTapTargetSize,
      t,
    ),
    iconSize: _lerpDouble(a.iconSize, b.iconSize, t),
    margin: EdgeInsetsGeometry.lerp(a.margin, b.margin, t),
    progressColor: Color.lerp(a.progressColor, b.progressColor, t),
    progressTrackColor: Color.lerp(
      a.progressTrackColor,
      b.progressTrackColor,
      t,
    ),
    progressSize: _lerpDouble(a.progressSize, b.progressSize, t),
    progressThickness: _lerpDouble(a.progressThickness, b.progressThickness, t),
    clipBehavior: t < .5 ? a.clipBehavior : b.clipBehavior,
  );

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null || b == null) return t < .5 ? a : b;
    return a + (b - a) * t;
  }

  static HyperFill? _lerpFill(HyperFill? a, HyperFill? b, double t) {
    if (a == null || b == null) return t < .5 ? a : b;
    return HyperFill.lerp(a, b, t);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperIconButtonStyle &&
          other.background == background &&
          other.material == material &&
          other.foregroundColor == foregroundColor &&
          other.contrastMode == contrastMode &&
          other.overlayColor == overlayColor &&
          other.border == border &&
          other.borderRadius == borderRadius &&
          listEquals(other.boxShadow, boxShadow) &&
          other.size == size &&
          other.minimumTapTargetSize == minimumTapTargetSize &&
          other.iconSize == iconSize &&
          other.margin == margin &&
          other.progressColor == progressColor &&
          other.progressTrackColor == progressTrackColor &&
          other.progressSize == progressSize &&
          other.progressThickness == progressThickness &&
          other.clipBehavior == clipBehavior;

  @override
  int get hashCode => Object.hashAll([
    background,
    material,
    foregroundColor,
    contrastMode,
    overlayColor,
    border,
    borderRadius,
    Object.hashAll(boxShadow ?? const []),
    size,
    minimumTapTargetSize,
    iconSize,
    margin,
    progressColor,
    progressTrackColor,
    progressSize,
    progressThickness,
    clipBehavior,
  ]);
}
