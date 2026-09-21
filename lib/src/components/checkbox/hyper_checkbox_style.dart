import 'package:flutter/widgets.dart';

/// HyperCheckbox 的内置外形变体。
enum HyperCheckboxVariant { circle, rounded }

/// HyperCheckbox 的可覆盖视觉属性；null 表示继续继承。
@immutable
final class HyperCheckboxStyle {
  HyperCheckboxStyle({
    this.size,
    this.minimumTapTargetSize,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.disabledColor,
    this.disabledCheckColor,
    this.overlayColor,
    this.border,
    this.borderRadius,
    this.markStrokeWidth,
    this.pressScale,
    this.duration,
    this.curve,
    List<BoxShadow>? boxShadow,
  }) : boxShadow = boxShadow == null ? null : List.unmodifiable(boxShadow);

  /// 复选框视觉区域边长。
  final double? size;

  /// 独立于视觉尺寸的最小命中区域边长。
  final double? minimumTapTargetSize;

  /// 选中和半选中状态背景色。
  final Color? activeColor;

  /// 未选中状态背景色。
  final Color? inactiveColor;

  /// 勾选和半选标记颜色。
  final Color? checkColor;

  /// 禁用状态背景色。
  final Color? disabledColor;

  /// 禁用状态标记颜色。
  final Color? disabledCheckColor;

  /// 悬停和按下状态层颜色。
  final Color? overlayColor;

  /// 未选中状态边框。
  final BorderSide? border;

  /// 复选框圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 勾选和半选标记线宽。
  final double? markStrokeWidth;

  /// 按下时视觉区域的缩放值。
  final double? pressScale;

  /// 状态变化动画时长。
  final Duration? duration;

  /// 状态变化动画曲线。
  final Curve? curve;

  /// 复选框阴影；空列表表示显式关闭。
  final List<BoxShadow>? boxShadow;

  HyperCheckboxStyle merge(HyperCheckboxStyle? other) {
    if (other == null) return this;
    return HyperCheckboxStyle(
      size: other.size ?? size,
      minimumTapTargetSize: other.minimumTapTargetSize ?? minimumTapTargetSize,
      activeColor: other.activeColor ?? activeColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
      checkColor: other.checkColor ?? checkColor,
      disabledColor: other.disabledColor ?? disabledColor,
      disabledCheckColor: other.disabledCheckColor ?? disabledCheckColor,
      overlayColor: other.overlayColor ?? overlayColor,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      markStrokeWidth: other.markStrokeWidth ?? markStrokeWidth,
      pressScale: other.pressScale ?? pressScale,
      duration: other.duration ?? duration,
      curve: other.curve ?? curve,
      boxShadow: other.boxShadow ?? boxShadow,
    );
  }

  static HyperCheckboxStyle lerp(
    HyperCheckboxStyle a,
    HyperCheckboxStyle b,
    double t,
  ) => t < .5 ? a : b;
}
