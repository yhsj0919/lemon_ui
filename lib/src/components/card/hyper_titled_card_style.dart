import 'package:flutter/material.dart';

/// 标题行的实例或局部覆盖；null 继续继承全局解析结果。
@immutable
final class HyperTitledCardStyle {
  const HyperTitledCardStyle({
    this.titlePadding,
    this.titleSpacing,
    this.actionSpacing,
    this.titleTextStyle,
    this.actionTextStyle,
  });

  /// 标题行与卡片边缘的距离。
  final EdgeInsetsGeometry? titlePadding;

  /// 标题行到主体内容的距离。
  final double? titleSpacing;

  /// 标题与右侧 action 的最小距离。
  final double? actionSpacing;
  final TextStyle? titleTextStyle;

  /// 标题右侧内容的默认文字样式；显式子控件样式仍优先。
  final TextStyle? actionTextStyle;

  HyperTitledCardStyle merge(HyperTitledCardStyle? other) => other == null
      ? this
      : HyperTitledCardStyle(
          titlePadding: other.titlePadding ?? titlePadding,
          titleSpacing: other.titleSpacing ?? titleSpacing,
          actionSpacing: other.actionSpacing ?? actionSpacing,
          titleTextStyle:
              titleTextStyle?.merge(other.titleTextStyle) ??
              other.titleTextStyle,
          actionTextStyle:
              actionTextStyle?.merge(other.actionTextStyle) ??
              other.actionTextStyle,
        );

  HyperTitledCardStyle copyWith({
    EdgeInsetsGeometry? titlePadding,
    double? titleSpacing,
    double? actionSpacing,
    TextStyle? titleTextStyle,
    TextStyle? actionTextStyle,
  }) => HyperTitledCardStyle(
    titlePadding: titlePadding ?? this.titlePadding,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    actionSpacing: actionSpacing ?? this.actionSpacing,
    titleTextStyle:
        this.titleTextStyle?.merge(titleTextStyle) ?? titleTextStyle,
    actionTextStyle:
        this.actionTextStyle?.merge(actionTextStyle) ?? actionTextStyle,
  );

  static HyperTitledCardStyle lerp(
    HyperTitledCardStyle a,
    HyperTitledCardStyle b,
    double t,
  ) => HyperTitledCardStyle(
    titlePadding: EdgeInsetsGeometry.lerp(a.titlePadding, b.titlePadding, t),
    titleSpacing: a.titleSpacing == null || b.titleSpacing == null
        ? (t < .5 ? a.titleSpacing : b.titleSpacing)
        : a.titleSpacing! + (b.titleSpacing! - a.titleSpacing!) * t,
    actionSpacing: a.actionSpacing == null || b.actionSpacing == null
        ? (t < .5 ? a.actionSpacing : b.actionSpacing)
        : a.actionSpacing! + (b.actionSpacing! - a.actionSpacing!) * t,
    titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
    actionTextStyle: TextStyle.lerp(a.actionTextStyle, b.actionTextStyle, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperTitledCardStyle &&
      other.titlePadding == titlePadding &&
      other.titleSpacing == titleSpacing &&
      other.actionSpacing == actionSpacing &&
      other.titleTextStyle == titleTextStyle &&
      other.actionTextStyle == actionTextStyle;

  @override
  int get hashCode => Object.hash(
    titlePadding,
    titleSpacing,
    actionSpacing,
    titleTextStyle,
    actionTextStyle,
  );
}
