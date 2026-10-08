import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../button/hyper_button_theme.dart';

@immutable
final class HyperBottomSheetStyle {
  const HyperBottomSheetStyle({
    this.background,
    this.material,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.width,
    this.maxWidth,
    this.height,
    this.maxHeight,
    this.padding,
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
    this.dragHandleColor,
    this.dragHandleSize,
    this.dragHandleBorderRadius,
    this.dragHandlePadding,
    this.barrierColor,
    this.animationStyle,
    this.clipBehavior,
  });
  final HyperFill? background;
  final HyperSurfaceMaterial? material;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? maxWidth;
  final double? height;
  final double? maxHeight;
  final EdgeInsetsGeometry? padding;
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
  final Color? dragHandleColor;
  final Size? dragHandleSize;
  final BorderRadiusGeometry? dragHandleBorderRadius;
  final EdgeInsetsGeometry? dragHandlePadding;
  final Color? barrierColor;
  final AnimationStyle? animationStyle;
  final Clip? clipBehavior;
  HyperBottomSheetStyle copyWith({
    HyperFill? background,
    HyperSurfaceMaterial? material,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    double? width,
    double? maxWidth,
    double? height,
    double? maxHeight,
    EdgeInsetsGeometry? padding,
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
    Color? dragHandleColor,
    Size? dragHandleSize,
    BorderRadiusGeometry? dragHandleBorderRadius,
    EdgeInsetsGeometry? dragHandlePadding,
    Color? barrierColor,
    AnimationStyle? animationStyle,
    Clip? clipBehavior,
  }) => HyperBottomSheetStyle(
    background: background ?? this.background,
    material: material ?? this.material,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    boxShadow: boxShadow ?? this.boxShadow,
    width: width ?? this.width,
    maxWidth: maxWidth ?? this.maxWidth,
    height: height ?? this.height,
    maxHeight: maxHeight ?? this.maxHeight,
    padding: padding ?? this.padding,
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
    dragHandleColor: dragHandleColor ?? this.dragHandleColor,
    dragHandleSize: dragHandleSize ?? this.dragHandleSize,
    dragHandleBorderRadius:
        dragHandleBorderRadius ?? this.dragHandleBorderRadius,
    dragHandlePadding: dragHandlePadding ?? this.dragHandlePadding,
    barrierColor: barrierColor ?? this.barrierColor,
    animationStyle: animationStyle ?? this.animationStyle,
    clipBehavior: clipBehavior ?? this.clipBehavior,
  );
  HyperBottomSheetStyle merge(HyperBottomSheetStyle? other) => other == null
      ? this
      : copyWith(
          background: other.background,
          material: other.material,
          border: other.border,
          borderRadius: other.borderRadius,
          boxShadow: other.boxShadow,
          width: other.width,
          maxWidth: other.maxWidth,
          height: other.height,
          maxHeight: other.maxHeight,
          padding: other.padding,
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
          dragHandleColor: other.dragHandleColor,
          dragHandleSize: other.dragHandleSize,
          dragHandleBorderRadius: other.dragHandleBorderRadius,
          dragHandlePadding: other.dragHandlePadding,
          barrierColor: other.barrierColor,
          animationStyle:
              animationStyle?.merge(other.animationStyle) ??
              other.animationStyle,
          clipBehavior: other.clipBehavior,
        );
  static HyperBottomSheetStyle lerp(
    HyperBottomSheetStyle a,
    HyperBottomSheetStyle b,
    double t,
  ) {
    if (t == 0 || a == b) return a;
    if (t == 1) return b;
    return HyperBottomSheetStyle(
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
      height: a.height == null || b.height == null
          ? (t < .5 ? a.height : b.height)
          : a.height! + (b.height! - a.height!) * t,
      maxHeight: a.maxHeight == null || b.maxHeight == null
          ? (t < .5 ? a.maxHeight : b.maxHeight)
          : a.maxHeight! + (b.maxHeight! - a.maxHeight!) * t,
      padding: a.padding == null || b.padding == null
          ? (t < .5 ? a.padding : b.padding)
          : EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
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
      dragHandleColor: a.dragHandleColor == null || b.dragHandleColor == null
          ? (t < .5 ? a.dragHandleColor : b.dragHandleColor)
          : Color.lerp(a.dragHandleColor, b.dragHandleColor, t),
      dragHandleSize: a.dragHandleSize == null || b.dragHandleSize == null
          ? (t < .5 ? a.dragHandleSize : b.dragHandleSize)
          : Size.lerp(a.dragHandleSize, b.dragHandleSize, t),
      dragHandleBorderRadius:
          a.dragHandleBorderRadius == null || b.dragHandleBorderRadius == null
          ? (t < .5 ? a.dragHandleBorderRadius : b.dragHandleBorderRadius)
          : BorderRadiusGeometry.lerp(
              a.dragHandleBorderRadius,
              b.dragHandleBorderRadius,
              t,
            ),
      dragHandlePadding:
          a.dragHandlePadding == null || b.dragHandlePadding == null
          ? (t < .5 ? a.dragHandlePadding : b.dragHandlePadding)
          : EdgeInsetsGeometry.lerp(
              a.dragHandlePadding,
              b.dragHandlePadding,
              t,
            ),
      barrierColor: a.barrierColor == null || b.barrierColor == null
          ? (t < .5 ? a.barrierColor : b.barrierColor)
          : Color.lerp(a.barrierColor, b.barrierColor, t),
      animationStyle: a.animationStyle == null || b.animationStyle == null
          ? (t < .5 ? a.animationStyle : b.animationStyle)
          : AnimationStyle.lerp(a.animationStyle, b.animationStyle, t),
      clipBehavior: a.clipBehavior == null || b.clipBehavior == null
          ? (t < .5 ? a.clipBehavior : b.clipBehavior)
          : t < .5
          ? a.clipBehavior
          : b.clipBehavior,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperBottomSheetStyle &&
      background == other.background &&
      material == other.material &&
      border == other.border &&
      borderRadius == other.borderRadius &&
      listEquals(boxShadow, other.boxShadow) &&
      width == other.width &&
      maxWidth == other.maxWidth &&
      height == other.height &&
      maxHeight == other.maxHeight &&
      padding == other.padding &&
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
      dragHandleColor == other.dragHandleColor &&
      dragHandleSize == other.dragHandleSize &&
      dragHandleBorderRadius == other.dragHandleBorderRadius &&
      dragHandlePadding == other.dragHandlePadding &&
      barrierColor == other.barrierColor &&
      animationStyle == other.animationStyle &&
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
    height,
    maxHeight,
    padding,
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
    dragHandleColor,
    dragHandleSize,
    dragHandleBorderRadius,
    dragHandlePadding,
    barrierColor,
    animationStyle,
    clipBehavior,
  ]);
}
