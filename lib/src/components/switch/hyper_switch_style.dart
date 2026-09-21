import 'package:flutter/widgets.dart';

/// HyperSwitch 的全部可覆盖视觉属性。
@immutable
final class HyperSwitchStyle {
  HyperSwitchStyle({
    this.width,
    this.height,
    this.thumbSize,
    this.minimumTapTargetSize,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.disabledTrackColor,
    this.disabledActiveTrackColor,
    this.disabledInactiveTrackColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.disabledThumbColor,
    this.disabledActiveThumbColor,
    this.disabledInactiveThumbColor,
    this.overlayColor,
    this.border,
    this.borderRadius,
    this.thumbRadius,
    this.uncheckedThumbOffset,
    this.checkedThumbOffset,
    this.interactionThumbScale,
    this.duration,
    this.curve,
    List<BoxShadow>? thumbShadow,
  }) : thumbShadow = thumbShadow == null
           ? null
           : List.unmodifiable(thumbShadow);

  /// 轨道宽度。
  final double? width;

  /// 轨道高度。
  final double? height;

  /// 滑块宽高。
  final double? thumbSize;

  /// 独立于视觉尺寸的最小命中区域边长。
  final double? minimumTapTargetSize;

  /// 开启状态轨道颜色。
  final Color? activeTrackColor;

  /// 关闭状态轨道颜色。
  final Color? inactiveTrackColor;

  /// 禁用轨道的公共回退颜色。
  final Color? disabledTrackColor;

  /// 禁用且开启时的轨道颜色。
  final Color? disabledActiveTrackColor;

  /// 禁用且关闭时的轨道颜色。
  final Color? disabledInactiveTrackColor;

  /// 开启状态滑块颜色。
  final Color? activeThumbColor;

  /// 关闭状态滑块颜色。
  final Color? inactiveThumbColor;

  /// 禁用滑块的公共回退颜色。
  final Color? disabledThumbColor;

  /// 禁用且开启时的滑块颜色。
  final Color? disabledActiveThumbColor;

  /// 禁用且关闭时的滑块颜色。
  final Color? disabledInactiveThumbColor;

  /// 悬停和按下状态层颜色。
  final Color? overlayColor;

  /// 轨道边框。
  final BorderSide? border;

  /// 轨道圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 滑块圆角。
  final BorderRadiusGeometry? thumbRadius;

  /// 关闭状态下滑块距起始边的距离。
  final double? uncheckedThumbOffset;

  /// 开启状态下滑块距起始边的距离。
  final double? checkedThumbOffset;

  /// 悬停、按下或拖动时的滑块放大值。
  final double? interactionThumbScale;

  /// 滑块阴影；空列表表示显式关闭。
  final List<BoxShadow>? thumbShadow;

  /// 状态变化动画时长。
  final Duration? duration;

  /// 状态变化动画曲线。
  final Curve? curve;

  HyperSwitchStyle merge(HyperSwitchStyle? other) {
    if (other == null) return this;
    return HyperSwitchStyle(
      width: other.width ?? width,
      height: other.height ?? height,
      thumbSize: other.thumbSize ?? thumbSize,
      minimumTapTargetSize: other.minimumTapTargetSize ?? minimumTapTargetSize,
      activeTrackColor: other.activeTrackColor ?? activeTrackColor,
      inactiveTrackColor: other.inactiveTrackColor ?? inactiveTrackColor,
      disabledTrackColor: other.disabledTrackColor ?? disabledTrackColor,
      disabledActiveTrackColor:
          other.disabledActiveTrackColor ?? disabledActiveTrackColor,
      disabledInactiveTrackColor:
          other.disabledInactiveTrackColor ?? disabledInactiveTrackColor,
      activeThumbColor: other.activeThumbColor ?? activeThumbColor,
      inactiveThumbColor: other.inactiveThumbColor ?? inactiveThumbColor,
      disabledThumbColor: other.disabledThumbColor ?? disabledThumbColor,
      disabledActiveThumbColor:
          other.disabledActiveThumbColor ?? disabledActiveThumbColor,
      disabledInactiveThumbColor:
          other.disabledInactiveThumbColor ?? disabledInactiveThumbColor,
      overlayColor: other.overlayColor ?? overlayColor,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      thumbRadius: other.thumbRadius ?? thumbRadius,
      uncheckedThumbOffset: other.uncheckedThumbOffset ?? uncheckedThumbOffset,
      checkedThumbOffset: other.checkedThumbOffset ?? checkedThumbOffset,
      interactionThumbScale:
          other.interactionThumbScale ?? interactionThumbScale,
      thumbShadow: other.thumbShadow ?? thumbShadow,
      duration: other.duration ?? duration,
      curve: other.curve ?? curve,
    );
  }

  static HyperSwitchStyle lerp(
    HyperSwitchStyle a,
    HyperSwitchStyle b,
    double t,
  ) {
    double? number(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperSwitchStyle(
      width: number(a.width, b.width),
      height: number(a.height, b.height),
      thumbSize: number(a.thumbSize, b.thumbSize),
      minimumTapTargetSize: number(
        a.minimumTapTargetSize,
        b.minimumTapTargetSize,
      ),
      activeTrackColor: Color.lerp(a.activeTrackColor, b.activeTrackColor, t),
      inactiveTrackColor: Color.lerp(
        a.inactiveTrackColor,
        b.inactiveTrackColor,
        t,
      ),
      disabledTrackColor: Color.lerp(
        a.disabledTrackColor,
        b.disabledTrackColor,
        t,
      ),
      disabledActiveTrackColor: Color.lerp(
        a.disabledActiveTrackColor,
        b.disabledActiveTrackColor,
        t,
      ),
      disabledInactiveTrackColor: Color.lerp(
        a.disabledInactiveTrackColor,
        b.disabledInactiveTrackColor,
        t,
      ),
      activeThumbColor: Color.lerp(a.activeThumbColor, b.activeThumbColor, t),
      inactiveThumbColor: Color.lerp(
        a.inactiveThumbColor,
        b.inactiveThumbColor,
        t,
      ),
      disabledThumbColor: Color.lerp(
        a.disabledThumbColor,
        b.disabledThumbColor,
        t,
      ),
      disabledActiveThumbColor: Color.lerp(
        a.disabledActiveThumbColor,
        b.disabledActiveThumbColor,
        t,
      ),
      disabledInactiveThumbColor: Color.lerp(
        a.disabledInactiveThumbColor,
        b.disabledInactiveThumbColor,
        t,
      ),
      overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
      border: BorderSide.lerp(
        a.border ?? BorderSide.none,
        b.border ?? BorderSide.none,
        t,
      ),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      thumbRadius: BorderRadiusGeometry.lerp(a.thumbRadius, b.thumbRadius, t),
      uncheckedThumbOffset: number(
        a.uncheckedThumbOffset,
        b.uncheckedThumbOffset,
      ),
      checkedThumbOffset: number(a.checkedThumbOffset, b.checkedThumbOffset),
      interactionThumbScale: number(
        a.interactionThumbScale,
        b.interactionThumbScale,
      ),
      thumbShadow: BoxShadow.lerpList(a.thumbShadow, b.thumbShadow, t),
      duration: t < .5 ? a.duration : b.duration,
      curve: t < .5 ? a.curve : b.curve,
    );
  }
}
