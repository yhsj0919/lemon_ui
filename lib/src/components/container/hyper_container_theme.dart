import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/hyper_fill.dart';

const _unchanged = Object();

/// 容器独立主题。空字段表示继续继承；中性值表示显式关闭效果。
///
/// 阴影列表会复制为不可变列表。尺寸不进行任何倍率换算。
@immutable
final class HyperContainerThemeData {
  HyperContainerThemeData({
    this.background,
    this.border,
    this.borderRadius,
    this.padding,
    this.margin,
    this.alignment,
    this.constraints,
    this.animationDuration,
    this.animationCurve,
    this.clipBehavior,
    List<BoxShadow>? boxShadow,
  }) : boxShadow = boxShadow == null ? null : List.unmodifiable(boxShadow);

  /// 容器的 background 配置；null 表示未指定。
  final HyperFill? background;

  /// 容器的 border 配置；null 表示未指定。
  final BoxBorder? border;

  /// 容器的 borderRadius 配置；null 表示未指定。
  final BorderRadiusGeometry? borderRadius;

  /// 容器的 padding 配置；null 表示未指定。
  final EdgeInsetsGeometry? padding;

  /// 容器的 margin 配置；null 表示未指定。
  final EdgeInsetsGeometry? margin;

  /// 容器的 alignment 配置；null 表示未指定。
  final AlignmentGeometry? alignment;

  /// 容器的 constraints 配置；null 表示未指定。
  final BoxConstraints? constraints;

  /// 容器的 animationDuration 配置；null 表示未指定。
  final Duration? animationDuration;

  /// 容器的 animationCurve 配置；null 表示未指定。
  final Curve? animationCurve;

  /// 容器的 clipBehavior 配置；null 表示未指定。
  final Clip? clipBehavior;

  /// 阴影列表；空列表显式移除阴影。
  final List<BoxShadow>? boxShadow;

  /// 不传参数保留原值；显式传 null 恢复该字段的继承行为。
  HyperContainerThemeData copyWith({
    Object? background = _unchanged,
    Object? border = _unchanged,
    Object? borderRadius = _unchanged,
    Object? padding = _unchanged,
    Object? margin = _unchanged,
    Object? alignment = _unchanged,
    Object? constraints = _unchanged,
    Object? animationDuration = _unchanged,
    Object? animationCurve = _unchanged,
    Object? clipBehavior = _unchanged,
    Object? boxShadow = _unchanged,
  }) => HyperContainerThemeData(
    background: identical(background, _unchanged)
        ? this.background
        : background as HyperFill?,
    border: identical(border, _unchanged) ? this.border : border as BoxBorder?,
    borderRadius: identical(borderRadius, _unchanged)
        ? this.borderRadius
        : borderRadius as BorderRadiusGeometry?,
    padding: identical(padding, _unchanged)
        ? this.padding
        : padding as EdgeInsetsGeometry?,
    margin: identical(margin, _unchanged)
        ? this.margin
        : margin as EdgeInsetsGeometry?,
    alignment: identical(alignment, _unchanged)
        ? this.alignment
        : alignment as AlignmentGeometry?,
    constraints: identical(constraints, _unchanged)
        ? this.constraints
        : constraints as BoxConstraints?,
    animationDuration: identical(animationDuration, _unchanged)
        ? this.animationDuration
        : animationDuration as Duration?,
    animationCurve: identical(animationCurve, _unchanged)
        ? this.animationCurve
        : animationCurve as Curve?,
    clipBehavior: identical(clipBehavior, _unchanged)
        ? this.clipBehavior
        : clipBehavior as Clip?,
    boxShadow: identical(boxShadow, _unchanged)
        ? this.boxShadow
        : boxShadow as List<BoxShadow>?,
  );

  /// 按字段合并；覆盖对象的 null 字段保持当前值。
  HyperContainerThemeData merge(HyperContainerThemeData? other) {
    if (other == null) return this;
    return HyperContainerThemeData(
      background: other.background ?? background,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      margin: other.margin ?? margin,
      alignment: other.alignment ?? alignment,
      constraints: other.constraints ?? constraints,
      animationDuration: other.animationDuration ?? animationDuration,
      animationCurve: other.animationCurve ?? animationCurve,
      clipBehavior: other.clipBehavior ?? clipBehavior,
      boxShadow: other.boxShadow ?? boxShadow,
    );
  }

  /// 对已解析的主题插值。未指定字段及离散属性在中点切换。
  ///
  /// 为保留继承语义，单侧为 null 时不将其解释为零或透明。
  static HyperContainerThemeData lerp(
    HyperContainerThemeData a,
    HyperContainerThemeData b,
    double t,
  ) {
    if (t == 0) return a;
    if (t == 1) return b;
    T? blend<T>(T? x, T? y, T Function(T, T, double) interpolate) {
      if (x == null || y == null) return t < 0.5 ? x : y;
      return interpolate(x, y, t);
    }

    return HyperContainerThemeData(
      background: blend(a.background, b.background, HyperFill.lerp),
      border: blend(a.border, b.border, (x, y, t) => BoxBorder.lerp(x, y, t)!),
      borderRadius: blend(
        a.borderRadius,
        b.borderRadius,
        (x, y, t) => BorderRadiusGeometry.lerp(x, y, t)!,
      ),
      padding: blend(
        a.padding,
        b.padding,
        (x, y, t) => EdgeInsetsGeometry.lerp(x, y, t)!,
      ),
      margin: blend(
        a.margin,
        b.margin,
        (x, y, t) => EdgeInsetsGeometry.lerp(x, y, t)!,
      ),
      alignment: blend(
        a.alignment,
        b.alignment,
        (x, y, t) => AlignmentGeometry.lerp(x, y, t)!,
      ),
      constraints: blend(
        a.constraints,
        b.constraints,
        (x, y, t) => BoxConstraints.lerp(x, y, t)!,
      ),
      boxShadow: blend(
        a.boxShadow,
        b.boxShadow,
        (x, y, t) => BoxShadow.lerpList(x, y, t)!,
      ),
      animationDuration: blend(
        a.animationDuration,
        b.animationDuration,
        (x, y, t) => Duration(
          microseconds:
              (x.inMicroseconds + (y.inMicroseconds - x.inMicroseconds) * t)
                  .round(),
        ),
      ),
      animationCurve: t < 0.5 ? a.animationCurve : b.animationCurve,
      clipBehavior: t < 0.5 ? a.clipBehavior : b.clipBehavior,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HyperContainerThemeData &&
            other.background == background &&
            other.border == border &&
            other.borderRadius == borderRadius &&
            other.padding == padding &&
            other.margin == margin &&
            other.alignment == alignment &&
            other.constraints == constraints &&
            other.animationDuration == animationDuration &&
            other.animationCurve == animationCurve &&
            other.clipBehavior == clipBehavior &&
            listEquals(other.boxShadow, boxShadow);
  }

  @override
  int get hashCode => Object.hash(
    background,
    border,
    borderRadius,
    padding,
    margin,
    alignment,
    constraints,
    animationDuration,
    animationCurve,
    clipBehavior,
    Object.hashAll(boxShadow ?? const <BoxShadow>[]),
  );
}
