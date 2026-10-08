import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../button/hyper_button_theme.dart';

enum HyperNoticeSeverity { info, success, warning, error }

typedef HyperNoticeTransitionBuilder = Widget Function(
  BuildContext context,
  double value,
  Widget child,
);

/// Alert 与 Banner 的字段模板；两个组件的主题和尺寸独立。
@immutable
final class HyperNoticeStyle {
  const HyperNoticeStyle({
    this.background,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.padding,
    this.titleStyle,
    this.contentStyle,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.closeIcon,
    this.closeIconColor,
    this.closeIconSize,
    this.closeButtonSize,
    this.closeLabel,
    this.spacing,
    this.titleSpacing,
    this.actionSpacing,
    this.actionRunSpacing,
    this.actionsAlignment,
    this.buttonTheme,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final HyperFill? background;
  final HyperSurfaceMaterial? material;
  final HyperMaterialQuality? materialQuality;
  final bool? reduceTransparency;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final IconData? closeIcon;
  final Color? closeIconColor;
  final double? closeIconSize;
  final double? closeButtonSize;
  final String? closeLabel;
  final double? spacing;
  final double? titleSpacing;
  final double? actionSpacing;
  final double? actionRunSpacing;
  final WrapAlignment? actionsAlignment;
  final HyperButtonThemeData? buttonTheme;
  final Duration? duration;
  final Curve? curve;
  final HyperNoticeTransitionBuilder? transitionBuilder;
  HyperNoticeStyle copyWith({
    HyperFill? background,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
    IconData? closeIcon,
    Color? closeIconColor,
    double? closeIconSize,
    double? closeButtonSize,
    String? closeLabel,
    double? spacing,
    double? titleSpacing,
    double? actionSpacing,
    double? actionRunSpacing,
    WrapAlignment? actionsAlignment,
    HyperButtonThemeData? buttonTheme,
    Duration? duration,
    Curve? curve,
    HyperNoticeTransitionBuilder? transitionBuilder,
  }) => HyperNoticeStyle(
    background: background ?? this.background,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    boxShadow: boxShadow ?? this.boxShadow,
    padding: padding ?? this.padding,
    titleStyle: titleStyle ?? this.titleStyle,
    contentStyle: contentStyle ?? this.contentStyle,
    icon: icon ?? this.icon,
    iconColor: iconColor ?? this.iconColor,
    iconSize: iconSize ?? this.iconSize,
    closeIcon: closeIcon ?? this.closeIcon,
    closeIconColor: closeIconColor ?? this.closeIconColor,
    closeIconSize: closeIconSize ?? this.closeIconSize,
    closeButtonSize: closeButtonSize ?? this.closeButtonSize,
    closeLabel: closeLabel ?? this.closeLabel,
    spacing: spacing ?? this.spacing,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    actionSpacing: actionSpacing ?? this.actionSpacing,
    actionRunSpacing: actionRunSpacing ?? this.actionRunSpacing,
    actionsAlignment: actionsAlignment ?? this.actionsAlignment,
    buttonTheme: buttonTheme ?? this.buttonTheme,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperNoticeStyle merge(HyperNoticeStyle? other) => other == null
      ? this
      : copyWith(
          background: other.background,
          material: other.material,
          materialQuality: other.materialQuality,
          reduceTransparency: other.reduceTransparency,
          border: other.border,
          borderRadius: other.borderRadius,
          boxShadow: other.boxShadow,
          padding: other.padding,
          titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
          contentStyle:
              contentStyle?.merge(other.contentStyle) ?? other.contentStyle,
          icon: other.icon,
          iconColor: other.iconColor,
          iconSize: other.iconSize,
          closeIcon: other.closeIcon,
          closeIconColor: other.closeIconColor,
          closeIconSize: other.closeIconSize,
          closeButtonSize: other.closeButtonSize,
          closeLabel: other.closeLabel,
          spacing: other.spacing,
          titleSpacing: other.titleSpacing,
          actionSpacing: other.actionSpacing,
          actionRunSpacing: other.actionRunSpacing,
          actionsAlignment: other.actionsAlignment,
          buttonTheme:
              buttonTheme?.merge(other.buttonTheme) ?? other.buttonTheme,
          duration: other.duration,
          curve: other.curve,
          transitionBuilder: other.transitionBuilder,
        );
  static HyperNoticeStyle lerp(
    HyperNoticeStyle a,
    HyperNoticeStyle b,
    double t,
  ) {
    if (t == 0 || a == b) return a;
    if (t == 1) return b;
    return HyperNoticeStyle(
      background: a.background == null || b.background == null
          ? (t < .5 ? a.background : b.background)
          : HyperFill.lerp(a.background!, b.background!, t),
      material: a.material == null || b.material == null
          ? (t < .5 ? a.material : b.material)
          : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
      materialQuality: t < .5 ? a.materialQuality : b.materialQuality,
      reduceTransparency: t < .5 ? a.reduceTransparency : b.reduceTransparency,
      border: a.border == null || b.border == null
          ? (t < .5 ? a.border : b.border)
          : BoxBorder.lerp(a.border!, b.border!, t),
      borderRadius: a.borderRadius == null || b.borderRadius == null
          ? (t < .5 ? a.borderRadius : b.borderRadius)
          : BorderRadiusGeometry.lerp(a.borderRadius!, b.borderRadius!, t),
      boxShadow: a.boxShadow == null || b.boxShadow == null
          ? (t < .5 ? a.boxShadow : b.boxShadow)
          : BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      padding: a.padding == null || b.padding == null
          ? (t < .5 ? a.padding : b.padding)
          : EdgeInsetsGeometry.lerp(a.padding!, b.padding!, t),
      titleStyle: a.titleStyle == null || b.titleStyle == null
          ? (t < .5 ? a.titleStyle : b.titleStyle)
          : TextStyle.lerp(a.titleStyle!, b.titleStyle!, t),
      contentStyle: a.contentStyle == null || b.contentStyle == null
          ? (t < .5 ? a.contentStyle : b.contentStyle)
          : TextStyle.lerp(a.contentStyle!, b.contentStyle!, t),
      icon: t < .5 ? a.icon : b.icon,
      iconColor: a.iconColor == null || b.iconColor == null
          ? (t < .5 ? a.iconColor : b.iconColor)
          : Color.lerp(a.iconColor!, b.iconColor!, t),
      iconSize: a.iconSize == null || b.iconSize == null
          ? (t < .5 ? a.iconSize : b.iconSize)
          : a.iconSize! + (b.iconSize! - a.iconSize!) * t,
      closeIcon: t < .5 ? a.closeIcon : b.closeIcon,
      closeIconColor: a.closeIconColor == null || b.closeIconColor == null
          ? (t < .5 ? a.closeIconColor : b.closeIconColor)
          : Color.lerp(a.closeIconColor!, b.closeIconColor!, t),
      closeIconSize: a.closeIconSize == null || b.closeIconSize == null
          ? (t < .5 ? a.closeIconSize : b.closeIconSize)
          : a.closeIconSize! + (b.closeIconSize! - a.closeIconSize!) * t,
      closeButtonSize: a.closeButtonSize == null || b.closeButtonSize == null
          ? (t < .5 ? a.closeButtonSize : b.closeButtonSize)
          : a.closeButtonSize! + (b.closeButtonSize! - a.closeButtonSize!) * t,
      closeLabel: t < .5 ? a.closeLabel : b.closeLabel,
      spacing: a.spacing == null || b.spacing == null
          ? (t < .5 ? a.spacing : b.spacing)
          : a.spacing! + (b.spacing! - a.spacing!) * t,
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
      actionsAlignment: t < .5 ? a.actionsAlignment : b.actionsAlignment,
      buttonTheme: a.buttonTheme == null || b.buttonTheme == null
          ? (t < .5 ? a.buttonTheme : b.buttonTheme)
          : HyperButtonThemeData.lerp(a.buttonTheme!, b.buttonTheme!, t),
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
  }

  @override
  bool operator ==(Object other) =>
      other is HyperNoticeStyle &&
      background == other.background &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      border == other.border &&
      borderRadius == other.borderRadius &&
      listEquals(boxShadow, other.boxShadow) &&
      padding == other.padding &&
      titleStyle == other.titleStyle &&
      contentStyle == other.contentStyle &&
      icon == other.icon &&
      iconColor == other.iconColor &&
      iconSize == other.iconSize &&
      closeIcon == other.closeIcon &&
      closeIconColor == other.closeIconColor &&
      closeIconSize == other.closeIconSize &&
      closeButtonSize == other.closeButtonSize &&
      closeLabel == other.closeLabel &&
      spacing == other.spacing &&
      titleSpacing == other.titleSpacing &&
      actionSpacing == other.actionSpacing &&
      actionRunSpacing == other.actionRunSpacing &&
      actionsAlignment == other.actionsAlignment &&
      buttonTheme == other.buttonTheme &&
      duration == other.duration &&
      curve == other.curve &&
      transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    background,
    material,
    materialQuality,
    reduceTransparency,
    border,
    borderRadius,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    padding,
    titleStyle,
    contentStyle,
    icon,
    iconColor,
    iconSize,
    closeIcon,
    closeIconColor,
    closeIconSize,
    closeButtonSize,
    closeLabel,
    spacing,
    titleSpacing,
    actionSpacing,
    actionRunSpacing,
    actionsAlignment,
    buttonTheme,
    duration,
    curve,
    transitionBuilder,
  ]);
}
