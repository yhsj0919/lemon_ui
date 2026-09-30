import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

enum HyperProgressVariant { thin, wide }

/// 进度指示器可由主题和实例共同配置的视觉属性。
@immutable
final class HyperProgressStyle {
  const HyperProgressStyle({
    this.variant,
    this.color,
    this.trackColor,
    this.thickness,
    this.size,
    this.radius,
    this.fillRadius,
    this.strokeCap,
    this.orbitingDotSize,
    this.animationDuration,
    this.animationCurve,
  });

  /// 已完成部分的颜色。
  final Color? color;
  final HyperProgressVariant? variant;

  /// 未完成轨道的颜色。
  final Color? trackColor;

  /// 线性轨道高度或圆形轨道线宽。
  final double? thickness;

  /// 圆形直径；在线性进度中表示明确长度。
  final double? size;

  /// 线性轨道圆角，不跟随全局控件圆角。
  final double? radius;

  /// 线性填充端圆角，默认轨道高度的一半；0 为直边，与外轨道圆角独立。
  final double? fillRadius;

  /// 圆形进度线段的端点样式。
  final StrokeCap? strokeCap;

  /// 无限进度指示器轨道圆点的半径，与 MIUIX 的同名参数保持一致。
  final double? orbitingDotSize;

  /// 确定进度发生变化时的动画时长。
  final Duration? animationDuration;

  /// 确定进度发生变化时的动画曲线。
  final Curve? animationCurve;

  HyperProgressStyle copyWith({
    HyperProgressVariant? variant,
    Color? color,
    Color? trackColor,
    double? thickness,
    double? size,
    double? radius,
    double? fillRadius,
    StrokeCap? strokeCap,
    double? orbitingDotSize,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => merge(
    HyperProgressStyle(
      variant: variant,
      color: color,
      trackColor: trackColor,
      thickness: thickness,
      size: size,
      radius: radius,
      fillRadius: fillRadius,
      strokeCap: strokeCap,
      orbitingDotSize: orbitingDotSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    ),
  );

  /// 用 [other] 中明确提供的属性覆盖当前样式。
  HyperProgressStyle merge(HyperProgressStyle? other) {
    if (other == null) return this;
    return HyperProgressStyle(
      variant: other.variant ?? variant,
      color: other.color ?? color,
      trackColor: other.trackColor ?? trackColor,
      thickness: other.thickness ?? thickness,
      size: other.size ?? size,
      radius: other.radius ?? radius,
      fillRadius: other.fillRadius ?? fillRadius,
      strokeCap: other.strokeCap ?? strokeCap,
      orbitingDotSize: other.orbitingDotSize ?? orbitingDotSize,
      animationDuration: other.animationDuration ?? animationDuration,
      animationCurve: other.animationCurve ?? animationCurve,
    );
  }

  /// 在两套进度样式之间插值。
  static HyperProgressStyle lerp(
    HyperProgressStyle a,
    HyperProgressStyle b,
    double t,
  ) => HyperProgressStyle(
    variant: t < .5 ? a.variant : b.variant,
    color: Color.lerp(a.color, b.color, t),
    trackColor: Color.lerp(a.trackColor, b.trackColor, t),
    thickness: _lerpDouble(a.thickness, b.thickness, t),
    size: _lerpDouble(a.size, b.size, t),
    radius: _lerpDouble(a.radius, b.radius, t),
    fillRadius: _lerpDouble(a.fillRadius, b.fillRadius, t),
    strokeCap: t < .5 ? a.strokeCap : b.strokeCap,
    orbitingDotSize: _lerpDouble(a.orbitingDotSize, b.orbitingDotSize, t),
    animationDuration: _lerpDuration(
      a.animationDuration,
      b.animationDuration,
      t,
    ),
    animationCurve: t < .5 ? a.animationCurve : b.animationCurve,
  );

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null || b == null) return t < .5 ? a : b;
    return a + (b - a) * t;
  }

  static Duration? _lerpDuration(Duration? a, Duration? b, double t) {
    if (a == null || b == null) return t < .5 ? a : b;
    return Duration(
      microseconds:
          (a.inMicroseconds + (b.inMicroseconds - a.inMicroseconds) * t)
              .round(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperProgressStyle &&
          other.color == color &&
          other.variant == variant &&
          other.trackColor == trackColor &&
          other.thickness == thickness &&
          other.size == size &&
          other.radius == radius &&
          other.fillRadius == fillRadius &&
          other.strokeCap == strokeCap &&
          other.orbitingDotSize == orbitingDotSize &&
          other.animationDuration == animationDuration &&
          other.animationCurve == animationCurve;

  @override
  int get hashCode => Object.hash(
    variant,
    color,
    trackColor,
    thickness,
    size,
    radius,
    fillRadius,
    strokeCap,
    orbitingDotSize,
    animationDuration,
    animationCurve,
  );
}
