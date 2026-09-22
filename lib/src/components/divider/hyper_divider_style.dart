import 'package:flutter/widgets.dart';

/// 分隔线的绘制方式。
enum HyperDividerPattern {
  /// 连续实线。
  solid,

  /// 由等长线段组成的虚线。
  dashed,

  /// 由圆点组成的点线。
  dotted,
}

/// HyperDivider 可由主题和实例共同配置的视觉属性。
@immutable
final class HyperDividerStyle {
  const HyperDividerStyle({
    this.color,
    this.gradient,
    this.thickness,
    this.length,
    this.indent,
    this.endIndent,
    this.radius,
    this.pattern,
    this.dashLength,
    this.gap,
  });

  /// 纯色；设置 [gradient] 后由渐变优先绘制。
  final Color? color;

  /// 分隔线渐变。
  final Gradient? gradient;

  /// 线条粗细。
  final double? thickness;

  /// 主轴方向上的明确长度；null 表示占满父级可用空间。
  final double? length;

  /// 线条起点缩进。
  final double? indent;

  /// 线条终点缩进。
  final double? endIndent;

  /// 线段端部圆角半径，不跟随全局控件圆角。
  final double? radius;

  /// 实线、虚线或点线。
  final HyperDividerPattern? pattern;

  /// 虚线中单个线段的长度。
  final double? dashLength;

  /// 虚线或点线之间的间隔。
  final double? gap;

  /// 用 [other] 中明确提供的属性覆盖当前样式。
  HyperDividerStyle merge(HyperDividerStyle? other) {
    if (other == null) return this;
    return HyperDividerStyle(
      color: other.color ?? color,
      gradient: other.gradient ?? gradient,
      thickness: other.thickness ?? thickness,
      length: other.length ?? length,
      indent: other.indent ?? indent,
      endIndent: other.endIndent ?? endIndent,
      radius: other.radius ?? radius,
      pattern: other.pattern ?? pattern,
      dashLength: other.dashLength ?? dashLength,
      gap: other.gap ?? gap,
    );
  }

  /// 在两套分隔线样式之间插值。
  static HyperDividerStyle lerp(
    HyperDividerStyle a,
    HyperDividerStyle b,
    double t,
  ) => HyperDividerStyle(
    color: Color.lerp(a.color, b.color, t),
    gradient: Gradient.lerp(a.gradient, b.gradient, t),
    thickness: _lerpDouble(a.thickness, b.thickness, t),
    length: _lerpDouble(a.length, b.length, t),
    indent: _lerpDouble(a.indent, b.indent, t),
    endIndent: _lerpDouble(a.endIndent, b.endIndent, t),
    radius: _lerpDouble(a.radius, b.radius, t),
    pattern: t < .5 ? a.pattern : b.pattern,
    dashLength: _lerpDouble(a.dashLength, b.dashLength, t),
    gap: _lerpDouble(a.gap, b.gap, t),
  );

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null || b == null) return t < .5 ? a : b;
    return a + (b - a) * t;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperDividerStyle &&
          other.color == color &&
          other.gradient == gradient &&
          other.thickness == thickness &&
          other.length == length &&
          other.indent == indent &&
          other.endIndent == endIndent &&
          other.radius == radius &&
          other.pattern == pattern &&
          other.dashLength == dashLength &&
          other.gap == gap;

  @override
  int get hashCode => Object.hash(
    color,
    gradient,
    thickness,
    length,
    indent,
    endIndent,
    radius,
    pattern,
    dashLength,
    gap,
  );
}
