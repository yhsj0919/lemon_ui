import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/hyper_state_value.dart';

/// HyperIcon 可由主题和实例共同配置的视觉属性。
@immutable
final class HyperIconStyle {
  const HyperIconStyle({
    this.color,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
  });

  /// 按状态解析的图标颜色。
  final HyperStateValue<Color>? color;

  /// 按状态解析的图标尺寸。
  final HyperStateValue<double>? size;

  /// 可变图标的填充轴，通常使用 0 到 1。
  final HyperStateValue<double>? fill;

  /// 可变图标的字重轴。
  final HyperStateValue<double>? weight;

  /// 可变图标的等级轴。
  final HyperStateValue<double>? grade;

  /// 可变图标的光学尺寸轴。
  final HyperStateValue<double>? opticalSize;

  /// 图标阴影；空列表表示显式移除阴影。
  final List<Shadow>? shadows;

  /// 用 [other] 中明确提供的属性覆盖当前样式。
  HyperIconStyle merge(HyperIconStyle? other) {
    if (other == null) return this;
    return HyperIconStyle(
      color: other.color ?? color,
      size: other.size ?? size,
      fill: other.fill ?? fill,
      weight: other.weight ?? weight,
      grade: other.grade ?? grade,
      opticalSize: other.opticalSize ?? opticalSize,
      shadows: other.shadows ?? shadows,
    );
  }

  /// 在两套图标样式之间插值，用于主题切换动画。
  static HyperIconStyle lerp(HyperIconStyle a, HyperIconStyle b, double t) {
    return HyperIconStyle(
      color: _lerpState(a.color, b.color, t, (a, b, t) => Color.lerp(a, b, t)!),
      size: _lerpState(a.size, b.size, t, _lerpDouble),
      fill: _lerpState(a.fill, b.fill, t, _lerpDouble),
      weight: _lerpState(a.weight, b.weight, t, _lerpDouble),
      grade: _lerpState(a.grade, b.grade, t, _lerpDouble),
      opticalSize: _lerpState(a.opticalSize, b.opticalSize, t, _lerpDouble),
      shadows: Shadow.lerpList(a.shadows, b.shadows, t),
    );
  }

  static HyperStateValue<T>? _lerpState<T>(
    HyperStateValue<T>? a,
    HyperStateValue<T>? b,
    double t,
    T Function(T a, T b, double t) interpolate,
  ) {
    if (a == null || b == null) return t < .5 ? a : b;
    return HyperStateValue.lerp(a, b, t, interpolate);
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperIconStyle &&
          other.color == color &&
          other.size == size &&
          other.fill == fill &&
          other.weight == weight &&
          other.grade == grade &&
          other.opticalSize == opticalSize &&
          listEquals(other.shadows, shadows);

  @override
  int get hashCode => Object.hash(
    color,
    size,
    fill,
    weight,
    grade,
    opticalSize,
    Object.hashAll(shadows ?? const []),
  );
}
