import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../card/hyper_card_style.dart';
import '../overlay/hyper_anchored_overlay.dart';

/// 空字段继承；边框为零、空阴影或 HyperFill.none 为显式关闭。
@immutable
final class HyperTextFieldStyle {
  const HyperTextFieldStyle({
    this.background,
    this.material,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.boxShadow,
    this.height,
    this.minimumHeight,
    this.padding,
    this.iconSize,
    this.actionWidth,
    this.labelGap,
    this.textAlignVertical,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.counterStyle,
    this.foregroundColor,
    this.iconColor,
    this.cursorColor,
    this.cursorWidth,
    this.cursorRadius,
    this.errorIcon,
    this.clearIcon,
    this.showPasswordIcon,
    this.hidePasswordIcon,
    this.errorIconColor,
    this.errorPopupStyle,
    this.errorTextStyle,
    this.errorTransitionBuilder,
    this.errorPlacement,
    this.errorMaxWidth,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final HyperFill? background;
  final HyperSurfaceMaterial? material;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;

  /// 期望高度；空间不足时先减少上下内边距，再允许内容撑高。
  final double? height;
  final double? minimumHeight;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final double? actionWidth;
  final double? labelGap;
  final TextAlignVertical? textAlignVertical;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? counterStyle;
  final Color? foregroundColor;
  final Color? iconColor;
  final Color? cursorColor;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final IconData? errorIcon;
  final IconData? clearIcon;
  final IconData? showPasswordIcon;
  final IconData? hidePasswordIcon;
  final Color? errorIconColor;
  final HyperCardStyle? errorPopupStyle;
  final TextStyle? errorTextStyle;
  final HyperOverlayTransitionBuilder? errorTransitionBuilder;
  final HyperOverlayPlacement? errorPlacement;
  final double? errorMaxWidth;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperTextFieldStyle copyWith({
    HyperFill? background,
    HyperSurfaceMaterial? material,
    Color? borderColor,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    double? height,
    double? minimumHeight,
    EdgeInsetsGeometry? padding,
    double? iconSize,
    double? actionWidth,
    double? labelGap,
    TextAlignVertical? textAlignVertical,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? counterStyle,
    Color? foregroundColor,
    Color? iconColor,
    Color? cursorColor,
    double? cursorWidth,
    Radius? cursorRadius,
    IconData? errorIcon,
    IconData? clearIcon,
    IconData? showPasswordIcon,
    IconData? hidePasswordIcon,
    Color? errorIconColor,
    HyperCardStyle? errorPopupStyle,
    TextStyle? errorTextStyle,
    HyperOverlayTransitionBuilder? errorTransitionBuilder,
    HyperOverlayPlacement? errorPlacement,
    double? errorMaxWidth,
    Duration? duration,
    Curve? curve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => merge(
    HyperTextFieldStyle(
      background: background,
      material: material,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      height: height,
      minimumHeight: minimumHeight,
      padding: padding,
      iconSize: iconSize,
      actionWidth: actionWidth,
      labelGap: labelGap,
      textAlignVertical: textAlignVertical,
      textStyle: textStyle,
      hintStyle: hintStyle,
      labelStyle: labelStyle,
      counterStyle: counterStyle,
      foregroundColor: foregroundColor,
      iconColor: iconColor,
      cursorColor: cursorColor,
      cursorWidth: cursorWidth,
      cursorRadius: cursorRadius,
      errorIcon: errorIcon,
      clearIcon: clearIcon,
      showPasswordIcon: showPasswordIcon,
      hidePasswordIcon: hidePasswordIcon,
      errorIconColor: errorIconColor,
      errorPopupStyle: errorPopupStyle,
      errorTextStyle: errorTextStyle,
      errorTransitionBuilder: errorTransitionBuilder,
      errorPlacement: errorPlacement,
      errorMaxWidth: errorMaxWidth,
      duration: duration,
      curve: curve,
      transitionBuilder: transitionBuilder,
    ),
  );
  HyperTextFieldStyle merge(HyperTextFieldStyle? other) => other == null
      ? this
      : HyperTextFieldStyle(
          background: other.background ?? background,
          material: other.material ?? material,
          borderColor: other.borderColor ?? borderColor,
          borderWidth: other.borderWidth ?? borderWidth,
          borderRadius: other.borderRadius ?? borderRadius,
          boxShadow: other.boxShadow ?? boxShadow,
          height: other.height ?? height,
          minimumHeight: other.minimumHeight ?? minimumHeight,
          padding: other.padding ?? padding,
          iconSize: other.iconSize ?? iconSize,
          actionWidth: other.actionWidth ?? actionWidth,
          labelGap: other.labelGap ?? labelGap,
          textAlignVertical: other.textAlignVertical ?? textAlignVertical,
          textStyle: other.textStyle ?? textStyle,
          hintStyle: other.hintStyle ?? hintStyle,
          labelStyle: other.labelStyle ?? labelStyle,
          counterStyle: other.counterStyle ?? counterStyle,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          iconColor: other.iconColor ?? iconColor,
          cursorColor: other.cursorColor ?? cursorColor,
          cursorWidth: other.cursorWidth ?? cursorWidth,
          cursorRadius: other.cursorRadius ?? cursorRadius,
          errorIcon: other.errorIcon ?? errorIcon,
          clearIcon: other.clearIcon ?? clearIcon,
          showPasswordIcon: other.showPasswordIcon ?? showPasswordIcon,
          hidePasswordIcon: other.hidePasswordIcon ?? hidePasswordIcon,
          errorIconColor: other.errorIconColor ?? errorIconColor,
          errorPopupStyle: other.errorPopupStyle ?? errorPopupStyle,
          errorTextStyle: other.errorTextStyle ?? errorTextStyle,
          errorTransitionBuilder:
              other.errorTransitionBuilder ?? errorTransitionBuilder,
          errorPlacement: other.errorPlacement ?? errorPlacement,
          errorMaxWidth: other.errorMaxWidth ?? errorMaxWidth,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperTextFieldStyle lerp(
    HyperTextFieldStyle a,
    HyperTextFieldStyle b,
    double t,
  ) {
    if (t == 0 || a == b) return a;
    if (t == 1) return b;
    T? blend<T>(T? x, T? y, T Function(T, T, double) interpolate) =>
        x == null || y == null ? (t < .5 ? x : y) : interpolate(x, y, t);
    return HyperTextFieldStyle(
      background: blend(a.background, b.background, HyperFill.lerp),
      material: blend(a.material, b.material, HyperSurfaceMaterial.lerp),
      borderColor: blend(
        a.borderColor,
        b.borderColor,
        (x, y, t) => Color.lerp(x, y, t)!,
      ),
      borderWidth: blend(
        a.borderWidth,
        b.borderWidth,
        (x, y, t) => x + (y - x) * t,
      ),
      borderRadius: blend(
        a.borderRadius,
        b.borderRadius,
        (x, y, t) => BorderRadiusGeometry.lerp(x, y, t)!,
      ),
      boxShadow: blend(
        a.boxShadow,
        b.boxShadow,
        (x, y, t) => BoxShadow.lerpList(x, y, t)!,
      ),
      height: blend(a.height, b.height, (x, y, t) => x + (y - x) * t),
      minimumHeight: blend(
        a.minimumHeight,
        b.minimumHeight,
        (x, y, t) => x + (y - x) * t,
      ),
      padding: blend(
        a.padding,
        b.padding,
        (x, y, t) => EdgeInsetsGeometry.lerp(x, y, t)!,
      ),
      iconSize: blend(a.iconSize, b.iconSize, (x, y, t) => x + (y - x) * t),
      actionWidth: blend(
        a.actionWidth,
        b.actionWidth,
        (x, y, t) => x + (y - x) * t,
      ),
      labelGap: blend(a.labelGap, b.labelGap, (x, y, t) => x + (y - x) * t),
      textAlignVertical: blend(
        a.textAlignVertical,
        b.textAlignVertical,
        (x, y, t) => TextAlignVertical(y: x.y + (y.y - x.y) * t),
      ),
      textStyle: blend(
        a.textStyle,
        b.textStyle,
        (x, y, t) => TextStyle.lerp(x, y, t)!,
      ),
      hintStyle: blend(
        a.hintStyle,
        b.hintStyle,
        (x, y, t) => TextStyle.lerp(x, y, t)!,
      ),
      labelStyle: blend(
        a.labelStyle,
        b.labelStyle,
        (x, y, t) => TextStyle.lerp(x, y, t)!,
      ),
      counterStyle: blend(
        a.counterStyle,
        b.counterStyle,
        (x, y, t) => TextStyle.lerp(x, y, t)!,
      ),
      foregroundColor: blend(
        a.foregroundColor,
        b.foregroundColor,
        (x, y, t) => Color.lerp(x, y, t)!,
      ),
      iconColor: blend(
        a.iconColor,
        b.iconColor,
        (x, y, t) => Color.lerp(x, y, t)!,
      ),
      cursorColor: blend(
        a.cursorColor,
        b.cursorColor,
        (x, y, t) => Color.lerp(x, y, t)!,
      ),
      cursorWidth: blend(
        a.cursorWidth,
        b.cursorWidth,
        (x, y, t) => x + (y - x) * t,
      ),
      cursorRadius: blend(
        a.cursorRadius,
        b.cursorRadius,
        (x, y, t) => Radius.lerp(x, y, t)!,
      ),
      errorIcon: t < .5 ? a.errorIcon : b.errorIcon,
      clearIcon: t < .5 ? a.clearIcon : b.clearIcon,
      showPasswordIcon: t < .5 ? a.showPasswordIcon : b.showPasswordIcon,
      hidePasswordIcon: t < .5 ? a.hidePasswordIcon : b.hidePasswordIcon,
      errorIconColor: blend(
        a.errorIconColor,
        b.errorIconColor,
        (x, y, t) => Color.lerp(x, y, t)!,
      ),
      errorPopupStyle: blend(
        a.errorPopupStyle,
        b.errorPopupStyle,
        HyperCardStyle.lerp,
      ),
      errorTextStyle: blend(
        a.errorTextStyle,
        b.errorTextStyle,
        (x, y, t) => TextStyle.lerp(x, y, t)!,
      ),
      errorTransitionBuilder: t < .5
          ? a.errorTransitionBuilder
          : b.errorTransitionBuilder,
      errorPlacement: t < .5 ? a.errorPlacement : b.errorPlacement,
      errorMaxWidth: blend(
        a.errorMaxWidth,
        b.errorMaxWidth,
        (x, y, t) => x + (y - x) * t,
      ),
      duration: t < .5 ? a.duration : b.duration,
      curve: t < .5 ? a.curve : b.curve,
      transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperTextFieldStyle &&
          background == other.background &&
          material == other.material &&
          borderColor == other.borderColor &&
          borderWidth == other.borderWidth &&
          borderRadius == other.borderRadius &&
          listEquals(boxShadow, other.boxShadow) &&
          height == other.height &&
          minimumHeight == other.minimumHeight &&
          padding == other.padding &&
          iconSize == other.iconSize &&
          actionWidth == other.actionWidth &&
          labelGap == other.labelGap &&
          textAlignVertical == other.textAlignVertical &&
          textStyle == other.textStyle &&
          hintStyle == other.hintStyle &&
          labelStyle == other.labelStyle &&
          counterStyle == other.counterStyle &&
          foregroundColor == other.foregroundColor &&
          iconColor == other.iconColor &&
          cursorColor == other.cursorColor &&
          cursorWidth == other.cursorWidth &&
          cursorRadius == other.cursorRadius &&
          errorIcon == other.errorIcon &&
          clearIcon == other.clearIcon &&
          showPasswordIcon == other.showPasswordIcon &&
          hidePasswordIcon == other.hidePasswordIcon &&
          errorIconColor == other.errorIconColor &&
          errorPopupStyle == other.errorPopupStyle &&
          errorTextStyle == other.errorTextStyle &&
          errorTransitionBuilder == other.errorTransitionBuilder &&
          errorPlacement == other.errorPlacement &&
          errorMaxWidth == other.errorMaxWidth &&
          duration == other.duration &&
          curve == other.curve &&
          transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    background,
    material,
    borderColor,
    borderWidth,
    borderRadius,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    height,
    minimumHeight,
    padding,
    iconSize,
    actionWidth,
    labelGap,
    textAlignVertical,
    textStyle,
    hintStyle,
    labelStyle,
    counterStyle,
    foregroundColor,
    iconColor,
    cursorColor,
    cursorWidth,
    cursorRadius,
    errorIcon,
    clearIcon,
    showPasswordIcon,
    hidePasswordIcon,
    errorIconColor,
    errorPopupStyle,
    errorTextStyle,
    errorTransitionBuilder,
    errorPlacement,
    errorMaxWidth,
    duration,
    curve,
    transitionBuilder,
  ]);
}
