import 'package:flutter/material.dart';

/// 面包屑颜色与文字样式；空字段继承上一层主题。
@immutable
final class HyperBreadcrumbStyle {
  const HyperBreadcrumbStyle({
    this.backgroundColor,
    this.highlightBackgroundColor,
    this.disabledBackgroundColor,
    this.foregroundColor,
    this.highlightForegroundColor,
    this.separatorColor,
    this.disabledColor,
    this.textStyle,
  });

  final Color? backgroundColor;
  final Color? highlightBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? foregroundColor;
  final Color? highlightForegroundColor;
  final Color? separatorColor;
  final Color? disabledColor;
  final TextStyle? textStyle;

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
          disabledColor: other.disabledColor ?? disabledColor,
          textStyle: other.textStyle ?? textStyle,
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
    disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
    textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperBreadcrumbStyle &&
      other.backgroundColor == backgroundColor &&
      other.highlightBackgroundColor == highlightBackgroundColor &&
      other.disabledBackgroundColor == disabledBackgroundColor &&
      other.foregroundColor == foregroundColor &&
      other.highlightForegroundColor == highlightForegroundColor &&
      other.separatorColor == separatorColor &&
      other.disabledColor == disabledColor &&
      other.textStyle == textStyle;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    highlightBackgroundColor,
    disabledBackgroundColor,
    foregroundColor,
    highlightForegroundColor,
    separatorColor,
    disabledColor,
    textStyle,
  );
}
