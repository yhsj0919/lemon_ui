import 'package:flutter/material.dart';

/// HyperListTile 的视觉与布局覆盖。
@immutable
final class HyperListTileStyle {
  const HyperListTileStyle({
    this.foregroundColor,
    this.leadingColor,
    this.subtitleColor,
    this.trailingColor,
    this.disabledColor,
    this.overlayColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.minHeight,
    this.leadingSize,
    this.leadingIconSize,
    this.leadingSpacing,
    this.trailingSpacing,
    this.trailingIconSize,
    this.animationDuration,
    this.animationCurve,
  });

  final Color? foregroundColor;
  final Color? leadingColor;
  final Color? subtitleColor;
  final Color? trailingColor;
  final Color? disabledColor;
  final Color? overlayColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final double? minHeight;
  final double? leadingSize;
  final double? leadingIconSize;
  final double? leadingSpacing;
  final double? trailingSpacing;
  final double? trailingIconSize;
  final Duration? animationDuration;
  final Curve? animationCurve;

  HyperListTileStyle copyWith({
    Color? foregroundColor,
    Color? leadingColor,
    Color? subtitleColor,
    Color? trailingColor,
    Color? disabledColor,
    Color? overlayColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    EdgeInsetsGeometry? padding,
    double? minHeight,
    double? leadingSize,
    double? leadingIconSize,
    double? leadingSpacing,
    double? trailingSpacing,
    double? trailingIconSize,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => merge(
    HyperListTileStyle(
      foregroundColor: foregroundColor,
      leadingColor: leadingColor,
      subtitleColor: subtitleColor,
      trailingColor: trailingColor,
      disabledColor: disabledColor,
      overlayColor: overlayColor,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      padding: padding,
      minHeight: minHeight,
      leadingSize: leadingSize,
      leadingIconSize: leadingIconSize,
      leadingSpacing: leadingSpacing,
      trailingSpacing: trailingSpacing,
      trailingIconSize: trailingIconSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    ),
  );

  HyperListTileStyle merge(HyperListTileStyle? other) {
    if (other == null) return this;
    return HyperListTileStyle(
      foregroundColor: other.foregroundColor ?? foregroundColor,
      leadingColor: other.leadingColor ?? leadingColor,
      subtitleColor: other.subtitleColor ?? subtitleColor,
      trailingColor: other.trailingColor ?? trailingColor,
      disabledColor: other.disabledColor ?? disabledColor,
      overlayColor: other.overlayColor ?? overlayColor,
      titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      subtitleStyle:
          subtitleStyle?.merge(other.subtitleStyle) ?? other.subtitleStyle,
      padding: other.padding ?? padding,
      minHeight: other.minHeight ?? minHeight,
      leadingSize: other.leadingSize ?? leadingSize,
      leadingIconSize: other.leadingIconSize ?? leadingIconSize,
      leadingSpacing: other.leadingSpacing ?? leadingSpacing,
      trailingSpacing: other.trailingSpacing ?? trailingSpacing,
      trailingIconSize: other.trailingIconSize ?? trailingIconSize,
      animationDuration: other.animationDuration ?? animationDuration,
      animationCurve: other.animationCurve ?? animationCurve,
    );
  }

  static HyperListTileStyle lerp(
    HyperListTileStyle a,
    HyperListTileStyle b,
    double t,
  ) => a == b
      ? a
      : HyperListTileStyle(
          foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
          leadingColor: Color.lerp(a.leadingColor, b.leadingColor, t),
          subtitleColor: Color.lerp(a.subtitleColor, b.subtitleColor, t),
          trailingColor: Color.lerp(a.trailingColor, b.trailingColor, t),
          disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
          overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
          titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
          subtitleStyle: TextStyle.lerp(a.subtitleStyle, b.subtitleStyle, t),
          padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
          minHeight: _lerp(a.minHeight, b.minHeight, t),
          leadingSize: _lerp(a.leadingSize, b.leadingSize, t),
          leadingIconSize: _lerp(a.leadingIconSize, b.leadingIconSize, t),
          leadingSpacing: _lerp(a.leadingSpacing, b.leadingSpacing, t),
          trailingSpacing: _lerp(a.trailingSpacing, b.trailingSpacing, t),
          trailingIconSize: _lerp(a.trailingIconSize, b.trailingIconSize, t),
          animationDuration: t < .5 ? a.animationDuration : b.animationDuration,
          animationCurve: t < .5 ? a.animationCurve : b.animationCurve,
        );

  static double? _lerp(double? a, double? b, double t) {
    if (a == null || b == null) return t < .5 ? a : b;
    return a + (b - a) * t;
  }

  @override
  bool operator ==(Object other) =>
      other is HyperListTileStyle &&
      other.foregroundColor == foregroundColor &&
      other.leadingColor == leadingColor &&
      other.subtitleColor == subtitleColor &&
      other.trailingColor == trailingColor &&
      other.disabledColor == disabledColor &&
      other.overlayColor == overlayColor &&
      other.titleStyle == titleStyle &&
      other.subtitleStyle == subtitleStyle &&
      other.padding == padding &&
      other.minHeight == minHeight &&
      other.leadingSize == leadingSize &&
      other.leadingIconSize == leadingIconSize &&
      other.leadingSpacing == leadingSpacing &&
      other.trailingSpacing == trailingSpacing &&
      other.trailingIconSize == trailingIconSize &&
      other.animationDuration == animationDuration &&
      other.animationCurve == animationCurve;

  @override
  int get hashCode => Object.hash(
    foregroundColor,
    subtitleColor,
    trailingColor,
    disabledColor,
    overlayColor,
    titleStyle,
    subtitleStyle,
    padding,
    minHeight,
    leadingSize,
    leadingIconSize,
    leadingSpacing,
    trailingSpacing,
    trailingIconSize,
    animationDuration,
    animationCurve,
  );
}
