import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../button/hyper_button_theme.dart';

/// 对话框表面、布局、按钮与路由过渡；null 表示继承。
@immutable
final class HyperDialogStyle {
  const HyperDialogStyle({
    this.background,
    this.material,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.width,
    this.maxWidth,
    this.insetPadding,
    this.padding,
    this.alignment,
    this.titleStyle,
    this.contentStyle,
    this.titleSpacing,
    this.actionSpacing,
    this.actionRunSpacing,
    this.actionsAlignment,
    this.actionsDirection,
    this.buttonTheme,
    this.closeIcon,
    this.closeIconColor,
    this.closeIconSize,
    this.barrierColor,
    this.duration,
    this.curve,
    this.transitionBuilder,
    this.clipBehavior,
  });
  final HyperFill? background;
  final HyperSurfaceMaterial? material;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? maxWidth;
  final EdgeInsetsGeometry? insetPadding;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final double? titleSpacing;
  final double? actionSpacing;
  final double? actionRunSpacing;
  final WrapAlignment? actionsAlignment;
  final Axis? actionsDirection;
  final HyperButtonThemeData? buttonTheme;
  final IconData? closeIcon;
  final Color? closeIconColor;
  final double? closeIconSize;
  final Color? barrierColor;
  final Duration? duration;
  final Curve? curve;
  final RouteTransitionsBuilder? transitionBuilder;
  final Clip? clipBehavior;
  HyperDialogStyle copyWith({
    HyperFill? background,
    HyperSurfaceMaterial? material,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    double? width,
    double? maxWidth,
    EdgeInsetsGeometry? insetPadding,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    double? titleSpacing,
    double? actionSpacing,
    double? actionRunSpacing,
    WrapAlignment? actionsAlignment,
    Axis? actionsDirection,
    HyperButtonThemeData? buttonTheme,
    IconData? closeIcon,
    Color? closeIconColor,
    double? closeIconSize,
    Color? barrierColor,
    Duration? duration,
    Curve? curve,
    RouteTransitionsBuilder? transitionBuilder,
    Clip? clipBehavior,
  }) => HyperDialogStyle(
    background: background ?? this.background,
    material: material ?? this.material,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    boxShadow: boxShadow ?? this.boxShadow,
    width: width ?? this.width,
    maxWidth: maxWidth ?? this.maxWidth,
    insetPadding: insetPadding ?? this.insetPadding,
    padding: padding ?? this.padding,
    alignment: alignment ?? this.alignment,
    titleStyle: titleStyle ?? this.titleStyle,
    contentStyle: contentStyle ?? this.contentStyle,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    actionSpacing: actionSpacing ?? this.actionSpacing,
    actionRunSpacing: actionRunSpacing ?? this.actionRunSpacing,
    actionsAlignment: actionsAlignment ?? this.actionsAlignment,
    actionsDirection: actionsDirection ?? this.actionsDirection,
    buttonTheme: buttonTheme ?? this.buttonTheme,
    closeIcon: closeIcon ?? this.closeIcon,
    closeIconColor: closeIconColor ?? this.closeIconColor,
    closeIconSize: closeIconSize ?? this.closeIconSize,
    barrierColor: barrierColor ?? this.barrierColor,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    clipBehavior: clipBehavior ?? this.clipBehavior,
  );
  HyperDialogStyle merge(HyperDialogStyle? other) => other == null
      ? this
      : copyWith(
          background: other.background,
          material: other.material,
          border: other.border,
          borderRadius: other.borderRadius,
          boxShadow: other.boxShadow,
          width: other.width,
          maxWidth: other.maxWidth,
          insetPadding: other.insetPadding,
          padding: other.padding,
          alignment: other.alignment,
          titleStyle: other.titleStyle,
          contentStyle: other.contentStyle,
          titleSpacing: other.titleSpacing,
          actionSpacing: other.actionSpacing,
          actionRunSpacing: other.actionRunSpacing,
          actionsAlignment: other.actionsAlignment,
          actionsDirection: other.actionsDirection,
          buttonTheme:
              buttonTheme?.merge(other.buttonTheme) ?? other.buttonTheme,
          closeIcon: other.closeIcon,
          closeIconColor: other.closeIconColor,
          closeIconSize: other.closeIconSize,
          barrierColor: other.barrierColor,
          duration: other.duration,
          curve: other.curve,
          transitionBuilder: other.transitionBuilder,
          clipBehavior: other.clipBehavior,
        );
  static HyperDialogStyle lerp(
    HyperDialogStyle a,
    HyperDialogStyle b,
    double t,
  ) {
    if (t == 0 || a == b) return a;
    if (t == 1) return b;
    return HyperDialogStyle(
      background: a.background == null || b.background == null
          ? (t < .5 ? a.background : b.background)
          : HyperFill.lerp(a.background!, b.background!, t),
      material: a.material == null || b.material == null
          ? (t < .5 ? a.material : b.material)
          : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
      border: a.border == null || b.border == null
          ? (t < .5 ? a.border : b.border)
          : BoxBorder.lerp(a.border, b.border, t),
      borderRadius: a.borderRadius == null || b.borderRadius == null
          ? (t < .5 ? a.borderRadius : b.borderRadius)
          : BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
      boxShadow: a.boxShadow == null || b.boxShadow == null
          ? (t < .5 ? a.boxShadow : b.boxShadow)
          : BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      width: a.width == null || b.width == null
          ? (t < .5 ? a.width : b.width)
          : a.width! + (b.width! - a.width!) * t,
      maxWidth: a.maxWidth == null || b.maxWidth == null
          ? (t < .5 ? a.maxWidth : b.maxWidth)
          : a.maxWidth! + (b.maxWidth! - a.maxWidth!) * t,
      insetPadding: a.insetPadding == null || b.insetPadding == null
          ? (t < .5 ? a.insetPadding : b.insetPadding)
          : EdgeInsetsGeometry.lerp(a.insetPadding, b.insetPadding, t),
      padding: a.padding == null || b.padding == null
          ? (t < .5 ? a.padding : b.padding)
          : EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      alignment: a.alignment == null || b.alignment == null
          ? (t < .5 ? a.alignment : b.alignment)
          : AlignmentGeometry.lerp(a.alignment, b.alignment, t),
      titleStyle: a.titleStyle == null || b.titleStyle == null
          ? (t < .5 ? a.titleStyle : b.titleStyle)
          : TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      contentStyle: a.contentStyle == null || b.contentStyle == null
          ? (t < .5 ? a.contentStyle : b.contentStyle)
          : TextStyle.lerp(a.contentStyle, b.contentStyle, t),
      titleSpacing: a.titleSpacing == null || b.titleSpacing == null
          ? (t < .5 ? a.titleSpacing : b.titleSpacing)
          : a.titleSpacing! + (b.titleSpacing! - a.titleSpacing!) * t,
      actionSpacing: a.actionSpacing == null || b.actionSpacing == null
          ? (t < .5 ? a.actionSpacing : b.actionSpacing)
          : a.actionSpacing! + (b.actionSpacing! - a.actionSpacing!) * t,
      actionRunSpacing: a.actionRunSpacing == null || b.actionRunSpacing == null
          ? (t < .5 ? a.actionRunSpacing : b.actionRunSpacing)
          : a.actionRunSpacing! +
                (b.actionRunSpacing! - a.actionRunSpacing!) * t,
      actionsAlignment: a.actionsAlignment == null || b.actionsAlignment == null
          ? (t < .5 ? a.actionsAlignment : b.actionsAlignment)
          : t < .5
          ? a.actionsAlignment
          : b.actionsAlignment,
      actionsDirection: a.actionsDirection == null || b.actionsDirection == null
          ? (t < .5 ? a.actionsDirection : b.actionsDirection)
          : t < .5
          ? a.actionsDirection
          : b.actionsDirection,
      buttonTheme: a.buttonTheme == null || b.buttonTheme == null
          ? (t < .5 ? a.buttonTheme : b.buttonTheme)
          : HyperButtonThemeData.lerp(a.buttonTheme!, b.buttonTheme!, t),
      closeIcon: a.closeIcon == null || b.closeIcon == null
          ? (t < .5 ? a.closeIcon : b.closeIcon)
          : t < .5
          ? a.closeIcon
          : b.closeIcon,
      closeIconColor: a.closeIconColor == null || b.closeIconColor == null
          ? (t < .5 ? a.closeIconColor : b.closeIconColor)
          : Color.lerp(a.closeIconColor, b.closeIconColor, t),
      closeIconSize: a.closeIconSize == null || b.closeIconSize == null
          ? (t < .5 ? a.closeIconSize : b.closeIconSize)
          : a.closeIconSize! + (b.closeIconSize! - a.closeIconSize!) * t,
      barrierColor: a.barrierColor == null || b.barrierColor == null
          ? (t < .5 ? a.barrierColor : b.barrierColor)
          : Color.lerp(a.barrierColor, b.barrierColor, t),
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
      curve: a.curve == null || b.curve == null
          ? (t < .5 ? a.curve : b.curve)
          : t < .5
          ? a.curve
          : b.curve,
      transitionBuilder:
          a.transitionBuilder == null || b.transitionBuilder == null
          ? (t < .5 ? a.transitionBuilder : b.transitionBuilder)
          : t < .5
          ? a.transitionBuilder
          : b.transitionBuilder,
      clipBehavior: a.clipBehavior == null || b.clipBehavior == null
          ? (t < .5 ? a.clipBehavior : b.clipBehavior)
          : t < .5
          ? a.clipBehavior
          : b.clipBehavior,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperDialogStyle &&
      background == other.background &&
      material == other.material &&
      border == other.border &&
      borderRadius == other.borderRadius &&
      listEquals(boxShadow, other.boxShadow) &&
      width == other.width &&
      maxWidth == other.maxWidth &&
      insetPadding == other.insetPadding &&
      padding == other.padding &&
      alignment == other.alignment &&
      titleStyle == other.titleStyle &&
      contentStyle == other.contentStyle &&
      titleSpacing == other.titleSpacing &&
      actionSpacing == other.actionSpacing &&
      actionRunSpacing == other.actionRunSpacing &&
      actionsAlignment == other.actionsAlignment &&
      actionsDirection == other.actionsDirection &&
      buttonTheme == other.buttonTheme &&
      closeIcon == other.closeIcon &&
      closeIconColor == other.closeIconColor &&
      closeIconSize == other.closeIconSize &&
      barrierColor == other.barrierColor &&
      duration == other.duration &&
      curve == other.curve &&
      transitionBuilder == other.transitionBuilder &&
      clipBehavior == other.clipBehavior;
  @override
  int get hashCode => Object.hashAll([
    background,
    material,
    border,
    borderRadius,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    width,
    maxWidth,
    insetPadding,
    padding,
    alignment,
    titleStyle,
    contentStyle,
    titleSpacing,
    actionSpacing,
    actionRunSpacing,
    actionsAlignment,
    actionsDirection,
    buttonTheme,
    closeIcon,
    closeIconColor,
    closeIconSize,
    barrierColor,
    duration,
    curve,
    transitionBuilder,
    clipBehavior,
  ]);
}
