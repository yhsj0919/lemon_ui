import 'package:flutter/material.dart';

import '../card/hyper_card_style.dart';

/// Explicit visual and transition overrides; null fields inherit the theme.
@immutable
final class HyperImageStyle {
  const HyperImageStyle({
    this.surfaceStyle,
    this.placeholderColor,
    this.progressColor,
    this.progressTrackColor,
    this.failureIcon,
    this.iconColor,
    this.textStyle,
    this.failureText,
    this.retryText,
    this.iconSize,
    this.progressSize,
    this.progressThickness,
    this.spacing,
    this.padding,
    this.animationDuration,
    this.animationCurve,
    this.transitionBuilder,
  });
  final HyperCardStyle? surfaceStyle;
  final Color? placeholderColor;
  final Color? progressColor;
  final Color? progressTrackColor;
  final IconData? failureIcon;
  final Color? iconColor;
  final TextStyle? textStyle;
  final String? failureText;
  final String? retryText;
  final double? iconSize;
  final double? progressSize;
  final double? progressThickness;
  final double? spacing;
  final EdgeInsetsGeometry? padding;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperImageStyle copyWith({
    HyperCardStyle? surfaceStyle,
    Color? placeholderColor,
    Color? progressColor,
    Color? progressTrackColor,
    IconData? failureIcon,
    Color? iconColor,
    TextStyle? textStyle,
    String? failureText,
    String? retryText,
    double? iconSize,
    double? progressSize,
    double? progressThickness,
    double? spacing,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
    Curve? animationCurve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => HyperImageStyle(
    surfaceStyle: surfaceStyle == null
        ? this.surfaceStyle
        : (this.surfaceStyle ?? HyperCardStyle()).merge(surfaceStyle),
    placeholderColor: placeholderColor ?? this.placeholderColor,
    progressColor: progressColor ?? this.progressColor,
    progressTrackColor: progressTrackColor ?? this.progressTrackColor,
    failureIcon: failureIcon ?? this.failureIcon,
    iconColor: iconColor ?? this.iconColor,
    textStyle: this.textStyle?.merge(textStyle) ?? textStyle,
    failureText: failureText ?? this.failureText,
    retryText: retryText ?? this.retryText,
    iconSize: iconSize ?? this.iconSize,
    progressSize: progressSize ?? this.progressSize,
    progressThickness: progressThickness ?? this.progressThickness,
    spacing: spacing ?? this.spacing,
    padding: padding ?? this.padding,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperImageStyle merge(HyperImageStyle? other) => other == null
      ? this
      : copyWith(
          surfaceStyle: other.surfaceStyle,
          placeholderColor: other.placeholderColor,
          progressColor: other.progressColor,
          progressTrackColor: other.progressTrackColor,
          failureIcon: other.failureIcon,
          iconColor: other.iconColor,
          textStyle: other.textStyle,
          failureText: other.failureText,
          retryText: other.retryText,
          iconSize: other.iconSize,
          progressSize: other.progressSize,
          progressThickness: other.progressThickness,
          spacing: other.spacing,
          padding: other.padding,
          animationDuration: other.animationDuration,
          animationCurve: other.animationCurve,
          transitionBuilder: other.transitionBuilder,
        );
  static HyperImageStyle lerp(HyperImageStyle a, HyperImageStyle b, double t) {
    T? discrete<T>(T? a, T? b) => t < .5 ? a : b;
    double? number(double? a, double? b) =>
        a == null || b == null ? discrete(a, b) : a + (b - a) * t;
    return HyperImageStyle(
      surfaceStyle: a.surfaceStyle == null || b.surfaceStyle == null
          ? discrete(a.surfaceStyle, b.surfaceStyle)
          : HyperCardStyle.lerp(a.surfaceStyle!, b.surfaceStyle!, t),
      placeholderColor: Color.lerp(a.placeholderColor, b.placeholderColor, t),
      progressColor: Color.lerp(a.progressColor, b.progressColor, t),
      progressTrackColor: Color.lerp(
        a.progressTrackColor,
        b.progressTrackColor,
        t,
      ),
      failureIcon: discrete(a.failureIcon, b.failureIcon),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      failureText: discrete(a.failureText, b.failureText),
      retryText: discrete(a.retryText, b.retryText),
      iconSize: number(a.iconSize, b.iconSize),
      progressSize: number(a.progressSize, b.progressSize),
      progressThickness: number(a.progressThickness, b.progressThickness),
      spacing: number(a.spacing, b.spacing),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      animationDuration: discrete(a.animationDuration, b.animationDuration),
      animationCurve: discrete(a.animationCurve, b.animationCurve),
      transitionBuilder: discrete(a.transitionBuilder, b.transitionBuilder),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperImageStyle &&
      surfaceStyle == other.surfaceStyle &&
      placeholderColor == other.placeholderColor &&
      progressColor == other.progressColor &&
      progressTrackColor == other.progressTrackColor &&
      failureIcon == other.failureIcon &&
      iconColor == other.iconColor &&
      textStyle == other.textStyle &&
      failureText == other.failureText &&
      retryText == other.retryText &&
      iconSize == other.iconSize &&
      progressSize == other.progressSize &&
      progressThickness == other.progressThickness &&
      spacing == other.spacing &&
      padding == other.padding &&
      animationDuration == other.animationDuration &&
      animationCurve == other.animationCurve &&
      transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    surfaceStyle,
    placeholderColor,
    progressColor,
    progressTrackColor,
    failureIcon,
    iconColor,
    textStyle,
    failureText,
    retryText,
    iconSize,
    progressSize,
    progressThickness,
    spacing,
    padding,
    animationDuration,
    animationCurve,
    transitionBuilder,
  ]);
}
