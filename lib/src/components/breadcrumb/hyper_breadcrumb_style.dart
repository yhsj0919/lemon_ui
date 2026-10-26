import 'package:flutter/material.dart';

import '../card/hyper_card_style.dart';

enum HyperBreadcrumbSeparator { slash, chevron }

@immutable
final class HyperBreadcrumbStyle {
  const HyperBreadcrumbStyle({
    this.backgroundColor,
    this.highlightBackgroundColor,
    this.disabledBackgroundColor,
    this.foregroundColor,
    this.highlightForegroundColor,
    this.separatorColor,
    this.separator,
    this.disabledColor,
    this.textStyle,
    this.itemStyle,
    this.highlightStyle,
    this.disabledStyle,
  });
  final Color? backgroundColor;
  final Color? highlightBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? foregroundColor;
  final Color? highlightForegroundColor;
  final Color? separatorColor;
  final HyperBreadcrumbSeparator? separator;
  final Color? disabledColor;
  final TextStyle? textStyle;
  final HyperCardStyle? itemStyle;
  final HyperCardStyle? highlightStyle;
  final HyperCardStyle? disabledStyle;
  HyperBreadcrumbStyle copyWith({
    Color? backgroundColor,
    Color? highlightBackgroundColor,
    Color? disabledBackgroundColor,
    Color? foregroundColor,
    Color? highlightForegroundColor,
    Color? separatorColor,
    HyperBreadcrumbSeparator? separator,
    Color? disabledColor,
    TextStyle? textStyle,
    HyperCardStyle? itemStyle,
    HyperCardStyle? highlightStyle,
    HyperCardStyle? disabledStyle,
  }) => merge(
    HyperBreadcrumbStyle(
      backgroundColor: backgroundColor,
      highlightBackgroundColor: highlightBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      foregroundColor: foregroundColor,
      highlightForegroundColor: highlightForegroundColor,
      separatorColor: separatorColor,
      separator: separator,
      disabledColor: disabledColor,
      textStyle: textStyle,
      itemStyle: itemStyle,
      highlightStyle: highlightStyle,
      disabledStyle: disabledStyle,
    ),
  );
  HyperBreadcrumbStyle merge(HyperBreadcrumbStyle? other) => other == null
      ? this
      : HyperBreadcrumbStyle(
          backgroundColor: other.backgroundColor ?? backgroundColor,
          highlightBackgroundColor:
              other.highlightBackgroundColor ?? highlightBackgroundColor,
          disabledBackgroundColor:
              other.disabledBackgroundColor ?? disabledBackgroundColor,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          highlightForegroundColor:
              other.highlightForegroundColor ?? highlightForegroundColor,
          separatorColor: other.separatorColor ?? separatorColor,
          separator: other.separator ?? separator,
          disabledColor: other.disabledColor ?? disabledColor,
          textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
          itemStyle: itemStyle?.merge(other.itemStyle) ?? other.itemStyle,
          highlightStyle:
              highlightStyle?.merge(other.highlightStyle) ??
              other.highlightStyle,
          disabledStyle:
              disabledStyle?.merge(other.disabledStyle) ?? other.disabledStyle,
        );
  static HyperBreadcrumbStyle lerp(
    HyperBreadcrumbStyle a,
    HyperBreadcrumbStyle b,
    double t,
  ) => HyperBreadcrumbStyle(
    backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
    highlightBackgroundColor: Color.lerp(
      a.highlightBackgroundColor,
      b.highlightBackgroundColor,
      t,
    ),
    disabledBackgroundColor: Color.lerp(
      a.disabledBackgroundColor,
      b.disabledBackgroundColor,
      t,
    ),
    foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
    highlightForegroundColor: Color.lerp(
      a.highlightForegroundColor,
      b.highlightForegroundColor,
      t,
    ),
    separatorColor: Color.lerp(a.separatorColor, b.separatorColor, t),
    separator: t < .5 ? a.separator : b.separator,
    disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
    textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    itemStyle: a.itemStyle == null || b.itemStyle == null
        ? (t < .5 ? a.itemStyle : b.itemStyle)
        : HyperCardStyle.lerp(a.itemStyle!, b.itemStyle!, t),
    highlightStyle: a.highlightStyle == null || b.highlightStyle == null
        ? (t < .5 ? a.highlightStyle : b.highlightStyle)
        : HyperCardStyle.lerp(a.highlightStyle!, b.highlightStyle!, t),
    disabledStyle: a.disabledStyle == null || b.disabledStyle == null
        ? (t < .5 ? a.disabledStyle : b.disabledStyle)
        : HyperCardStyle.lerp(a.disabledStyle!, b.disabledStyle!, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperBreadcrumbStyle &&
      backgroundColor == other.backgroundColor &&
      highlightBackgroundColor == other.highlightBackgroundColor &&
      disabledBackgroundColor == other.disabledBackgroundColor &&
      foregroundColor == other.foregroundColor &&
      highlightForegroundColor == other.highlightForegroundColor &&
      separatorColor == other.separatorColor &&
      separator == other.separator &&
      disabledColor == other.disabledColor &&
      textStyle == other.textStyle &&
      itemStyle == other.itemStyle &&
      highlightStyle == other.highlightStyle &&
      disabledStyle == other.disabledStyle;
  @override
  int get hashCode => Object.hashAll([
    backgroundColor,
    highlightBackgroundColor,
    disabledBackgroundColor,
    foregroundColor,
    highlightForegroundColor,
    separatorColor,
    separator,
    disabledColor,
    textStyle,
    itemStyle,
    highlightStyle,
    disabledStyle,
  ]);
}
