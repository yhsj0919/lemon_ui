import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 进度指示器可由主题和实例共同配置的视觉属性。
@immutable
final class HyperProgressIndicatorStyle {
  const HyperProgressIndicatorStyle({
    this.color,
    this.trackColor,
    this.thickness,
    this.size,
    this.radius,
    this.strokeCap,
    this.orbitingDotSize,
    this.animationDuration,
    this.animationCurve,
  });

  /// 已完成部分的颜色。
  final Color? color;

  /// 未完成轨道的颜色。
  final Color? trackColor;

  /// 线性轨道高度或圆形轨道线宽。
  final double? thickness;

  /// 圆形直径；在线性进度中表示明确长度。
  final double? size;

  /// 线性轨道圆角，不跟随全局控件圆角。
  final double? radius;

  /// 圆形进度线段的端点样式。
  final StrokeCap? strokeCap;

  /// 无限进度指示器轨道圆点的半径，与 MIUIX 的同名参数保持一致。
  final double? orbitingDotSize;

  /// 确定进度发生变化时的动画时长。
  final Duration? animationDuration;

  /// 确定进度发生变化时的动画曲线。
  final Curve? animationCurve;

  /// 用 [other] 中明确提供的属性覆盖当前样式。
  HyperProgressIndicatorStyle merge(HyperProgressIndicatorStyle? other) {
    if (other == null) return this;
    return HyperProgressIndicatorStyle(
      color: other.color ?? color,
      trackColor: other.trackColor ?? trackColor,
      thickness: other.thickness ?? thickness,
      size: other.size ?? size,
      radius: other.radius ?? radius,
      strokeCap: other.strokeCap ?? strokeCap,
      orbitingDotSize: other.orbitingDotSize ?? orbitingDotSize,
      animationDuration: other.animationDuration ?? animationDuration,
      animationCurve: other.animationCurve ?? animationCurve,
    );
  }

  /// 在两套进度样式之间插值。
  static HyperProgressIndicatorStyle lerp(
    HyperProgressIndicatorStyle a,
    HyperProgressIndicatorStyle b,
    double t,
  ) => HyperProgressIndicatorStyle(
    color: Color.lerp(a.color, b.color, t),
    trackColor: Color.lerp(a.trackColor, b.trackColor, t),
    thickness: _lerpDouble(a.thickness, b.thickness, t),
    size: _lerpDouble(a.size, b.size, t),
    radius: _lerpDouble(a.radius, b.radius, t),
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
      other is HyperProgressIndicatorStyle &&
          other.color == color &&
          other.trackColor == trackColor &&
          other.thickness == thickness &&
          other.size == size &&
          other.radius == radius &&
          other.strokeCap == strokeCap &&
          other.orbitingDotSize == orbitingDotSize &&
          other.animationDuration == animationDuration &&
          other.animationCurve == animationCurve;

  @override
  int get hashCode => Object.hash(
    color,
    trackColor,
    thickness,
    size,
    radius,
    strokeCap,
    orbitingDotSize,
    animationDuration,
    animationCurve,
  );
}
