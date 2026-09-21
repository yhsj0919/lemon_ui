import 'package:flutter/widgets.dart';

/// HyperRadio 的内置视觉变体。
enum HyperRadioVariant { checkmark, circle, filled }

/// HyperRadio 的可覆盖视觉属性；null 表示继续继承。
@immutable
final class HyperRadioStyle {
  const HyperRadioStyle({
    this.size,
    this.minimumTapTargetSize,
    this.selectedColor,
    this.disabledSelectedColor,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.border,
    this.selectedBorder,
    this.borderRadius,
    this.indicatorSize,
    this.markSize,
    this.boxShadow,
    this.strokeWidth,
    this.pressScale,
    this.duration,
    this.curve,
  });

  /// 单选标记视觉区域边长。
  final double? size;

  /// 独立于视觉尺寸的最小命中区域边长。
  final double? minimumTapTargetSize;

  /// 启用且选中时的对勾或圆点颜色。
  final Color? selectedColor;

  /// 禁用且选中时的内部标记颜色。
  final Color? disabledSelectedColor;

  /// 未选中状态背景色。
  final Color? backgroundColor;

  /// 选中状态背景色。
  final Color? selectedBackgroundColor;

  /// 未选中状态边框。
  final BorderSide? border;

  /// 选中状态边框。
  final BorderSide? selectedBorder;

  /// 背景和边框圆角，不继承全局基础圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 圆点变体的内部标记直径。
  final double? indicatorSize;

  /// 对勾绘制区域边长；独立于控件视觉区域尺寸。
  final double? markSize;

  /// 控件阴影；空列表表示显式关闭。
  final List<BoxShadow>? boxShadow;

  /// 勾线宽度。
  final double? strokeWidth;

  /// 按下时视觉区域的缩放值。
  final double? pressScale;

  /// 选中状态变化动画时长。
  final Duration? duration;

  /// 选中状态变化动画曲线。
  final Curve? curve;

  HyperRadioStyle merge(HyperRadioStyle? other) {
    if (other == null) return this;
    return HyperRadioStyle(
      size: other.size ?? size,
      minimumTapTargetSize: other.minimumTapTargetSize ?? minimumTapTargetSize,
      selectedColor: other.selectedColor ?? selectedColor,
      disabledSelectedColor:
          other.disabledSelectedColor ?? disabledSelectedColor,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      selectedBackgroundColor:
          other.selectedBackgroundColor ?? selectedBackgroundColor,
      border: other.border ?? border,
      selectedBorder: other.selectedBorder ?? selectedBorder,
      borderRadius: other.borderRadius ?? borderRadius,
      indicatorSize: other.indicatorSize ?? indicatorSize,
      markSize: other.markSize ?? markSize,
      boxShadow: other.boxShadow ?? boxShadow,
      strokeWidth: other.strokeWidth ?? strokeWidth,
      pressScale: other.pressScale ?? pressScale,
      duration: other.duration ?? duration,
      curve: other.curve ?? curve,
    );
  }

  static HyperRadioStyle lerp(HyperRadioStyle a, HyperRadioStyle b, double t) =>
      t < .5 ? a : b;
}
