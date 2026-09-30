import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';

@immutable
final class HyperEmptyStateStyle {
  const HyperEmptyStateStyle({
    this.icon,
    this.iconColor,
    this.iconSize,
    this.illustrationSize,
    this.maxWidth,
    this.contentSpacing,
    this.titleSpacing,
    this.actionSpacing,
    this.actionRunSpacing,
    this.padding,
    this.background,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.titleStyle,
    this.descriptionStyle,
    this.textAlign,
    this.actionAlignment,
    this.alignment,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final double? illustrationSize;
  final double? maxWidth;
  final double? contentSpacing;
  final double? titleSpacing;
  final double? actionSpacing;
  final double? actionRunSpacing;
  final EdgeInsetsGeometry? padding;
  final HyperFill? background;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final TextAlign? textAlign;
  final WrapAlignment? actionAlignment;
  final AlignmentGeometry? alignment;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperEmptyStateStyle copyWith({
    IconData? icon,
    Color? iconColor,
    double? iconSize,
    double? illustrationSize,
    double? maxWidth,
    double? contentSpacing,
    double? titleSpacing,
    double? actionSpacing,
    double? actionRunSpacing,
    EdgeInsetsGeometry? padding,
    HyperFill? background,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TextAlign? textAlign,
    WrapAlignment? actionAlignment,
    AlignmentGeometry? alignment,
    Duration? duration,
    Curve? curve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => merge(
    HyperEmptyStateStyle(
      icon: icon,
      iconColor: iconColor,
      iconSize: iconSize,
      illustrationSize: illustrationSize,
      maxWidth: maxWidth,
      contentSpacing: contentSpacing,
      titleSpacing: titleSpacing,
      actionSpacing: actionSpacing,
      actionRunSpacing: actionRunSpacing,
      padding: padding,
      background: background,
      border: border,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      titleStyle: titleStyle,
      descriptionStyle: descriptionStyle,
      textAlign: textAlign,
      actionAlignment: actionAlignment,
      alignment: alignment,
      duration: duration,
      curve: curve,
      transitionBuilder: transitionBuilder,
    ),
  );
  HyperEmptyStateStyle merge(HyperEmptyStateStyle? other) => other == null
      ? this
      : HyperEmptyStateStyle(
          icon: other.icon ?? icon,
          iconColor: other.iconColor ?? iconColor,
          iconSize: other.iconSize ?? iconSize,
          illustrationSize: other.illustrationSize ?? illustrationSize,
          maxWidth: other.maxWidth ?? maxWidth,
          contentSpacing: other.contentSpacing ?? contentSpacing,
          titleSpacing: other.titleSpacing ?? titleSpacing,
          actionSpacing: other.actionSpacing ?? actionSpacing,
          actionRunSpacing: other.actionRunSpacing ?? actionRunSpacing,
          padding: other.padding ?? padding,
          background: other.background ?? background,
          border: other.border ?? border,
          borderRadius: other.borderRadius ?? borderRadius,
          boxShadow: other.boxShadow ?? boxShadow,
          titleStyle: other.titleStyle ?? titleStyle,
          descriptionStyle: other.descriptionStyle ?? descriptionStyle,
          textAlign: other.textAlign ?? textAlign,
          actionAlignment: other.actionAlignment ?? actionAlignment,
          alignment: other.alignment ?? alignment,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperEmptyStateStyle lerp(
    HyperEmptyStateStyle a,
    HyperEmptyStateStyle b,
    double t,
  ) => t == 0 || a == b
      ? a
      : t == 1
      ? b
      : HyperEmptyStateStyle(
          icon: t < .5 ? a.icon : b.icon,
          iconColor: Color.lerp(a.iconColor, b.iconColor, t),
          iconSize: lerpDouble(a.iconSize, b.iconSize, t),
          illustrationSize: lerpDouble(
            a.illustrationSize,
            b.illustrationSize,
            t,
          ),
          maxWidth: lerpDouble(a.maxWidth, b.maxWidth, t),
          contentSpacing: lerpDouble(a.contentSpacing, b.contentSpacing, t),
          titleSpacing: lerpDouble(a.titleSpacing, b.titleSpacing, t),
          actionSpacing: lerpDouble(a.actionSpacing, b.actionSpacing, t),
          actionRunSpacing: lerpDouble(
            a.actionRunSpacing,
            b.actionRunSpacing,
            t,
          ),
          padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
          background: a.background == null || b.background == null
              ? (t < .5 ? a.background : b.background)
              : HyperFill.lerp(a.background!, b.background!, t),
          border: BoxBorder.lerp(a.border, b.border, t),
          borderRadius: BorderRadiusGeometry.lerp(
            a.borderRadius,
            b.borderRadius,
            t,
          ),
          boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
          titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
          descriptionStyle: TextStyle.lerp(
            a.descriptionStyle,
            b.descriptionStyle,
            t,
          ),
          textAlign: t < .5 ? a.textAlign : b.textAlign,
          actionAlignment: t < .5 ? a.actionAlignment : b.actionAlignment,
          alignment: AlignmentGeometry.lerp(a.alignment, b.alignment, t),
          duration: a.duration == null || b.duration == null
              ? (t < .5 ? a.duration : b.duration)
              : Duration(
                  microseconds:
                      (a.duration!.inMicroseconds +
                              (b.duration!.inMicroseconds -
                                      a.duration!.inMicroseconds) *
                                  t)
                          .round(),
                ),
          curve: t < .5 ? a.curve : b.curve,
          transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
        );
  @override
  bool operator ==(Object other) =>
      other is HyperEmptyStateStyle &&
      other.icon == icon &&
      other.iconColor == iconColor &&
      other.iconSize == iconSize &&
      other.illustrationSize == illustrationSize &&
      other.maxWidth == maxWidth &&
      other.contentSpacing == contentSpacing &&
      other.titleSpacing == titleSpacing &&
      other.actionSpacing == actionSpacing &&
      other.actionRunSpacing == actionRunSpacing &&
      other.padding == padding &&
      other.background == background &&
      other.border == border &&
      other.borderRadius == borderRadius &&
      listEquals(other.boxShadow, boxShadow) &&
      other.titleStyle == titleStyle &&
      other.descriptionStyle == descriptionStyle &&
      other.textAlign == textAlign &&
      other.actionAlignment == actionAlignment &&
      other.alignment == alignment &&
      other.duration == duration &&
      other.curve == curve &&
      other.transitionBuilder == transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    icon,
    iconColor,
    iconSize,
    illustrationSize,
    maxWidth,
    contentSpacing,
    titleSpacing,
    actionSpacing,
    actionRunSpacing,
    padding,
    background,
    border,
    borderRadius,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    titleStyle,
    descriptionStyle,
    textAlign,
    actionAlignment,
    alignment,
    duration,
    curve,
    transitionBuilder,
  ]);
}
